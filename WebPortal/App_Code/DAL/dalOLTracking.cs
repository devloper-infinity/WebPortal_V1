using System;
using System.Data;
using System.Data.SqlClient;
using System.Xml.Linq;

namespace WebPortal.App_Code.DAL
{
    public sealed class dalOLTracking
    {
        private static SqlCommand Command(string name)
        {
            return new SqlCommand(name) { CommandType = CommandType.StoredProcedure, CommandTimeout = 90 };
        }

        private static void Add(SqlCommand command, string name, SqlDbType type, object value, int size = 0)
        {
            SqlParameter parameter = size == 0 ? command.Parameters.Add(name, type) : command.Parameters.Add(name, type, size);
            parameter.Value = value ?? DBNull.Value;
        }

        private static DataTable Table(SqlCommand command)
        {
            using (command)
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlDataAdapter adapter = new SqlDataAdapter(command))
            {
                command.Connection = connection;
                DataTable table = new DataTable();
                adapter.Fill(table);
                return table;
            }
        }

        private static DataSet Set(SqlCommand command)
        {
            using (command)
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlDataAdapter adapter = new SqlDataAdapter(command))
            {
                command.Connection = connection;
                DataSet set = new DataSet();
                adapter.Fill(set);
                return set;
            }
        }

        private static int Execute(SqlCommand command)
        {
            using (command)
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            {
                command.Connection = connection;
                connection.Open();
                object value = command.ExecuteScalar();
                return value == null || value == DBNull.Value ? 0 : Convert.ToInt32(value);
            }
        }

        public DataTable GetProjects()
        {
            return Table(Command("usp_GetAllProject"));
        }

        public DataTable GetProcesses(int projectId)
        {
            SqlCommand command = Command("GetProcessBYProject");
            Add(command, "@ProjectID", SqlDbType.NVarChar, projectId.ToString(), 100);
            return Table(command);
        }

        public DataTable GetFields(int projectId)
        {
            SqlCommand command = Command("OLTracking_GetFields");
            Add(command, "@ProjectID", SqlDbType.Int, projectId);
            return Table(command);
        }

        public int SaveField(int fieldId, int projectId, string fieldName, string dataType, string dateFormat, string optionsText, int displayOrder,
            bool isRequired, bool isVisible, bool isEditable, bool isUnique, int userId)
        {
            SqlCommand command = Command("OLTracking_SaveField");
            Add(command, "@FieldID", SqlDbType.Int, fieldId); Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@FieldName", SqlDbType.NVarChar, fieldName, 150); Add(command, "@DataType", SqlDbType.VarChar, dataType, 20);
            Add(command, "@DateFormat", SqlDbType.VarChar, string.IsNullOrWhiteSpace(dateFormat) ? null : dateFormat, 30);
            Add(command, "@OptionsText", SqlDbType.NVarChar, string.IsNullOrWhiteSpace(optionsText) ? null : optionsText, -1);
            Add(command, "@DisplayOrder", SqlDbType.Int, displayOrder); Add(command, "@IsRequired", SqlDbType.Bit, isRequired);
            Add(command, "@IsVisible", SqlDbType.Bit, isVisible); Add(command, "@IsEditable", SqlDbType.Bit, isEditable);
            Add(command, "@IsUnique", SqlDbType.Bit, isUnique); Add(command, "@UserID", SqlDbType.Int, userId);
            return Execute(command);
        }

        public int RetireField(int fieldId, int userId)
        {
            SqlCommand command = Command("OLTracking_RetireField");
            Add(command, "@FieldID", SqlDbType.Int, fieldId); Add(command, "@UserID", SqlDbType.Int, userId);
            return Execute(command);
        }

        public DataSet GetProcessConfiguration(int projectId)
        {
            SqlCommand command = Command("OLTracking_GetProcessConfiguration");
            Add(command, "@ProjectID", SqlDbType.Int, projectId);
            return Set(command);
        }

        public void SaveProjectSetting(int projectId, string itemLabel, byte maxActive, int userId)
        {
            SqlCommand command = Command("OLTracking_SaveProjectSetting");
            Add(command, "@ProjectID", SqlDbType.Int, projectId); Add(command, "@ItemLabel", SqlDbType.NVarChar, itemLabel, 20);
            Add(command, "@MaxActiveAssignments", SqlDbType.TinyInt, maxActive); Add(command, "@UserID", SqlDbType.Int, userId);
            ExecuteNonQuery(command);
        }

        public void SaveProcessConfiguration(int projectId, int processId, bool canSkip, bool isActive, bool feedbackRequired, string prerequisiteMode, int[] sourceProcessIds, int userId)
        {
            XElement sources = new XElement("processes");
            if (sourceProcessIds != null) foreach (int sourceId in sourceProcessIds)
                if (sourceId > 0 && sourceId != processId) sources.Add(new XElement("process", new XAttribute("id", sourceId)));
            SqlCommand command = Command("OLTracking_SaveProcessConfiguration");
            Add(command, "@ProjectID", SqlDbType.Int, projectId); Add(command, "@ProcessID", SqlDbType.Int, processId);
            Add(command, "@CanSkip", SqlDbType.Bit, canSkip); Add(command, "@IsActive", SqlDbType.Bit, isActive);
            Add(command, "@FeedbackRequiredOnComplete", SqlDbType.Bit, feedbackRequired);
            Add(command, "@PrerequisiteMode", SqlDbType.VarChar, prerequisiteMode, 3);
            Add(command, "@SourceProcessesXml", SqlDbType.Xml, sources.HasElements ? sources.ToString(SaveOptions.DisableFormatting) : null);
            Add(command, "@UserID", SqlDbType.Int, userId);
            ExecuteNonQuery(command);
        }

        public DataTable GetDeals(int projectId)
        {
            SqlCommand command = Command("OLTracking_GetDeals"); Add(command, "@ProjectID", SqlDbType.Int, projectId); return Table(command);
        }

        public DataSet GetItems(int projectId)
        {
            SqlCommand command = Command("OLTracking_GetItems"); Add(command, "@ProjectID", SqlDbType.Int, projectId); return Set(command);
        }

        public long SaveItem(long itemId, int projectId, string itemNumber, string dealNumber, int? processId, int userId)
        {
            SqlCommand command = Command("OLTracking_SaveItem");
            Add(command, "@ItemID", SqlDbType.BigInt, itemId); Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@ItemNumber", SqlDbType.NVarChar, itemNumber, 150); Add(command, "@DealNumber", SqlDbType.NVarChar, dealNumber, 150);
            Add(command, "@CurrentProcessID", SqlDbType.Int, processId); Add(command, "@UserID", SqlDbType.Int, userId);
            using (command) using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            { command.Connection = connection; connection.Open(); return Convert.ToInt64(command.ExecuteScalar()); }
        }

        public void SaveItemValues(long itemId, System.Collections.Generic.IDictionary<int, string> values, int userId)
        {
            XElement root = new XElement("values");
            if (values != null) foreach (System.Collections.Generic.KeyValuePair<int, string> pair in values)
                root.Add(new XElement("value", new XAttribute("fieldId", pair.Key), pair.Value ?? string.Empty));
            SqlCommand command = Command("OLTracking_SaveItemValues"); Add(command, "@ItemID", SqlDbType.BigInt, itemId);
            Add(command, "@ValuesXml", SqlDbType.Xml, root.ToString(SaveOptions.DisableFormatting)); Add(command, "@UserID", SqlDbType.Int, userId);
            ExecuteNonQuery(command);
        }

        public DataTable GetNextItem(int projectId, string dealNumber, int processId, int userId)
        {
            SqlCommand command = Command("OLTracking_GetNextItem");
            Add(command, "@ProjectID", SqlDbType.Int, projectId); Add(command, "@DealNumber", SqlDbType.NVarChar, dealNumber, 150);
            Add(command, "@ProcessID", SqlDbType.Int, processId); Add(command, "@UserID", SqlDbType.Int, userId); return Table(command);
        }

        public int Allocate(long itemId, int projectId, int processId, int userId)
        {
            SqlCommand command = Command("OLTracking_AllocateItem");
            Add(command, "@ItemID", SqlDbType.BigInt, itemId); Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@ProcessID", SqlDbType.Int, processId); Add(command, "@UserID", SqlDbType.Int, userId); return Execute(command);
        }

        public DataSet GetDashboard(int userId)
        {
            SqlCommand command = Command("OLTracking_GetUserDashboard"); Add(command, "@UserID", SqlDbType.Int, userId); return Set(command);
        }

        public void UpdateStatus(long assignmentId, string status, string remark, string[] feedbacks, int userId)
        {
            XElement root = new XElement("feedbacks");
            if (feedbacks != null) foreach (string feedback in feedbacks)
                if (!string.IsNullOrWhiteSpace(feedback)) root.Add(new XElement("feedback", feedback.Trim()));
            SqlCommand command = Command("OLTracking_UpdateAssignmentStatus");
            Add(command, "@AssignmentID", SqlDbType.BigInt, assignmentId); Add(command, "@Status", SqlDbType.VarChar, status, 20);
            Add(command, "@Remark", SqlDbType.NVarChar, remark, 1000);
            Add(command, "@FeedbackXml", SqlDbType.Xml, root.HasElements ? root.ToString(SaveOptions.DisableFormatting) : null);
            Add(command, "@UserID", SqlDbType.Int, userId); ExecuteNonQuery(command);
        }

        public DataSet GetDailyStatus(int userId, int projectId, int processId, DateTime? fromDate, DateTime? toDate)
        {
            SqlCommand command = Command("OLTracking_GetDailyStatus");
            Add(command, "@UserID", SqlDbType.Int, userId); Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@ProcessID", SqlDbType.Int, processId); Add(command, "@FromDate", SqlDbType.Date, fromDate);
            Add(command, "@ToDate", SqlDbType.Date, toDate); return Set(command);
        }

        public DataTable GetProcessFlow(int projectId)
        {
            EnsureFinalProcessColumn();
            SqlCommand command = new SqlCommand(@"
SELECT FlowID,ProjectID,ProcessID,ProcessName,StageNo,IsMandatory,
       CAST(CASE WHEN IsMandatory=1 THEN 0 ELSE 1 END AS bit) CanSkip,
       FeedbackRequiredOnComplete,IsFinalProcess,IsActive
FROM dbo.OLTracking_ProcessFlow
WHERE ProjectID=@ProjectID AND IsActive=1
ORDER BY StageNo,ProcessName;") { CommandType = CommandType.Text };
            Add(command, "@ProjectID", SqlDbType.Int, projectId);
            return Table(command);
        }

        public void SaveProcessFlow(int projectId, int processId, string processName, int stageNo, bool isMandatory, bool feedbackRequired, bool isFinalProcess, int userId)
        {
            EnsureFinalProcessColumn();
            SqlCommand command = new SqlCommand(@"
SET NOCOUNT ON;
SET XACT_ABORT ON;
IF @ProjectID<=0 OR @ProcessID<=0 THROW 50100,'Project and process are required.',1;
IF @StageNo<=0 THROW 50101,'Sequence must be greater than zero.',1;
IF NULLIF(LTRIM(RTRIM(@ProcessName)),'') IS NULL THROW 50102,'Process name is required.',1;
BEGIN TRANSACTION;
IF @IsFinalProcess=1
    UPDATE dbo.OLTracking_ProcessFlow
       SET IsFinalProcess=0,UpdatedBy=@UserID,UpdatedDate=GETDATE()
     WHERE ProjectID=@ProjectID AND ProcessID<>@ProcessID AND IsActive=1 AND IsFinalProcess=1;
MERGE dbo.OLTracking_ProcessFlow AS T
USING(SELECT @ProjectID ProjectID,@ProcessID ProcessID) S
ON T.ProjectID=S.ProjectID AND T.ProcessID=S.ProcessID
WHEN MATCHED THEN UPDATE SET ProcessName=LTRIM(RTRIM(@ProcessName)),StageNo=@StageNo,IsMandatory=@IsMandatory,
 FeedbackRequiredOnComplete=@FeedbackRequiredOnComplete,IsFinalProcess=@IsFinalProcess,IsActive=1,UpdatedBy=@UserID,UpdatedDate=GETDATE()
WHEN NOT MATCHED THEN INSERT(ProjectID,ProcessID,ProcessName,StageNo,IsMandatory,FeedbackRequiredOnComplete,IsFinalProcess,AddedBy)
 VALUES(@ProjectID,@ProcessID,LTRIM(RTRIM(@ProcessName)),@StageNo,@IsMandatory,@FeedbackRequiredOnComplete,@IsFinalProcess,@UserID);
COMMIT TRANSACTION;") { CommandType = CommandType.Text };
            Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@ProcessID", SqlDbType.Int, processId); Add(command, "@ProcessName", SqlDbType.NVarChar, processName, 200);
            Add(command, "@StageNo", SqlDbType.Int, stageNo); Add(command, "@IsMandatory", SqlDbType.Bit, isMandatory);
            Add(command, "@FeedbackRequiredOnComplete", SqlDbType.Bit, feedbackRequired); Add(command, "@IsFinalProcess", SqlDbType.Bit, isFinalProcess);
            Add(command, "@UserID", SqlDbType.Int, userId);
            ExecuteNonQuery(command);
        }

        private static void EnsureFinalProcessColumn()
        {
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand command = new SqlCommand(@"
IF COL_LENGTH('dbo.OLTracking_ProcessFlow','IsFinalProcess') IS NULL
    ALTER TABLE dbo.OLTracking_ProcessFlow ADD IsFinalProcess bit NOT NULL
        CONSTRAINT DF_OLTracking_ProcessFlow_Final DEFAULT(0) WITH VALUES;
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.OLTracking_ProcessFlow') AND name='UX_OLTracking_ProcessFlow_Final')
    EXEC(N'CREATE UNIQUE INDEX UX_OLTracking_ProcessFlow_Final
        ON dbo.OLTracking_ProcessFlow(ProjectID)
        WHERE IsFinalProcess=1 AND IsActive=1;');", connection))
            {
                connection.Open();
                command.ExecuteNonQuery();
            }
        }

        public int RemoveProcessFlow(int projectId, int processId, int userId)
        {
            SqlCommand command = Command("OLTracking_RemoveProcessFlow"); Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@ProcessID", SqlDbType.Int, processId); Add(command, "@UserID", SqlDbType.Int, userId); return Execute(command);
        }

        public DataTable GetImportedDeals(int projectId)
        {
            EnsureImportSourceColumn();
            SqlCommand command = new SqlCommand(@"
SELECT DISTINCT DealNumber AS DealNo, DealNumber
FROM dbo.OLTracking_Item
WHERE ProjectID = @ProjectID AND IsDeleted = 0 AND RecordSource = 'Import'
  AND NULLIF(LTRIM(RTRIM(DealNumber)), '') IS NOT NULL
ORDER BY DealNumber;") { CommandType = CommandType.Text };
            Add(command, "@ProjectID", SqlDbType.Int, projectId); return Table(command);
        }

        public DataTable GetImportedLoans(int projectId, string dealNumber)
        {
            EnsureImportSourceColumn();
            SqlCommand command = new SqlCommand(@"
SELECT ItemNumber AS LoanNumber, ISNULL(DealNumber, '') AS DealNumber
FROM dbo.OLTracking_Item
WHERE ProjectID = @ProjectID AND IsDeleted = 0 AND RecordSource = 'Import'
  AND ISNULL(DealNumber, '') = ISNULL(@DealNumber, '')
ORDER BY ItemID;") { CommandType = CommandType.Text };
            Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@DealNumber", SqlDbType.NVarChar, dealNumber ?? string.Empty, 150); return Table(command);
        }

        public DataTable GetNextEligibleImportedLoan(int projectId, string dealNumber, int processId)
        {
            EnsureImportSourceColumn();
            SqlCommand command = new SqlCommand(@"
DECLARE @StageNo int =
(
    SELECT StageNo FROM dbo.OLTracking_ProcessFlow
    WHERE ProjectID = @ProjectID AND ProcessID = @ProcessID AND IsActive = 1
);
DECLARE @PreviousStage int =
(
    SELECT MAX(StageNo) FROM dbo.OLTracking_ProcessFlow
    WHERE ProjectID = @ProjectID AND IsActive = 1 AND StageNo < @StageNo
);

SELECT TOP (1)
    i.ItemNumber AS LoanNumber,
    ISNULL(i.DealNumber, '') AS DealNumber
FROM dbo.OLTracking_Item i
WHERE @StageNo IS NOT NULL
  AND i.ProjectID = @ProjectID
  AND i.IsDeleted = 0
  AND i.RecordSource = 'Import'
  AND LTRIM(RTRIM(ISNULL(i.DealNumber, ''))) = LTRIM(RTRIM(ISNULL(@DealNumber, '')))
  AND NOT EXISTS
  (
      SELECT 1 FROM dbo.OLTracking_Assignment a
      WHERE a.ItemID = i.ItemID AND a.ProcessID = @ProcessID
        AND (a.IsCurrent = 1 OR a.AssignmentStatus IN ('Completed', 'Skipped'))
  )
  AND NOT EXISTS
  (
      SELECT 1
      FROM dbo.OLTracking_Assignment duplicateAssignment
      INNER JOIN dbo.OLTracking_Item duplicateItem ON duplicateItem.ItemID = duplicateAssignment.ItemID
      WHERE duplicateAssignment.ProcessID = @ProcessID
        AND duplicateAssignment.IsCurrent = 1
        AND LTRIM(RTRIM(duplicateItem.ItemNumber)) = LTRIM(RTRIM(i.ItemNumber))
  )
  AND
  (
      @PreviousStage IS NULL
      OR NOT EXISTS
      (
          SELECT 1 FROM dbo.OLTracking_ProcessFlow previousFlow
          WHERE previousFlow.ProjectID = @ProjectID AND previousFlow.IsActive = 1
            AND previousFlow.StageNo = @PreviousStage AND previousFlow.IsMandatory = 1
      )
      OR EXISTS
      (
          SELECT 1
          FROM dbo.OLTracking_Assignment completedAssignment
          INNER JOIN dbo.OLTracking_ProcessFlow completedFlow
              ON completedFlow.ProjectID = @ProjectID
             AND completedFlow.ProcessID = completedAssignment.ProcessID
             AND completedFlow.IsActive = 1
             AND completedFlow.IsMandatory = 1
             AND completedFlow.StageNo = @PreviousStage
          WHERE completedAssignment.ItemID = i.ItemID
            AND completedAssignment.AssignmentStatus IN ('Completed', 'Skipped')
      )
  )
ORDER BY i.ItemID; ") { CommandType = CommandType.Text };
            Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@DealNumber", SqlDbType.NVarChar, dealNumber ?? string.Empty, 150);
            Add(command, "@ProcessID", SqlDbType.Int, processId);
            return Table(command);
        }

        private static void EnsureImportSourceColumn()
        {
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand command = new SqlCommand(@"
IF COL_LENGTH('dbo.OLTracking_Item', 'RecordSource') IS NULL
    ALTER TABLE dbo.OLTracking_Item ADD RecordSource varchar(20) NOT NULL
        CONSTRAINT DF_OLTracking_Item_RecordSource DEFAULT ('Tracking') WITH VALUES;", connection))
            {
                connection.Open(); command.ExecuteNonQuery();
            }
        }

        public bool IsLoanEligible(int projectId, int processId, string loanNumber)
        {
            SqlCommand command = Command("OLTracking_IsLoanEligible"); Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@ProcessID", SqlDbType.Int, processId); Add(command, "@LoanNumber", SqlDbType.NVarChar, loanNumber, 150);
            DataTable result = Table(command); return result.Rows.Count > 0 && Convert.ToBoolean(result.Rows[0]["Eligible"]);
        }

        public int AllocateLoan(int projectId, int processId, string loanNumber, string dealNumber, int userId)
        {
            SqlCommand command = new SqlCommand(@"
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
    BEGIN TRANSACTION;
    DECLARE @LockResult int,
            @LockResource nvarchar(255)=N'OLTracking_Allocate_Global';
    EXEC @LockResult=sys.sp_getapplock @Resource=@LockResource,@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
    IF @LockResult<0 THROW 50112,'Unable to verify whether this loan is already allocated. Please try again.',1;
    IF EXISTS
    (
        SELECT 1
        FROM dbo.OLTracking_Assignment a WITH(UPDLOCK,HOLDLOCK)
        INNER JOIN dbo.OLTracking_Item i ON i.ItemID=a.ItemID
        WHERE a.ProcessID=@ProcessID AND a.IsCurrent=1
          AND LTRIM(RTRIM(i.ItemNumber))=LTRIM(RTRIM(@LoanNumber))
    )
        THROW 50112,'This loan and process combination is already allocated to another user.',1;

    DECLARE @Allocated table(AssignmentID bigint);
    INSERT @Allocated(AssignmentID)
    EXEC dbo.OLTracking_AllocateLoan @ProjectID=@ProjectID,@ProcessID=@ProcessID,@LoanNumber=@LoanNumber,
                                     @DealNumber=@DealNumber,@UserID=@UserID;
    COMMIT TRANSACTION;
    SELECT TOP(1) AssignmentID FROM @Allocated;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT>0 ROLLBACK TRANSACTION;
    THROW;
END CATCH") { CommandType = CommandType.Text, CommandTimeout = 90 };
            Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@ProcessID", SqlDbType.Int, processId);
            Add(command, "@LoanNumber", SqlDbType.NVarChar, loanNumber, 150);
            Add(command, "@DealNumber", SqlDbType.NVarChar, dealNumber, 150);
            Add(command, "@UserID", SqlDbType.Int, userId);
            return Execute(command);
        }

        public bool IsLoanProcessCurrentlyAllocated(string loanNumber, int processId)
        {
            SqlCommand command = new SqlCommand(@"
SELECT CAST(CASE WHEN EXISTS
(
    SELECT 1
    FROM dbo.OLTracking_Assignment a
    INNER JOIN dbo.OLTracking_Item i ON i.ItemID=a.ItemID
    WHERE a.ProcessID=@ProcessID AND a.IsCurrent=1
      AND LTRIM(RTRIM(i.ItemNumber))=LTRIM(RTRIM(@LoanNumber))
) THEN 1 ELSE 0 END AS bit);") { CommandType = CommandType.Text };
            Add(command, "@LoanNumber", SqlDbType.NVarChar, loanNumber, 150);
            Add(command, "@ProcessID", SqlDbType.Int, processId);
            DataTable result = Table(command);
            return result.Rows.Count > 0 && Convert.ToBoolean(result.Rows[0][0]);
        }

        public DataTable GetTrackingQueue(int userId)
        {
            SqlCommand command = Command("OLTracking_GetTrackingQueue"); Add(command, "@UserID", SqlDbType.Int, userId); return Table(command);
        }

        public void StartLoan(long assignmentId, int userId)
        {
            EnsureSingleInProcessIndex();
            SqlCommand command = new SqlCommand(@"
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
    BEGIN TRANSACTION;
    DECLARE @LockResult int,@LockResource nvarchar(255)=N'OLTracking_InProcess_User_'+CONVERT(nvarchar(20),@UserID);
    EXEC @LockResult=sys.sp_getapplock @Resource=@LockResource,@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
    IF @LockResult<0 THROW 50132,'Unable to verify the active loan. Please try again.',1;
    IF EXISTS(SELECT 1 FROM dbo.OLTracking_Assignment WITH(UPDLOCK,HOLDLOCK)
              WHERE UserID=@UserID AND IsCurrent=1 AND AssignmentStatus='In Process')
        THROW 50132,'Another loan is already in process.',1;
    EXEC dbo.OLTracking_StartLoan @AssignmentID=@AssignmentID,@UserID=@UserID;
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT>0 ROLLBACK TRANSACTION;
    THROW;
END CATCH") { CommandType = CommandType.Text, CommandTimeout = 90 };
            Add(command, "@AssignmentID", SqlDbType.BigInt, assignmentId);
            Add(command, "@UserID", SqlDbType.Int, userId);
            ExecuteNonQuery(command);
        }

        public void HoldLoan(long assignmentId, string holdReason, int userId)
        {
            SqlCommand command = Command("OLTracking_HoldLoan");
            Add(command, "@AssignmentID", SqlDbType.BigInt, assignmentId);
            Add(command, "@HoldReason", SqlDbType.NVarChar, holdReason, 1000);
            Add(command, "@UserID", SqlDbType.Int, userId);
            ExecuteNonQuery(command);
        }

        public void ResumeLoan(long assignmentId, int userId)
        {
            EnsureSingleInProcessIndex();
            SqlCommand command = new SqlCommand(@"
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
    BEGIN TRANSACTION;
    DECLARE @LockResult int,@LockResource nvarchar(255)=N'OLTracking_InProcess_User_'+CONVERT(nvarchar(20),@UserID);
    EXEC @LockResult=sys.sp_getapplock @Resource=@LockResource,@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
    IF @LockResult<0 THROW 50132,'Unable to verify the active loan. Please try again.',1;
    IF EXISTS(SELECT 1 FROM dbo.OLTracking_Assignment WITH(UPDLOCK,HOLDLOCK)
              WHERE UserID=@UserID AND IsCurrent=1 AND AssignmentStatus='In Process')
        THROW 50132,'Another loan is already in process.',1;
    EXEC dbo.OLTracking_ResumeLoan @AssignmentID=@AssignmentID,@UserID=@UserID;
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT>0 ROLLBACK TRANSACTION;
    THROW;
END CATCH") { CommandType = CommandType.Text, CommandTimeout = 90 };
            Add(command, "@AssignmentID", SqlDbType.BigInt, assignmentId);
            Add(command, "@UserID", SqlDbType.Int, userId);
            ExecuteNonQuery(command);
        }

        private static void EnsureSingleInProcessIndex()
        {
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand command = new SqlCommand(@"
DECLARE @LockResult int;
EXEC @LockResult=sys.sp_getapplock @Resource=N'OLTracking_SingleInProcess_Index',@LockMode='Exclusive',@LockOwner='Session',@LockTimeout=10000;
IF @LockResult<0 THROW 50132,'Unable to verify the active-loan rule. Please try again.',1;
BEGIN TRY
    IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.OLTracking_Assignment') AND name='UX_OLTracking_Assignment_OneInProcessPerUser')
       AND NOT EXISTS
       (
           SELECT UserID FROM dbo.OLTracking_Assignment
           WHERE IsCurrent=1 AND AssignmentStatus='In Process'
           GROUP BY UserID HAVING COUNT(1)>1
       )
        EXEC(N'CREATE UNIQUE INDEX UX_OLTracking_Assignment_OneInProcessPerUser
               ON dbo.OLTracking_Assignment(UserID)
               WHERE IsCurrent=1 AND AssignmentStatus=''In Process'';');
    EXEC sys.sp_releaseapplock @Resource=N'OLTracking_SingleInProcess_Index',@LockOwner='Session';
END TRY
BEGIN CATCH
    EXEC sys.sp_releaseapplock @Resource=N'OLTracking_SingleInProcess_Index',@LockOwner='Session';
    THROW;
END CATCH", connection) { CommandTimeout = 90 })
            {
                connection.Open();
                command.ExecuteNonQuery();
            }
        }

        public void CompleteLoan(long assignmentId, string remark, string[] feedbacks, int userId)
        {
            XElement root = new XElement("feedbacks");
            if (feedbacks != null) foreach (string feedback in feedbacks)
                if (!string.IsNullOrWhiteSpace(feedback)) root.Add(new XElement("feedback", feedback.Trim()));
            SqlCommand command = Command("OLTracking_CompleteLoan"); Add(command, "@AssignmentID", SqlDbType.BigInt, assignmentId);
            Add(command, "@Remark", SqlDbType.NVarChar, remark, 1000);
            Add(command, "@FeedbackXml", SqlDbType.Xml, root.HasElements ? root.ToString(SaveOptions.DisableFormatting) : null);
            Add(command, "@UserID", SqlDbType.Int, userId); ExecuteNonQuery(command);
        }

        public DataSet GetFeedbackDefaults(long assignmentId, int userId, string feedbackBy)
        {
            SqlCommand command = Command("OLTracking_GetFeedbackDefaults");
            Add(command, "@AssignmentID", SqlDbType.BigInt, assignmentId);
            Add(command, "@UserID", SqlDbType.Int, userId);
            Add(command, "@FeedbackBy", SqlDbType.NVarChar, feedbackBy, 200);
            return Set(command);
        }

        public DataTable SaveFeedback(long assignmentId, string markedTo, string errorBy, string feedbackBy,
            string errorType, int categoryId, string category, int subcategoryId, string subcategory, string severity,
            string errorField, string screen, string feedbackType, string error, string shouldBe, string remark,
            string dateReviewed, int userId)
        {
            SqlCommand command = Command("OLTracking_SaveFeedback");
            Add(command, "@AssignmentID", SqlDbType.BigInt, assignmentId);
            Add(command, "@MarkedTo", SqlDbType.NVarChar, markedTo, 200);
            Add(command, "@ErrorBy", SqlDbType.NVarChar, errorBy, 200);
            Add(command, "@FeedbackBy", SqlDbType.NVarChar, feedbackBy, 200);
            Add(command, "@ErrorType", SqlDbType.NVarChar, errorType, 100);
            Add(command, "@CategoryID", SqlDbType.Int, categoryId);
            Add(command, "@Category", SqlDbType.NVarChar, category, 200);
            Add(command, "@SubcategoryID", SqlDbType.Int, subcategoryId);
            Add(command, "@Subcategory", SqlDbType.NVarChar, subcategory, 200);
            Add(command, "@Severity", SqlDbType.NVarChar, severity, 100);
            Add(command, "@ErrorField", SqlDbType.NVarChar, errorField, 500);
            Add(command, "@Screen", SqlDbType.NVarChar, screen, 1000);
            Add(command, "@FeedbackType", SqlDbType.NVarChar, feedbackType, 100);
            Add(command, "@Error", SqlDbType.NVarChar, error, 2000);
            Add(command, "@ShouldBe", SqlDbType.NVarChar, shouldBe, 2000);
            Add(command, "@Remark", SqlDbType.NVarChar, remark, 1000);
            Add(command, "@DateReviewed", SqlDbType.NVarChar, dateReviewed, 100);
            Add(command, "@UserID", SqlDbType.Int, userId);
            return Table(command);
        }

        public DataTable GetUserDailyStatus(int userId, int processId, DateTime? fromDate, DateTime? toDate)
        {
            SqlCommand command = Command("OLTracking_GetUserDailyStatus"); Add(command, "@UserID", SqlDbType.Int, userId);
            Add(command, "@ProcessID", SqlDbType.Int, processId); Add(command, "@FromDate", SqlDbType.Date, fromDate);
            Add(command, "@ToDate", SqlDbType.Date, toDate); return Table(command);
        }

        public DataTable GetUserDailyProcesses(int userId)
        {
            SqlCommand command = Command("OLTracking_GetUserDailyProcesses"); Add(command, "@UserID", SqlDbType.Int, userId); return Table(command);
        }

        public DataTable GetProjectUsers(int projectId)
        {
            SqlCommand command = Command("OLTracking_GetProjectUsers"); Add(command, "@ProjectID", SqlDbType.Int, projectId); return Table(command);
        }

        public DataTable GetEligibleLoans(int projectId, string dealNumber, int processId)
        {
            SqlCommand command = Command("OLTracking_GetEligibleLoans"); Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@DealNumber", SqlDbType.NVarChar, dealNumber, 150); Add(command, "@ProcessID", SqlDbType.Int, processId); return Table(command);
        }

        public int ManagerAllocate(int projectId, string dealNumber, int processId, int targetUserId, string[] loanNumbers, int managerId)
        {
            XElement loans = new XElement("loans");
            if (loanNumbers != null) foreach (string loan in loanNumbers)
                if (!string.IsNullOrWhiteSpace(loan)) loans.Add(new XElement("loan", loan.Trim()));
            SqlCommand command = Command("OLTracking_ManagerAllocate"); Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@DealNumber", SqlDbType.NVarChar, dealNumber, 150); Add(command, "@ProcessID", SqlDbType.Int, processId);
            Add(command, "@TargetUserID", SqlDbType.Int, targetUserId); Add(command, "@LoanXml", SqlDbType.Xml, loans.ToString(SaveOptions.DisableFormatting));
            Add(command, "@ManagerID", SqlDbType.Int, managerId); return Execute(command);
        }

        public void ValidateManagerAllocation(int projectId, int processId, string[] loanNumbers)
        {
            XElement loans = new XElement("loans");
            if (loanNumbers != null) foreach (string loan in loanNumbers)
                if (!string.IsNullOrWhiteSpace(loan)) loans.Add(new XElement("loan", loan.Trim()));
            SqlCommand command = Command("OLTracking_ValidateManagerAllocation");
            Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@ProcessID", SqlDbType.Int, processId);
            Add(command, "@LoanXml", SqlDbType.Xml, loans.ToString(SaveOptions.DisableFormatting));
            ExecuteNonQuery(command);
        }

        public DataTable GetManagerDetail(int projectId, int processId, int userId, string status, DateTime? fromDate, DateTime? toDate)
        {
            SqlCommand command = Command("OLTracking_GetManagerDetail"); Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@ProcessID", SqlDbType.Int, processId); Add(command, "@UserID", SqlDbType.Int, userId);
            Add(command, "@Status", SqlDbType.VarChar, status, 20); Add(command, "@FromDate", SqlDbType.Date, fromDate);
            Add(command, "@ToDate", SqlDbType.Date, toDate); return Table(command);
        }

        public DataTable GetManagerSummary(int projectId, int processId, int userId, DateTime? fromDate, DateTime? toDate)
        {
            SqlCommand command = Command("OLTracking_GetManagerSummary"); Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@ProcessID", SqlDbType.Int, processId); Add(command, "@UserID", SqlDbType.Int, userId);
            Add(command, "@FromDate", SqlDbType.Date, fromDate); Add(command, "@ToDate", SqlDbType.Date, toDate); return Table(command);
        }

        public DataTable GetDealDashboard(int projectId, string dealNumber)
        {
            SqlCommand command = Command("OLTracking_GetDealDashboard"); Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@DealNumber", SqlDbType.NVarChar, dealNumber, 150); return Table(command);
        }

        public DataTable GetHourlyProduction(int projectId, DateTime reportDate, string dealNumber)
        {
            SqlCommand command = Command("OLTracking_GetHourlyProduction"); Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@ReportDate", SqlDbType.Date, reportDate); Add(command, "@DealNumber", SqlDbType.NVarChar, dealNumber, 150); return Table(command);
        }

        public DataTable GetReallocationUsers(int projectId, string dealNumber, int processId)
        {
            SqlCommand command = Command("OLTracking_GetReallocationUsers"); Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@DealNumber", SqlDbType.NVarChar, dealNumber, 150); Add(command, "@ProcessID", SqlDbType.Int, processId); return Table(command);
        }

        public DataTable GetReallocationOrders(int projectId, string dealNumber, int processId, int fromUserId)
        {
            SqlCommand command = Command("OLTracking_GetReallocationOrders"); Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@DealNumber", SqlDbType.NVarChar, dealNumber, 150); Add(command, "@ProcessID", SqlDbType.Int, processId);
            Add(command, "@FromUserID", SqlDbType.Int, fromUserId); return Table(command);
        }

        public int ReallocateOrders(int projectId, int fromUserId, int toUserId, long[] assignmentIds, string remark, bool confirmInProcess, int managerId)
        {
            XElement assignments = new XElement("assignments");
            if (assignmentIds != null) foreach (long id in assignmentIds) if (id > 0) assignments.Add(new XElement("assignment", id));
            SqlCommand command = Command("OLTracking_ReallocateOrders"); Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@FromUserID", SqlDbType.Int, fromUserId); Add(command, "@ToUserID", SqlDbType.Int, toUserId);
            Add(command, "@AssignmentXml", SqlDbType.Xml, assignments.ToString(SaveOptions.DisableFormatting));
            Add(command, "@Remark", SqlDbType.NVarChar, remark, 1000); Add(command, "@ConfirmInProcess", SqlDbType.Bit, confirmInProcess);
            Add(command, "@ManagerID", SqlDbType.Int, managerId); return Execute(command);
        }

        private static void ExecuteNonQuery(SqlCommand command)
        {
            using (command)
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            { command.Connection = connection; connection.Open(); command.ExecuteNonQuery(); }
        }
    }
}
