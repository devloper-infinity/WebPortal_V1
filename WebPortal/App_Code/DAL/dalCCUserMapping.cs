using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using WebPortal.App_Code.Class;

namespace WebPortal.App_Code.DAL
{
    public class dalCCUserMapping
    {
        public DataTable GetInvoiceContext(int headerID)
        {
            const string sql = @"SELECT TOP (1) h.HeaderID, h.Header, h.DomainName, h.Product, h.PayTo,
       ISNULL(d.ProjectID, 0) AS ProjectID, ISNULL(p.ProjectName, '') AS ProjectName,
       CASE WHEN ISDATE(h.EffectiveDate)=1 THEN CONVERT(char(10), CONVERT(datetime,h.EffectiveDate),23) ELSE '' END AS EffectiveFrom,
       CONVERT(char(10),d.ActiveThrough,23) AS EffectiveTo
FROM dbo.CCInvoiceHeaders h
LEFT JOIN dbo.CCInvoiceVerificationDetails d ON d.HeaderID=h.HeaderID
LEFT JOIN dbo.Project p ON p.ProjectID=d.ProjectID
WHERE h.HeaderID=@HeaderID
ORDER BY d.ModifiedOn DESC;";
            SqlCommand command = SQLHelper.GetCommand(CommandType.Text, sql);
            SQLHelper.AddParamToSQLCmd(command, "@HeaderID", SqlDbType.Int, 0, ParameterDirection.Input, headerID);
            return SQLHelper.ExecuteDataTableCmd(command);
        }

        public DataTable GetResources(int projectID)
        {
            const string sql = @"SELECT r.ResourceID,r.ResourceName,r.ResourceType,r.AccountIdentifier,r.ProjectID,
       p.ProjectName,r.DepartmentDomain,r.Description,r.EffectiveFrom,r.EffectiveTo,r.IsActive,r.Remark,
       ISNULL(e.MappedEmployees,'') AS MappedEmployees
FROM dbo.CCCorporateResource r
INNER JOIN dbo.Project p ON p.ProjectID=r.ProjectID
OUTER APPLY (SELECT STUFF((SELECT ', ' + m.EmployeeCode
                           FROM dbo.CCCorporateResourceEmployee m
                           WHERE m.ResourceID=r.ResourceID AND m.IsActive=1
                             AND m.EffectiveFrom<=CONVERT(date,GETDATE())
                             AND (m.EffectiveTo IS NULL OR m.EffectiveTo>=CONVERT(date,GETDATE()))
                           ORDER BY m.EmployeeCode
                           FOR XML PATH(''),TYPE).value('.','nvarchar(max)'),1,2,'') AS MappedEmployees) e
WHERE (@ProjectID=0 OR r.ProjectID=@ProjectID)
ORDER BY r.IsActive DESC,r.ResourceName;";
            SqlCommand command = SQLHelper.GetCommand(CommandType.Text, sql);
            SQLHelper.AddParamToSQLCmd(command, "@ProjectID", SqlDbType.Int, 0, ParameterDirection.Input, projectID);
            return SQLHelper.ExecuteDataTableCmd(command);
        }

        public int SaveResource(int resourceID, string name, string type, string identifier, int projectID,
            string departmentDomain, string description, DateTime from, DateTime? to, bool active, string remark, int userID)
        {
            const string sql = @"SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRANSACTION;
IF EXISTS (SELECT 1 FROM dbo.CCCorporateResource WITH (UPDLOCK,HOLDLOCK)
           WHERE ResourceID<>@ResourceID AND ProjectID=@ProjectID AND
             ((@Identifier<>'' AND AccountIdentifier=@Identifier) OR ResourceName=@ResourceName))
BEGIN ROLLBACK TRANSACTION; RAISERROR('A resource with this name or account identifier already exists for this project.',16,1); RETURN; END;
IF @ResourceID=0
BEGIN
 INSERT dbo.CCCorporateResource(ResourceName,ResourceType,AccountIdentifier,ProjectID,DepartmentDomain,Description,EffectiveFrom,EffectiveTo,IsActive,Remark,CreatedBy)
 VALUES(@ResourceName,@ResourceType,NULLIF(@Identifier,''),@ProjectID,NULLIF(@DepartmentDomain,''),NULLIF(@Description,''),@EffectiveFrom,@EffectiveTo,@IsActive,NULLIF(@Remark,''),@UserID);
 SELECT CONVERT(int,SCOPE_IDENTITY());
END
ELSE
BEGIN
 IF NOT EXISTS(SELECT 1 FROM dbo.CCCorporateResource WITH (UPDLOCK,HOLDLOCK) WHERE ResourceID=@ResourceID)
 BEGIN ROLLBACK TRANSACTION; RAISERROR('Corporate resource was not found.',16,1); RETURN; END;
 IF EXISTS(SELECT 1 FROM dbo.CCCorporateResourceEmployee WITH (UPDLOCK,HOLDLOCK)
           WHERE ResourceID=@ResourceID AND (EffectiveFrom<@EffectiveFrom OR
             (@EffectiveTo IS NOT NULL AND (EffectiveTo IS NULL OR EffectiveTo>@EffectiveTo))))
 BEGIN ROLLBACK TRANSACTION; RAISERROR('The resource effective period cannot exclude an existing employee mapping.',16,1); RETURN; END;
 IF EXISTS(SELECT 1 FROM dbo.CCCorporateResourceBilling WITH (UPDLOCK,HOLDLOCK) WHERE ResourceID=@ResourceID)
    AND EXISTS(SELECT 1 FROM dbo.CCCorporateResource WITH (UPDLOCK,HOLDLOCK) WHERE ResourceID=@ResourceID AND ProjectID<>@ProjectID)
 BEGIN ROLLBACK TRANSACTION; RAISERROR('A resource with billing history cannot be moved to another project.',16,1); RETURN; END;
 UPDATE dbo.CCCorporateResource SET ResourceName=@ResourceName,ResourceType=@ResourceType,AccountIdentifier=NULLIF(@Identifier,''),
  ProjectID=@ProjectID,DepartmentDomain=NULLIF(@DepartmentDomain,''),Description=NULLIF(@Description,''),EffectiveFrom=@EffectiveFrom,
  EffectiveTo=@EffectiveTo,IsActive=@IsActive,Remark=NULLIF(@Remark,''),ModifiedBy=@UserID,ModifiedDate=GETDATE()
 WHERE ResourceID=@ResourceID;
 SELECT @ResourceID;
END;
COMMIT TRANSACTION;";
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand command = SQLHelper.GetCommand(CommandType.Text, sql))
            {
                command.Parameters.Add("@ResourceID", SqlDbType.Int).Value = resourceID;
                command.Parameters.Add("@ResourceName", SqlDbType.NVarChar, 255).Value = name;
                command.Parameters.Add("@ResourceType", SqlDbType.NVarChar, 100).Value = type;
                command.Parameters.Add("@Identifier", SqlDbType.NVarChar, 255).Value = identifier ?? "";
                command.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectID;
                command.Parameters.Add("@DepartmentDomain", SqlDbType.NVarChar, 255).Value = departmentDomain ?? "";
                command.Parameters.Add("@Description", SqlDbType.NVarChar, 1000).Value = description ?? "";
                command.Parameters.Add("@EffectiveFrom", SqlDbType.Date).Value = from;
                command.Parameters.Add("@EffectiveTo", SqlDbType.Date).Value = (object)to ?? DBNull.Value;
                command.Parameters.Add("@IsActive", SqlDbType.Bit).Value = active;
                command.Parameters.Add("@Remark", SqlDbType.NVarChar, 1000).Value = remark ?? "";
                command.Parameters.Add("@UserID", SqlDbType.Int).Value = userID;
                connection.Open();
                command.Connection = connection;
                command.CommandTimeout = 0;
                object result = command.ExecuteScalar();
                if (result == null || result == DBNull.Value)
                    throw new InvalidOperationException("The corporate resource was not saved.");
                return Convert.ToInt32(result);
            }
        }

        public void SetResourceStatus(int resourceID, bool active, int userID)
        {
            const string sql = @"UPDATE dbo.CCCorporateResource SET IsActive=@IsActive,ModifiedBy=@UserID,ModifiedDate=GETDATE()
WHERE ResourceID=@ResourceID; IF @@ROWCOUNT=0 RAISERROR('Corporate resource was not found.',16,1);";
            SqlCommand command = SQLHelper.GetCommand(CommandType.Text, sql);
            command.Parameters.Add("@ResourceID", SqlDbType.Int).Value = resourceID;
            command.Parameters.Add("@IsActive", SqlDbType.Bit).Value = active;
            command.Parameters.Add("@UserID", SqlDbType.Int).Value = userID;
            SQLHelper.ExecuteNonQueryCmd(command);
        }

        public DataTable GetResourceMappings(int resourceID)
        {
            const string sql = @"SELECT MappingID,ResourceID,EmployeeCode,EffectiveFrom,EffectiveTo,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,
       CAST(0 AS bit) AS IsHistory,CAST(NULL AS int) AS HistoryID
FROM dbo.CCCorporateResourceEmployee WHERE ResourceID=@ResourceID
UNION ALL
SELECT MappingID,ResourceID,EmployeeCode,EffectiveFrom,EffectiveTo,IsActive,ChangedBy AS CreatedBy,ChangedDate AS CreatedDate,
       ChangedBy AS ModifiedBy,ChangedDate AS ModifiedDate,CAST(1 AS bit) AS IsHistory,HistoryID
FROM dbo.CCCorporateResourceEmployeeHistory WHERE ResourceID=@ResourceID
ORDER BY IsHistory,EffectiveFrom DESC,MappingID DESC;";
            SqlCommand command = SQLHelper.GetCommand(CommandType.Text, sql);
            command.Parameters.Add("@ResourceID", SqlDbType.Int).Value = resourceID;
            return SQLHelper.ExecuteDataTableCmd(command);
        }

        public void SaveMappings(int resourceID, IList<string> employeeCodes, DateTime from, DateTime? to, int userID)
        {
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            {
                connection.Open();
                using (SqlTransaction transaction = connection.BeginTransaction(IsolationLevel.Serializable))
                {
                    try
                    {
                        DateTime resourceFrom, resourceTo;
                        bool hasResourceTo;
                        using (SqlCommand resource = new SqlCommand("SELECT EffectiveFrom,EffectiveTo,IsActive FROM dbo.CCCorporateResource WITH (UPDLOCK,HOLDLOCK) WHERE ResourceID=@ResourceID", connection, transaction))
                        {
                            resource.Parameters.Add("@ResourceID", SqlDbType.Int).Value = resourceID;
                            using (SqlDataReader reader = resource.ExecuteReader())
                            {
                                if (!reader.Read()) throw new InvalidOperationException("Select a valid corporate resource.");
                                resourceFrom = reader.GetDateTime(0);
                                hasResourceTo = !reader.IsDBNull(1);
                                resourceTo = hasResourceTo ? reader.GetDateTime(1) : DateTime.MaxValue;
                                if (!reader.GetBoolean(2)) throw new InvalidOperationException("Activate the corporate resource before adding employee mappings.");
                            }
                        }
                        if (from < resourceFrom || (hasResourceTo && (!to.HasValue || to.Value > resourceTo)) || (to.HasValue && to.Value < from))
                            throw new InvalidOperationException("Mapping dates must fall within the corporate resource's effective period.");

                        foreach (string code in employeeCodes.Distinct(StringComparer.OrdinalIgnoreCase))
                        {
                            using (SqlCommand overlap = new SqlCommand(@"SELECT COUNT(1) FROM dbo.CCCorporateResourceEmployee WITH (UPDLOCK,HOLDLOCK)
WHERE ResourceID=@ResourceID AND EmployeeCode=@EmployeeCode
 AND EffectiveFrom<=ISNULL(@EffectiveTo,CONVERT(date,'99991231'))
 AND ISNULL(EffectiveTo,CONVERT(date,'99991231'))>=@EffectiveFrom", connection, transaction))
                            {
                                overlap.Parameters.Add("@ResourceID", SqlDbType.Int).Value = resourceID;
                                overlap.Parameters.Add("@EmployeeCode", SqlDbType.NVarChar, 50).Value = code;
                                overlap.Parameters.Add("@EffectiveFrom", SqlDbType.Date).Value = from;
                                overlap.Parameters.Add("@EffectiveTo", SqlDbType.Date).Value = (object)to ?? DBNull.Value;
                                if (Convert.ToInt32(overlap.ExecuteScalar()) > 0)
                                    throw new InvalidOperationException("One or more employees already have an overlapping mapping to this resource.");
                            }
                            using (SqlCommand insert = new SqlCommand(@"INSERT dbo.CCCorporateResourceEmployee(ResourceID,EmployeeCode,EffectiveFrom,EffectiveTo,CreatedBy)
VALUES(@ResourceID,@EmployeeCode,@EffectiveFrom,@EffectiveTo,@UserID);", connection, transaction))
                            {
                                insert.Parameters.Add("@ResourceID", SqlDbType.Int).Value = resourceID;
                                insert.Parameters.Add("@EmployeeCode", SqlDbType.NVarChar, 50).Value = code;
                                insert.Parameters.Add("@EffectiveFrom", SqlDbType.Date).Value = from;
                                insert.Parameters.Add("@EffectiveTo", SqlDbType.Date).Value = (object)to ?? DBNull.Value;
                                insert.Parameters.Add("@UserID", SqlDbType.Int).Value = userID;
                                insert.ExecuteNonQuery();
                            }
                        }
                        transaction.Commit();
                    }
                    catch { transaction.Rollback(); throw; }
                }
            }
        }

        public void EndMapping(int mappingID, DateTime effectiveTo, int userID)
        {
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            {
                connection.Open();
                using (SqlTransaction transaction = connection.BeginTransaction(IsolationLevel.Serializable))
                {
                    try
                    {
                        const string sql = @"INSERT dbo.CCCorporateResourceEmployeeHistory(MappingID,ResourceID,EmployeeCode,EffectiveFrom,EffectiveTo,IsActive,ChangeAction,ChangedBy)
SELECT MappingID,ResourceID,EmployeeCode,EffectiveFrom,EffectiveTo,IsActive,'Ended',@UserID FROM dbo.CCCorporateResourceEmployee WITH (UPDLOCK,HOLDLOCK)
WHERE MappingID=@MappingID AND IsActive=1 AND EffectiveFrom<=@EffectiveTo;
IF @@ROWCOUNT=0 RAISERROR('Active mapping was not found or the end date is earlier than its start date.',16,1);
UPDATE dbo.CCCorporateResourceEmployee SET EffectiveTo=@EffectiveTo,IsActive=0,ModifiedBy=@UserID,ModifiedDate=GETDATE()
WHERE MappingID=@MappingID AND IsActive=1 AND EffectiveFrom<=@EffectiveTo;";
                        using (SqlCommand command = new SqlCommand(sql, connection, transaction))
                        {
                            command.Parameters.Add("@MappingID", SqlDbType.Int).Value = mappingID;
                            command.Parameters.Add("@EffectiveTo", SqlDbType.Date).Value = effectiveTo;
                            command.Parameters.Add("@UserID", SqlDbType.Int).Value = userID;
                            command.ExecuteNonQuery();
                        }
                        transaction.Commit();
                    }
                    catch { transaction.Rollback(); throw; }
                }
            }
        }

        public void UpdateMapping(int mappingID, DateTime from, DateTime? to, int userID)
        {
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            {
                connection.Open();
                using (SqlTransaction transaction = connection.BeginTransaction(IsolationLevel.Serializable))
                {
                    try
                    {
                        const string sql = @"DECLARE @ResourceID int,@EmployeeCode nvarchar(50),@ResourceFrom date,@ResourceTo date;
SELECT @ResourceID=m.ResourceID,@EmployeeCode=m.EmployeeCode,@ResourceFrom=r.EffectiveFrom,@ResourceTo=r.EffectiveTo
FROM dbo.CCCorporateResourceEmployee m WITH (UPDLOCK,HOLDLOCK)
INNER JOIN dbo.CCCorporateResource r WITH (UPDLOCK,HOLDLOCK) ON r.ResourceID=m.ResourceID
WHERE m.MappingID=@MappingID AND m.IsActive=1 AND r.IsActive=1;
IF @ResourceID IS NULL RAISERROR('Active mapping was not found.',16,1);
IF @ResourceID IS NULL RETURN;
IF @EffectiveFrom<@ResourceFrom OR (@ResourceTo IS NOT NULL AND (@EffectiveTo IS NULL OR @EffectiveTo>@ResourceTo))
BEGIN RAISERROR('Mapping dates must fall within the corporate resource effective period.',16,1); RETURN; END;
IF @EffectiveTo IS NOT NULL AND @EffectiveTo<@EffectiveFrom
BEGIN RAISERROR('Mapping end date cannot be earlier than its start date.',16,1); RETURN; END;
IF EXISTS(SELECT 1 FROM dbo.CCCorporateResourceEmployee WITH (UPDLOCK,HOLDLOCK)
          WHERE ResourceID=@ResourceID AND EmployeeCode=@EmployeeCode AND MappingID<>@MappingID
            AND EffectiveFrom<=ISNULL(@EffectiveTo,CONVERT(date,'99991231'))
            AND ISNULL(EffectiveTo,CONVERT(date,'99991231'))>=@EffectiveFrom)
BEGIN RAISERROR('The updated dates overlap another mapping for this employee and resource.',16,1); RETURN; END;
INSERT dbo.CCCorporateResourceEmployeeHistory(MappingID,ResourceID,EmployeeCode,EffectiveFrom,EffectiveTo,IsActive,ChangeAction,ChangedBy)
SELECT MappingID,ResourceID,EmployeeCode,EffectiveFrom,EffectiveTo,IsActive,'Updated',@UserID FROM dbo.CCCorporateResourceEmployee WHERE MappingID=@MappingID;
UPDATE dbo.CCCorporateResourceEmployee SET EffectiveFrom=@EffectiveFrom,EffectiveTo=@EffectiveTo,ModifiedBy=@UserID,ModifiedDate=GETDATE()
WHERE MappingID=@MappingID AND IsActive=1;";
                        using (SqlCommand command = new SqlCommand(sql, connection, transaction))
                        {
                            command.Parameters.Add("@MappingID", SqlDbType.Int).Value = mappingID;
                            command.Parameters.Add("@EffectiveFrom", SqlDbType.Date).Value = from;
                            command.Parameters.Add("@EffectiveTo", SqlDbType.Date).Value = (object)to ?? DBNull.Value;
                            command.Parameters.Add("@UserID", SqlDbType.Int).Value = userID;
                            command.ExecuteNonQuery();
                        }
                        transaction.Commit();
                    }
                    catch { transaction.Rollback(); throw; }
                }
            }
        }

        public int AssociateBilling(int headerID, string month, string year, int resourceID, int userID)
        {
            const string sql = @"IF NOT EXISTS(SELECT 1 FROM dbo.CCCorporateResourceBilling WITH (UPDLOCK,HOLDLOCK)
WHERE HeaderID=@HeaderID AND BillingMonth=@Month AND BillingYear=@Year)
 INSERT dbo.CCCorporateResourceBilling(HeaderID,BillingMonth,BillingYear,ResourceID,CreatedBy) VALUES(@HeaderID,@Month,@Year,@ResourceID,@UserID);
ELSE IF NOT EXISTS(SELECT 1 FROM dbo.CCCorporateResourceBilling WHERE HeaderID=@HeaderID AND BillingMonth=@Month AND BillingYear=@Year AND ResourceID=@ResourceID)
 RAISERROR('A corporate resource is already associated with this invoice period.',16,1);
SELECT COUNT(1) FROM dbo.CCCorporateResourceBilling WHERE HeaderID=@HeaderID AND BillingMonth=@Month AND BillingYear=@Year AND ResourceID=@ResourceID;";
            SqlCommand command = SQLHelper.GetCommand(CommandType.Text, sql);
            command.Parameters.Add("@HeaderID", SqlDbType.Int).Value = headerID;
            command.Parameters.Add("@Month", SqlDbType.NVarChar, 20).Value = month;
            command.Parameters.Add("@Year", SqlDbType.NVarChar, 4).Value = year;
            command.Parameters.Add("@ResourceID", SqlDbType.Int).Value = resourceID;
            command.Parameters.Add("@UserID", SqlDbType.Int).Value = userID;
            return Convert.ToInt32(SQLHelper.ExecuteScalarCmd(command));
        }

        public DataTable GetBillingAssociations(string month, string year)
        {
            const string sql = @"SELECT b.HeaderID,b.BillingMonth,b.BillingYear,r.ResourceID,r.ResourceName,r.ResourceType,r.AccountIdentifier,
 r.ProjectID,p.ProjectName,r.DepartmentDomain,r.EffectiveFrom,r.EffectiveTo,r.IsActive,r.Remark
FROM dbo.CCCorporateResourceBilling b
INNER JOIN dbo.CCCorporateResource r ON r.ResourceID=b.ResourceID
INNER JOIN dbo.Project p ON p.ProjectID=r.ProjectID
WHERE (@Month='' OR b.BillingMonth=@Month) AND (@Year='' OR b.BillingYear=@Year);";
            SqlCommand command = SQLHelper.GetCommand(CommandType.Text, sql);
            command.Parameters.Add("@Month", SqlDbType.NVarChar, 20).Value = month ?? "";
            command.Parameters.Add("@Year", SqlDbType.NVarChar, 4).Value = year ?? "";
            return SQLHelper.ExecuteDataTableCmd(command);
        }
    }
}
