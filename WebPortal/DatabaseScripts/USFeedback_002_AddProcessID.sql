ALTER PROCEDURE dbo.usp_InsertUSImportedFeedback_NewERP
 @LoanNo nvarchar(max), @Client nvarchar(max), @UWName nvarchar(max), @QCName nvarchar(max),
 @DateReviewed nvarchar(max), @QCDate nvarchar(max), @Severity nvarchar(max), @Finding nvarchar(max),
 @Source nvarchar(max), @FeedbackReceivedDate nvarchar(max), @AddedBy int, @ProcessID int = 0
AS
BEGIN
 SET NOCOUNT ON;
 IF ISNULL(@QCName,'')='' SELECT @QCName=PsuedoName FROM dbo.EmployeeConfiguration WHERE EmployeeID=@AddedBy AND DataSource='ERP';
 IF @UWName=@QCName SET @UWName='';
 -- @ProcessID is available here for project/task-specific UW-name rules.
 IF @Client IN ('561','2104')
 BEGIN
  INSERT dbo.ImportedFeedbacks_Servicing
   ([Loan Number],Client,[UW Name],[QC Name],[Date Reviewed],[QC Date],Finding,Severity,Source,[Feedback Received Date],AddedBy,AddedDate)
  VALUES(@LoanNo,@Client,@UWName,@QCName,@DateReviewed,@QCDate,@Finding,@Severity,@Source,@FeedbackReceivedDate,@AddedBy,GETDATE());
  RETURN CONVERT(int,SCOPE_IDENTITY());
 END
 INSERT dbo.ImportedFeedbacks
  ([Loan Number],Client,[UW Name],[QC Name],[Date Reviewed],[QC Date],Finding,Severity,Source,[Feedback Received Date],AddedBy,AddedDate)
 VALUES(@LoanNo,@Client,@UWName,@QCName,@DateReviewed,@QCDate,@Finding,@Severity,@Source,@FeedbackReceivedDate,@AddedBy,GETDATE());
 RETURN CONVERT(int,SCOPE_IDENTITY());
END;
