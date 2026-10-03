SET NOCOUNT ON;
GO

IF OBJECT_ID('dbo.CommitmentClientBillingEmailLog','U') IS NULL
BEGIN
    CREATE TABLE dbo.CommitmentClientBillingEmailLog
    (
        LogID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_CommitmentClientBillingEmailLog PRIMARY KEY,
        ProjectID int NOT NULL,
        BillingPeriod nvarchar(1000) NOT NULL,
        PeriodFrom date NOT NULL,
        PeriodTo date NOT NULL,
        BillingCycle nvarchar(100) NULL,
        ActualTo nvarchar(max) NULL,
        ActualCc nvarchar(max) NULL,
        ActualBcc nvarchar(max) NULL,
        SentTo nvarchar(max) NULL,
        IsTestEmail bit NOT NULL CONSTRAINT DF_CommitmentClientBillingEmailLog_Test DEFAULT(0),
        Status nvarchar(30) NOT NULL,
        ErrorMessage nvarchar(max) NULL,
        AttachmentFileName nvarchar(500) NULL,
        SentDateTime datetime NULL,
        AddedDate datetime NOT NULL CONSTRAINT DF_CommitmentClientBillingEmailLog_Added DEFAULT(GETDATE()),
        CONSTRAINT UQ_CommitmentClientBillingEmailLog_ProjectPeriodMode UNIQUE(ProjectID,PeriodFrom,PeriodTo,IsTestEmail)
    );
END
GO

IF OBJECT_ID('dbo.usp_ProcessCommitmentClientBilling','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.usp_ProcessCommitmentClientBilling AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.usp_ProcessCommitmentClientBilling
    @ProjectID int,
    @PeriodFrom date,
    @PeriodTo date,
    @BillingPeriod nvarchar(1000),
    @BillingAddedBy int=2,
    @ApplyChanges bit=1
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @BillingCycle nvarchar(100),@ProjectName nvarchar(100),@BillingType nvarchar(100),@DateColumn sysname,@DispatchColumn sysname,@FinalStatusColumn sysname,@TotalRecordsColumn sysname,@DispatchedRecordsColumn sysname,@CancelledRecordsColumn sysname,@DomainId int,@FreightDispatchFilter nvarchar(max)=N'';
    SELECT TOP 1 @BillingCycle=LTRIM(RTRIM(CF.BillingCycle)),@ProjectName=P.ProjectName,@DomainId=CF.DomainId
    FROM dbo.ClientFeedback CF INNER JOIN dbo.Project P ON P.ProjectID=CF.ProjectId
    WHERE CF.ProjectId=@ProjectID AND CF.DomainId IN (2,19,34)
      AND NOT (CF.DomainId=2 AND CF.ProjectId IN (49,333))
      AND ISNULL(NULLIF(LOWER(LTRIM(RTRIM(CONVERT(nvarchar(50),CF.Status)))),''),'active') NOT IN ('0','false','inactive','deleted');
    SET @BillingType=CASE WHEN @DomainId=2 THEN 'Freight' ELSE 'Commitment Typing' END;
    IF @ProjectName IS NULL BEGIN RAISERROR('Active Commitment/Freight project configuration was not found.',16,1); RETURN; END;
    IF LOWER(@BillingCycle) NOT IN ('monthly','bi-monthly','bimonthly','bi monthly') BEGIN RAISERROR('Unsupported Commitment billing cycle.',16,1); RETURN; END;
    IF @PeriodTo<@PeriodFrom BEGIN RAISERROR('Invalid billing period.',16,1); RETURN; END;

    -- 711 contains aggregate quantities (for example one row represents 58
    -- records).  Its 16th-to-month-end run must also collect an earlier row in
    -- that month when it is still unbilled.  Rows carrying another BillingPeriod
    -- remain excluded, so a completed first-half billing is never duplicated.
    IF @ProjectID=137
        SET @PeriodFrom=DATEADD(MONTH,DATEDIFF(MONTH,0,@PeriodFrom),0);

    IF @ProjectID IN (47,137)
    BEGIN
        SELECT @DateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Order Date');
        IF NULLIF(@DateColumn,'') IS NULL SELECT @DateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'order Date');
        SELECT @TotalRecordsColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'No of Records');
        SELECT @DispatchedRecordsColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'No of Dispatched Records');
        IF NULLIF(@DispatchedRecordsColumn,'') IS NULL SELECT @DispatchedRecordsColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Dispatched Record');
        SELECT @CancelledRecordsColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Cancelled Record');
        IF NULLIF(@CancelledRecordsColumn,'') IS NULL SELECT @CancelledRecordsColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Rejected Record');
        SELECT @DispatchColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Dispatched Date');
        IF NULLIF(@DispatchColumn,'') IS NULL SELECT @DispatchColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Dispatch Date');
    END
    ELSE
    BEGIN
        SELECT @DateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Dispatched Date');
        IF NULLIF(@DateColumn,'') IS NULL SELECT @DateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Dispatch Date');
    END;
    IF NULLIF(@DateColumn,'') IS NULL BEGIN RAISERROR('Dispatched Date mapping was not found.',16,1); RETURN; END;
    IF NULLIF(@DispatchColumn,'') IS NULL SET @DispatchColumn=@DateColumn;
    IF @ProjectID=47 AND NULLIF(@DispatchColumn,'') IS NOT NULL
        SET @FreightDispatchFilter=N' AND (NULLIF(LTRIM(RTRIM(CONVERT(NVARCHAR(100),T.'+QUOTENAME(@DispatchColumn)+N'))),'''') IS NULL OR (ISDATE(T.'+QUOTENAME(@DispatchColumn)+N')=1 AND CONVERT(DATE,T.'+QUOTENAME(@DispatchColumn)+N')<=@PeriodTo))';
    SELECT @FinalStatusColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Final Status');
    IF NULLIF(@FinalStatusColumn,'') IS NULL BEGIN RAISERROR('Final Status mapping was not found for this Commitment project.',16,1); RETURN; END;

    DECLARE @Sql nvarchar(max),@Updated int,@CandidateCount int;
    SET @Sql=N'SELECT @CandidateCount=COUNT(1) FROM Commitment.dbo.WBT_TrackingSheet T WHERE T.ProjectID=@ProjectID AND
    LOWER(LTRIM(RTRIM(CONVERT(nvarchar(max),T.'+QUOTENAME(@FinalStatusColumn)+N'))))=''completed'' AND
    (T.BillingPeriod=@BillingPeriod OR (NULLIF(LTRIM(RTRIM(T.BillingPeriod)),'''') IS NULL AND ISDATE(T.'+QUOTENAME(@DateColumn)+N')=1 AND CONVERT(date,T.'+QUOTENAME(@DateColumn)+N') BETWEEN @PeriodFrom AND @PeriodTo))'+@FreightDispatchFilter+N';';
    EXEC sys.sp_executesql @Sql,N'@ProjectID int,@BillingPeriod nvarchar(1000),@PeriodFrom date,@PeriodTo date,@CandidateCount int OUTPUT',@ProjectID,@BillingPeriod,@PeriodFrom,@PeriodTo,@CandidateCount OUTPUT;
    IF ISNULL(@CandidateCount,0)=0
    BEGIN
        SELECT @ProjectID ProjectID,@ProjectName [Project #],@BillingType [Type],@BillingCycle BillingCycle,@BillingPeriod BillingPeriod,
               0 TotalOrders,0 Dispatched,0 Cancelled,0 OnHold;
        SELECT TOP 0 CAST(NULL AS nvarchar(100)) [Project #];
        RETURN;
    END;
    IF @ApplyChanges=1
    BEGIN
      BEGIN TRANSACTION;
      SET @Sql=N'UPDATE T WITH(UPDLOCK) SET IsVerify=1,BillingPeriod=@BillingPeriod,BillingAddedBy=CONVERT(nvarchar(100),@BillingAddedBy),BillingAddedDate=REPLACE(CONVERT(nvarchar(11),GETDATE(),106),'' '',''-'')
FROM Commitment.dbo.WBT_TrackingSheet T
WHERE T.ProjectID=@ProjectID AND NULLIF(LTRIM(RTRIM(T.BillingPeriod)),'''') IS NULL
AND LOWER(LTRIM(RTRIM(CONVERT(nvarchar(max),T.'+QUOTENAME(@FinalStatusColumn)+N'))))=''completed''
AND ISDATE(T.'+QUOTENAME(@DateColumn)+N')=1 AND CONVERT(date,T.'+QUOTENAME(@DateColumn)+N') BETWEEN @PeriodFrom AND @PeriodTo'+@FreightDispatchFilter+N';
SET @Updated=@@ROWCOUNT;';
      EXEC sys.sp_executesql @Sql,N'@ProjectID int,@PeriodFrom date,@PeriodTo date,@BillingPeriod nvarchar(1000),@BillingAddedBy int,@Updated int OUTPUT',@ProjectID,@PeriodFrom,@PeriodTo,@BillingPeriod,@BillingAddedBy,@Updated OUTPUT;

      IF EXISTS(SELECT 1 FROM InfinityBilling.dbo.ProjectBillingDetails WITH(UPDLOCK,HOLDLOCK) WHERE ProjectId=@ProjectID AND LTRIM(RTRIM(BillingPeriod))=LTRIM(RTRIM(@BillingPeriod)))
        UPDATE InfinityBilling.dbo.ProjectBillingDetails SET BillingCycle=@BillingCycle,BillingSendBy=@BillingAddedBy,BillingSendDate=ISNULL(BillingSendDate,GETDATE()),CurrentStatus=ISNULL(CurrentStatus,'Pending'),Client=@ProjectName WHERE ProjectId=@ProjectID AND LTRIM(RTRIM(BillingPeriod))=LTRIM(RTRIM(@BillingPeriod));
      ELSE
        INSERT InfinityBilling.dbo.ProjectBillingDetails(ProjectId,BillingPeriod,BillingCycle,BillingSendBy,BillingSendDate,CurrentStatus,AddedDate,Client)
        VALUES(@ProjectID,@BillingPeriod,@BillingCycle,@BillingAddedBy,GETDATE(),'Pending',GETDATE(),@ProjectName);
      COMMIT TRANSACTION;
    END;

    DECLARE @DispatchExpression nvarchar(500)=CASE WHEN NULLIF(@DispatchColumn,'') IS NULL THEN N'0' ELSE N'CASE WHEN NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(max),T.'+QUOTENAME(@DispatchColumn)+N'))),'''') IS NOT NULL THEN 1 ELSE 0 END' END;
    DECLARE @CancelledExpression nvarchar(500)=CASE WHEN NULLIF(@FinalStatusColumn,'') IS NULL THEN N'0' ELSE N'CASE WHEN LTRIM(RTRIM(CONVERT(nvarchar(max),T.'+QUOTENAME(@FinalStatusColumn)+N')))=''Cancelled'' THEN 1 ELSE 0 END' END;
    DECLARE @CompletedFilter nvarchar(500)=N'LOWER(LTRIM(RTRIM(CONVERT(nvarchar(max),T.'+QUOTENAME(@FinalStatusColumn)+N'))))=''completed''';
    DECLARE @DataFilter nvarchar(max)=@CompletedFilter+N' AND '+CASE WHEN @ApplyChanges=1 THEN N'T.BillingPeriod=@BillingPeriod' ELSE N'(T.BillingPeriod=@BillingPeriod OR (NULLIF(LTRIM(RTRIM(T.BillingPeriod)),'''') IS NULL AND ISDATE(T.'+QUOTENAME(@DateColumn)+N')=1 AND CONVERT(date,T.'+QUOTENAME(@DateColumn)+N') BETWEEN @PeriodFrom AND @PeriodTo))' END+@FreightDispatchFilter;
    DECLARE @TotalSummaryExpression nvarchar(1000)=CASE WHEN @ProjectID IN (47,137) AND NULLIF(@TotalRecordsColumn,'') IS NOT NULL THEN N'SUM(CASE WHEN ISNUMERIC(T.'+QUOTENAME(@TotalRecordsColumn)+N')=1 THEN CONVERT(INT,CONVERT(DECIMAL(18,2),T.'+QUOTENAME(@TotalRecordsColumn)+N')) ELSE 0 END)' ELSE N'COUNT(1)' END;
    DECLARE @DispatchedSummaryExpression nvarchar(1000)=CASE WHEN @ProjectID IN (47,137) AND NULLIF(@DispatchedRecordsColumn,'') IS NOT NULL THEN N'SUM(CASE WHEN ISNUMERIC(T.'+QUOTENAME(@DispatchedRecordsColumn)+N')=1 THEN CONVERT(INT,CONVERT(DECIMAL(18,2),T.'+QUOTENAME(@DispatchedRecordsColumn)+N')) ELSE 0 END)' ELSE N'SUM('+@DispatchExpression+N')' END;
    DECLARE @CancelledSummaryExpression nvarchar(1000)=CASE WHEN @ProjectID IN (47,137) AND NULLIF(@CancelledRecordsColumn,'') IS NOT NULL THEN N'SUM(CASE WHEN ISNUMERIC(T.'+QUOTENAME(@CancelledRecordsColumn)+N')=1 THEN CONVERT(INT,CONVERT(DECIMAL(18,2),T.'+QUOTENAME(@CancelledRecordsColumn)+N')) ELSE 0 END)' ELSE N'SUM('+@CancelledExpression+N')' END;
    DECLARE @OnHoldSummaryExpression nvarchar(3200)=CASE WHEN @ProjectID IN (47,137) THEN N'CASE WHEN ('+@TotalSummaryExpression+N')-('+@DispatchedSummaryExpression+N')-('+@CancelledSummaryExpression+N')>0 THEN ('+@TotalSummaryExpression+N')-('+@DispatchedSummaryExpression+N')-('+@CancelledSummaryExpression+N') ELSE 0 END' ELSE N'SUM(CASE WHEN ('+@DispatchExpression+N')=0 AND ('+@CancelledExpression+N')=0 THEN 1 ELSE 0 END)' END;
    SET @Sql=N'SELECT @ProjectID ProjectID,@ProjectName [Project #],@BillingType [Type],@BillingCycle BillingCycle,@BillingPeriod BillingPeriod,
'+@TotalSummaryExpression+N' TotalOrders,'+@DispatchedSummaryExpression+N' Dispatched,'+@CancelledSummaryExpression+N' Cancelled,
'+@OnHoldSummaryExpression+N' OnHold
FROM Commitment.dbo.WBT_TrackingSheet T WHERE T.ProjectID=@ProjectID AND '+@DataFilter+N';';
    EXEC sys.sp_executesql @Sql,N'@ProjectID int,@ProjectName nvarchar(100),@BillingType nvarchar(100),@BillingCycle nvarchar(100),@BillingPeriod nvarchar(1000),@PeriodFrom date,@PeriodTo date',@ProjectID,@ProjectName,@BillingType,@BillingCycle,@BillingPeriod,@PeriodFrom,@PeriodTo;

    DECLARE @Columns nvarchar(max);
    SELECT @Columns=STUFF((SELECT ',T.'+QUOTENAME(C.ColumnName)+' AS '+QUOTENAME(D.FieldName)
        FROM dbo.WBT_DomianWiseFieldMaster D
        INNER JOIN dbo.WBT_ProjectWiseFieldMaster PWF ON PWF.FieldName=D.DomainFieldID
        INNER JOIN dbo.WBT_ColumnMapping CM ON CM.ProjectFieldID=PWF.ProjectFieldID AND CM.ProjectID=PWF.ProjectID
        INNER JOIN dbo.WBT_ColumnMaster C ON C.ColumnID=CM.CoumnID
        WHERE CM.ProjectID=@ProjectID AND CM.ForBilling=1 ORDER BY SequenceNo FOR XML PATH(''),TYPE).value('.','nvarchar(max)'),1,1,'');
    IF NULLIF(@Columns,'') IS NULL SELECT TOP 0 @ProjectName [Project #];
    ELSE BEGIN SET @Sql=N'SELECT @ProjectName [Project #],'+@Columns+N' FROM Commitment.dbo.WBT_TrackingSheet T WHERE T.ProjectID=@ProjectID AND '+@DataFilter+N' ORDER BY T.TrackingSheetID;'; EXEC sys.sp_executesql @Sql,N'@ProjectID int,@ProjectName nvarchar(100),@BillingPeriod nvarchar(1000),@PeriodFrom date,@PeriodTo date',@ProjectID,@ProjectName,@BillingPeriod,@PeriodFrom,@PeriodTo; END;
END
GO

IF OBJECT_ID('dbo.usp_StartCommitmentClientBillingEmail','P') IS NULL EXEC('CREATE PROCEDURE dbo.usp_StartCommitmentClientBillingEmail AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.usp_StartCommitmentClientBillingEmail
 @ProjectID int,@BillingPeriod nvarchar(1000),@PeriodFrom date,@PeriodTo date,@BillingCycle nvarchar(100),
 @ActualTo nvarchar(max),@ActualCc nvarchar(max)=NULL,@ActualBcc nvarchar(max)=NULL,@SentTo nvarchar(max),@IsTestEmail bit
AS
BEGIN
 SET NOCOUNT ON; SET XACT_ABORT ON; BEGIN TRANSACTION; DECLARE @ID bigint;
 SELECT @ID=LogID FROM dbo.CommitmentClientBillingEmailLog WITH(UPDLOCK,HOLDLOCK) WHERE ProjectID=@ProjectID AND PeriodFrom=@PeriodFrom AND PeriodTo=@PeriodTo AND IsTestEmail=@IsTestEmail;
 IF @ID IS NOT NULL AND EXISTS(SELECT 1 FROM dbo.CommitmentClientBillingEmailLog WHERE LogID=@ID AND (Status='Sent' OR (Status='Processing' AND AddedDate>=DATEADD(minute,-30,GETDATE())))) BEGIN COMMIT; SELECT CAST(0 AS bigint) LogID; RETURN; END;
 IF @ID IS NULL BEGIN INSERT dbo.CommitmentClientBillingEmailLog(ProjectID,BillingPeriod,PeriodFrom,PeriodTo,BillingCycle,ActualTo,ActualCc,ActualBcc,SentTo,IsTestEmail,Status) VALUES(@ProjectID,@BillingPeriod,@PeriodFrom,@PeriodTo,@BillingCycle,@ActualTo,@ActualCc,@ActualBcc,@SentTo,@IsTestEmail,'Processing'); SET @ID=SCOPE_IDENTITY(); END
 ELSE UPDATE dbo.CommitmentClientBillingEmailLog SET Status='Processing',ErrorMessage=NULL,ActualTo=@ActualTo,ActualCc=@ActualCc,ActualBcc=@ActualBcc,SentTo=@SentTo,BillingPeriod=@BillingPeriod,BillingCycle=@BillingCycle,AddedDate=GETDATE() WHERE LogID=@ID;
 COMMIT; SELECT @ID LogID;
END
GO

IF OBJECT_ID('dbo.usp_CompleteCommitmentClientBillingEmail','P') IS NULL EXEC('CREATE PROCEDURE dbo.usp_CompleteCommitmentClientBillingEmail AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.usp_CompleteCommitmentClientBillingEmail @LogID bigint,@Status nvarchar(30),@ErrorMessage nvarchar(max)=NULL,@AttachmentFileName nvarchar(500)=NULL
AS BEGIN SET NOCOUNT ON; UPDATE dbo.CommitmentClientBillingEmailLog SET Status=@Status,ErrorMessage=@ErrorMessage,AttachmentFileName=@AttachmentFileName,SentDateTime=CASE WHEN @Status='Sent' THEN GETDATE() ELSE NULL END WHERE LogID=@LogID; END
GO
