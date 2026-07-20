/* Full feedback capture for the isolated OLTracking workflow. Safe to run repeatedly. */
IF COL_LENGTH('dbo.OLTracking_Feedback', 'MarkedTo') IS NULL ALTER TABLE dbo.OLTracking_Feedback ADD MarkedTo nvarchar(200) NULL;
IF COL_LENGTH('dbo.OLTracking_Feedback', 'ErrorBy') IS NULL ALTER TABLE dbo.OLTracking_Feedback ADD ErrorBy nvarchar(200) NULL;
IF COL_LENGTH('dbo.OLTracking_Feedback', 'FeedbackBy') IS NULL ALTER TABLE dbo.OLTracking_Feedback ADD FeedbackBy nvarchar(200) NULL;
IF COL_LENGTH('dbo.OLTracking_Feedback', 'ErrorType') IS NULL ALTER TABLE dbo.OLTracking_Feedback ADD ErrorType nvarchar(100) NULL;
IF COL_LENGTH('dbo.OLTracking_Feedback', 'CategoryID') IS NULL ALTER TABLE dbo.OLTracking_Feedback ADD CategoryID int NULL;
IF COL_LENGTH('dbo.OLTracking_Feedback', 'Category') IS NULL ALTER TABLE dbo.OLTracking_Feedback ADD Category nvarchar(200) NULL;
IF COL_LENGTH('dbo.OLTracking_Feedback', 'SubcategoryID') IS NULL ALTER TABLE dbo.OLTracking_Feedback ADD SubcategoryID int NULL;
IF COL_LENGTH('dbo.OLTracking_Feedback', 'Subcategory') IS NULL ALTER TABLE dbo.OLTracking_Feedback ADD Subcategory nvarchar(200) NULL;
IF COL_LENGTH('dbo.OLTracking_Feedback', 'Severity') IS NULL ALTER TABLE dbo.OLTracking_Feedback ADD Severity nvarchar(100) NULL;
IF COL_LENGTH('dbo.OLTracking_Feedback', 'ErrorField') IS NULL ALTER TABLE dbo.OLTracking_Feedback ADD ErrorField nvarchar(500) NULL;
IF COL_LENGTH('dbo.OLTracking_Feedback', 'FeedbackType') IS NULL ALTER TABLE dbo.OLTracking_Feedback ADD FeedbackType nvarchar(100) NULL;
IF COL_LENGTH('dbo.OLTracking_Feedback', 'ErrorText') IS NULL ALTER TABLE dbo.OLTracking_Feedback ADD ErrorText nvarchar(2000) NULL;
IF COL_LENGTH('dbo.OLTracking_Feedback', 'ShouldBe') IS NULL ALTER TABLE dbo.OLTracking_Feedback ADD ShouldBe nvarchar(2000) NULL;
IF COL_LENGTH('dbo.OLTracking_Feedback', 'Remark') IS NULL ALTER TABLE dbo.OLTracking_Feedback ADD Remark nvarchar(1000) NULL;
IF COL_LENGTH('dbo.OLTracking_Feedback', 'Screen') IS NULL ALTER TABLE dbo.OLTracking_Feedback ADD Screen nvarchar(1000) NULL;
IF COL_LENGTH('dbo.OLTracking_Feedback', 'ExternalFeedbackID') IS NULL ALTER TABLE dbo.OLTracking_Feedback ADD ExternalFeedbackID bigint NULL;
IF COL_LENGTH('dbo.OLTracking_Feedback', 'ExternalTable') IS NULL ALTER TABLE dbo.OLTracking_Feedback ADD ExternalTable nvarchar(100) NULL;
GO

IF OBJECT_ID('dbo.OLTracking_GetFeedbackDefaults', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_GetFeedbackDefaults AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_GetFeedbackDefaults
    @AssignmentID bigint,
    @UserID int,
    @FeedbackBy nvarchar(200)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ItemID bigint, @ProjectID int, @CurrentStage int;
    SELECT @ItemID=a.ItemID,@ProjectID=a.ProjectID,@CurrentStage=currentFlow.StageNo
    FROM dbo.OLTracking_Assignment a
    INNER JOIN dbo.OLTracking_ProcessFlow currentFlow
        ON currentFlow.ProjectID=a.ProjectID AND currentFlow.ProcessID=a.ProcessID AND currentFlow.IsActive=1
    WHERE a.AssignmentID=@AssignmentID AND a.UserID=@UserID AND a.IsCurrent=1;

    IF @ItemID IS NULL THROW 50124, 'Assignment is no longer available.', 1;

    SELECT a.AssignmentID,a.ProjectID,p.ProjectName AS Client,a.ProcessID,currentFlow.ProcessName,i.DealNumber,i.ItemNumber AS LoanNumber,
           @FeedbackBy AS FeedbackBy,
           CONVERT(varchar(10),GETDATE(),101) AS QCDate,
           (SELECT COUNT(1) FROM dbo.OLTracking_Feedback f WHERE f.AssignmentID=@AssignmentID AND f.IsDeleted=0) AS FeedbackCount
    FROM dbo.OLTracking_Assignment a
    INNER JOIN dbo.OLTracking_Item i ON i.ItemID=a.ItemID
    INNER JOIN dbo.OLTracking_ProcessFlow currentFlow ON currentFlow.ProjectID=a.ProjectID AND currentFlow.ProcessID=a.ProcessID
    INNER JOIN dbo.Project p ON p.ProjectID=a.ProjectID
    WHERE a.AssignmentID=@AssignmentID;

    SELECT DISTINCT previousFlow.ProcessID,previousFlow.ProcessName
    FROM dbo.OLTracking_Assignment previous
    INNER JOIN dbo.OLTracking_ProcessFlow previousFlow
        ON previousFlow.ProjectID=previous.ProjectID AND previousFlow.ProcessID=previous.ProcessID AND previousFlow.IsActive=1
    WHERE previous.ItemID=@ItemID
      AND previous.AssignmentStatus='Completed'
      AND previousFlow.StageNo<@CurrentStage
    ORDER BY previousFlow.ProcessName;

    SELECT DISTINCT previous.AssignmentID,previous.ProcessID,previousFlow.ProcessName,previousFlow.StageNo,previous.CompletedDate,
           COALESCE(NULLIF(employeeConfig.Code,''),NULLIF(e.Code,''),CONVERT(nvarchar(30),previous.UserID)) AS UserCode,
           COALESCE(NULLIF(employeeConfig.PsuedoName,''),NULLIF(employeeConfig.Code,''),
                    NULLIF(e.Code,''),CONVERT(nvarchar(30),previous.UserID)) AS UserName
    FROM dbo.OLTracking_Assignment previous
    INNER JOIN dbo.OLTracking_ProcessFlow previousFlow
        ON previousFlow.ProjectID=previous.ProjectID AND previousFlow.ProcessID=previous.ProcessID AND previousFlow.IsActive=1
    LEFT JOIN dbo.EmployeeInfo e ON e.EmployeeID=previous.UserID
    OUTER APPLY
    (
        SELECT TOP 1 configuration.Code,configuration.PsuedoName
        FROM dbo.EmployeeConfiguration configuration
        WHERE configuration.EmployeeID=previous.UserID
          AND configuration.Code=e.Code
          AND configuration.DataSource='ERP'
          AND configuration.IsDelete=0
        ORDER BY configuration.EmpConfigrationID DESC
    ) employeeConfig
    WHERE previous.ItemID=@ItemID
      AND previous.AssignmentStatus='Completed'
      AND previousFlow.StageNo<@CurrentStage
    ORDER BY previousFlow.StageNo DESC,previous.CompletedDate DESC,UserName;
END;
GO

IF OBJECT_ID('dbo.OLTracking_SaveFeedback', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_SaveFeedback AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_SaveFeedback
    @AssignmentID bigint,@MarkedTo nvarchar(200),@ErrorBy nvarchar(200),@FeedbackBy nvarchar(200),
    @ErrorType nvarchar(100),@CategoryID int,@Category nvarchar(200),@SubcategoryID int,@Subcategory nvarchar(200),
    @Severity nvarchar(100),@ErrorField nvarchar(500),@Screen nvarchar(1000),@FeedbackType nvarchar(100),@Error nvarchar(2000),
    @ShouldBe nvarchar(2000),@Remark nvarchar(1000),@DateReviewed nvarchar(100),@UserID int
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        DECLARE @LoanNumber nvarchar(150),@Client nvarchar(100),@ExternalFeedbackID bigint,@ExternalTable nvarchar(100);
        SELECT @LoanNumber=i.ItemNumber,@Client=p.ProjectName
        FROM dbo.OLTracking_Assignment a WITH(UPDLOCK,HOLDLOCK)
        INNER JOIN dbo.OLTracking_Item i ON i.ItemID=a.ItemID
        INNER JOIN dbo.Project p ON p.ProjectID=a.ProjectID
        WHERE a.AssignmentID=@AssignmentID AND a.UserID=@UserID AND a.IsCurrent=1;
        IF @LoanNumber IS NULL THROW 50124, 'Assignment is no longer available.', 1;

        IF NULLIF(LTRIM(RTRIM(@MarkedTo)),'') IS NULL OR NULLIF(LTRIM(RTRIM(@ErrorBy)),'') IS NULL OR
           NULLIF(LTRIM(RTRIM(@ErrorType)),'') IS NULL OR @CategoryID<=0 OR @SubcategoryID<=0 OR
           NULLIF(LTRIM(RTRIM(@FeedbackType)),'') IS NULL OR NULLIF(LTRIM(RTRIM(@Error)),'') IS NULL
            THROW 50123, 'Required feedback fields are missing.', 1;

        IF @Client IN('561','2104')
        BEGIN
            INSERT dbo.ImportedFeedbacks_Servicing
                ([Loan Number],[Client],[UW Name],[QC Name],[Date Reviewed],[QC Date],[Category],[Sub category],
                 [Error Field],[Screen],[Error Type],[Finding],[Feedback Type],[Severity],[RCA],[Comments],[Source],
                 [Feedback Received Date],[Emp Status],[AddedBy],[AddedDate],[IsDisplayFeedbackInERP],[Finding Status])
            VALUES(@LoanNumber,@Client,@ErrorBy,@FeedbackBy,@DateReviewed,CONVERT(varchar(10),GETDATE(),101),@Category,@Subcategory,
                   LEFT(@ErrorField,255),LEFT(@Screen,255),@ErrorType,@Error,@FeedbackType,@Severity,@ShouldBe,LEFT(@Remark,255),'Internal',GETDATE(),
                   'Active',@UserID,GETDATE(),1,'Pending');
            SET @ExternalFeedbackID=CONVERT(bigint,SCOPE_IDENTITY()); SET @ExternalTable='ImportedFeedbacks_Servicing';
        END
        ELSE
        BEGIN
            INSERT dbo.ImportedFeedbacks
                ([Loan Number],[Client],[UW Name],[QC Name],[Date Reviewed],[QC Date],[Category],[Sub category],
                 [Error Field],[Screen],[Error Type],[Finding],[Feedback Type],[Severity],[RCA],[Comments],[Source],
                 [Feedback Received Date],[Emp Status],[AddedBy],[AddedDate],[IsDisplayFeedbackInERP],[Finding Status],[QCDate_Converted])
            VALUES(@LoanNumber,@Client,@ErrorBy,@FeedbackBy,@DateReviewed,CONVERT(varchar(10),GETDATE(),101),@Category,@Subcategory,
                   @ErrorField,@Screen,@ErrorType,@Error,@FeedbackType,@Severity,@ShouldBe,@Remark,'Internal',
                   CONVERT(varchar(10),GETDATE(),101),'Active',@UserID,GETDATE(),1,'Pending',CONVERT(date,GETDATE()));
            SET @ExternalFeedbackID=CONVERT(bigint,SCOPE_IDENTITY()); SET @ExternalTable='ImportedFeedbacks';
        END

        INSERT dbo.OLTracking_Feedback
            (AssignmentID,FeedbackText,MarkedTo,ErrorBy,FeedbackBy,ErrorType,CategoryID,Category,SubcategoryID,
             Subcategory,Severity,ErrorField,Screen,FeedbackType,ErrorText,ShouldBe,Remark,ExternalFeedbackID,ExternalTable,AddedBy)
        VALUES(@AssignmentID,@Error,@MarkedTo,@ErrorBy,@FeedbackBy,@ErrorType,@CategoryID,@Category,@SubcategoryID,
               @Subcategory,NULLIF(@Severity,''),NULLIF(@ErrorField,''),NULLIF(@Screen,''),@FeedbackType,@Error,
               NULLIF(@ShouldBe,''),NULLIF(@Remark,''),@ExternalFeedbackID,@ExternalTable,@UserID);

        DECLARE @FeedbackID bigint=CONVERT(bigint,SCOPE_IDENTITY());
        SELECT @FeedbackID AS FeedbackID,COUNT(1) AS FeedbackCount,@ExternalFeedbackID AS ExternalFeedbackID,@ExternalTable AS ExternalTable
        FROM dbo.OLTracking_Feedback WHERE AssignmentID=@AssignmentID AND IsDeleted=0;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

IF OBJECT_ID('dbo.OLTracking_CompleteLoan', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_CompleteLoan AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_CompleteLoan
    @AssignmentID bigint,@Remark nvarchar(1000),@FeedbackXml xml=NULL,@UserID int
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        IF NULLIF(LTRIM(RTRIM(@Remark)),'') IS NULL THROW 50121, 'Remark is required.', 1;
        DECLARE @ItemID bigint,@ProjectID int,@ProcessID int,@OldStatus varchar(20),@FeedbackRequired bit;
        SELECT @ItemID=a.ItemID,@ProjectID=a.ProjectID,@ProcessID=a.ProcessID,@OldStatus=a.AssignmentStatus,
               @FeedbackRequired=f.FeedbackRequiredOnComplete
        FROM dbo.OLTracking_Assignment a WITH(UPDLOCK,HOLDLOCK)
        INNER JOIN dbo.OLTracking_ProcessFlow f ON f.ProjectID=a.ProjectID AND f.ProcessID=a.ProcessID AND f.IsActive=1
        WHERE a.AssignmentID=@AssignmentID AND a.UserID=@UserID AND a.IsCurrent=1;
        IF @ItemID IS NULL THROW 50122, 'Assignment was not found.', 1;

        IF @FeedbackXml IS NOT NULL
            INSERT dbo.OLTracking_Feedback(AssignmentID,FeedbackText,AddedBy)
            SELECT @AssignmentID,n.value('(text())[1]','nvarchar(2000)'),@UserID
            FROM @FeedbackXml.nodes('/feedbacks/feedback') x(n)
            WHERE NULLIF(LTRIM(RTRIM(n.value('(text())[1]','nvarchar(2000)'))),'') IS NOT NULL;

        IF @FeedbackRequired=1 AND NOT EXISTS
           (SELECT 1 FROM dbo.OLTracking_Feedback WHERE AssignmentID=@AssignmentID AND IsDeleted=0)
            THROW 50123, 'Feedback is mandatory for this process.', 1;

        UPDATE dbo.OLTracking_Assignment SET AssignmentStatus='Completed',CompletedDate=GETDATE(),LastRemark=@Remark,
               IsCurrent=0,UpdatedBy=@UserID,UpdatedDate=GETDATE() WHERE AssignmentID=@AssignmentID;
        INSERT dbo.OLTracking_StatusHistory(AssignmentID,OldStatus,NewStatus,Remark,ChangedBy)
        VALUES(@AssignmentID,@OldStatus,'Completed',@Remark,@UserID);

        DECLARE @AllMandatoryDone bit=0;
        IF NOT EXISTS(SELECT 1 FROM dbo.OLTracking_ProcessFlow rf WHERE rf.ProjectID=@ProjectID AND rf.IsActive=1 AND rf.IsMandatory=1
          AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_Assignment ca WHERE ca.ItemID=@ItemID AND ca.ProcessID=rf.ProcessID AND ca.AssignmentStatus IN('Completed','Skipped')))
            SET @AllMandatoryDone=1;
        UPDATE dbo.OLTracking_Item SET ItemStatus=CASE WHEN @AllMandatoryDone=1 THEN 'Completed' ELSE 'Pending' END,
               CurrentProcessID=NULL,UpdatedBy=@UserID,UpdatedDate=GETDATE() WHERE ItemID=@ItemID;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
