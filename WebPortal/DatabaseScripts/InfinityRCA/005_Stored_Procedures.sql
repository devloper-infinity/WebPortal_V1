/* SQL Server 2016-compatible RCA binding, eligibility, and persistence procedures. */
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE dbo.usp_IsInfinityCreditFeedback
    @FeedbackID bigint,
    @Subdomain nvarchar(100),
    @IsEligible bit OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @IsEligible = 0;

    IF @Subdomain NOT IN (N'C', N'Credit') RETURN;

    /* ImportedFeedbacks.Client stores Project.ProjectName (for example, '2377'). */
    DECLARE @CreditPredicate nvarchar(500);
    IF COL_LENGTH(N'dbo.vw_GetLiveProject_ForReport', N'Flag') IS NOT NULL
        SET @CreditPredicate = N'v.Flag = N''Credit''';
    ELSE IF COL_LENGTH(N'dbo.vw_GetLiveProject_ForReport', N'Credit') IS NOT NULL
        SET @CreditPredicate = N'ISNULL(TRY_CONVERT(int, v.Credit), 0) = 1';
    ELSE IF COL_LENGTH(N'dbo.vw_GetLiveProject_ForReport', N'SubDomain') IS NOT NULL
        SET @CreditPredicate = N'v.SubDomain = N''Credit''';
    ELSE
        THROW 51003, 'vw_GetLiveProject_ForReport must expose Flag, Credit, or SubDomain for bifurcation.', 1;

    DECLARE @sql nvarchar(max) = N'
        SELECT @Eligible = CASE WHEN EXISTS
        (
            SELECT 1
            FROM dbo.ImportedFeedbacks f
            INNER JOIN dbo.Project p ON LTRIM(RTRIM(p.ProjectName)) = LTRIM(RTRIM(f.Client))
            INNER JOIN dbo.vw_GetLiveProject_ForReport v ON v.ProjectID = p.ProjectID
            WHERE f.FeedbackID = @FID
              AND ' + @CreditPredicate + N'
              AND ISNULL(p.SubDomainID, 0) <> 99
        ) THEN 1 ELSE 0 END;';
    EXEC sys.sp_executesql @sql, N'@FID bigint, @Eligible bit OUTPUT', @FID = @FeedbackID, @Eligible = @IsEligible OUTPUT;
END;
GO

CREATE PROCEDURE dbo.usp_GetInfinityFeedbackRcaBootstrap
    @FeedbackID bigint,
    @Subdomain nvarchar(100)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @IsEligible bit = 0;
    EXEC dbo.usp_IsInfinityCreditFeedback @FeedbackID, @Subdomain, @IsEligible OUTPUT;

    SELECT N'META' AS OptionType, 0 AS ID, 0 AS ParentID, N'' AS Name, @IsEligible AS IsEligible,
           ISNULL(s.ErrorType1ID, 0) AS ErrorType1ID, ISNULL(s.ErrorType2ID, 0) AS ErrorType2ID,
           ISNULL(s.ErrorType3ID, 0) AS ErrorType3ID, ISNULL(s.ErrorType4ID, 0) AS ErrorType4ID,
           ISNULL(s.ErrorType5ID, 0) AS ErrorType5ID, ISNULL(s.ErrorType6ID, 0) AS ErrorType6ID,
           ISNULL(s.ErrorType7ID, 0) AS ErrorType7ID, ISNULL(s.ErrorType8ID, 0) AS ErrorType8ID,
           ISNULL(s.ErrorType9ID, 0) AS ErrorType9ID
    FROM (SELECT 1 AS Anchor) a
    LEFT JOIN dbo.InfinityFeedbackErrorSelection s ON s.FeedbackID = @FeedbackID
    UNION ALL
    SELECT N'ET1', ID, 0, Name, @IsEligible, 0,0,0,0,0,0,0,0,0 FROM dbo.ErrorType1Master WHERE IsActive = 1
    UNION ALL
    SELECT N'ET4', ID, 0, Name, @IsEligible, 0,0,0,0,0,0,0,0,0 FROM dbo.ErrorType4Master WHERE IsActive = 1
    UNION ALL
    SELECT N'ET5', ID, ISNULL(TaxonomyID, 0), Name, @IsEligible, 0,0,0,0,0,0,0,0,0 FROM dbo.ErrorType5Master WHERE IsActive = 1
    UNION ALL
    SELECT N'ET8', ID, 0, Name, @IsEligible, 0,0,0,0,0,0,0,0,0 FROM dbo.ErrorType8Master WHERE IsActive = 1
    UNION ALL
    SELECT N'ET9', ID, 0, Name, @IsEligible, 0,0,0,0,0,0,0,0,0 FROM dbo.ErrorType9Master WHERE IsActive = 1
    ORDER BY OptionType, ID;
END;
GO

CREATE PROCEDURE dbo.usp_GetInfinityFeedbackRcaChildren
    @ErrorType tinyint,
    @ParentID int
AS
BEGIN
    SET NOCOUNT ON;
    IF @ErrorType = 2
        SELECT ID, ErrorType1ID AS ParentID, Name FROM dbo.ErrorType2Master WHERE ErrorType1ID = @ParentID AND IsActive = 1 ORDER BY DisplayOrder, ID;
    ELSE IF @ErrorType = 3
        SELECT ID, ErrorType2ID AS ParentID, Name FROM dbo.ErrorType3Master WHERE ErrorType2ID = @ParentID AND IsActive = 1 ORDER BY DisplayOrder, ID;
    ELSE IF @ErrorType = 6
        SELECT ID, ErrorType5ID AS ParentID, Name FROM dbo.ErrorType6Master WHERE ErrorType5ID = @ParentID AND IsActive = 1 ORDER BY DisplayOrder, ID;
    ELSE IF @ErrorType = 7
        SELECT ID, ErrorType6ID AS ParentID, Name FROM dbo.ErrorType7Master WHERE ErrorType6ID = @ParentID AND IsActive = 1 ORDER BY DisplayOrder, ID;
    ELSE
        THROW 51001, 'Unsupported RCA child error type.', 1;
END;
GO

CREATE PROCEDURE dbo.usp_SaveInfinityFeedbackRcaSelections
    @FeedbackID bigint,
    @Subdomain nvarchar(100),
    @ErrorType1ID int, @ErrorType2ID int, @ErrorType3ID int,
    @ErrorType4ID int, @ErrorType5ID int, @ErrorType6ID int,
    @ErrorType7ID int, @ErrorType8ID int, @ErrorType9ID int,
    @AddedBy int
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @IsEligible bit = 0;
    EXEC dbo.usp_IsInfinityCreditFeedback @FeedbackID, @Subdomain, @IsEligible OUTPUT;

    /* Non-Infinity-Credit records keep their existing flow and receive no RCA selection write. */
    IF @IsEligible = 0 RETURN 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.ErrorType1Master WHERE ID=@ErrorType1ID AND IsActive=1)
       OR NOT EXISTS (SELECT 1 FROM dbo.ErrorType2Master WHERE ID=@ErrorType2ID AND ErrorType1ID=@ErrorType1ID AND IsActive=1)
       OR NOT EXISTS (SELECT 1 FROM dbo.ErrorType3Master WHERE ID=@ErrorType3ID AND ErrorType2ID=@ErrorType2ID AND IsActive=1)
       OR NOT EXISTS (SELECT 1 FROM dbo.ErrorType4Master WHERE ID=@ErrorType4ID AND IsActive=1)
       OR NOT EXISTS (SELECT 1 FROM dbo.ErrorType5Master WHERE ID=@ErrorType5ID AND IsActive=1)
       OR NOT EXISTS (SELECT 1 FROM dbo.ErrorType6Master WHERE ID=@ErrorType6ID AND ErrorType5ID=@ErrorType5ID AND IsActive=1)
       OR NOT EXISTS (SELECT 1 FROM dbo.ErrorType7Master WHERE ID=@ErrorType7ID AND ErrorType6ID=@ErrorType6ID AND IsActive=1)
       OR NOT EXISTS (SELECT 1 FROM dbo.ErrorType8Master WHERE ID=@ErrorType8ID AND IsActive=1)
       OR NOT EXISTS (SELECT 1 FROM dbo.ErrorType9Master WHERE ID=@ErrorType9ID AND IsActive=1)
        THROW 51002, 'All ET1-ET9 selections are mandatory and must form valid active hierarchies.', 1;

    BEGIN TRANSACTION;
    UPDATE dbo.InfinityFeedbackErrorSelection
       SET ErrorType1ID=@ErrorType1ID, ErrorType2ID=@ErrorType2ID, ErrorType3ID=@ErrorType3ID,
           ErrorType4ID=@ErrorType4ID, ErrorType5ID=@ErrorType5ID, ErrorType6ID=@ErrorType6ID,
           ErrorType7ID=@ErrorType7ID, ErrorType8ID=@ErrorType8ID, ErrorType9ID=@ErrorType9ID,
           UpdatedBy=@AddedBy, UpdatedDate=GETDATE()
     WHERE FeedbackID=@FeedbackID;

    IF @@ROWCOUNT = 0
        INSERT dbo.InfinityFeedbackErrorSelection
            (FeedbackID,ErrorType1ID,ErrorType2ID,ErrorType3ID,ErrorType4ID,ErrorType5ID,ErrorType6ID,ErrorType7ID,ErrorType8ID,ErrorType9ID,AddedBy,AddedDate)
        VALUES
            (@FeedbackID,@ErrorType1ID,@ErrorType2ID,@ErrorType3ID,@ErrorType4ID,@ErrorType5ID,@ErrorType6ID,@ErrorType7ID,@ErrorType8ID,@ErrorType9ID,@AddedBy,GETDATE());
    COMMIT TRANSACTION;
    RETURN 1;
END;
GO

CREATE PROCEDURE dbo.usp_ValidateInfinityFeedbackRcaSelections
    @FeedbackID bigint,
    @Subdomain nvarchar(100),
    @ErrorType1ID int, @ErrorType2ID int, @ErrorType3ID int,
    @ErrorType4ID int, @ErrorType5ID int, @ErrorType6ID int,
    @ErrorType7ID int, @ErrorType8ID int, @ErrorType9ID int
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @IsEligible bit = 0;
    EXEC dbo.usp_IsInfinityCreditFeedback @FeedbackID, @Subdomain, @IsEligible OUTPUT;
    IF @IsEligible = 0 RETURN 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.ErrorType1Master WHERE ID=@ErrorType1ID AND IsActive=1)
       OR NOT EXISTS (SELECT 1 FROM dbo.ErrorType2Master WHERE ID=@ErrorType2ID AND ErrorType1ID=@ErrorType1ID AND IsActive=1)
       OR NOT EXISTS (SELECT 1 FROM dbo.ErrorType3Master WHERE ID=@ErrorType3ID AND ErrorType2ID=@ErrorType2ID AND IsActive=1)
       OR NOT EXISTS (SELECT 1 FROM dbo.ErrorType4Master WHERE ID=@ErrorType4ID AND IsActive=1)
       OR NOT EXISTS (SELECT 1 FROM dbo.ErrorType5Master WHERE ID=@ErrorType5ID AND IsActive=1)
       OR NOT EXISTS (SELECT 1 FROM dbo.ErrorType6Master WHERE ID=@ErrorType6ID AND ErrorType5ID=@ErrorType5ID AND IsActive=1)
       OR NOT EXISTS (SELECT 1 FROM dbo.ErrorType7Master WHERE ID=@ErrorType7ID AND ErrorType6ID=@ErrorType6ID AND IsActive=1)
       OR NOT EXISTS (SELECT 1 FROM dbo.ErrorType8Master WHERE ID=@ErrorType8ID AND IsActive=1)
       OR NOT EXISTS (SELECT 1 FROM dbo.ErrorType9Master WHERE ID=@ErrorType9ID AND IsActive=1)
        THROW 51002, 'All ET1-ET9 selections are mandatory and must form valid active hierarchies.', 1;
    RETURN 1;
END;
GO
