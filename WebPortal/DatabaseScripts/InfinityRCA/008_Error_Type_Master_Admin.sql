/* Administration procedures for adding and enabling/disabling ET1-ET9. */
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE dbo.usp_GetErrorTypeMasterAdmin
    @ErrorType tinyint
AS
BEGIN
    SET NOCOUNT ON;
    IF @ErrorType=1 SELECT ID,0 ParentID,N'' ParentName,0 TaxonomyID,N'' TaxonomyName,Name,IsActive,DisplayOrder FROM dbo.ErrorType1Master ORDER BY DisplayOrder,ID;
    ELSE IF @ErrorType=2 SELECT c.ID,c.ErrorType1ID ParentID,p.Name ParentName,0 TaxonomyID,N'' TaxonomyName,c.Name,c.IsActive,c.DisplayOrder FROM dbo.ErrorType2Master c JOIN dbo.ErrorType1Master p ON p.ID=c.ErrorType1ID ORDER BY p.DisplayOrder,c.DisplayOrder,c.ID;
    ELSE IF @ErrorType=3 SELECT c.ID,c.ErrorType2ID ParentID,p.Name ParentName,0 TaxonomyID,N'' TaxonomyName,c.Name,c.IsActive,c.DisplayOrder FROM dbo.ErrorType3Master c JOIN dbo.ErrorType2Master p ON p.ID=c.ErrorType2ID ORDER BY p.DisplayOrder,c.DisplayOrder,c.ID;
    ELSE IF @ErrorType=4 SELECT ID,0 ParentID,N'' ParentName,0 TaxonomyID,N'' TaxonomyName,Name,IsActive,DisplayOrder FROM dbo.ErrorType4Master ORDER BY DisplayOrder,ID;
    ELSE IF @ErrorType=5 SELECT c.ID,ISNULL(c.TaxonomyID,0) ParentID,ISNULL(t.Name,N'') ParentName,ISNULL(c.TaxonomyID,0) TaxonomyID,ISNULL(t.Name,N'') TaxonomyName,c.Name,c.IsActive,c.DisplayOrder FROM dbo.ErrorType5Master c LEFT JOIN dbo.TaxonomyMaster t ON t.ID=c.TaxonomyID ORDER BY t.DisplayOrder,c.DisplayOrder,c.ID;
    ELSE IF @ErrorType=6 SELECT c.ID,c.ErrorType5ID ParentID,p.Name ParentName,ISNULL(p.TaxonomyID,0) TaxonomyID,ISNULL(t.Name,N'') TaxonomyName,c.Name,c.IsActive,c.DisplayOrder FROM dbo.ErrorType6Master c JOIN dbo.ErrorType5Master p ON p.ID=c.ErrorType5ID LEFT JOIN dbo.TaxonomyMaster t ON t.ID=p.TaxonomyID ORDER BY p.DisplayOrder,c.DisplayOrder,c.ID;
    ELSE IF @ErrorType=7 SELECT c.ID,c.ErrorType6ID ParentID,p.Name ParentName,ISNULL(g.TaxonomyID,0) TaxonomyID,ISNULL(t.Name,N'') TaxonomyName,c.Name,c.IsActive,c.DisplayOrder FROM dbo.ErrorType7Master c JOIN dbo.ErrorType6Master p ON p.ID=c.ErrorType6ID JOIN dbo.ErrorType5Master g ON g.ID=p.ErrorType5ID LEFT JOIN dbo.TaxonomyMaster t ON t.ID=g.TaxonomyID ORDER BY p.DisplayOrder,c.DisplayOrder,c.ID;
    ELSE IF @ErrorType=8 SELECT ID,0 ParentID,N'' ParentName,0 TaxonomyID,N'' TaxonomyName,Name,IsActive,DisplayOrder FROM dbo.ErrorType8Master ORDER BY DisplayOrder,ID;
    ELSE IF @ErrorType=9 SELECT ID,0 ParentID,N'' ParentName,0 TaxonomyID,N'' TaxonomyName,Name,IsActive,DisplayOrder FROM dbo.ErrorType9Master ORDER BY DisplayOrder,ID;
    ELSE THROW 51010,'Error Type must be between 1 and 9.',1;
END;
GO

CREATE PROCEDURE dbo.usp_GetErrorTypeMasterParents
    @ErrorType tinyint
AS
BEGIN
    SET NOCOUNT ON;
    IF @ErrorType=2 SELECT ID,Name FROM dbo.ErrorType1Master WHERE IsActive=1 ORDER BY DisplayOrder,ID;
    ELSE IF @ErrorType=3 SELECT ID,Name FROM dbo.ErrorType2Master WHERE IsActive=1 ORDER BY DisplayOrder,ID;
    ELSE IF @ErrorType=5 SELECT ID,Name FROM dbo.TaxonomyMaster WHERE IsActive=1 ORDER BY DisplayOrder,ID;
    ELSE IF @ErrorType=6 SELECT ID,Name FROM dbo.ErrorType5Master WHERE IsActive=1 ORDER BY DisplayOrder,ID;
    ELSE IF @ErrorType=7 SELECT ID,Name FROM dbo.ErrorType6Master WHERE IsActive=1 ORDER BY DisplayOrder,ID;
    ELSE SELECT CAST(NULL AS int) ID,CAST(NULL AS nvarchar(500)) Name WHERE 1=0;
END;
GO

CREATE PROCEDURE dbo.usp_AddErrorTypeMaster
    @ErrorType tinyint,
    @Name nvarchar(500),
    @ParentID int=NULL,
    @DisplayOrder int=NULL,
    @AddedBy int
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    SET @Name=LTRIM(RTRIM(@Name));
    IF ISNULL(@Name,N'')=N'' THROW 51011,'Name is mandatory.',1;
    IF @ErrorType IN (2,3,5,6,7) AND ISNULL(@ParentID,0)<=0 THROW 51012,'A parent selection is mandatory.',1;
    BEGIN TRANSACTION;
    DECLARE @ID int,@Order int;
    IF @ErrorType=1 BEGIN SELECT @ID=ISNULL(MAX(ID),0)+1,@Order=ISNULL(@DisplayOrder,ISNULL(MAX(DisplayOrder),0)+1) FROM dbo.ErrorType1Master WITH(UPDLOCK,HOLDLOCK); INSERT dbo.ErrorType1Master VALUES(@ID,@Name,1,@Order,@AddedBy,GETDATE()); END
    ELSE IF @ErrorType=2 BEGIN IF NOT EXISTS(SELECT 1 FROM dbo.ErrorType1Master WHERE ID=@ParentID AND IsActive=1) THROW 51013,'Active ET1 parent not found.',1; SELECT @ID=ISNULL(MAX(ID),0)+1,@Order=ISNULL(@DisplayOrder,ISNULL(MAX(DisplayOrder),0)+1) FROM dbo.ErrorType2Master WITH(UPDLOCK,HOLDLOCK); INSERT dbo.ErrorType2Master VALUES(@ID,@ParentID,@Name,1,@Order,@AddedBy,GETDATE()); END
    ELSE IF @ErrorType=3 BEGIN IF NOT EXISTS(SELECT 1 FROM dbo.ErrorType2Master WHERE ID=@ParentID AND IsActive=1) THROW 51013,'Active ET2 parent not found.',1; SELECT @ID=ISNULL(MAX(ID),0)+1,@Order=ISNULL(@DisplayOrder,ISNULL(MAX(DisplayOrder),0)+1) FROM dbo.ErrorType3Master WITH(UPDLOCK,HOLDLOCK); INSERT dbo.ErrorType3Master VALUES(@ID,@ParentID,@Name,1,@Order,@AddedBy,GETDATE()); END
    ELSE IF @ErrorType=4 BEGIN SELECT @ID=ISNULL(MAX(ID),0)+1,@Order=ISNULL(@DisplayOrder,ISNULL(MAX(DisplayOrder),0)+1) FROM dbo.ErrorType4Master WITH(UPDLOCK,HOLDLOCK); INSERT dbo.ErrorType4Master VALUES(@ID,@Name,1,@Order,@AddedBy,GETDATE()); END
    ELSE IF @ErrorType=5 BEGIN IF NOT EXISTS(SELECT 1 FROM dbo.TaxonomyMaster WHERE ID=@ParentID AND IsActive=1) THROW 51013,'Active Taxonomy parent not found.',1; SELECT @ID=ISNULL(MAX(ID),0)+1,@Order=ISNULL(@DisplayOrder,ISNULL(MAX(DisplayOrder),0)+1) FROM dbo.ErrorType5Master WITH(UPDLOCK,HOLDLOCK); INSERT dbo.ErrorType5Master VALUES(@ID,@ParentID,@Name,1,@Order,@AddedBy,GETDATE()); END
    ELSE IF @ErrorType=6 BEGIN IF NOT EXISTS(SELECT 1 FROM dbo.ErrorType5Master WHERE ID=@ParentID AND IsActive=1) THROW 51013,'Active ET5 parent not found.',1; SELECT @ID=ISNULL(MAX(ID),0)+1,@Order=ISNULL(@DisplayOrder,ISNULL(MAX(DisplayOrder),0)+1) FROM dbo.ErrorType6Master WITH(UPDLOCK,HOLDLOCK); INSERT dbo.ErrorType6Master VALUES(@ID,@ParentID,@Name,1,@Order,@AddedBy,GETDATE()); END
    ELSE IF @ErrorType=7 BEGIN IF NOT EXISTS(SELECT 1 FROM dbo.ErrorType6Master WHERE ID=@ParentID AND IsActive=1) THROW 51013,'Active ET6 parent not found.',1; SELECT @ID=ISNULL(MAX(ID),0)+1,@Order=ISNULL(@DisplayOrder,ISNULL(MAX(DisplayOrder),0)+1) FROM dbo.ErrorType7Master WITH(UPDLOCK,HOLDLOCK); INSERT dbo.ErrorType7Master VALUES(@ID,@ParentID,@Name,1,@Order,@AddedBy,GETDATE()); END
    ELSE IF @ErrorType=8 BEGIN SELECT @ID=ISNULL(MAX(ID),0)+1,@Order=ISNULL(@DisplayOrder,ISNULL(MAX(DisplayOrder),0)+1) FROM dbo.ErrorType8Master WITH(UPDLOCK,HOLDLOCK); INSERT dbo.ErrorType8Master VALUES(@ID,@Name,1,@Order,@AddedBy,GETDATE()); END
    ELSE IF @ErrorType=9 BEGIN SELECT @ID=ISNULL(MAX(ID),0)+1,@Order=ISNULL(@DisplayOrder,ISNULL(MAX(DisplayOrder),0)+1) FROM dbo.ErrorType9Master WITH(UPDLOCK,HOLDLOCK); INSERT dbo.ErrorType9Master VALUES(@ID,@Name,1,@Order,@AddedBy,GETDATE()); END
    ELSE THROW 51010,'Error Type must be between 1 and 9.',1;
    COMMIT TRANSACTION;
    SELECT @ID;
END;
GO

CREATE PROCEDURE dbo.usp_SetErrorTypeMasterActive
    @ErrorType tinyint,@ID int,@IsActive bit
AS
BEGIN
    SET NOCOUNT ON;
    IF @ErrorType=1 UPDATE dbo.ErrorType1Master SET IsActive=@IsActive WHERE ID=@ID;
    ELSE IF @ErrorType=2 UPDATE dbo.ErrorType2Master SET IsActive=@IsActive WHERE ID=@ID;
    ELSE IF @ErrorType=3 UPDATE dbo.ErrorType3Master SET IsActive=@IsActive WHERE ID=@ID;
    ELSE IF @ErrorType=4 UPDATE dbo.ErrorType4Master SET IsActive=@IsActive WHERE ID=@ID;
    ELSE IF @ErrorType=5 UPDATE dbo.ErrorType5Master SET IsActive=@IsActive WHERE ID=@ID;
    ELSE IF @ErrorType=6 UPDATE dbo.ErrorType6Master SET IsActive=@IsActive WHERE ID=@ID;
    ELSE IF @ErrorType=7 UPDATE dbo.ErrorType7Master SET IsActive=@IsActive WHERE ID=@ID;
    ELSE IF @ErrorType=8 UPDATE dbo.ErrorType8Master SET IsActive=@IsActive WHERE ID=@ID;
    ELSE IF @ErrorType=9 UPDATE dbo.ErrorType9Master SET IsActive=@IsActive WHERE ID=@ID;
    ELSE THROW 51010,'Error Type must be between 1 and 9.',1;
    IF @@ROWCOUNT=0 THROW 51014,'Error Type record not found.',1;
    RETURN 1;
END;
GO

