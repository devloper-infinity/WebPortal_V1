/* Task Allocation.xlsx / Sheet3. Run after SoftwareRequests_001_FullModule.sql. */
SET NOCOUNT ON; SET XACT_ABORT ON; BEGIN TRAN;
DELETE h FROM dbo.SRM_History h JOIN dbo.SRM_Request r ON r.RequestID=h.RequestID WHERE r.RequestNo LIKE 'SWR-DEMO-%' OR r.RequestNo LIKE 'SWR-ALLOC-%';
DELETE a FROM dbo.SRM_Attachment a JOIN dbo.SRM_Request r ON r.RequestID=a.RequestID WHERE r.RequestNo LIKE 'SWR-DEMO-%' OR r.RequestNo LIKE 'SWR-ALLOC-%';
DELETE FROM dbo.SRM_Request WHERE RequestNo LIKE 'SWR-DEMO-%' OR RequestNo LIKE 'SWR-ALLOC-%';
DECLARE @ERP int=(SELECT ApplicationID FROM dbo.SRM_Application WHERE ApplicationName=N'Infinity ERP'),@AP int=(SELECT ApplicationID FROM dbo.SRM_Application WHERE ApplicationName=N'AP Billing'),@Client int=(SELECT ApplicationID FROM dbo.SRM_Application WHERE ApplicationName=N'Client Billing'),@Type int=(SELECT RequestTypeID FROM dbo.SRM_RequestType WHERE RequestTypeName=N'Enhancement');
DECLARE @Tasks TABLE(RowNo int,Developer varchar(20),ModuleName nvarchar(100),Description nvarchar(max),OwnerCode varchar(30),DueDate date,StatusCode varchar(30),Remark nvarchar(max));
INSERT @Tasks VALUES
(1,'NGK',N'Auto Service',N'Change Auto Service email templates for auto absconding and auto block/unblock.',N'HCM','20260828','In Progress',N'Other new ERP formats are changed; Auto Service is pending.'),
(2,'KIP',N'HR',N'Compare old ERP and new ERP pages using Sagar Sir login.',N'GDK','20260828','New',NULL),
(3,'KIP',N'AP Billing',N'Provide all AP 1099 data for billing purposes.',N'OCX','20260828','In Progress',NULL),
(4,'NGK',N'ERP Onshore Tracker',N'Create and assign QCer profiles; grant feedback report access; create Canopy login; add feedback delete option; auto-populate Finding as No Error when severity is No Error.',N'EOT','20260828','In Progress',N'Points 1 to 4 completed. Points 5 and 6 in progress.'),
(5,'NGK',N'OCR Issue',N'Unable to run OCR software due to large files.',N'RCT',NULL,'New',N'Discussion required with Alex and Sam regarding large files.'),
(6,'NGK',N'ERP Onshore Tracker',N'Credit Quality report: add Include No Error Loan Count option. When selected include loans without feedback; otherwise include only loans having feedback.',N'EOT','20260830','New',NULL),
(7,'ICG',N'OST',N'Tracking Report of OST (Search domain) Portal.',N'VMR','20260831','In Progress',NULL),
(8,'KIP',N'HR',N'Branch Wise Salary Report.',N'GDK','20260831','New',NULL),
(9,'KIP',N'Canopy AR',N'Provide all Client Billing data for billing purposes.',N'OCX','20260831','In Progress',NULL),
(10,'NGK',N'ERP - Feedback Analysis',N'Add RCA dropdowns as per Taxonomy for Credit and Compliance Review and add seven Error Types.',N'YCY','20260831','In Progress',N'Structure ready to deploy; awaiting dependent data.'),
(11,'ICG',N'DD- Tracking Sheet',N'Enhance SND Tracker reports and dashboard: today loans, four mandatory process completion percentages, hide lowest active producers, and hold/reallocated order counts with details.',N'NGK','20260905','In Progress',NULL),
(12,'KIP',N'Tracking Sheet',N'Test ERP Tracking Sheet Web process flow for selected Non-DD Commitment and Freight domain before live implementation.',N'MGMT','20260903','In Progress',NULL),
(13,'KIP',N'HR',N'Change existing PM-wise Attrition Report filter to Domain-wise.',N'GDK','20260907','New',NULL),
(14,'KIP',N'AP Billing',N'Auto-email IPS and Canopy vendor billing monthly/weekly to Adam Sir, BCS Sir and Robert.',N'BCS/OCX','20260907','In Progress',NULL),
(15,'YTU',N'Online Tracking Sheet',N'ERP Tracking Sheet Web for all non-DD domains: new development and bug resolution.',N'MGMT','20260907','In Progress',NULL),
(16,'ICG',N'HR',N'Work Anniversary Template integration.',N'GDK','20260910','New',NULL),
(17,'NGK',N'Canopy Billing',N'Integrate RL and Securitization invoice format, send invoice email to selected recipients, and update email template.',N'MGMT','20260825','In Progress',N'Invoice format and email update deployed; awaiting the remaining template from JIM Sir.');
INSERT dbo.SRM_Module(ApplicationID,ModuleName,IsBusinessCritical)
SELECT DISTINCT CASE WHEN ModuleName=N'AP Billing' THEN @AP WHEN ModuleName IN(N'Canopy AR',N'Canopy Billing') THEN @Client ELSE @ERP END,ModuleName,CASE WHEN ModuleName IN(N'AP Billing',N'Canopy AR',N'Canopy Billing') THEN 1 ELSE 0 END FROM @Tasks t
WHERE NOT EXISTS(SELECT 1 FROM dbo.SRM_Module m WHERE m.ApplicationID=CASE WHEN t.ModuleName=N'AP Billing' THEN @AP WHEN t.ModuleName IN(N'Canopy AR',N'Canopy Billing') THEN @Client ELSE @ERP END AND m.ModuleName=t.ModuleName);
INSERT dbo.SRM_Request(RequestNo,RequestDate,RequestedBy,RequestOwnerCode,RequestedByName,Department,RequestTypeID,ApplicationID,ModuleID,Title,Description,BusinessJustification,RequestedPriority,RequiredByDate,AssignedDeveloperID,AssignedDeveloperName,FinalPriority,StatusCode,ExpectedCompletionDate,LatestUpdate,UpdatedBy)
SELECT 'SWR-ALLOC-'+RIGHT('0000'+CAST(t.RowNo AS varchar(4)),4),SYSDATETIME(),CASE WHEN t.OwnerCode='MGMT' OR CHARINDEX('/',t.OwnerCode)>0 THEN NULL ELSE owner1.EmployeeID END,t.OwnerCode,CASE WHEN t.OwnerCode='MGMT' THEN N'Management' ELSE owner1.Code+N' : '+LTRIM(RTRIM(ISNULL(owner1.FirstName,'')+N' '+ISNULL(owner1.lastName,'')))+CASE WHEN owner2.EmployeeID IS NULL THEN N'' ELSE N' / '+owner2.Code+N' : '+LTRIM(RTRIM(ISNULL(owner2.FirstName,'')+N' '+ISNULL(owner2.lastName,''))) END END,NULL,@Type,app.ApplicationID,m.ModuleID,t.ModuleName,t.Description,N'Imported from Software Department task allocation.',CASE WHEN t.ModuleName IN(N'AP Billing',N'Canopy AR',N'Canopy Billing') THEN 'Critical' ELSE 'Medium' END,t.DueDate,dev.EmployeeID,dev.Code+' : '+LTRIM(RTRIM(ISNULL(dev.FirstName,'')+' '+ISNULL(dev.lastName,''))),CASE WHEN t.ModuleName IN(N'AP Billing',N'Canopy AR',N'Canopy Billing') THEN 'Critical' ELSE 'Medium' END,t.StatusCode,t.DueDate,t.Remark,dev.EmployeeID
FROM @Tasks t CROSS APPLY(SELECT CASE WHEN t.ModuleName=N'AP Billing' THEN @AP WHEN t.ModuleName IN(N'Canopy AR',N'Canopy Billing') THEN @Client ELSE @ERP END ApplicationID) app JOIN dbo.SRM_Module m ON m.ApplicationID=app.ApplicationID AND m.ModuleName=t.ModuleName
LEFT JOIN dbo.EmployeeInfo dev ON dev.Code=t.Developer AND dev.Department=12
LEFT JOIN dbo.EmployeeInfo owner1 ON owner1.Code=CASE WHEN CHARINDEX('/',t.OwnerCode)>0 THEN LEFT(t.OwnerCode,CHARINDEX('/',t.OwnerCode)-1) ELSE t.OwnerCode END AND t.OwnerCode<>'MGMT'
LEFT JOIN dbo.EmployeeInfo owner2 ON owner2.Code=CASE WHEN CHARINDEX('/',t.OwnerCode)>0 THEN SUBSTRING(t.OwnerCode,CHARINDEX('/',t.OwnerCode)+1,30) END;
INSERT dbo.SRM_History(RequestID,FieldName,NewValue,Remarks,ChangedBy) SELECT RequestID,N'Import',StatusCode,N'Imported from Task Allocation.xlsx',COALESCE(UpdatedBy,0) FROM dbo.SRM_Request WHERE RequestNo LIKE 'SWR-ALLOC-%';
COMMIT;
