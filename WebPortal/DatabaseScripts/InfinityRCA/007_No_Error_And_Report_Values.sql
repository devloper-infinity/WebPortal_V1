/* No-Error selection cleanup and report-name projection. */
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE dbo.usp_ClearInfinityFeedbackRcaSelections
    @FeedbackID bigint,
    @Subdomain nvarchar(100)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @IsEligible bit = 0;
    EXEC dbo.usp_IsInfinityCreditFeedback @FeedbackID, @Subdomain, @IsEligible OUTPUT;
    IF @IsEligible = 1 DELETE dbo.InfinityFeedbackErrorSelection WHERE FeedbackID = @FeedbackID;
    RETURN 1;
END;
GO

CREATE PROCEDURE dbo.usp_GetInfinityFeedbackRcaReportValues
    @FeedbackIDs nvarchar(max)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @xml xml = TRY_CAST(N'<i>' + REPLACE(REPLACE(ISNULL(@FeedbackIDs,N''),N'&',N'&amp;'),N',',N'</i><i>') + N'</i>' AS xml);

    ;WITH Requested AS
    (
        SELECT DISTINCT TRY_CONVERT(bigint, n.value(N'.', N'nvarchar(30)')) AS FeedbackID
        FROM @xml.nodes(N'/i') x(n)
        WHERE TRY_CONVERT(bigint, n.value(N'.', N'nvarchar(30)')) IS NOT NULL
    )
    SELECT s.FeedbackID,
           et1.Name AS ErrorType1Name, et2.Name AS ErrorType2Name, et3.Name AS ErrorType3Name,
           et4.Name AS ErrorType4Name, et5.Name AS ErrorType5Name, et6.Name AS ErrorType6Name,
           et7.Name AS ErrorType7Name, et8.Name AS ErrorType8Name, et9.Name AS ErrorType9Name
    FROM Requested r
    INNER JOIN dbo.InfinityFeedbackErrorSelection s ON s.FeedbackID = r.FeedbackID
    INNER JOIN dbo.ErrorType1Master et1 ON et1.ID=s.ErrorType1ID
    INNER JOIN dbo.ErrorType2Master et2 ON et2.ID=s.ErrorType2ID
    INNER JOIN dbo.ErrorType3Master et3 ON et3.ID=s.ErrorType3ID
    INNER JOIN dbo.ErrorType4Master et4 ON et4.ID=s.ErrorType4ID
    INNER JOIN dbo.ErrorType5Master et5 ON et5.ID=s.ErrorType5ID
    INNER JOIN dbo.ErrorType6Master et6 ON et6.ID=s.ErrorType6ID
    INNER JOIN dbo.ErrorType7Master et7 ON et7.ID=s.ErrorType7ID
    INNER JOIN dbo.ErrorType8Master et8 ON et8.ID=s.ErrorType8ID
    INNER JOIN dbo.ErrorType9Master et9 ON et9.ID=s.ErrorType9ID;
END;
GO

