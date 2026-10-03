SET NOCOUNT ON;
GO

IF OBJECT_ID('dbo.FTEClientBillingEmailLog','U') IS NULL
BEGIN
    CREATE TABLE dbo.FTEClientBillingEmailLog
    (
        LogID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_FTEClientBillingEmailLog PRIMARY KEY,
        ProjectID int NOT NULL,
        BillingPeriod nvarchar(1000) NOT NULL,
        PeriodFrom date NOT NULL,
        PeriodTo date NOT NULL,
        ActualTo nvarchar(max) NULL,
        ActualCc nvarchar(max) NULL,
        ActualBcc nvarchar(max) NULL,
        SentTo nvarchar(max) NULL,
        IsTestEmail bit NOT NULL CONSTRAINT DF_FTEClientBillingEmailLog_IsTest DEFAULT(0),
        Status nvarchar(30) NOT NULL,
        ErrorMessage nvarchar(max) NULL,
        AttachmentFileName nvarchar(500) NULL,
        SentDateTime datetime NULL,
        AddedBy int NULL,
        AddedDate datetime NOT NULL CONSTRAINT DF_FTEClientBillingEmailLog_AddedDate DEFAULT(GETDATE()),
        CONSTRAINT UQ_FTEClientBillingEmailLog_ProjectMonthMode UNIQUE(ProjectID, PeriodFrom, IsTestEmail)
    );
END
GO

IF OBJECT_ID('dbo.usp_PrepareFTEClientMonthlyBilling','P') IS NOT NULL DROP PROCEDURE dbo.usp_PrepareFTEClientMonthlyBilling;
GO
CREATE PROCEDURE dbo.usp_PrepareFTEClientMonthlyBilling
    @ProjectID int,
    @BillingPeriod nvarchar(1000)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRANSACTION;
    IF EXISTS (SELECT 1 FROM dbo.ProjectBillingDetails WITH (UPDLOCK,HOLDLOCK) WHERE ProjectId=@ProjectID AND LTRIM(RTRIM(BillingPeriod))=LTRIM(RTRIM(@BillingPeriod)))
        UPDATE dbo.ProjectBillingDetails SET BillingCycle='Monthly' WHERE ProjectId=@ProjectID AND LTRIM(RTRIM(BillingPeriod))=LTRIM(RTRIM(@BillingPeriod));
    ELSE
        INSERT dbo.ProjectBillingDetails(ProjectId,BillingPeriod,BillingCycle,CurrentStatus,AddedDate,Client)
        SELECT @ProjectID,@BillingPeriod,'Monthly','Pending',GETDATE(),ProjectName FROM dbo.Project WHERE ProjectID=@ProjectID;
    COMMIT TRANSACTION;
END
GO

IF OBJECT_ID('dbo.usp_StartFTEClientBillingEmail','P') IS NOT NULL DROP PROCEDURE dbo.usp_StartFTEClientBillingEmail;
GO
CREATE PROCEDURE dbo.usp_StartFTEClientBillingEmail
 @ProjectID int,@BillingPeriod nvarchar(1000),@PeriodFrom date,@PeriodTo date,
 @ActualTo nvarchar(max),@ActualCc nvarchar(max)=NULL,@ActualBcc nvarchar(max)=NULL,
 @SentTo nvarchar(max),@IsTestEmail bit,@AddedBy int=NULL
AS
BEGIN
 SET NOCOUNT ON; SET XACT_ABORT ON; BEGIN TRANSACTION;
 DECLARE @ID bigint;
 SELECT @ID=LogID FROM dbo.FTEClientBillingEmailLog WITH(UPDLOCK,HOLDLOCK) WHERE ProjectID=@ProjectID AND PeriodFrom=@PeriodFrom AND IsTestEmail=@IsTestEmail;
 IF @ID IS NOT NULL AND EXISTS(SELECT 1 FROM dbo.FTEClientBillingEmailLog WHERE LogID=@ID AND (Status='Sent' OR (Status='Processing' AND AddedDate>=DATEADD(minute,-30,GETDATE())))) BEGIN COMMIT; SELECT CAST(0 AS bigint) LogID; RETURN; END
 IF @ID IS NULL BEGIN
  INSERT dbo.FTEClientBillingEmailLog(ProjectID,BillingPeriod,PeriodFrom,PeriodTo,ActualTo,ActualCc,ActualBcc,SentTo,IsTestEmail,Status,AddedBy)
  VALUES(@ProjectID,@BillingPeriod,@PeriodFrom,@PeriodTo,@ActualTo,@ActualCc,@ActualBcc,@SentTo,@IsTestEmail,'Processing',@AddedBy); SET @ID=SCOPE_IDENTITY();
 END ELSE UPDATE dbo.FTEClientBillingEmailLog SET Status='Processing',ErrorMessage=NULL,ActualTo=@ActualTo,ActualCc=@ActualCc,ActualBcc=@ActualBcc,SentTo=@SentTo,IsTestEmail=@IsTestEmail,AddedBy=@AddedBy,AddedDate=GETDATE() WHERE LogID=@ID;
 COMMIT; SELECT @ID LogID;
END
GO

IF OBJECT_ID('dbo.usp_CompleteFTEClientBillingEmail','P') IS NOT NULL DROP PROCEDURE dbo.usp_CompleteFTEClientBillingEmail;
GO
CREATE PROCEDURE dbo.usp_CompleteFTEClientBillingEmail @LogID bigint,@Status nvarchar(30),@ErrorMessage nvarchar(max)=NULL,@AttachmentFileName nvarchar(500)=NULL
AS
BEGIN
 SET NOCOUNT ON;
 UPDATE dbo.FTEClientBillingEmailLog SET Status=@Status,ErrorMessage=@ErrorMessage,AttachmentFileName=@AttachmentFileName,SentDateTime=CASE WHEN @Status='Sent' THEN GETDATE() ELSE NULL END WHERE LogID=@LogID;
END
GO
