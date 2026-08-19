using System;
using System.Collections.Generic;
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
            EnsureProcessFlowColumns();
            SqlCommand command = new SqlCommand(@"
SELECT FlowID,ProjectID,ProcessID,ProcessName,StageNo,IsMandatory,
       CAST(CASE WHEN IsMandatory=1 THEN 0 ELSE 1 END AS bit) CanSkip,
       FeedbackRequiredOnComplete,IsFinalProcess,IsTrackingSheetProcess,
       ISNULL(ProductivityType,'Loan Based Productivity') ProductivityType,
       ISNULL(ExpectedCompletionMinutes,0) ExpectedCompletionMinutes,MinCompletionMinutes,MaxCompletionMinutes,IsActive,
       STUFF((SELECT ','+CONVERT(varchar(11),dependency.PredecessorProcessID)
              FROM dbo.OLTracking_ProcessDependency dependency
              JOIN dbo.OLTracking_ProcessFlow predecessor ON predecessor.ProjectID=dependency.ProjectID
                   AND predecessor.ProcessID=dependency.PredecessorProcessID AND predecessor.IsActive=1
              WHERE dependency.ProjectID=flow.ProjectID AND dependency.ProcessID=flow.ProcessID AND dependency.IsActive=1
              ORDER BY predecessor.StageNo,predecessor.ProcessName
              FOR XML PATH(''),TYPE).value('.','nvarchar(max)'),1,1,'') EligibleAfterProcessIDs,
       STUFF((SELECT ', '+predecessor.ProcessName
              FROM dbo.OLTracking_ProcessDependency dependency
              JOIN dbo.OLTracking_ProcessFlow predecessor ON predecessor.ProjectID=dependency.ProjectID
                   AND predecessor.ProcessID=dependency.PredecessorProcessID AND predecessor.IsActive=1
              WHERE dependency.ProjectID=flow.ProjectID AND dependency.ProcessID=flow.ProcessID AND dependency.IsActive=1
              ORDER BY predecessor.StageNo,predecessor.ProcessName
              FOR XML PATH(''),TYPE).value('.','nvarchar(max)'),1,2,'') EligibleAfterProcessNames,
       STUFF((SELECT ','+CONVERT(varchar(11),target.TargetProcessID)
              FROM dbo.OLTracking_ProcessFeedbackTarget target
              JOIN dbo.OLTracking_ProcessFlow targetFlow ON targetFlow.ProjectID=target.ProjectID
                   AND targetFlow.ProcessID=target.TargetProcessID AND targetFlow.IsActive=1
              WHERE target.ProjectID=flow.ProjectID AND target.ProcessID=flow.ProcessID AND target.IsActive=1
              ORDER BY targetFlow.StageNo,targetFlow.ProcessName
              FOR XML PATH(''),TYPE).value('.','nvarchar(max)'),1,1,'') FeedbackAgainstProcessIDs,
       STUFF((SELECT ', '+targetFlow.ProcessName
              FROM dbo.OLTracking_ProcessFeedbackTarget target
              JOIN dbo.OLTracking_ProcessFlow targetFlow ON targetFlow.ProjectID=target.ProjectID
                   AND targetFlow.ProcessID=target.TargetProcessID AND targetFlow.IsActive=1
              WHERE target.ProjectID=flow.ProjectID AND target.ProcessID=flow.ProcessID AND target.IsActive=1
              ORDER BY targetFlow.StageNo,targetFlow.ProcessName
              FOR XML PATH(''),TYPE).value('.','nvarchar(max)'),1,2,'') FeedbackAgainstProcessNames
FROM dbo.OLTracking_ProcessFlow flow
WHERE ProjectID=@ProjectID AND IsActive=1
ORDER BY StageNo,ProcessName;") { CommandType = CommandType.Text };
            Add(command, "@ProjectID", SqlDbType.Int, projectId);
            return Table(command);
        }

        public DataTable GetDealProcessFlow(int projectId, string dealNumber)
        {
            SqlCommand command = Command("OLTracking_GetDealProcessFlow");
            Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@DealNumber", SqlDbType.NVarChar, dealNumber, 150);
            return Table(command);
        }

        public DataTable GetEffectiveProcessFlow(int projectId, string dealNumber)
        {
            EnsureProcessFlowColumns();
            SqlCommand command = new SqlCommand(@"
SELECT effective.*,CAST(ISNULL(projectFlow.IsTrackingSheetProcess,1) AS bit) IsTrackingSheetProcess
FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) effective
LEFT JOIN dbo.OLTracking_ProcessFlow projectFlow
  ON projectFlow.ProjectID=@ProjectID AND projectFlow.ProcessID=effective.ProcessID AND projectFlow.IsActive=1
ORDER BY effective.StageNo,effective.ProcessName;") { CommandType = CommandType.Text };
            Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@DealNumber", SqlDbType.NVarChar, dealNumber, 150);
            return Table(command);
        }

        public DataTable GetConfiguredProcesses(int projectId)
        {
            SqlCommand command = new SqlCommand(@"
SELECT ProcessID,MAX(ProcessName) ProcessName
FROM
(
    SELECT flow.ProcessID,flow.ProcessName
    FROM (SELECT DISTINCT DealNumber FROM dbo.OLTracking_Item
          WHERE ProjectID=@ProjectID AND IsDeleted=0) deal
    CROSS APPLY dbo.OLTracking_EffectiveProcessFlow(@ProjectID,deal.DealNumber) flow
    UNION ALL
    SELECT flow.ProcessID,flow.ProcessName
    FROM dbo.OLTracking_ProcessFlow flow
    WHERE flow.ProjectID=@ProjectID AND flow.IsActive=1
      AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_Item item
                     WHERE item.ProjectID=@ProjectID AND item.IsDeleted=0)
) configured
GROUP BY ProcessID ORDER BY ProcessName;") { CommandType = CommandType.Text };
            Add(command, "@ProjectID", SqlDbType.Int, projectId);
            return Table(command);
        }

        public void SaveDealProcessFlow(int projectId, string dealNumber, int processId, string processName, int stageNo,
            bool isMandatory, bool feedbackRequired, bool isFinalProcess, string productivityType, int expectedCompletionMinutes, int? minCompletionMinutes, int? maxCompletionMinutes, bool isOutOfScope, int userId)
        {
            SqlCommand command = Command("OLTracking_SaveDealProcessFlow");
            Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@DealNumber", SqlDbType.NVarChar, dealNumber, 150);
            Add(command, "@ProcessID", SqlDbType.Int, processId);
            Add(command, "@ProcessName", SqlDbType.NVarChar, processName, 150);
            Add(command, "@StageNo", SqlDbType.Int, stageNo);
            Add(command, "@IsMandatory", SqlDbType.Bit, isMandatory);
            Add(command, "@FeedbackRequiredOnComplete", SqlDbType.Bit, feedbackRequired);
            Add(command, "@IsFinalProcess", SqlDbType.Bit, isFinalProcess);
            Add(command, "@ProductivityType", SqlDbType.NVarChar, productivityType, 40);
            Add(command, "@ExpectedCompletionMinutes", SqlDbType.Int, expectedCompletionMinutes);
            Add(command, "@MinCompletionMinutes", SqlDbType.Int, minCompletionMinutes);
            Add(command, "@MaxCompletionMinutes", SqlDbType.Int, maxCompletionMinutes);
            Add(command, "@IsOutOfScope", SqlDbType.Bit, isOutOfScope);
            Add(command, "@UserID", SqlDbType.Int, userId);
            ExecuteNonQuery(command);
        }

        public int RemoveDealProcessFlow(int projectId, string dealNumber, int processId, int userId)
        {
            SqlCommand command = Command("OLTracking_RemoveDealProcessFlow");
            Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@DealNumber", SqlDbType.NVarChar, dealNumber, 150);
            Add(command, "@ProcessID", SqlDbType.Int, processId);
            Add(command, "@UserID", SqlDbType.Int, userId);
            return Execute(command);
        }

        public void SaveProcessFlow(int projectId, int processId, string processName, int stageNo, bool isMandatory, bool feedbackRequired, bool isFinalProcess, bool isTrackingSheetProcess, string productivityType, int expectedCompletionMinutes, int? minCompletionMinutes, int? maxCompletionMinutes, int[] eligibleAfterProcessIds, int[] feedbackAgainstProcessIds, int userId)
        {
            EnsureProcessFlowColumns();
            XElement dependencies = new XElement("processes");
            if (eligibleAfterProcessIds != null)
                foreach (int predecessorId in eligibleAfterProcessIds)
                    if (predecessorId > 0) dependencies.Add(new XElement("process", predecessorId));
            XElement feedbackTargets = new XElement("processes");
            if (feedbackAgainstProcessIds != null)
                foreach (int targetProcessId in feedbackAgainstProcessIds)
                    if (targetProcessId > 0) feedbackTargets.Add(new XElement("process", targetProcessId));
            SqlCommand command = new SqlCommand(@"
SET NOCOUNT ON;
SET XACT_ABORT ON;
IF @ProjectID<=0 OR @ProcessID<=0 THROW 50100,'Project and process are required.',1;
IF @StageNo<=0 THROW 50101,'Sequence must be greater than zero.',1;
IF NULLIF(LTRIM(RTRIM(@ProcessName)),'') IS NULL THROW 50102,'Process name is required.',1;
IF @MinCompletionMinutes<0 OR @MaxCompletionMinutes<0 THROW 50151,'Completion minutes must be zero or greater.',1;
IF @MinCompletionMinutes IS NOT NULL AND @MaxCompletionMinutes IS NOT NULL AND @MaxCompletionMinutes<@MinCompletionMinutes
    THROW 50152,'Maximum completion time cannot be less than the minimum completion time.',1;
IF EXISTS(SELECT 1 FROM @EligibleAfterXml.nodes('/processes/process') dependency(node) WHERE dependency.node.value('(text())[1]','int')=@ProcessID)
    THROW 50141,'A process cannot depend on itself.',1;
IF EXISTS
(
    SELECT 1 FROM @EligibleAfterXml.nodes('/processes/process') dependency(node)
    LEFT JOIN dbo.OLTracking_ProcessFlow predecessor ON predecessor.ProjectID=@ProjectID
         AND predecessor.ProcessID=dependency.node.value('(text())[1]','int') AND predecessor.IsActive=1
    WHERE predecessor.ProcessID IS NULL OR predecessor.StageNo>=@StageNo
)
    THROW 50142,'Eligible After Process(es) must contain only active processes from an earlier sequence.',1;
IF EXISTS(SELECT 1 FROM @FeedbackTargetXml.nodes('/processes/process') target(node) WHERE target.node.value('(text())[1]','int')=@ProcessID)
    THROW 50145,'A process cannot route feedback to itself.',1;
IF EXISTS
(
    SELECT 1 FROM @FeedbackTargetXml.nodes('/processes/process') target(node)
    LEFT JOIN dbo.OLTracking_ProcessFlow targetFlow ON targetFlow.ProjectID=@ProjectID
         AND targetFlow.ProcessID=target.node.value('(text())[1]','int') AND targetFlow.IsActive=1
    WHERE targetFlow.ProcessID IS NULL OR targetFlow.StageNo>=@StageNo
)
    THROW 50146,'Feedback Against Process(es) must contain only active processes from an earlier sequence.',1;
BEGIN TRANSACTION;
IF @IsFinalProcess=1
    UPDATE dbo.OLTracking_ProcessFlow
       SET IsFinalProcess=0,UpdatedBy=@UserID,UpdatedDate=GETDATE()
     WHERE ProjectID=@ProjectID AND ProcessID<>@ProcessID AND IsActive=1 AND IsFinalProcess=1;
MERGE dbo.OLTracking_ProcessFlow AS T
USING(SELECT @ProjectID ProjectID,@ProcessID ProcessID) S
ON T.ProjectID=S.ProjectID AND T.ProcessID=S.ProcessID
WHEN MATCHED THEN UPDATE SET ProcessName=LTRIM(RTRIM(@ProcessName)),StageNo=@StageNo,IsMandatory=@IsMandatory,
 FeedbackRequiredOnComplete=@FeedbackRequiredOnComplete,IsFinalProcess=@IsFinalProcess,IsTrackingSheetProcess=@IsTrackingSheetProcess,
 ProductivityType=@ProductivityType,ExpectedCompletionMinutes=NULLIF(@ExpectedCompletionMinutes,0),MinCompletionMinutes=@MinCompletionMinutes,MaxCompletionMinutes=@MaxCompletionMinutes,IsActive=1,UpdatedBy=@UserID,UpdatedDate=GETDATE()
WHEN NOT MATCHED THEN INSERT(ProjectID,ProcessID,ProcessName,StageNo,IsMandatory,FeedbackRequiredOnComplete,IsFinalProcess,IsTrackingSheetProcess,ProductivityType,ExpectedCompletionMinutes,MinCompletionMinutes,MaxCompletionMinutes,AddedBy)
 VALUES(@ProjectID,@ProcessID,LTRIM(RTRIM(@ProcessName)),@StageNo,@IsMandatory,@FeedbackRequiredOnComplete,@IsFinalProcess,@IsTrackingSheetProcess,@ProductivityType,NULLIF(@ExpectedCompletionMinutes,0),@MinCompletionMinutes,@MaxCompletionMinutes,@UserID);
DELETE dbo.OLTracking_ProcessDependency WHERE ProjectID=@ProjectID AND ProcessID=@ProcessID;
INSERT dbo.OLTracking_ProcessDependency(ProjectID,ProcessID,PredecessorProcessID,IsActive,AddedBy)
SELECT @ProjectID,@ProcessID,dependency.PredecessorProcessID,1,@UserID
FROM
(
    SELECT DISTINCT node.value('(text())[1]','int') PredecessorProcessID
    FROM @EligibleAfterXml.nodes('/processes/process') source(node)
) dependency;
DELETE dbo.OLTracking_ProcessFeedbackTarget WHERE ProjectID=@ProjectID AND ProcessID=@ProcessID;
INSERT dbo.OLTracking_ProcessFeedbackTarget(ProjectID,ProcessID,TargetProcessID,IsActive,AddedBy)
SELECT @ProjectID,@ProcessID,target.TargetProcessID,1,@UserID
FROM
(
    SELECT DISTINCT node.value('(text())[1]','int') TargetProcessID
    FROM @FeedbackTargetXml.nodes('/processes/process') source(node)
) target;
COMMIT TRANSACTION;") { CommandType = CommandType.Text };
            Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@ProcessID", SqlDbType.Int, processId); Add(command, "@ProcessName", SqlDbType.NVarChar, processName, 200);
            Add(command, "@StageNo", SqlDbType.Int, stageNo); Add(command, "@IsMandatory", SqlDbType.Bit, isMandatory);
            Add(command, "@FeedbackRequiredOnComplete", SqlDbType.Bit, feedbackRequired); Add(command, "@IsFinalProcess", SqlDbType.Bit, isFinalProcess);
            Add(command, "@IsTrackingSheetProcess", SqlDbType.Bit, isTrackingSheetProcess);
            Add(command, "@ProductivityType", SqlDbType.NVarChar, productivityType, 40);
            Add(command, "@ExpectedCompletionMinutes", SqlDbType.Int, expectedCompletionMinutes);
            Add(command, "@MinCompletionMinutes", SqlDbType.Int, minCompletionMinutes);
            Add(command, "@MaxCompletionMinutes", SqlDbType.Int, maxCompletionMinutes);
            Add(command, "@EligibleAfterXml", SqlDbType.Xml, dependencies.ToString(SaveOptions.DisableFormatting));
            Add(command, "@FeedbackTargetXml", SqlDbType.Xml, feedbackTargets.ToString(SaveOptions.DisableFormatting));
            Add(command, "@UserID", SqlDbType.Int, userId);
            ExecuteNonQuery(command);
        }

        private static void EnsureProcessFlowColumns()
        {
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand command = new SqlCommand(@"
IF COL_LENGTH('dbo.OLTracking_ProcessFlow','IsFinalProcess') IS NULL
    ALTER TABLE dbo.OLTracking_ProcessFlow ADD IsFinalProcess bit NOT NULL
        CONSTRAINT DF_OLTracking_ProcessFlow_Final DEFAULT(0) WITH VALUES;
IF COL_LENGTH('dbo.OLTracking_ProcessFlow','IsTrackingSheetProcess') IS NULL
    ALTER TABLE dbo.OLTracking_ProcessFlow ADD IsTrackingSheetProcess bit NOT NULL
        CONSTRAINT DF_OLTracking_ProcessFlow_TrackingSheet DEFAULT(1) WITH VALUES;
IF COL_LENGTH('dbo.OLTracking_ProcessFlow','ProductivityType') IS NULL
    ALTER TABLE dbo.OLTracking_ProcessFlow ADD ProductivityType nvarchar(40) NOT NULL
        CONSTRAINT DF_OLTracking_ProcessFlow_ProductivityType DEFAULT('Loan Based Productivity') WITH VALUES;
IF COL_LENGTH('dbo.OLTracking_ProcessFlow','ExpectedCompletionMinutes') IS NULL
    ALTER TABLE dbo.OLTracking_ProcessFlow ADD ExpectedCompletionMinutes int NULL;
IF COL_LENGTH('dbo.OLTracking_ProcessFlow','MinCompletionMinutes') IS NULL
    ALTER TABLE dbo.OLTracking_ProcessFlow ADD MinCompletionMinutes int NULL;
IF COL_LENGTH('dbo.OLTracking_ProcessFlow','MaxCompletionMinutes') IS NULL
    ALTER TABLE dbo.OLTracking_ProcessFlow ADD MaxCompletionMinutes int NULL;
IF COL_LENGTH('dbo.OLTracking_DealProcessFlow','MinCompletionMinutes') IS NULL
    ALTER TABLE dbo.OLTracking_DealProcessFlow ADD MinCompletionMinutes int NULL;
IF COL_LENGTH('dbo.OLTracking_DealProcessFlow','MaxCompletionMinutes') IS NULL
    ALTER TABLE dbo.OLTracking_DealProcessFlow ADD MaxCompletionMinutes int NULL;
IF COL_LENGTH('dbo.OLTracking_DealProcessFlow','IsOutOfScope') IS NULL
    ALTER TABLE dbo.OLTracking_DealProcessFlow ADD IsOutOfScope bit NOT NULL
        CONSTRAINT DF_OLTracking_DealFlow_OutOfScope DEFAULT(0) WITH VALUES;
IF COL_LENGTH('dbo.OLTracking_Assignment','MaxTimeAcknowledgedDate') IS NULL
    ALTER TABLE dbo.OLTracking_Assignment ADD MaxTimeAcknowledgedDate datetime NULL;
IF OBJECT_ID('dbo.OLTracking_ProcessDependency','U') IS NULL
BEGIN
    CREATE TABLE dbo.OLTracking_ProcessDependency
    (
        DependencyID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_OLTracking_ProcessDependency PRIMARY KEY,
        ProjectID int NOT NULL,ProcessID int NOT NULL,PredecessorProcessID int NOT NULL,
        IsActive bit NOT NULL CONSTRAINT DF_OLTracking_ProcessDependency_Active DEFAULT(1),
        AddedBy int NOT NULL,AddedDate datetime NOT NULL CONSTRAINT DF_OLTracking_ProcessDependency_Added DEFAULT(GETDATE()),
        UpdatedBy int NULL,UpdatedDate datetime NULL,
        CONSTRAINT UQ_OLTracking_ProcessDependency UNIQUE(ProjectID,ProcessID,PredecessorProcessID),
        CONSTRAINT CK_OLTracking_ProcessDependency_Self CHECK(ProcessID<>PredecessorProcessID)
    );
END;
IF OBJECT_ID('dbo.OLTracking_ProcessFeedbackTarget','U') IS NULL
BEGIN
    CREATE TABLE dbo.OLTracking_ProcessFeedbackTarget
    (
        FeedbackTargetID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_OLTracking_ProcessFeedbackTarget PRIMARY KEY,
        ProjectID int NOT NULL,ProcessID int NOT NULL,TargetProcessID int NOT NULL,
        IsActive bit NOT NULL CONSTRAINT DF_OLTracking_ProcessFeedbackTarget_Active DEFAULT(1),
        AddedBy int NOT NULL,AddedDate datetime NOT NULL CONSTRAINT DF_OLTracking_ProcessFeedbackTarget_Added DEFAULT(GETDATE()),
        UpdatedBy int NULL,UpdatedDate datetime NULL,
        CONSTRAINT UQ_OLTracking_ProcessFeedbackTarget UNIQUE(ProjectID,ProcessID,TargetProcessID),
        CONSTRAINT CK_OLTracking_ProcessFeedbackTarget_Self CHECK(ProcessID<>TargetProcessID)
    );
END;
IF COL_LENGTH('dbo.OLTracking_Feedback','FeedbackAgainstAssignmentID') IS NULL
    ALTER TABLE dbo.OLTracking_Feedback ADD FeedbackAgainstAssignmentID bigint NULL;
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.OLTracking_Feedback') AND name='IX_OLTracking_Feedback_AgainstAssignment')
    EXEC(N'CREATE INDEX IX_OLTracking_Feedback_AgainstAssignment ON dbo.OLTracking_Feedback(AssignmentID,FeedbackAgainstAssignmentID,IsDeleted);');
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
DECLARE @StageNo int = (SELECT StageNo FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) WHERE ProcessID=@ProcessID);

SELECT TOP (1)
    i.ItemNumber AS LoanNumber,
    ISNULL(i.DealNumber, '') AS DealNumber
FROM dbo.OLTracking_Item i
CROSS APPLY dbo.OLTracking_ProcessDependencyEligibility(@ProjectID,@ProcessID,i.ItemID) dependencyEligibility
WHERE @StageNo IS NOT NULL
  AND i.ProjectID = @ProjectID
  AND i.IsDeleted = 0
  AND i.RecordSource = 'Import'
  AND LTRIM(RTRIM(ISNULL(i.DealNumber, ''))) = LTRIM(RTRIM(ISNULL(@DealNumber, '')))
  AND NOT EXISTS
  (
      SELECT 1 FROM dbo.OLTracking_LoanHold loanHold
      WHERE loanHold.ItemID=i.ItemID AND loanHold.ResumedDate IS NULL
  )
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
      (dependencyEligibility.HasConfiguredDependencies=1 AND dependencyEligibility.DependenciesSatisfied=1)
      OR
      (dependencyEligibility.HasConfiguredDependencies=0 AND NOT EXISTS
       (
           SELECT 1 FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) requiredFlow
           WHERE requiredFlow.StageNo<@StageNo AND requiredFlow.IsMandatory=1
             AND NOT EXISTS
             (
                 SELECT 1 FROM dbo.OLTracking_Assignment completedAssignment
                 WHERE completedAssignment.ItemID=i.ItemID AND completedAssignment.ProcessID=requiredFlow.ProcessID
                   AND completedAssignment.AssignmentStatus='Completed'
             )
       ))
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

        public long StartNonTrackingLoan(int projectId, int processId, string loanNumber, string dealNumber, long assignmentId, int userId)
        {
            SqlCommand command = new SqlCommand(@"
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
    BEGIN TRANSACTION;
    IF NOT EXISTS
    (
        SELECT 1 FROM dbo.OLTracking_ProcessFlow
        WHERE ProjectID=@ProjectID AND ProcessID=@ProcessID AND IsActive=1 AND IsTrackingSheetProcess=0
    )
        THROW 50138,'The selected process uses the standard Tracking Sheet workflow.',1;

    DECLARE @ResolvedAssignmentID bigint=@AssignmentID;
    IF ISNULL(@ResolvedAssignmentID,0)<=0
    BEGIN
        DECLARE @Allocated table(AssignmentID bigint);
        INSERT @Allocated(AssignmentID)
        EXEC dbo.OLTracking_AllocateLoan @ProjectID=@ProjectID,@ProcessID=@ProcessID,
             @LoanNumber=@LoanNumber,@DealNumber=@DealNumber,@UserID=@UserID;
        SELECT TOP (1) @ResolvedAssignmentID=AssignmentID FROM @Allocated;
    END
    ELSE IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.OLTracking_Assignment assignment
        INNER JOIN dbo.OLTracking_Item item ON item.ItemID=assignment.ItemID
        WHERE assignment.AssignmentID=@ResolvedAssignmentID AND assignment.UserID=@UserID
          AND assignment.ProjectID=@ProjectID AND assignment.ProcessID=@ProcessID
          AND assignment.IsCurrent=1 AND assignment.AssignmentStatus='Pending'
          AND LTRIM(RTRIM(item.ItemNumber))=LTRIM(RTRIM(@LoanNumber))
          AND LTRIM(RTRIM(ISNULL(item.DealNumber,'')))=LTRIM(RTRIM(ISNULL(@DealNumber,'')))
    )
        THROW 50120,'This loan is no longer available in your Pending queue.',1;

    IF ISNULL(@ResolvedAssignmentID,0)<=0 THROW 50120,'Pending assignment was not found.',1;
    EXEC dbo.OLTracking_StartLoan @AssignmentID=@ResolvedAssignmentID,@UserID=@UserID;
    COMMIT TRANSACTION;
    SELECT @ResolvedAssignmentID AssignmentID;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT>0 ROLLBACK TRANSACTION;
    THROW;
END CATCH") { CommandType = CommandType.Text, CommandTimeout = 30 };
            Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@ProcessID", SqlDbType.Int, processId);
            Add(command, "@LoanNumber", SqlDbType.NVarChar, loanNumber, 150);
            Add(command, "@DealNumber", SqlDbType.NVarChar, dealNumber ?? string.Empty, 150);
            Add(command, "@AssignmentID", SqlDbType.BigInt, assignmentId);
            Add(command, "@UserID", SqlDbType.Int, userId);
            DataTable result = Table(command);
            return result.Rows.Count == 0 ? 0 : Convert.ToInt64(result.Rows[0]["AssignmentID"]);
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

        public DataTable GetHoldReasons(bool includeInactive)
        {
            SqlCommand command = new SqlCommand(@"
SELECT HoldReasonID,ReasonText,IsActive,AddedDate,UpdatedDate
FROM dbo.OLTracking_HoldReason
WHERE @IncludeInactive=1 OR IsActive=1
ORDER BY IsActive DESC,ReasonText;") { CommandType = CommandType.Text };
            Add(command, "@IncludeInactive", SqlDbType.Bit, includeInactive);
            return Table(command);
        }

        public bool IsActiveHoldReason(string reasonText)
        {
            SqlCommand command = new SqlCommand(@"
SELECT CAST(CASE WHEN EXISTS
(
    SELECT 1 FROM dbo.OLTracking_HoldReason
    WHERE IsActive=1 AND ReasonText=LTRIM(RTRIM(@ReasonText))
) THEN 1 ELSE 0 END AS bit);") { CommandType = CommandType.Text };
            Add(command, "@ReasonText", SqlDbType.NVarChar, reasonText, 400);
            DataTable result = Table(command);
            return result.Rows.Count > 0 && Convert.ToBoolean(result.Rows[0][0]);
        }

        public int SaveHoldReason(string reasonText, int userId)
        {
            SqlCommand command = new SqlCommand(@"
SET NOCOUNT ON;
DECLARE @Reason nvarchar(400)=LTRIM(RTRIM(@ReasonText));
IF NULLIF(@Reason,'') IS NULL THROW 50153,'Hold Reason is required.',1;
IF LEN(@Reason)>400 THROW 50154,'Hold Reason cannot exceed 400 characters.',1;
IF EXISTS(SELECT 1 FROM dbo.OLTracking_HoldReason WHERE ReasonText=@Reason)
BEGIN
    UPDATE dbo.OLTracking_HoldReason SET IsActive=1,UpdatedBy=@UserID,UpdatedDate=GETDATE() WHERE ReasonText=@Reason;
    SELECT HoldReasonID FROM dbo.OLTracking_HoldReason WHERE ReasonText=@Reason;
END
ELSE
BEGIN
    INSERT dbo.OLTracking_HoldReason(ReasonText,IsActive,AddedBy) VALUES(@Reason,1,@UserID);
    SELECT CONVERT(int,SCOPE_IDENTITY());
END;") { CommandType = CommandType.Text };
            Add(command, "@ReasonText", SqlDbType.NVarChar, reasonText, 400);
            Add(command, "@UserID", SqlDbType.Int, userId);
            return Execute(command);
        }

        public int SetHoldReasonActive(int holdReasonId, bool isActive, int userId)
        {
            SqlCommand command = new SqlCommand(@"
UPDATE dbo.OLTracking_HoldReason
SET IsActive=@IsActive,UpdatedBy=@UserID,UpdatedDate=GETDATE()
WHERE HoldReasonID=@HoldReasonID;
SELECT @@ROWCOUNT;") { CommandType = CommandType.Text };
            Add(command, "@HoldReasonID", SqlDbType.Int, holdReasonId);
            Add(command, "@IsActive", SqlDbType.Bit, isActive);
            Add(command, "@UserID", SqlDbType.Int, userId);
            return Execute(command);
        }

        public DataTable GetLoanHoldCandidates(int projectId, string dealNumber)
        {
            SqlCommand command = Command("OLTracking_GetLoanHoldCandidates");
            Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@DealNumber", SqlDbType.NVarChar, dealNumber ?? string.Empty, 150);
            return Table(command);
        }

        public DataTable GetHeldLoans(int projectId, string dealNumber)
        {
            SqlCommand command = Command("OLTracking_GetHeldLoans");
            Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@DealNumber", SqlDbType.NVarChar, dealNumber ?? string.Empty, 150);
            return Table(command);
        }

        public int HoldLoans(int projectId, string dealNumber, long[] itemIds, string reason, int userId)
        {
            XElement items = ItemXml(itemIds);
            SqlCommand command = Command("OLTracking_HoldLoans");
            Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@DealNumber", SqlDbType.NVarChar, dealNumber ?? string.Empty, 150);
            Add(command, "@ItemXml", SqlDbType.Xml, items.ToString(SaveOptions.DisableFormatting));
            Add(command, "@Reason", SqlDbType.NVarChar, reason, 1000);
            Add(command, "@UserID", SqlDbType.Int, userId);
            return Execute(command);
        }

        public int ResumeLoans(int projectId, string dealNumber, long[] itemIds, int userId)
        {
            XElement items = ItemXml(itemIds);
            SqlCommand command = Command("OLTracking_ResumeLoans");
            Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@DealNumber", SqlDbType.NVarChar, dealNumber ?? string.Empty, 150);
            Add(command, "@ItemXml", SqlDbType.Xml, items.ToString(SaveOptions.DisableFormatting));
            Add(command, "@UserID", SqlDbType.Int, userId);
            return Execute(command);
        }

        private static XElement ItemXml(long[] itemIds)
        {
            XElement items = new XElement("items");
            if (itemIds != null)
                foreach (long itemId in itemIds)
                    if (itemId > 0) items.Add(new XElement("item", itemId));
            return items;
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
            EnsureProcessFlowColumns();
            SqlCommand timeValidation = new SqlCommand(@"
DECLARE @ProcessName nvarchar(200),@MinMinutes int,@ElapsedSeconds bigint,@Message nvarchar(2048);
SELECT @ProcessName=flow.ProcessName,@MinMinutes=flow.MinCompletionMinutes,
       @ElapsedSeconds=CASE WHEN DATEDIFF(second,a.StartedDate,GETDATE())-ISNULL(a.HoldTATSeconds,0)<0 THEN 0
                            ELSE DATEDIFF(second,a.StartedDate,GETDATE())-ISNULL(a.HoldTATSeconds,0) END
FROM dbo.OLTracking_Assignment a
JOIN dbo.OLTracking_Item i ON i.ItemID=a.ItemID
CROSS APPLY dbo.OLTracking_EffectiveProcessFlow(a.ProjectID,i.DealNumber) flow
WHERE a.AssignmentID=@AssignmentID AND a.UserID=@UserID AND a.IsCurrent=1
  AND flow.ProcessID=a.ProcessID AND a.StartedDate IS NOT NULL;
IF @MinMinutes IS NOT NULL AND @ElapsedSeconds<CONVERT(bigint,@MinMinutes)*60
BEGIN
    SET @Message=N'Process cannot be completed yet. Minimum processing time for '+@ProcessName+N' is '
        +CONVERT(nvarchar(20),@MinMinutes)+N' minutes. Elapsed Time: '+CONVERT(nvarchar(20),@ElapsedSeconds/60)
        +N' minutes. Remaining Time: '+CONVERT(nvarchar(20),CEILING((CONVERT(bigint,@MinMinutes)*60-@ElapsedSeconds)/60.0))+N' minutes.';
    THROW 50150,@Message,1;
END;") { CommandType = CommandType.Text, CommandTimeout = 10 };
            Add(timeValidation, "@AssignmentID", SqlDbType.BigInt, assignmentId);
            Add(timeValidation, "@UserID", SqlDbType.Int, userId);
            ExecuteNonQuery(timeValidation);
            XElement root = new XElement("feedbacks");
            if (feedbacks != null) foreach (string feedback in feedbacks)
                if (!string.IsNullOrWhiteSpace(feedback)) root.Add(new XElement("feedback", feedback.Trim()));
            if (!root.HasElements && GetCompletionFeedbackRequirement(assignmentId, userId))
            {
                SqlCommand validation = new SqlCommand(@"
DECLARE @ProjectID int,@ProcessID int;
SELECT @ProjectID=ProjectID,@ProcessID=ProcessID
FROM dbo.OLTracking_Assignment
WHERE AssignmentID=@AssignmentID AND UserID=@UserID AND IsCurrent=1;
IF @ProjectID IS NULL THROW 50122,'Assignment was not found.',1;

IF EXISTS(SELECT 1 FROM dbo.OLTracking_ProcessFeedbackTarget WHERE ProjectID=@ProjectID AND ProcessID=@ProcessID AND IsActive=1)
BEGIN
    IF EXISTS
    (
        SELECT 1
        FROM dbo.OLTracking_ProcessFeedbackTarget configured
        WHERE configured.ProjectID=@ProjectID AND configured.ProcessID=@ProcessID AND configured.IsActive=1
          AND NOT EXISTS
          (
              SELECT 1
              FROM dbo.OLTracking_Feedback feedback
              JOIN dbo.OLTracking_Assignment previous ON previous.AssignmentID=feedback.FeedbackAgainstAssignmentID
              WHERE feedback.AssignmentID=@AssignmentID AND feedback.IsDeleted=0
                AND previous.ProcessID=configured.TargetProcessID AND previous.AssignmentStatus='Completed'
          )
    ) THROW 50149,'Feedback is required for every configured Previous Process user.',1;
END
ELSE IF NOT EXISTS(SELECT 1 FROM dbo.OLTracking_Feedback WHERE AssignmentID=@AssignmentID AND IsDeleted=0)
    THROW 50123,'Feedback is mandatory before completing this process.',1;")
                { CommandType = CommandType.Text, CommandTimeout = 10 };
                Add(validation, "@AssignmentID", SqlDbType.BigInt, assignmentId);
                Add(validation, "@UserID", SqlDbType.Int, userId);
                ExecuteNonQuery(validation);
            }
            SqlCommand command = Command("OLTracking_CompleteLoan"); Add(command, "@AssignmentID", SqlDbType.BigInt, assignmentId);
            Add(command, "@Remark", SqlDbType.NVarChar, remark, 1000);
            Add(command, "@FeedbackXml", SqlDbType.Xml, root.HasElements ? root.ToString(SaveOptions.DisableFormatting) : null);
            Add(command, "@UserID", SqlDbType.Int, userId); ExecuteNonQuery(command);
        }

        public DataTable GetOverdueProcesses(int userId)
        {
            EnsureProcessFlowColumns();
            SqlCommand command = new SqlCommand(@"
SELECT a.AssignmentID,i.ItemNumber LoanNumber,flow.ProcessName,flow.MaxCompletionMinutes,
       CONVERT(int,elapsed.ElapsedSeconds/60) ElapsedMinutes,
       CAST(CASE WHEN a.MaxTimeAcknowledgedDate IS NULL THEN 0 ELSE 1 END AS bit) IsAcknowledged
FROM dbo.OLTracking_Assignment a
JOIN dbo.OLTracking_Item i ON i.ItemID=a.ItemID
CROSS APPLY dbo.OLTracking_EffectiveProcessFlow(a.ProjectID,i.DealNumber) flow
CROSS APPLY
(
    SELECT CONVERT(bigint,CASE WHEN DATEDIFF(second,a.StartedDate,
       CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN a.HoldDate ELSE GETDATE() END)-ISNULL(a.HoldTATSeconds,0)<0 THEN 0
       ELSE DATEDIFF(second,a.StartedDate,CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN a.HoldDate ELSE GETDATE() END)-ISNULL(a.HoldTATSeconds,0) END) ElapsedSeconds
) elapsed
WHERE a.UserID=@UserID AND a.IsCurrent=1 AND a.AssignmentStatus IN('In Process','Hold')
  AND a.StartedDate IS NOT NULL AND flow.ProcessID=a.ProcessID AND flow.MaxCompletionMinutes IS NOT NULL
  AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_LoanHold loanHold
                 WHERE loanHold.ItemID=i.ItemID AND loanHold.ResumedDate IS NULL)
  AND elapsed.ElapsedSeconds>=CONVERT(bigint,flow.MaxCompletionMinutes)*60
ORDER BY IsAcknowledged,a.AssignedDate;") { CommandType = CommandType.Text };
            Add(command, "@UserID", SqlDbType.Int, userId);
            return Table(command);
        }

        public DataTable GetCompletionTimeValidation(long assignmentId, int userId)
        {
            EnsureProcessFlowColumns();
            SqlCommand command = new SqlCommand(@"
SELECT flow.ProcessName,flow.MinCompletionMinutes,
       CONVERT(int,CASE WHEN a.StartedDate IS NULL THEN 0 WHEN DATEDIFF(second,a.StartedDate,GETDATE())-ISNULL(a.HoldTATSeconds,0)<0 THEN 0
                        ELSE (DATEDIFF(second,a.StartedDate,GETDATE())-ISNULL(a.HoldTATSeconds,0))/60 END) ElapsedMinutes,
       CONVERT(int,CASE WHEN flow.MinCompletionMinutes IS NULL OR a.StartedDate IS NULL THEN 0
                        WHEN CONVERT(bigint,flow.MinCompletionMinutes)*60>(DATEDIFF(second,a.StartedDate,GETDATE())-ISNULL(a.HoldTATSeconds,0))
                        THEN CEILING((CONVERT(bigint,flow.MinCompletionMinutes)*60-(DATEDIFF(second,a.StartedDate,GETDATE())-ISNULL(a.HoldTATSeconds,0)))/60.0) ELSE 0 END) RemainingMinutes
FROM dbo.OLTracking_Assignment a
JOIN dbo.OLTracking_Item i ON i.ItemID=a.ItemID
CROSS APPLY dbo.OLTracking_EffectiveProcessFlow(a.ProjectID,i.DealNumber) flow
WHERE a.AssignmentID=@AssignmentID AND a.UserID=@UserID AND a.IsCurrent=1 AND flow.ProcessID=a.ProcessID;") { CommandType = CommandType.Text };
            Add(command, "@AssignmentID", SqlDbType.BigInt, assignmentId);
            Add(command, "@UserID", SqlDbType.Int, userId);
            return Table(command);
        }

        public int AcknowledgeOverdueProcesses(long[] assignmentIds, int userId)
        {
            XElement root = new XElement("assignments");
            if (assignmentIds != null) foreach (long id in assignmentIds) if (id > 0) root.Add(new XElement("assignment", id));
            SqlCommand command = new SqlCommand(@"
UPDATE assignment SET MaxTimeAcknowledgedDate=GETDATE()
FROM dbo.OLTracking_Assignment assignment
JOIN @AssignmentXml.nodes('/assignments/assignment') selected(node)
  ON assignment.AssignmentID=selected.node.value('(text())[1]','bigint')
WHERE assignment.UserID=@UserID AND assignment.IsCurrent=1 AND assignment.AssignmentStatus IN('In Process','Hold');
SELECT @@ROWCOUNT;") { CommandType = CommandType.Text };
            Add(command, "@AssignmentXml", SqlDbType.Xml, root.ToString(SaveOptions.DisableFormatting));
            Add(command, "@UserID", SqlDbType.Int, userId);
            return Execute(command);
        }

        public DataSet GetFeedbackDefaults(long assignmentId, int userId, string feedbackBy)
        {
            EnsureProcessFlowColumns();
            SqlCommand command = new SqlCommand(@"
EXEC dbo.OLTracking_GetFeedbackDefaults @AssignmentID=@AssignmentID,@UserID=@UserID,@FeedbackBy=@FeedbackBy;

SELECT feedback.FeedbackID,feedback.MarkedTo,feedback.ErrorBy,feedback.FeedbackBy,
       feedback.Severity,feedback.Category,feedback.Subcategory,feedback.ErrorField,
       feedback.Screen,feedback.ErrorType,feedback.FeedbackType,
       COALESCE(NULLIF(feedback.ErrorText,''),feedback.FeedbackText,'') Finding,
       ISNULL(feedback.ShouldBe,'') RCA,ISNULL(feedback.Remark,'') Remark,
       COALESCE
       (
           CASE WHEN feedback.ExternalTable='ImportedFeedbacks_Servicing' THEN
               (SELECT TOP(1) ISNULL(servicing.[Finding Status],'Pending')
                FROM dbo.ImportedFeedbacks_Servicing servicing
                WHERE servicing.FeedbackID=feedback.ExternalFeedbackID)
           END,
           CASE WHEN feedback.ExternalTable='ImportedFeedbacks' THEN
               (SELECT TOP(1) ISNULL(standard.[Finding Status],'Pending')
                FROM dbo.ImportedFeedbacks standard
                WHERE standard.FeedbackID=feedback.ExternalFeedbackID)
           END,
           'Pending'
       ) FeedbackStatus,
       feedback.AddedDate,feedback.FeedbackAgainstAssignmentID,
       feedbackTargetAssignment.ProcessID FeedbackAgainstProcessID
FROM dbo.OLTracking_Feedback feedback
LEFT JOIN dbo.OLTracking_Assignment feedbackTargetAssignment
  ON feedbackTargetAssignment.AssignmentID=feedback.FeedbackAgainstAssignmentID
WHERE feedback.AssignmentID=@AssignmentID AND feedback.IsDeleted=0
  AND EXISTS
  (
      SELECT 1 FROM dbo.OLTracking_Assignment assignment
      WHERE assignment.AssignmentID=feedback.AssignmentID
        AND assignment.UserID=@UserID AND assignment.IsCurrent=1
  )
ORDER BY feedback.FeedbackID DESC;

SELECT target.TargetProcessID ProcessID,targetFlow.ProcessName,targetFlow.StageNo
FROM dbo.OLTracking_Assignment currentAssignment
JOIN dbo.OLTracking_ProcessFeedbackTarget target
  ON target.ProjectID=currentAssignment.ProjectID
 AND target.ProcessID=currentAssignment.ProcessID
 AND target.IsActive=1
JOIN dbo.OLTracking_ProcessFlow targetFlow ON targetFlow.ProjectID=target.ProjectID
 AND targetFlow.ProcessID=target.TargetProcessID AND targetFlow.IsActive=1
WHERE currentAssignment.AssignmentID=@AssignmentID
  AND currentAssignment.UserID=@UserID
  AND currentAssignment.IsCurrent=1
ORDER BY targetFlow.StageNo,targetFlow.ProcessName;") { CommandType = CommandType.Text, CommandTimeout = 30 };
            Add(command, "@AssignmentID", SqlDbType.BigInt, assignmentId);
            Add(command, "@UserID", SqlDbType.Int, userId);
            Add(command, "@FeedbackBy", SqlDbType.NVarChar, feedbackBy, 200);
            DataSet result = Set(command);
            bool hasConfiguredTargets = result.Tables.Count > 4 && result.Tables[4].Rows.Count > 0;
            if (result.Tables.Count > 0)
            {
                if (!result.Tables[0].Columns.Contains("HasConfiguredFeedbackTargets"))
                    result.Tables[0].Columns.Add("HasConfiguredFeedbackTargets", typeof(bool));
                foreach (DataRow contextRow in result.Tables[0].Rows)
                    contextRow["HasConfiguredFeedbackTargets"] = hasConfiguredTargets;
            }
            if (hasConfiguredTargets && result.Tables.Count > 2)
            {
                HashSet<int> allowedProcessIds = new HashSet<int>();
                foreach (DataRow row in result.Tables[4].Rows)
                    allowedProcessIds.Add(Convert.ToInt32(row["ProcessID"]));
                DataTable owners = result.Tables[2];
                for (int index = owners.Rows.Count - 1; index >= 0; index--)
                    if (!allowedProcessIds.Contains(Convert.ToInt32(owners.Rows[index]["ProcessID"]))) owners.Rows.RemoveAt(index);
            }
            return result;
        }

        public bool GetCompletionFeedbackRequirement(long assignmentId, int userId)
        {
            SqlCommand command = new SqlCommand(@"
SELECT CAST(CASE WHEN ISNULL(projectFlow.FeedbackRequiredOnComplete,0)=1
                       OR ISNULL(effectiveFlow.FeedbackRequiredOnComplete,0)=1
                 THEN 1 ELSE 0 END AS bit) FeedbackRequiredOnComplete
FROM dbo.OLTracking_Assignment assignment
JOIN dbo.OLTracking_Item item ON item.ItemID=assignment.ItemID
LEFT JOIN dbo.OLTracking_ProcessFlow projectFlow ON projectFlow.ProjectID=assignment.ProjectID
     AND projectFlow.ProcessID=assignment.ProcessID AND projectFlow.IsActive=1
OUTER APPLY
(
    SELECT TOP (1) flow.FeedbackRequiredOnComplete
    FROM dbo.OLTracking_EffectiveProcessFlow(assignment.ProjectID,item.DealNumber) flow
    WHERE flow.ProcessID=assignment.ProcessID
) effectiveFlow
WHERE assignment.AssignmentID=@AssignmentID AND assignment.UserID=@UserID AND assignment.IsCurrent=1;")
            { CommandType = CommandType.Text, CommandTimeout = 10 };
            Add(command, "@AssignmentID", SqlDbType.BigInt, assignmentId);
            Add(command, "@UserID", SqlDbType.Int, userId);
            DataTable result = Table(command);
            if (result.Rows.Count == 0) throw new InvalidOperationException("The assignment is no longer available.");
            return Convert.ToBoolean(result.Rows[0]["FeedbackRequiredOnComplete"]);
        }

        public DataTable GetNonTrackingPendingLoans(int projectId, string dealNumber, int processId, int userId, string userName)
        {
            EnsureProcessFlowColumns();
            EnsureImportSourceColumn();
            SqlCommand command = new SqlCommand(@"
SET NOCOUNT ON;
IF NOT EXISTS
(
    SELECT 1 FROM dbo.OLTracking_ProcessFlow
    WHERE ProjectID=@ProjectID AND ProcessID=@ProcessID AND IsActive=1 AND IsTrackingSheetProcess=0
)
    THROW 50138,'The selected process uses the standard Tracking Sheet workflow.',1;

DECLARE @StageNo int=(SELECT StageNo FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) WHERE ProcessID=@ProcessID);
;WITH Available AS
(
    SELECT i.ItemID,i.ItemNumber LoanNo,ISNULL(i.DealNumber,'') DealNo
    FROM dbo.OLTracking_Item i
    CROSS APPLY dbo.OLTracking_ProcessDependencyEligibility(@ProjectID,@ProcessID,i.ItemID) dependencyEligibility
    WHERE @StageNo IS NOT NULL AND i.ProjectID=@ProjectID AND i.IsDeleted=0 AND i.RecordSource='Import'
      AND LTRIM(RTRIM(ISNULL(i.DealNumber,'')))=LTRIM(RTRIM(ISNULL(@DealNumber,'')))
      AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_LoanHold loanHold
                     WHERE loanHold.ItemID=i.ItemID AND loanHold.ResumedDate IS NULL)
      AND NOT EXISTS
      (
          SELECT 1 FROM dbo.OLTracking_Assignment a
          WHERE a.ItemID=i.ItemID AND a.ProcessID=@ProcessID
            AND (a.IsCurrent=1 OR a.AssignmentStatus IN('Completed','Skipped'))
      )
      AND
      (
          (dependencyEligibility.HasConfiguredDependencies=1 AND dependencyEligibility.DependenciesSatisfied=1)
          OR
          (dependencyEligibility.HasConfiguredDependencies=0 AND NOT EXISTS
           (
               SELECT 1 FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) requiredFlow
               WHERE requiredFlow.StageNo<@StageNo AND requiredFlow.IsMandatory=1
                 AND NOT EXISTS
                 (
                     SELECT 1 FROM dbo.OLTracking_Assignment completedAssignment
                     WHERE completedAssignment.ItemID=i.ItemID AND completedAssignment.ProcessID=requiredFlow.ProcessID
                       AND completedAssignment.AssignmentStatus IN('Completed','Skipped')
                 )
           ))
      )
)
SELECT CAST(NULL AS bigint) AssignmentID,a.LoanNo,a.DealNo,@UserName UserName,
       CAST(NULL AS datetime) StartDate,CAST(NULL AS datetime) EndDate,'Available' Status,'' Reason,
       f.FeedbackRequiredOnComplete,CAST(CASE WHEN f.IsMandatory=1 THEN 0 ELSE 1 END AS bit) CanSkip,
       CAST(CASE WHEN EXISTS
       (
           SELECT 1 FROM dbo.OLTracking_Assignment activeAssignment
           JOIN dbo.OLTracking_ProcessFlow activeFlow ON activeFlow.ProjectID=activeAssignment.ProjectID
                AND activeFlow.ProcessID=activeAssignment.ProcessID AND activeFlow.IsActive=1
           WHERE activeAssignment.UserID=@UserID AND activeAssignment.IsCurrent=1
             AND activeAssignment.AssignmentStatus='In Process' AND activeFlow.IsTrackingSheetProcess=0
       ) THEN 1 ELSE 0 END AS bit) StartBlocked
FROM Available a
JOIN dbo.OLTracking_ProcessFlow f ON f.ProjectID=@ProjectID AND f.ProcessID=@ProcessID AND f.IsActive=1
UNION ALL
SELECT assignment.AssignmentID,item.ItemNumber LoanNo,ISNULL(item.DealNumber,'') DealNo,@UserName UserName,
       assignment.StartedDate StartDate,assignment.CompletedDate EndDate,assignment.AssignmentStatus Status,
       ISNULL(assignment.LastRemark,'') Reason,flow.FeedbackRequiredOnComplete,
       CAST(CASE WHEN flow.IsMandatory=1 THEN 0 ELSE 1 END AS bit) CanSkip,
       CAST(CASE WHEN EXISTS
       (
           SELECT 1 FROM dbo.OLTracking_Assignment activeAssignment
           JOIN dbo.OLTracking_ProcessFlow activeFlow ON activeFlow.ProjectID=activeAssignment.ProjectID
                AND activeFlow.ProcessID=activeAssignment.ProcessID AND activeFlow.IsActive=1
           WHERE activeAssignment.UserID=@UserID AND activeAssignment.IsCurrent=1
             AND activeAssignment.AssignmentStatus='In Process' AND activeFlow.IsTrackingSheetProcess=0
             AND activeAssignment.AssignmentID<>assignment.AssignmentID
       ) THEN 1 ELSE 0 END AS bit) StartBlocked
FROM dbo.OLTracking_Assignment assignment
JOIN dbo.OLTracking_Item item ON item.ItemID=assignment.ItemID
JOIN dbo.OLTracking_ProcessFlow flow ON flow.ProjectID=assignment.ProjectID AND flow.ProcessID=assignment.ProcessID AND flow.IsActive=1
WHERE assignment.ProjectID=@ProjectID AND assignment.ProcessID=@ProcessID AND assignment.UserID=@UserID
  AND assignment.IsCurrent=1 AND assignment.AssignmentStatus IN('Pending','In Process','Hold')
  AND LTRIM(RTRIM(ISNULL(item.DealNumber,'')))=LTRIM(RTRIM(ISNULL(@DealNumber,'')))
  AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_LoanHold loanHold
                 WHERE loanHold.ItemID=item.ItemID AND loanHold.ResumedDate IS NULL)
ORDER BY LoanNo;") { CommandType = CommandType.Text, CommandTimeout = 90 };
            Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@DealNumber", SqlDbType.NVarChar, dealNumber ?? string.Empty, 150);
            Add(command, "@ProcessID", SqlDbType.Int, processId);
            Add(command, "@UserID", SqlDbType.Int, userId);
            Add(command, "@UserName", SqlDbType.NVarChar, userName ?? string.Empty, 200);
            return Table(command);
        }

        public void EnsureCanStartNonTrackingLoan(int userId, long assignmentId)
        {
            SqlCommand command = new SqlCommand(@"
IF EXISTS
(
    SELECT 1
    FROM dbo.OLTracking_Assignment activeAssignment WITH(UPDLOCK,HOLDLOCK)
    JOIN dbo.OLTracking_ProcessFlow activeFlow ON activeFlow.ProjectID=activeAssignment.ProjectID
         AND activeFlow.ProcessID=activeAssignment.ProcessID AND activeFlow.IsActive=1
    WHERE activeAssignment.UserID=@UserID AND activeAssignment.IsCurrent=1
      AND activeAssignment.AssignmentStatus='In Process' AND activeFlow.IsTrackingSheetProcess=0
      AND (@AssignmentID<=0 OR activeAssignment.AssignmentID<>@AssignmentID)
)
    THROW 50132,'Complete or place the current In Process loan on hold before starting another loan.',1;")
            { CommandType = CommandType.Text, CommandTimeout = 10 };
            Add(command, "@UserID", SqlDbType.Int, userId);
            Add(command, "@AssignmentID", SqlDbType.BigInt, assignmentId);
            ExecuteNonQuery(command);
        }

        public void SkipLoan(long assignmentId, string remark, int userId)
        {
            SqlCommand command = Command("OLTracking_SkipLoan");
            Add(command, "@AssignmentID", SqlDbType.BigInt, assignmentId);
            Add(command, "@Remark", SqlDbType.NVarChar, remark, 1000);
            Add(command, "@UserID", SqlDbType.Int, userId);
            ExecuteNonQuery(command);
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

        public long SubmitHourlyProductivity(int projectId, int processId, string dealNumber, int durationMinutes, int userId)
        {
            SqlCommand command = Command("OLTracking_SubmitHourlyProductivity");
            Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@ProcessID", SqlDbType.Int, processId);
            Add(command, "@DealNumber", SqlDbType.NVarChar, dealNumber ?? string.Empty, 150);
            Add(command, "@DurationMinutes", SqlDbType.Int, durationMinutes);
            Add(command, "@UserID", SqlDbType.Int, userId);
            DataTable result = Table(command);
            return result.Rows.Count == 0 ? 0 : Convert.ToInt64(result.Rows[0]["HourlyEntryID"]);
        }

        public DataTable SaveFeedbackForTargets(long assignmentId, long[] targetAssignmentIds, string feedbackBy,
            string errorType, int categoryId, string category, int subcategoryId, string subcategory, string severity,
            string errorField, string screen, string feedbackType, string error, string shouldBe, string remark, int userId)
        {
            EnsureProcessFlowColumns();
            XElement targets = new XElement("assignments");
            if (targetAssignmentIds != null)
                foreach (long targetAssignmentId in targetAssignmentIds)
                    if (targetAssignmentId > 0) targets.Add(new XElement("assignment", targetAssignmentId));

            SqlCommand command = new SqlCommand(@"
SET NOCOUNT ON; SET XACT_ABORT ON;
DECLARE @Requested int=(SELECT COUNT(DISTINCT node.value('(text())[1]','bigint')) FROM @TargetXml.nodes('/assignments/assignment') source(node));
IF @Requested<1 THROW 50147,'Select at least one Previous Process.',1;

DECLARE @ItemID bigint,@ProjectID int,@CurrentProcessID int,@CurrentStage int;
SELECT @ItemID=currentAssignment.ItemID,@ProjectID=currentAssignment.ProjectID,
       @CurrentProcessID=currentAssignment.ProcessID,@CurrentStage=currentFlow.StageNo
FROM dbo.OLTracking_Assignment currentAssignment WITH(UPDLOCK,HOLDLOCK)
JOIN dbo.OLTracking_ProcessFlow currentFlow ON currentFlow.ProjectID=currentAssignment.ProjectID
 AND currentFlow.ProcessID=currentAssignment.ProcessID AND currentFlow.IsActive=1
WHERE currentAssignment.AssignmentID=@AssignmentID AND currentAssignment.UserID=@UserID AND currentAssignment.IsCurrent=1;
IF @ItemID IS NULL THROW 50124,'Assignment is no longer available.',1;

DECLARE @HasConfiguredTargets bit=CASE WHEN EXISTS
(
    SELECT 1 FROM dbo.OLTracking_ProcessFeedbackTarget
    WHERE ProjectID=@ProjectID AND ProcessID=@CurrentProcessID AND IsActive=1
) THEN 1 ELSE 0 END;

DECLARE @Targets table
(
    AssignmentID bigint NOT NULL PRIMARY KEY,ProcessID int NOT NULL,ProcessName nvarchar(200) NOT NULL,
    UserName nvarchar(200) NOT NULL,DateReviewed nvarchar(100) NULL
);
INSERT @Targets(AssignmentID,ProcessID,ProcessName,UserName,DateReviewed)
SELECT previous.AssignmentID,previous.ProcessID,previousFlow.ProcessName,
       COALESCE(NULLIF(employeeConfig.PsuedoName,''),NULLIF(employeeConfig.Code,''),NULLIF(employee.Code,''),CONVERT(nvarchar(30),previous.UserID)),
       CONVERT(varchar(10),previous.CompletedDate,101)
FROM
(
    SELECT DISTINCT node.value('(text())[1]','bigint') AssignmentID
    FROM @TargetXml.nodes('/assignments/assignment') source(node)
) requested
JOIN dbo.OLTracking_Assignment previous ON previous.AssignmentID=requested.AssignmentID
JOIN dbo.OLTracking_ProcessFlow previousFlow ON previousFlow.ProjectID=previous.ProjectID
 AND previousFlow.ProcessID=previous.ProcessID AND previousFlow.IsActive=1
LEFT JOIN dbo.EmployeeInfo employee ON employee.EmployeeID=previous.UserID
OUTER APPLY
(
    SELECT TOP 1 configuration.Code,configuration.PsuedoName
    FROM dbo.EmployeeConfiguration configuration
    WHERE configuration.EmployeeID=previous.UserID AND configuration.Code=employee.Code
      AND configuration.DataSource='ERP' AND configuration.IsDelete=0
    ORDER BY configuration.EmpConfigrationID DESC
) employeeConfig
WHERE previous.ItemID=@ItemID AND previous.ProjectID=@ProjectID
  AND previous.AssignmentStatus='Completed' AND previousFlow.StageNo<@CurrentStage
  AND
  (
      @HasConfiguredTargets=0 OR EXISTS
      (
          SELECT 1 FROM dbo.OLTracking_ProcessFeedbackTarget configured
          WHERE configured.ProjectID=@ProjectID AND configured.ProcessID=@CurrentProcessID
            AND configured.TargetProcessID=previous.ProcessID AND configured.IsActive=1
      )
  );
IF (SELECT COUNT(1) FROM @Targets)<>@Requested
    THROW 50148,'A selected Previous Process is invalid, incomplete, or not configured for feedback.',1;
IF @HasConfiguredTargets=1 AND EXISTS
(
    SELECT 1 FROM dbo.OLTracking_ProcessFeedbackTarget configured
    WHERE configured.ProjectID=@ProjectID AND configured.ProcessID=@CurrentProcessID AND configured.IsActive=1
      AND NOT EXISTS(SELECT 1 FROM @Targets selected WHERE selected.ProcessID=configured.TargetProcessID)
)
    THROW 50149,'Feedback must be added against every configured Previous Process user.',1;

DECLARE @Saved table(FeedbackID bigint NOT NULL);
DECLARE @One table(FeedbackID bigint,FeedbackCount int,ExternalFeedbackID bigint,ExternalTable nvarchar(100));
DECLARE @TargetAssignmentID bigint,@ProcessName nvarchar(200),@ErrorBy nvarchar(200),@DateReviewed nvarchar(100);
DECLARE targetCursor CURSOR LOCAL FAST_FORWARD FOR
    SELECT AssignmentID,ProcessName,UserName,DateReviewed FROM @Targets ORDER BY AssignmentID;
BEGIN TRY
    BEGIN TRANSACTION;
    OPEN targetCursor;
    FETCH NEXT FROM targetCursor INTO @TargetAssignmentID,@ProcessName,@ErrorBy,@DateReviewed;
    WHILE @@FETCH_STATUS=0
    BEGIN
        DELETE FROM @One;
        INSERT @One(FeedbackID,FeedbackCount,ExternalFeedbackID,ExternalTable)
        EXEC dbo.OLTracking_SaveFeedback
            @AssignmentID=@AssignmentID,@MarkedTo=@ProcessName,@ErrorBy=@ErrorBy,@FeedbackBy=@FeedbackBy,
            @ErrorType=@ErrorType,@CategoryID=@CategoryID,@Category=@Category,@SubcategoryID=@SubcategoryID,
            @Subcategory=@Subcategory,@Severity=@Severity,@ErrorField=@ErrorField,@Screen=@Screen,
            @FeedbackType=@FeedbackType,@Error=@Error,@ShouldBe=@ShouldBe,@Remark=@Remark,
            @DateReviewed=@DateReviewed,@UserID=@UserID;
        INSERT @Saved(FeedbackID) SELECT FeedbackID FROM @One;
        UPDATE feedback SET FeedbackAgainstAssignmentID=@TargetAssignmentID
        FROM dbo.OLTracking_Feedback feedback
        JOIN @One savedFeedback ON savedFeedback.FeedbackID=feedback.FeedbackID;
        FETCH NEXT FROM targetCursor INTO @TargetAssignmentID,@ProcessName,@ErrorBy,@DateReviewed;
    END;
    CLOSE targetCursor; DEALLOCATE targetCursor;
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF CURSOR_STATUS('local','targetCursor')>=0 CLOSE targetCursor;
    IF CURSOR_STATUS('local','targetCursor')>-3 DEALLOCATE targetCursor;
    IF @@TRANCOUNT>0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
SELECT ISNULL(MAX(FeedbackID),0) FeedbackID,
       (SELECT COUNT(1) FROM dbo.OLTracking_Feedback WHERE AssignmentID=@AssignmentID AND IsDeleted=0) FeedbackCount,
       COUNT(1) SavedTargetCount
FROM @Saved;") { CommandType = CommandType.Text, CommandTimeout = 90 };
            Add(command, "@AssignmentID", SqlDbType.BigInt, assignmentId);
            Add(command, "@TargetXml", SqlDbType.Xml, targets.ToString(SaveOptions.DisableFormatting));
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

        public DataTable GetHourlyProductivityEntries(int projectId, DateTime fromDate, DateTime toDate)
        {
            SqlCommand command = new SqlCommand(@"
SELECT h.HourlyEntryID,h.ProjectID,h.DealNumber,h.ProcessID,flow.ProcessName,flow.StageNo,h.UserID,
       COALESCE(NULLIF(ec.PsuedoName,''),NULLIF(ec.Code,''),NULLIF(e.Code,''),CONVERT(nvarchar(30),h.UserID)) UserName,
       h.DurationMinutes,h.EntryDate
FROM dbo.OLTracking_HourlyProductivityEntry h
CROSS APPLY dbo.OLTracking_EffectiveProcessFlow(h.ProjectID,h.DealNumber) flow
LEFT JOIN dbo.EmployeeInfo e ON e.EmployeeID=h.UserID
OUTER APPLY(SELECT TOP 1 c.Code,c.PsuedoName FROM dbo.EmployeeConfiguration c WHERE c.EmployeeID=h.UserID AND c.IsDelete=0 ORDER BY c.EmpConfigrationID DESC) ec
WHERE flow.ProcessID=h.ProcessID AND h.ProjectID=@ProjectID
  AND h.EntryDate>=@FromDate AND h.EntryDate<DATEADD(day,1,@ToDate)
ORDER BY h.EntryDate,h.HourlyEntryID;") { CommandType = CommandType.Text };
            Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@FromDate", SqlDbType.Date, fromDate.Date);
            Add(command, "@ToDate", SqlDbType.Date, toDate.Date);
            return Table(command);
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

        public DataTable GetManagerDetail(int projectId, string dealNumber, int processId, int userId, string status, string productivityType, DateTime? fromDate, DateTime? toDate)
        {
            SqlCommand command = Command("OLTracking_GetManagerDetail"); Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@DealNumber", SqlDbType.NVarChar, dealNumber, 150); Add(command, "@ProcessID", SqlDbType.Int, processId); Add(command, "@UserID", SqlDbType.Int, userId);
            Add(command, "@Status", SqlDbType.VarChar, status, 20); Add(command, "@FromDate", SqlDbType.Date, fromDate);
            Add(command, "@ProductivityType", SqlDbType.NVarChar, productivityType, 40); Add(command, "@ToDate", SqlDbType.Date, toDate); return Table(command);
        }

        public DataSet GetSndManagerDashboard(int projectId, DateTime fromDate, DateTime toDate)
        {
            SqlCommand command = new SqlCommand(@"
SET NOCOUNT ON;
DECLARE @PreviousFrom date,@PreviousTo date,@RecentFrom date,@HistoryFrom date;
SET @PreviousFrom=DATEADD(month,DATEDIFF(month,0,@FromDate)-1,0);
SET @PreviousTo=DATEADD(day,-1,DATEADD(month,DATEDIFF(month,0,@FromDate),0));
SET @RecentFrom=DATEADD(day,-60,@FromDate);
SET @HistoryFrom=CASE WHEN @RecentFrom<@PreviousFrom THEN @RecentFrom ELSE @PreviousFrom END;

SELECT configured.ProcessID,MAX(configured.ProcessName) ProcessName,MIN(configured.StageNo) StageNo
INTO #Processes
FROM
(
    SELECT flow.ProcessID,flow.ProcessName,flow.StageNo,
        ISNULL(flow.ProductivityType,N'Loan Based Productivity') ProductivityType
    FROM (SELECT DISTINCT DealNumber FROM dbo.OLTracking_Item
          WHERE ProjectID=@ProjectID AND IsDeleted=0) deal
    CROSS APPLY dbo.OLTracking_EffectiveProcessFlow(@ProjectID,deal.DealNumber) flow
    UNION ALL
    SELECT flow.ProcessID,flow.ProcessName,flow.StageNo,
        ISNULL(flow.ProductivityType,N'Loan Based Productivity') ProductivityType
    FROM dbo.OLTracking_ProcessFlow flow
    WHERE flow.ProjectID=@ProjectID AND flow.IsActive=1
      AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_Item item
                     WHERE item.ProjectID=@ProjectID AND item.IsDeleted=0)
) configured
GROUP BY configured.ProcessID
HAVING MAX(CASE WHEN configured.ProductivityType<>N'Hourly Productivity' THEN 1 ELSE 0 END)=1;

SELECT DISTINCT projectUser.UserID,
    COALESCE(NULLIF(employeeConfig.PsuedoName,''),NULLIF(employeeConfig.Code,''),NULLIF(employee.Code,''),CONVERT(nvarchar(30),projectUser.UserID)) UserName,
    COALESCE(NULLIF(employeeConfig.Code,''),NULLIF(employee.Code,''),CONVERT(nvarchar(30),projectUser.UserID)) UserCode
INTO #Users
FROM dbo.UserProjectConfiguration projectUser
JOIN dbo.EmployeeInfo employee ON employee.EmployeeID=projectUser.UserID AND ISNULL(employee.IsDelete,0)=0
OUTER APPLY
(
    SELECT TOP 1 configuration.Code,configuration.PsuedoName
    FROM dbo.EmployeeConfiguration configuration
    WHERE configuration.EmployeeID=employee.EmployeeID AND configuration.Code=employee.Code
      AND configuration.DataSource='ERP' AND configuration.IsDelete=0
    ORDER BY configuration.EmpConfigrationID DESC
) employeeConfig
WHERE projectUser.ProjectID=@ProjectID;

SELECT assignment.AssignmentID,assignment.ItemID,assignment.ProcessID,assignment.UserID,
    ISNULL(item.DealNumber,'') DealNumber,assignment.AssignmentStatus,assignment.AssignedDate,
    assignment.StartedDate,assignment.CompletedDate,ISNULL(assignment.CompletedDate,assignment.AssignedDate) ActivityDate
INTO #Activity
FROM dbo.OLTracking_Assignment assignment
JOIN dbo.OLTracking_Item item ON item.ItemID=assignment.ItemID
CROSS APPLY dbo.OLTracking_EffectiveProcessFlow(assignment.ProjectID,item.DealNumber) flow
JOIN #Processes process ON process.ProcessID=assignment.ProcessID
WHERE assignment.ProjectID=@ProjectID AND flow.ProcessID=assignment.ProcessID
  AND ISNULL(flow.ProductivityType,N'Loan Based Productivity')<>N'Hourly Productivity'
  AND ISNULL(assignment.CompletedDate,assignment.AssignedDate)>=@HistoryFrom
  AND ISNULL(assignment.CompletedDate,assignment.AssignedDate)<DATEADD(day,1,@ToDate);

SELECT ProcessID,ProcessName,StageNo FROM #Processes ORDER BY StageNo,ProcessName;

SELECT process.ProcessID,process.ProcessName,
    COUNT(activity.AssignmentID) TotalAssigned,
    SUM(CASE WHEN activity.AssignmentStatus='Completed' THEN 1 ELSE 0 END) DoneCount,
    SUM(CASE WHEN activity.AssignmentID IS NOT NULL AND activity.AssignmentStatus<>'Completed' THEN 1 ELSE 0 END) InProcessCount
FROM #Processes process
LEFT JOIN #Activity activity ON activity.ProcessID=process.ProcessID
    AND activity.ActivityDate>=@FromDate AND activity.ActivityDate<DATEADD(day,1,@ToDate)
GROUP BY process.ProcessID,process.ProcessName,process.StageNo
ORDER BY process.StageNo,process.ProcessName;

;WITH Counts AS
(
    SELECT users.UserID,users.UserName,
      SUM(CASE WHEN activity.ActivityDate>=@FromDate AND activity.ActivityDate<DATEADD(day,1,@ToDate) THEN 1 ELSE 0 END) CurrentAssigned,
      SUM(CASE WHEN activity.AssignmentStatus='Completed' AND activity.CompletedDate>=@FromDate AND activity.CompletedDate<DATEADD(day,1,@ToDate) THEN 1 ELSE 0 END) CurrentDone,
      SUM(CASE WHEN activity.AssignmentStatus='Completed' AND activity.CompletedDate>=@PreviousFrom AND activity.CompletedDate<DATEADD(day,1,@PreviousTo) THEN 1 ELSE 0 END) PreviousDone,
      SUM(CASE WHEN activity.ActivityDate>=@RecentFrom AND activity.ActivityDate<DATEADD(day,1,@ToDate) THEN 1 ELSE 0 END) RecentActivity
    FROM #Users users LEFT JOIN #Activity activity ON activity.UserID=users.UserID
    GROUP BY users.UserID,users.UserName
), Ranked AS
(
    SELECT *,RANK() OVER(ORDER BY CurrentDone DESC) CurrentRank,
      RANK() OVER(ORDER BY PreviousDone DESC) PreviousRank
    FROM Counts
)
SELECT UserID,UserName,CurrentAssigned,CurrentDone,PreviousDone,RecentActivity,CurrentRank,PreviousRank
FROM Ranked ORDER BY CurrentRank,UserName;

;WITH LoanCompletion AS
(
    SELECT item.ItemID,ISNULL(item.DealNumber,'') DealNumber,item.AddedDate,
      ISNULL(requiredProcesses.MandatoryCount,0) MandatoryCount,
      ISNULL(completedProcesses.CompletedMandatoryCount,0) CompletedMandatoryCount
    FROM dbo.OLTracking_Item item
    OUTER APPLY
    (
        SELECT COUNT(1) MandatoryCount
        FROM dbo.OLTracking_EffectiveProcessFlow(item.ProjectID,item.DealNumber) requiredFlow
        WHERE requiredFlow.IsMandatory=1
          AND ISNULL(requiredFlow.ProductivityType,N'Loan Based Productivity')<>N'Hourly Productivity'
    ) requiredProcesses
    OUTER APPLY
    (
        SELECT COUNT(1) CompletedMandatoryCount
        FROM dbo.OLTracking_EffectiveProcessFlow(item.ProjectID,item.DealNumber) completedFlow
        WHERE completedFlow.IsMandatory=1
          AND ISNULL(completedFlow.ProductivityType,N'Loan Based Productivity')<>N'Hourly Productivity'
          AND EXISTS
          (
              SELECT 1 FROM dbo.OLTracking_Assignment completedAssignment
              WHERE completedAssignment.ItemID=item.ItemID
                AND completedAssignment.ProcessID=completedFlow.ProcessID
                AND completedAssignment.AssignmentStatus='Completed'
          )
    ) completedProcesses
    WHERE item.ProjectID=@ProjectID AND ISNULL(item.IsDeleted,0)=0
)
SELECT DealNumber,COUNT(1) TotalLoans,
    SUM(CASE WHEN MandatoryCount>0 AND CompletedMandatoryCount=MandatoryCount THEN 1 ELSE 0 END) CompletedLoans,
    MAX(AddedDate) LatestActivity
FROM LoanCompletion
GROUP BY DealNumber ORDER BY MAX(AddedDate) DESC,DealNumber;

SELECT users.UserID,users.UserName,process.ProcessID,process.ProcessName,
    ISNULL(userDays.DaysWorked,0) DaysWorked,
    SUM(CASE WHEN activity.AssignmentStatus='Completed' THEN 1 ELSE 0 END) CompletedCount,
    COALESCE(NULLIF(userTarget.Target,''),NULLIF(processTarget.Maturity,'')) DailyTarget
FROM #Users users CROSS JOIN #Processes process
LEFT JOIN #Activity activity ON activity.UserID=users.UserID AND activity.ProcessID=process.ProcessID
    AND activity.CompletedDate>=@FromDate AND activity.CompletedDate<DATEADD(day,1,@ToDate)
OUTER APPLY
(
    SELECT COUNT(DISTINCT CONVERT(char(8),worked.CompletedDate,112)) DaysWorked
    FROM #Activity worked WHERE worked.UserID=users.UserID AND worked.AssignmentStatus='Completed'
      AND worked.CompletedDate>=@FromDate AND worked.CompletedDate<DATEADD(day,1,@ToDate)
) userDays
OUTER APPLY
(
    SELECT TOP 1 target.Target FROM dbo.UserTarget target
    WHERE target.ProjectID=@ProjectID AND target.ProcessID=process.ProcessID
      AND RTRIM(target.Code)=RTRIM(users.UserCode) AND ISNULL(target.IsDelete,0)=0
    ORDER BY ISNULL(target.UpdatedDate,target.AddedDate) DESC,target.ID DESC
) userTarget
OUTER APPLY
(
    SELECT TOP 1 matrix.Maturity FROM dbo.TargetMatrixMaster matrix
    WHERE matrix.ProjectID=CONVERT(nvarchar(20),@ProjectID)
      AND matrix.ProcessID=CONVERT(nvarchar(20),process.ProcessID)
      AND (matrix.ProductID IS NULL OR matrix.ProductID='' OR matrix.ProductID='0')
    ORDER BY matrix.TargetMatrixID DESC
) processTarget
GROUP BY users.UserID,users.UserName,process.ProcessID,process.ProcessName,userDays.DaysWorked,userTarget.Target,processTarget.Maturity,process.StageNo
HAVING SUM(CASE WHEN activity.AssignmentStatus='Completed' THEN 1 ELSE 0 END)>0
ORDER BY users.UserName,process.StageNo,process.ProcessName;

SELECT users.UserID,users.UserName,process.ProcessID,process.ProcessName,
    SUM(CASE WHEN activity.AssignmentStatus='Completed' THEN 1 ELSE 0 END) DoneCount,
    SUM(CASE WHEN activity.AssignmentStatus='In Process' THEN 1 ELSE 0 END) InProcessCount,
    SUM(CASE WHEN activity.AssignmentStatus='Pending' THEN 1 ELSE 0 END) PendingCount,
    COUNT(activity.AssignmentID) TotalCount
FROM #Users users CROSS JOIN #Processes process
LEFT JOIN #Activity activity ON activity.UserID=users.UserID AND activity.ProcessID=process.ProcessID
    AND activity.ActivityDate>=@FromDate AND activity.ActivityDate<DATEADD(day,1,@ToDate)
GROUP BY users.UserID,users.UserName,process.ProcessID,process.ProcessName,process.StageNo
HAVING COUNT(activity.AssignmentID)>0
ORDER BY process.StageNo,process.ProcessName,users.UserName;

DROP TABLE #Activity; DROP TABLE #Users; DROP TABLE #Processes;"
            ) { CommandType = CommandType.Text, CommandTimeout = 120 };
            Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@FromDate", SqlDbType.Date, fromDate.Date);
            Add(command, "@ToDate", SqlDbType.Date, toDate.Date);
            return Set(command);
        }

        public DataTable GetManagerSummary(int projectId, string dealNumber, int processId, int userId, string productivityType, DateTime? fromDate, DateTime? toDate)
        {
            SqlCommand command = Command("OLTracking_GetManagerSummary"); Add(command, "@ProjectID", SqlDbType.Int, projectId);
            Add(command, "@DealNumber", SqlDbType.NVarChar, dealNumber, 150); Add(command, "@ProcessID", SqlDbType.Int, processId); Add(command, "@UserID", SqlDbType.Int, userId);
            Add(command, "@ProductivityType", SqlDbType.NVarChar, productivityType, 40);
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
            SqlCommand validation = Command("OLTracking_ValidateReallocationFlow");
            Add(validation, "@ProjectID", SqlDbType.Int, projectId);
            Add(validation, "@AssignmentXml", SqlDbType.Xml, assignments.ToString(SaveOptions.DisableFormatting));
            ExecuteNonQuery(validation);
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
