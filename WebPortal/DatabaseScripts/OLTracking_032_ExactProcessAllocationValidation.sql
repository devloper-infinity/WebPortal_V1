/* Permanent validation boundary: an active assignment blocks only the same
   tracker item and process. Assignments for other processes on the loan do not collide. */
ALTER PROCEDURE dbo.OLTracking_ValidateManagerAllocation
    @ProjectID int,
    @ProcessID int,
    @LoanXml xml
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1 FROM dbo.WBT_ProjectTrackingFieldConfig
        WHERE ProjectID=@ProjectID AND IsUniqueField=1 AND IsDeleted=0
          AND ISNULL(IsSystemGenerated,0)=0 AND ISNULL(IsBillingField,0)=0
    )
        THROW 50134,'Configure at least one Unique Field for this project before allocation.',1;

    DECLARE @Selected table
    (
        ItemID bigint PRIMARY KEY,
        UniqueCombination nvarchar(2000),
        UniqueHash binary(32)
    );

    INSERT @Selected(ItemID,UniqueCombination,UniqueHash)
    SELECT item.ItemID,value.UniqueCombination,
           HASHBYTES('SHA2_256',CONVERT(varbinary(max),value.UniqueCombination))
    FROM
    (
        SELECT DISTINCT LTRIM(RTRIM(n.value('(text())[1]','nvarchar(150)'))) LoanNumber
        FROM @LoanXml.nodes('/loans/loan') x(n)
    ) selected
    JOIN dbo.OLTracking_Item item
      ON item.ProjectID=@ProjectID AND item.ItemNumber=selected.LoanNumber AND item.IsDeleted=0
    CROSS APPLY
    (
        SELECT dbo.OLTracking_BuildUniqueCombination(@ProjectID,item.ItemID,@ProcessID) UniqueCombination
    ) value
    WHERE EXISTS
    (
        SELECT 1 FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,item.DealNumber)
        WHERE ProcessID=@ProcessID
    );

    IF (SELECT COUNT(1) FROM @Selected)<>
       (SELECT COUNT(DISTINCT LTRIM(RTRIM(n.value('(text())[1]','nvarchar(150)'))))
        FROM @LoanXml.nodes('/loans/loan') x(n))
        THROW 50128,'One or more selected orders are not applicable to this deal process flow.',1;

    IF EXISTS
    (
        SELECT 1 FROM @Selected selected
        JOIN dbo.OLTracking_LoanHold loanHold ON loanHold.ItemID=selected.ItemID
        WHERE loanHold.ResumedDate IS NULL
    )
        THROW 50160,'One or more selected loans are on manager hold.',1;

    IF EXISTS(SELECT 1 FROM @Selected WHERE UniqueCombination IS NULL)
        THROW 50136,'One or more configured Unique Field values are missing for the selected loan.',1;

    IF EXISTS
    (
        SELECT 1
        FROM @Selected selected
        JOIN dbo.OLTracking_Assignment assignment
          ON assignment.ItemID=selected.ItemID
         AND assignment.ProjectID=@ProjectID
         AND assignment.ProcessID=@ProcessID
         AND assignment.IsCurrent=1
    )
        THROW 50112,'This loan is already allocated for the selected process.',1;
END;
GO
