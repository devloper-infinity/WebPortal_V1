/* Apply after 005 when the initial deployment has already been executed. */
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

ALTER PROCEDURE dbo.usp_IsInfinityCreditFeedback
    @FeedbackID bigint,
    @Subdomain nvarchar(100),
    @IsEligible bit OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @IsEligible = 0;

    IF @Subdomain NOT IN (N'C', N'Credit') RETURN;

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

