/* Adds CRM menu entries to the existing dynamic menu master.
   Built from the current menu-master format in "menus data.xlsx":
   MenuId, MenuName, ParentMenuId, Url, SectionName, SortOrder.

   Review @GrantToGroupId before running if you want the menu visible
   immediately for a group. Otherwise assign the CRM menu through
   Admin > Assign Group Menus after this script is applied.
*/

SET NOCOUNT ON;

DECLARE @GrantToGroupId INT = NULL; -- Example: set to an existing GroupId to grant CRM immediately.
DECLARE @GrantToUserId INT = NULL;  -- Optional legacy UserRights grant.

IF OBJECT_ID('tempdb..#MenuSeed') IS NOT NULL DROP TABLE #MenuSeed;
CREATE TABLE #MenuSeed
(
    MenuId INT NOT NULL PRIMARY KEY,
    MenuName NVARCHAR(250) NOT NULL,
    ParentMenuId INT NOT NULL,
    Url NVARCHAR(500) NULL,
    SectionName NVARCHAR(250) NULL,
    SortOrder INT NOT NULL
);

INSERT INTO #MenuSeed(MenuId, MenuName, ParentMenuId, Url, SectionName, SortOrder)
VALUES
    (18000, N'CRM', 0, NULL, NULL, 16),
    (18100, N'Workspace', 18000, NULL, N'Workspace', 1),
    (18101, N'CRM Dashboard', 18100, N'../CRM/Dashboard.aspx', NULL, 1),
    (18102, N'Activities', 18100, N'../CRM/Activities.aspx', NULL, 2),
    (18103, N'Reports', 18100, N'../CRM/Reports.aspx', NULL, 3),
    (18200, N'Records', 18000, NULL, N'Records', 2),
    (18201, N'Leads', 18200, N'../CRM/Leads.aspx', NULL, 1),
    (18202, N'Accounts', 18200, N'../CRM/Accounts.aspx', NULL, 2),
    (18203, N'Contacts', 18200, N'../CRM/Contacts.aspx', NULL, 3),
    (18204, N'Deals', 18200, N'../CRM/Deals.aspx', NULL, 4);

DECLARE @MenuTable NVARCHAR(300);

SELECT TOP 1
    @MenuTable = QUOTENAME(s.name) + N'.' + QUOTENAME(t.name)
FROM sys.tables t
INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
WHERE EXISTS (SELECT 1 FROM sys.columns c WHERE c.object_id = t.object_id AND c.name = 'MenuId')
  AND EXISTS (SELECT 1 FROM sys.columns c WHERE c.object_id = t.object_id AND c.name = 'MenuName')
  AND EXISTS (SELECT 1 FROM sys.columns c WHERE c.object_id = t.object_id AND c.name = 'ParentMenuId')
  AND EXISTS (SELECT 1 FROM sys.columns c WHERE c.object_id = t.object_id AND c.name = 'Url')
  AND EXISTS (SELECT 1 FROM sys.columns c WHERE c.object_id = t.object_id AND c.name = 'SectionName')
  AND EXISTS (SELECT 1 FROM sys.columns c WHERE c.object_id = t.object_id AND c.name = 'SortOrder')
ORDER BY
    CASE
        WHEN t.name IN ('MenuMaster', 'Menus', 'Menu', 'MenuMasterNew') THEN 0
        WHEN t.name LIKE '%Menu%' THEN 1
        ELSE 2
    END,
    t.name;

IF @MenuTable IS NULL
BEGIN
    RAISERROR('Could not find a menu master table with MenuId, MenuName, ParentMenuId, Url, SectionName, and SortOrder columns.', 16, 1);
    RETURN;
END;

DECLARE @Sql NVARCHAR(MAX);
DECLARE @ObjectIdSql NVARCHAR(500) = REPLACE(@MenuTable, '''', '''''');

SET @Sql = N'
DECLARE @HasIdentity BIT = 0;
SELECT @HasIdentity = CONVERT(BIT, COLUMNPROPERTY(OBJECT_ID(N''' + @ObjectIdSql + N'''), ''MenuId'', ''IsIdentity''));

IF @HasIdentity = 1 SET IDENTITY_INSERT ' + @MenuTable + N' ON;

MERGE ' + @MenuTable + N' AS target
USING #MenuSeed AS source
    ON target.MenuId = source.MenuId
WHEN MATCHED THEN
    UPDATE SET
        target.MenuName = source.MenuName,
        target.ParentMenuId = source.ParentMenuId,
        target.Url = source.Url,
        target.SectionName = source.SectionName,
        target.SortOrder = source.SortOrder
WHEN NOT MATCHED BY TARGET THEN
    INSERT (MenuId, MenuName, ParentMenuId, Url, SectionName, SortOrder)
    VALUES (source.MenuId, source.MenuName, source.ParentMenuId, source.Url, source.SectionName, source.SortOrder);

IF @HasIdentity = 1 SET IDENTITY_INSERT ' + @MenuTable + N' OFF;
';

EXEC sp_executesql @Sql;

IF @GrantToGroupId IS NOT NULL AND OBJECT_ID('dbo.GroupMenuMapping', 'U') IS NOT NULL
BEGIN
    INSERT INTO dbo.GroupMenuMapping(GroupId, MenuId)
    SELECT @GrantToGroupId, s.MenuId
    FROM #MenuSeed s
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM dbo.GroupMenuMapping gm
        WHERE gm.GroupId = @GrantToGroupId
          AND gm.MenuId = s.MenuId
    );
END;

IF @GrantToUserId IS NOT NULL AND OBJECT_ID('dbo.UserRights', 'U') IS NOT NULL
BEGIN
    INSERT INTO dbo.UserRights(UserId, MenuId)
    SELECT @GrantToUserId, s.MenuId
    FROM #MenuSeed s
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM dbo.UserRights ur
        WHERE ur.UserId = @GrantToUserId
          AND ur.MenuId = s.MenuId
    );
END;

SELECT s.*
FROM #MenuSeed s
ORDER BY s.MenuId;

PRINT 'CRM menu seed completed against ' + @MenuTable + '. Assign group rights if @GrantToGroupId was left NULL.';
