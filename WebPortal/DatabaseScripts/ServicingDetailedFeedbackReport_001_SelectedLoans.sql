/* Servicing-only Detailed Feedback Report. SQL Server 2016 compatible. */
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
IF OBJECT_ID('dbo.ServicingDetailedFeedbackSelection','U') IS NULL
BEGIN
 CREATE TABLE dbo.ServicingDetailedFeedbackSelection(BatchID uniqueidentifier NOT NULL,UserID int NOT NULL,ProjectID int NOT NULL,OrderID int NOT NULL,LoanNo nvarchar(1000) NULL,DispatchDate date NULL,CreatedDate datetime NOT NULL CONSTRAINT DF_ServicingDFR_CreatedDate DEFAULT(GETDATE()),CONSTRAINT PK_ServicingDFR PRIMARY KEY(BatchID,UserID,OrderID));
 CREATE INDEX IX_ServicingDFR_Loan ON dbo.ServicingDetailedFeedbackSelection(BatchID,UserID,ProjectID,LoanNo);
END
GO
IF COL_LENGTH('dbo.ServicingDetailedFeedbackSelection','DispatchDate') IS NULL ALTER TABLE dbo.ServicingDetailedFeedbackSelection ADD DispatchDate date NULL;
GO
IF OBJECT_ID('dbo.usp_ServicingDFR_GetProjects','P') IS NOT NULL DROP PROCEDURE dbo.usp_ServicingDFR_GetProjects;
GO
CREATE PROCEDURE dbo.usp_ServicingDFR_GetProjects @UserID int AS
BEGIN SET NOCOUNT ON;
 CREATE TABLE #Projects(ProjectID int,ProjectName nvarchar(1000));INSERT #Projects EXEC dbo.usp_GetAllProjectByUserRights @EmployeeID=@UserID;
 SELECT DISTINCT P.ProjectID,P.ProjectName FROM #Projects P INNER JOIN dbo.OrderData O ON O.ProjectID=P.ProjectID ORDER BY P.ProjectName;
END
GO
IF OBJECT_ID('dbo.usp_ServicingDFR_GetOrders','P') IS NOT NULL DROP PROCEDURE dbo.usp_ServicingDFR_GetOrders;
GO
CREATE PROCEDURE dbo.usp_ServicingDFR_GetOrders @UserID int,@ProjectIDs nvarchar(max),@FromDate date,@ToDate date AS
BEGIN SET NOCOUNT ON;
 CREATE TABLE #AllowedProjects(ProjectID int,ProjectName nvarchar(1000));INSERT #AllowedProjects EXEC dbo.usp_GetAllProjectByUserRights @EmployeeID=@UserID;
 ;WITH ProjectIDs AS (SELECT DISTINCT T.N.value('.','int') ProjectID FROM (SELECT CONVERT(xml,'<i>'+REPLACE(@ProjectIDs,',','</i><i>')+'</i>') X) A CROSS APPLY A.X.nodes('/i') T(N))
 SELECT ROW_NUMBER() OVER(ORDER BY CASE WHEN ISDATE(O.DispatchDate)=1 THEN CONVERT(date,O.DispatchDate) END,O.OrderID) SrNo,O.OrderID,O.ProjectID,ISNULL(O.DealNo,'') DealNo,ISNULL(O.LoanNo,'') LoanNo,ISNULL(O.OrderDate,'') OrderDate,ISNULL(O.DueDate,'') DueDate,ISNULL(O.DispatchDate,'') DispatchDate,CASE WHEN ISDATE(O.DispatchDate)=1 THEN CONVERT(date,O.DispatchDate) END SafeDispatchDate,ISNULL(O.FinalStatus,'') Status
 FROM dbo.OrderData O INNER JOIN ProjectIDs X ON X.ProjectID=O.ProjectID INNER JOIN #AllowedProjects U ON U.ProjectID=O.ProjectID
 WHERE CASE WHEN ISDATE(O.DispatchDate)=1 THEN CONVERT(date,O.DispatchDate) END BETWEEN @FromDate AND @ToDate
 ORDER BY CASE WHEN ISDATE(O.DispatchDate)=1 THEN CONVERT(date,O.DispatchDate) END,O.OrderID;
END
GO
IF OBJECT_ID('dbo.usp_ServicingDFR_StageSelection','P') IS NOT NULL DROP PROCEDURE dbo.usp_ServicingDFR_StageSelection;
GO
CREATE PROCEDURE dbo.usp_ServicingDFR_StageSelection @BatchID uniqueidentifier,@UserID int,@OrderIDs nvarchar(max) AS
BEGIN SET NOCOUNT ON;
 DELETE dbo.ServicingDetailedFeedbackSelection WHERE CreatedDate<DATEADD(day,-1,GETDATE());
 ;WITH OrderIDs AS (SELECT DISTINCT T.N.value('.','int') OrderID FROM (SELECT CONVERT(xml,'<i>'+REPLACE(@OrderIDs,',','</i><i>')+'</i>') X) A CROSS APPLY A.X.nodes('/i') T(N))
 INSERT dbo.ServicingDetailedFeedbackSelection(BatchID,UserID,ProjectID,OrderID,LoanNo,DispatchDate) SELECT @BatchID,@UserID,O.ProjectID,O.OrderID,O.LoanNo,CASE WHEN ISDATE(O.DispatchDate)=1 THEN CONVERT(date,O.DispatchDate) END FROM dbo.OrderData O INNER JOIN OrderIDs X ON X.OrderID=O.OrderID;
 SELECT @@ROWCOUNT;
END
GO
IF OBJECT_ID('dbo.usp_ServicingDFR_ClearSelection','P') IS NOT NULL DROP PROCEDURE dbo.usp_ServicingDFR_ClearSelection;
GO
CREATE PROCEDURE dbo.usp_ServicingDFR_ClearSelection @BatchID uniqueidentifier,@UserID int AS BEGIN SET NOCOUNT ON;DELETE dbo.ServicingDetailedFeedbackSelection WHERE BatchID=@BatchID AND UserID=@UserID;SELECT @@ROWCOUNT;END
GO
IF OBJECT_ID('dbo.usp_ServicingDFR_WeeklyGraphicalView','P') IS NOT NULL DROP PROCEDURE dbo.usp_ServicingDFR_WeeklyGraphicalView;
GO
CREATE PROCEDURE dbo.usp_ServicingDFR_WeeklyGraphicalView @BatchID uniqueidentifier, @UserID int AS                                    
begin                
DECLARE @Out table (Week nvarchar(max), Srno int, FromDate NVARCHAR(100), [Loan Qced] decimal(18,2), [NC/Loan-Internal] decimal(18,2), [C/Loan-Internal] decimal(18,2), [NC/Loan-ReQC] decimal(18,2),                               
[C/Loan-ReQC] decimal(18,2), [Non-Critical Errors-Client] decimal(18,2),[Critical Errors-Client] decimal(18,2)                  
,[Total Non Critical] decimal(18,2),[Total Critical] decimal(18,2),[Error/Loan] decimal(18,2), [No Error Files] decimal(18,2),[% No Error Files] decimal(18,2))                                    
             
CREATE table #LoopDates (loopid int primary key identity(1,1) not null, Srno int, Date nvarchar(100), Week nvarchar(500), FromDate nvarchar(100), ToDate nvarchar(100))                                    
insert into #LoopDates exec usp_GetMonthQuarterWeekDates_Optimized_Servicing_Infinity_FirstSheet                         
                
;WITH LoanLevelData AS (        
    SELECT         
        L.Week,        
        L.Srno,        
        L.FromDate,        
        F.[Loan Number],        
                
        MAX(CASE         
            WHEN RTRIM(F.[Severity]) <> 'No Error' THEN 1         
            ELSE 0         
        END) AS HasError,        
        
        SUM(CASE WHEN (F.[Severity]='Critical' AND F.[Source]='Internal') THEN 1 ELSE 0 END) AS Critical_Internal,        
        SUM(CASE WHEN ((F.[Severity]='Non-Critical' OR F.[Severity]='Non Critical') AND F.[Source]='Internal') THEN 1 ELSE 0 END) AS NonCritical_Internal,        
        SUM(CASE WHEN (F.[Feedback Type]='Incorrect feedback' AND F.[Source]='Internal') THEN 1 ELSE 0 END) AS Incorrect_Feedback,        
        
        SUM(CASE WHEN (F.[Severity]='Critical' AND F.[Source]='ReQC') THEN 1 ELSE 0 END) AS Critical_ReQC,        
        SUM(CASE WHEN ((F.[Severity]='Non-Critical' OR F.[Severity]='Non Critical') AND F.[Source]='ReQC') THEN 1 ELSE 0 END) AS NonCritical_ReQC,        
        
        SUM(CASE WHEN (F.[Severity]='Critical' AND F.[Source]='Client') THEN 1 ELSE 0 END) AS Critical_Client,        
        SUM(CASE WHEN ((F.[Severity]='Non-Critical' OR F.[Severity]='Non Critical') AND F.[Source]='Client') THEN 1 ELSE 0 END) AS NonCritical_Client,        
        
        SUM(CASE WHEN F.[Source]='Client' THEN 1 ELSE 0 END) AS ClientErrors,        
        
        SUM(CASE WHEN F.[Severity]='Critical' THEN 1 ELSE 0 END) AS TotalCritical,        
        SUM(CASE WHEN (F.[Severity]='Non-Critical' OR F.[Severity]='Non Critical') THEN 1 ELSE 0 END) AS TotalNonCritical        
        
    FROM #LoopDates L
        INNER JOIN (SELECT DISTINCT ProjectID,LoanNo,OrderID,DispatchDate FROM dbo.ServicingDetailedFeedbackSelection WHERE BatchID=@BatchID AND UserID=@UserID) S
            ON S.DispatchDate BETWEEN CAST(L.FromDate AS date) AND CAST(L.ToDate AS date)        
    LEFT JOIN dbo.ImportedFeedbacks_Servicing F         
        ON LTRIM(RTRIM(CONVERT(nvarchar(1000),F.[Loan Number])))=LTRIM(RTRIM(S.LoanNo))        
INNER JOIN Project P         
        ON P.ProjectName = F.Client AND P.ProjectID=S.ProjectID        
    WHERE ISNULL(F.[QC Date],'') <>'' and F.[QC Name]<>''
    GROUP BY         
        F.Client, L.Week, L.Srno, L.FromDate, F.[Loan Number]        
)        
 
--select distinct [Loan Number] from ImportedFeedbacks_Servicing where cast([QC Date] as date) between cast('24-Aug-2026' as date) and cast('30-Aug-2026' as date) and
    

    --select * from ImportedFeedbacks_Servicing where [Loan Number]='179820'
    
    
        
SELECT         
    Week AS [QC Date],        
    Srno,        
    FromDate,        
        
    COUNT(DISTINCT [Loan Number]) AS [Loan Qced],        
        
    SUM(Critical_Internal) AS [Critical Errors],        
    SUM(NonCritical_Internal) AS [Non-Critical Errors],        
        
    -- ✅ FIXED LOGIC        
    COUNT(CASE WHEN HasError = 0 THEN 1 END) AS [No Error Files],        
        
    SUM(Incorrect_Feedback) AS [Incorrect Feedback],        
        
    SUM(Critical_ReQC) AS [Critical Errors-ReQC],        
    SUM(NonCritical_ReQC) AS [Non-Critical Errors-ReQC],        
        
    CAST(SUM(Critical_Client) * 1.0 / COUNT(DISTINCT [Loan Number]) AS DECIMAL(18,2)) AS [Critical Errors-Client],        
    CAST(SUM(NonCritical_Client) * 1.0 / COUNT(DISTINCT [Loan Number]) AS DECIMAL(18,2)) AS [Non-Critical Errors-Client],        
        
    SUM(ClientErrors) AS [Client Errors],        
        
    SUM(TotalCritical) AS [Total Critical Errors],        
    SUM(TotalNonCritical) AS [Total Non-Critical Errors]        
        
INTO #WeekDetailsWeek1        
        
FROM LoanLevelData        
GROUP BY Week, Srno, FromDate;        

--select * from #WeekDetailsWeek1        
              
select *                                          
 , cast((cast([Non-Critical Errors] as decimal(18,2))/cast([Loan Qced]  as decimal(18,2))) as decimal(18,2)) as [NC/Loan-Internal]                                
 , cast((cast([Critical Errors] as decimal(18,2))/cast([Loan Qced]  as decimal(18,2))) as decimal(18,2)) as [C/Loan-Internal]                                      
 , cast((cast([Non-Critical Errors-ReQC] as decimal(18,4))/cast([Loan Qced]  as decimal(18,4))) as decimal(18,4)) as [NC/Loan-ReQC]                                      
 , cast((cast([Critical Errors-ReQC] as decimal(18,4))/cast([Loan Qced]  as decimal(18,4))) as decimal(18,4)) as [C/Loan-ReQC]                          
 into #WeekDetailsWeek2               
 from #WeekDetailsWeek1              
                                  
                                  
 select *, cast([Non-Critical Errors] as decimal(18,4)) + cast([Critical Errors] as decimal(18,4)) +                 
 CAST([Non-Critical Errors-ReQC] as decimal(18,4)) + cast([Critical Errors-ReQC] as decimal(18,4)) as [Total Errors] into #WeekDetailsWeek3 from                          
 #WeekDetailsWeek2                
                 
 insert into @Out                                            
select [QC Date] as Week, Srno, FromDate, cast(sum([Loan Qced]) as decimal(18,0)) as [Loan Qced], cast(sum([NC/Loan-Internal]) as decimal(18,2)) as [NC/Loan-Internal],                  
cast(sum([C/Loan-Internal]) as decimal(18,2)) as [C/Loan-Internal]                                          
 , cast(sum([NC/Loan-ReQC]) as decimal(18,4)) as [NC/Loan-ReQC], cast(sum([C/Loan-ReQC]) as decimal(18,4)) as [C/Loan-ReQC]                                          
  , cast(sum([Non-Critical Errors-Client]) as decimal(18,2)) as [Non-Critical Errors-Client],                                      
  cast(sum([Critical Errors-Client]) as decimal(18,2)) as [Critical Errors-Client],                    
  (cast(sum([NC/Loan-Internal]) as decimal(18,2)) + cast(sum([NC/Loan-ReQC]) as decimal(18,4)) + cast(sum([Non-Critical Errors-Client]) as decimal(18,2))) as [Total Non Critical],                    
  (cast(sum([C/Loan-Internal]) as decimal(18,2)) + cast(sum([C/Loan-ReQC]) as decimal(18,4)) + cast(sum([Critical Errors-Client]) as decimal(18,2))) as [Total Critical],                    
  cast((sum(cast([Total Errors] as decimal(18,4)))/sum(cast([Loan Qced] as decimal(18,4)))) as decimal(18,2)) as [Error/Loan],                   
  cast(sum([No Error Files]) as decimal(18,2)) as [No Error Files],                                    
  (cast((sum(cast([No Error Files] as decimal(18,2)))/sum(cast([Loan Qced] as decimal(18,2)))) * 100 as decimal(18,0))) as [% No Error Files]                                    
  from #WeekDetailsWeek3                                          
  group by [QC Date], Srno, FromDate                             
                
                  
drop table #WeekDetailsWeek1                                                       
 drop table #WeekDetailsWeek2                                                      
 drop table #WeekDetailsWeek3                                                            

                
 SELECT Week, [Loan Qced], [NC/Loan-Internal], [C/Loan-Internal], [NC/Loan-ReQC], [C/Loan-ReQC], [Non-Critical Errors-Client], [Critical Errors-Client],                
 [Total Non Critical], [Total Critical], [Error/Loan], [No Error Files], [% No Error Files]                
 FROM  @Out ORDER BY Srno asc, CAST(FromDate AS DATE) DESC                   
 --FROM  @Out ORDER BY case when Client='561' then 0 when Client='667' then 1 when Client='2104' then 3 else 4 end, Srno asc, CAST(FromDate AS DATE) DESC                   
                
                
                
DROP TABLE  #LoopDates                
end
GO
IF OBJECT_ID('dbo.usp_ServicingDFR_ClientwiseErrorTrending','P') IS NOT NULL DROP PROCEDURE dbo.usp_ServicingDFR_ClientwiseErrorTrending;
GO
CREATE PROCEDURE dbo.usp_ServicingDFR_ClientwiseErrorTrending @BatchID uniqueidentifier, @UserID int AS            
BEGIN            
    SET NOCOUNT ON;            
            
    -----------------------------------------            
    -- STEP 1: Date Ranges            
    -----------------------------------------            
    CREATE TABLE #LoopDates (            
        loopid INT IDENTITY(1,1) PRIMARY KEY,            
        [Date] NVARCHAR(100),            
        Week NVARCHAR(500),            
        FromDate NVARCHAR(100),            
        ToDate NVARCHAR(100)            
    )            
            
    INSERT INTO #LoopDates            
    EXEC usp_GetMonthQuarterWeekDates_Client_Servicing_Infinity_AdditionalSecondSheet            
            
            
    -----------------------------------------            
    -- STEP 2: Aggregation            
    -----------------------------------------            
    ;WITH LoanLevelData AS (            
    SELECT             
        I.Client,            
        L.Week,            
        L.FromDate,            
        I.[Loan Number],

        -- ✅ KEY LOGIC
        MAX(CASE 
            WHEN RTRIM(I.Severity) <> 'No Error' THEN 1 
            ELSE 0 
        END) AS HasError,

        SUM(CASE WHEN I.[Source]='Internal' AND I.Severity='Critical' THEN 1 ELSE 0 END) AS [Internal-Critical],            
        SUM(CASE WHEN I.[Source]='Internal' AND I.Severity IN ('Non Critical','Non-Critical') THEN 1 ELSE 0 END) AS [Internal-Non-Critical],            

        SUM(CASE WHEN I.[Source] IN ('ReQC','Re QC','Re-QC') AND I.Severity='Critical' THEN 1 ELSE 0 END) AS [ReQC-Critical],            
        SUM(CASE WHEN I.[Source] IN ('ReQC','Re QC','Re-QC') AND I.Severity IN ('Non Critical','Non-Critical') THEN 1 ELSE 0 END) AS [ReQC-Non-Critical],            

        SUM(CASE WHEN I.[Source] IN ('Internal','ReQC','Re QC','Re-QC') AND I.Severity='Critical' THEN 1 ELSE 0 END) AS TotalCritical,            
        SUM(CASE WHEN I.[Source] IN ('Internal','ReQC','Re QC','Re-QC') AND I.Severity IN ('Non Critical','Non-Critical') THEN 1 ELSE 0 END) AS TotalNonCritical            

    FROM #LoopDates L
        INNER JOIN (SELECT DISTINCT ProjectID,LoanNo,OrderID,DispatchDate FROM dbo.ServicingDetailedFeedbackSelection WHERE BatchID=@BatchID AND UserID=@UserID) S
            ON S.DispatchDate BETWEEN CAST(L.FromDate AS date) AND CAST(L.ToDate AS date)
    INNER JOIN ImportedFeedbacks_Servicing I             
        ON LTRIM(RTRIM(CONVERT(nvarchar(1000),I.[Loan Number])))=LTRIM(RTRIM(S.LoanNo))            
    INNER JOIN Project P             
        ON P.ProjectName = I.Client AND P.ProjectID=S.ProjectID            

    GROUP BY 
        I.Client, L.Week, L.FromDate, I.[Loan Number]            
),

cte AS (            
    SELECT             
        Client,            
        Week,            
        FromDate,            

        COUNT(DISTINCT [Loan Number]) AS [Loan Count],            

        SUM([Internal-Critical]) AS [Internal-Critical],            
        SUM([Internal-Non-Critical]) AS [Internal-Non-Critical],            

        SUM([ReQC-Critical]) AS [ReQC-Critical],            
        SUM([ReQC-Non-Critical]) AS [ReQC-Non-Critical],            

        SUM(TotalCritical) AS TotalCritical,            
        SUM(TotalNonCritical) AS TotalNonCritical,            

        -- ✅ FIXED
        COUNT(CASE WHEN HasError = 0 THEN 1 END) AS NoErrorCount            

    FROM LoanLevelData            
    GROUP BY Client, Week, FromDate            
)

SELECT *,            
    CASE WHEN [Loan Count]=0 THEN 0 ELSE CAST([Internal-Critical]*1.0/[Loan Count] AS DECIMAL(18,2)) END AS [Internal-Critical Per File],            
    CASE WHEN [Loan Count]=0 THEN 0 ELSE CAST([Internal-Non-Critical]*1.0/[Loan Count] AS DECIMAL(18,2)) END AS [Internal-Non-Critical Per File],            
    CASE WHEN [Loan Count]=0 THEN 0 ELSE CAST([ReQC-Critical]*1.0/[Loan Count] AS DECIMAL(18,2)) END AS [ReQC-Critical Per File],            
    CASE WHEN [Loan Count]=0 THEN 0 ELSE CAST([ReQC-Non-Critical]*1.0/[Loan Count] AS DECIMAL(18,2)) END AS [ReQC-Non-Critical Per File],            
    CASE WHEN [Loan Count]=0 THEN 0 ELSE CAST(TotalCritical*1.0/[Loan Count] AS DECIMAL(18,2)) END AS [Total-Critical Per File],          
    CASE WHEN [Loan Count]=0 THEN 0 ELSE CAST(TotalNonCritical*1.0/[Loan Count] AS DECIMAL(18,2)) END AS [Total-Non-Critical Per File],          

    -- ✅ CORRECT PERCENT
    CASE 
        WHEN [Loan Count]=0 THEN 0 
        ELSE CASE 
            WHEN CAST(NoErrorCount*100.0/[Loan Count] AS DECIMAL(18,2)) > 100 THEN 100 
            ELSE CAST(NoErrorCount*100.0/[Loan Count] AS DECIMAL(18,2)) 
        END 
    END AS [% No Error Files]          

INTO #FinalData            
FROM cte;           
            
    --select * from #FinalData            
    -----------------------------------------            
    -- STEP 3: UNPIVOT            
    -----------------------------------------            
    SELECT             
        Client,            
        Week,            
        FromDate,            
     Metric,            
        Value            
    INTO #UnpivotData            
    FROM #FinalData            
    CROSS APPLY (            
        VALUES          
        ('Loan Count', [Loan Count]),            
        ('Internal-Critical', [Internal-Critical]),            
        ('Internal-Non-Critical', [Internal-Non-Critical]),            
        ('ReQC-Critical', [ReQC-Critical]),            
        ('ReQC-Non-Critical', [ReQC-Non-Critical]),            
        ('Total-Critical Per File', [Total-Critical Per File]),            
        ('Total-Non-Critical Per File', [Total-Non-Critical Per File]),            
        ('Internal-Critical Per File', [Internal-Critical Per File]),            
        ('Internal-Non-Critical Per File', [Internal-Non-Critical Per File]),            
        ('ReQC-Critical Per File', [ReQC-Critical Per File]),            
        ('ReQC-Non-Critical Per File', [ReQC-Non-Critical Per File]),            
        ('% No Error Files', [% No Error Files])            
    ) AS U(Metric, Value)            
            
   -- select * from #UnpivotData            
    -----------------------------------------            
    -- STEP 4: Column List (Ordered)            
    -----------------------------------------            
    DECLARE @cols NVARCHAR(MAX),            
            @colsSelect NVARCHAR(MAX)            
            
    SELECT @cols = STUFF((            
        SELECT ',' + QUOTENAME(Week + '-' + Metric)            
        FROM (            
            SELECT DISTINCT             
                Week,            
                Metric,            
                CAST(FromDate AS DATE) AS FromDt,            
                CASE Metric            
                    WHEN 'Loan Count' THEN 1            
                    WHEN 'Internal-Critical' THEN 2            
                    WHEN 'Internal-Non-Critical' THEN 3            
                    WHEN 'Internal-Critical Per File' THEN 4            
                    WHEN 'Internal-Non-Critical Per File' THEN 5            
                    WHEN 'ReQC-Critical' THEN 6            
                    WHEN 'ReQC-Non-Critical' THEN 7            
                    WHEN 'ReQC-Critical Per File' THEN 8            
                    WHEN 'ReQC-Non-Critical Per File' THEN 9            
                    WHEN 'Total-Critical Per File' THEN 10            
                    WHEN 'Total-Non-Critical Per File' THEN 11            
                    WHEN '% No Error Files' THEN 12            
                END AS MetricOrder            
            FROM #UnpivotData            
        ) A            
        ORDER BY FromDt DESC, MetricOrder            
        FOR XML PATH(''), TYPE            
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, '')            
            
            
    -----------------------------------------            
    -- STEP 5: SELECT with ISNULL (0 instead of NULL)            
    -----------------------------------------            
    SELECT @colsSelect = STUFF((            
        SELECT ',' +             
               'ISNULL(' + QUOTENAME(Week + '-' + Metric) + ',0) AS '             
               + QUOTENAME(Week + '-' + Metric)            
        FROM (            
            SELECT DISTINCT             
                Week,            
                Metric,            
                CAST(FromDate AS DATE) AS FromDt,            
                CASE Metric            
                    WHEN 'Loan Count' THEN 1            
                    WHEN 'Internal-Critical' THEN 2            
                    WHEN 'Internal-Non-Critical' THEN 3            
                    WHEN 'Internal-Critical Per File' THEN 4            
                    WHEN 'Internal-Non-Critical Per File' THEN 5            
                    WHEN 'ReQC-Critical' THEN 6            
                    WHEN 'ReQC-Non-Critical' THEN 7      
                    WHEN 'ReQC-Critical Per File' THEN 8            
                    WHEN 'ReQC-Non-Critical Per File' THEN 9            
                    WHEN 'Total-Critical Per File' THEN 10            
                    WHEN 'Total-Non-Critical Per File' THEN 11        
                    WHEN '% No Error Files' THEN 12            
                END AS MetricOrder            
            FROM #UnpivotData            
        ) A            
        ORDER BY FromDt DESC, MetricOrder            
        FOR XML PATH(''), TYPE            
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, '')           
            
            
    -----------------------------------------            
    -- STEP 6: Pivot Execution            
    -----------------------------------------            
    DECLARE @sql NVARCHAR(MAX)            
            
    SET @sql = '            
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS SrNo,Client, ' + @colsSelect + '            
    FROM (            
        SELECT             
            Client,            
            Week + ''-'' + Metric AS ColName,            
            Value            
        FROM #UnpivotData            
    ) src            
    PIVOT (            
        MAX(Value)            
        FOR ColName IN (' + @cols + ')            
    ) p            
    ORDER BY Client            
    '            
    print @sql            
    EXEC(@sql)            
            
            
    -----------------------------------------            
    -- CLEANUP            
    -----------------------------------------            
    DROP TABLE #LoopDates            
    DROP TABLE #FinalData            
    DROP TABLE #UnpivotData            
            
END
GO
IF OBJECT_ID('dbo.usp_ServicingDFR_ReviewerwiseErrorTrending','P') IS NOT NULL DROP PROCEDURE dbo.usp_ServicingDFR_ReviewerwiseErrorTrending;
GO
CREATE PROCEDURE dbo.usp_ServicingDFR_ReviewerwiseErrorTrending @BatchID uniqueidentifier, @UserID int AS        
BEGIN        
    SET NOCOUNT ON;        
        
    -----------------------------------------        
    -- STEP 1: Date Ranges        
    -----------------------------------------        
    CREATE TABLE #LoopDates (        
        loopid INT IDENTITY(1,1) PRIMARY KEY,        
        [Date] NVARCHAR(100),        
        Week NVARCHAR(500),        
        FromDate NVARCHAR(100),        
        ToDate NVARCHAR(100)        
    )        
        
    INSERT INTO #LoopDates        
    EXEC usp_GetMonthQuarterWeekDates_Client_Servicing_Infinity        
        
        
    -----------------------------------------        
    -- STEP 2: Aggregation        
    -----------------------------------------        
    ;WITH cte AS (        
        SELECT         
            I.[UW Name] as Reviewer,        
            L.Week,        
            L.FromDate,        
        
            COUNT(DISTINCT I.[Loan Number]) AS [Loan Count],        
        
            SUM(CASE WHEN [Source]='Internal' AND Severity='Critical' THEN 1 ELSE 0 END) AS [Internal-Critical],        
            SUM(CASE WHEN [Source]='Internal' AND Severity IN ('Non Critical','Non-Critical') THEN 1 ELSE 0 END) AS [Internal-Non-Critical],        
        
            SUM(CASE WHEN [Source] IN ('ReQC','Re QC','Re-QC') AND Severity='Critical' THEN 1 ELSE 0 END) AS [ReQC-Critical],        
            SUM(CASE WHEN [Source] IN ('ReQC','Re QC','Re-QC') AND Severity IN ('Non Critical','Non-Critical') THEN 1 ELSE 0 END) AS [ReQC-Non-Critical],        
        
            SUM(CASE WHEN [Source] IN ('Internal','ReQC','Re QC','Re-QC') AND Severity='Critical' THEN 1 ELSE 0 END) AS TotalCritical,        
            SUM(CASE WHEN [Source] IN ('Internal','ReQC','Re QC','Re-QC') AND Severity IN ('Non Critical','Non-Critical') THEN 1 ELSE 0 END) AS TotalNonCritical,        
        
            SUM(CASE WHEN Severity='No Error' THEN 1 ELSE 0 END) AS NoErrorCount        
        
        FROM #LoopDates L
        INNER JOIN (SELECT DISTINCT ProjectID,LoanNo,OrderID,DispatchDate FROM dbo.ServicingDetailedFeedbackSelection WHERE BatchID=@BatchID AND UserID=@UserID) S
            ON S.DispatchDate BETWEEN CAST(L.FromDate AS date) AND CAST(L.ToDate AS date)        
        INNER JOIN ImportedFeedbacks_Servicing I         
            ON LTRIM(RTRIM(CONVERT(nvarchar(1000),I.[Loan Number])))=LTRIM(RTRIM(S.LoanNo))        
        INNER JOIN Project P         
            ON P.ProjectName = I.Client AND P.ProjectID=S.ProjectID        
        
        GROUP BY I.[UW Name], L.Week, L.FromDate        
    )        
        
    SELECT *,        
        CASE WHEN [Loan Count]=0 THEN 0 ELSE CAST([Internal-Critical]*1.0/[Loan Count] AS DECIMAL(18,2)) END AS [Internal-Critical Per File],        
        CASE WHEN [Loan Count]=0 THEN 0 ELSE CAST([Internal-Non-Critical]*1.0/[Loan Count] AS DECIMAL(18,2)) END AS [Internal-Non-Critical Per File],        
        CASE WHEN [Loan Count]=0 THEN 0 ELSE CAST([ReQC-Critical]*1.0/[Loan Count] AS DECIMAL(18,2)) END AS [ReQC-Critical Per File],        
        CASE WHEN [Loan Count]=0 THEN 0 ELSE CAST([ReQC-Non-Critical]*1.0/[Loan Count] AS DECIMAL(18,2)) END AS [ReQC-Non-Critical Per File],        
        CASE WHEN [Loan Count]=0 THEN 0 ELSE CAST(TotalCritical*1.0/[Loan Count] AS DECIMAL(18,2)) END AS [Total-Critical Per File],        
        CASE WHEN [Loan Count]=0 THEN 0 ELSE CAST(TotalNonCritical*1.0/[Loan Count] AS DECIMAL(18,2)) END AS [Total-Non-Critical Per File],        
        CASE WHEN [Loan Count]=0 THEN 0 ELSE case when CAST(NoErrorCount*100.0/[Loan Count] AS DECIMAL(18,2))>100 then 100 else        
        CAST(NoErrorCount*100.0/[Loan Count] AS DECIMAL(18,2)) end END AS [% No Error Files]        
    INTO #FinalData        
    FROM cte        
        
    --select * from #FinalData        
    -----------------------------------------        
    -- STEP 3: UNPIVOT        
    -----------------------------------------        
    SELECT         
        Reviewer,        
        Week,        
        FromDate,        
        Metric,        
        Value        
    INTO #UnpivotData        
    FROM #FinalData        
    CROSS APPLY (        
        VALUES        
        ('Loan Count', [Loan Count]),        
        ('Internal-Critical', [Internal-Critical]),        
        ('Internal-Non-Critical', [Internal-Non-Critical]),        
        ('ReQC-Critical', [ReQC-Critical]),        
        ('ReQC-Non-Critical', [ReQC-Non-Critical]),        
        ('Total-Critical Per File', [Total-Critical Per File]),        
        ('Total-Non-Critical Per File', [Total-Non-Critical Per File]),        
        ('Internal-Critical Per File', [Internal-Critical Per File]),        
        ('Internal-Non-Critical Per File', [Internal-Non-Critical Per File]),        
        ('ReQC-Critical Per File', [ReQC-Critical Per File]),        
        ('ReQC-Non-Critical Per File', [ReQC-Non-Critical Per File]),        
        ('% No Error Files', [% No Error Files])        
    ) AS U(Metric, Value)        
        
   -- select * from #UnpivotData        
    -----------------------------------------        
    -- STEP 4: Column List (Ordered)        
    -----------------------------------------        
    DECLARE @cols NVARCHAR(MAX),        
            @colsSelect NVARCHAR(MAX)        
        
    SELECT @cols = STUFF((        
        SELECT ',' + QUOTENAME(Week + '-' + Metric)        
        FROM (        
            SELECT DISTINCT         
                Week,        
                Metric,        
                CAST(FromDate AS DATE) AS FromDt,        
                CASE Metric        
                    WHEN 'Loan Count' THEN 1        
                    WHEN 'Internal-Critical' THEN 2        
                    WHEN 'Internal-Non-Critical' THEN 3        
                    WHEN 'Internal-Critical Per File' THEN 4        
                    WHEN 'Internal-Non-Critical Per File' THEN 5        
                    WHEN 'ReQC-Critical' THEN 6        
                    WHEN 'ReQC-Non-Critical' THEN 7        
                    WHEN 'ReQC-Critical Per File' THEN 8        
                    WHEN 'ReQC-Non-Critical Per File' THEN 9        
                    WHEN 'Total-Critical Per File' THEN 10        
                    WHEN 'Total-Non-Critical Per File' THEN 11        
                    WHEN '% No Error Files' THEN 12        
                END AS MetricOrder        
            FROM #UnpivotData        
        ) A        
        ORDER BY FromDt DESC, MetricOrder        
        FOR XML PATH(''), TYPE        
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, '')        
        
        
    -----------------------------------------        
    -- STEP 5: SELECT with ISNULL (0 instead of NULL)        
    -----------------------------------------        
    SELECT @colsSelect = STUFF((        
        SELECT ',' +         
               'ISNULL(' + QUOTENAME(Week + '-' + Metric) + ',0) AS '         
               + QUOTENAME(Week + '-' + Metric)        
        FROM (        
            SELECT DISTINCT         
                Week,        
                Metric,        
                CAST(FromDate AS DATE) AS FromDt,        
                CASE Metric        
                    WHEN 'Loan Count' THEN 1        
                    WHEN 'Internal-Critical' THEN 2        
                    WHEN 'Internal-Non-Critical' THEN 3        
                    WHEN 'Internal-Critical Per File' THEN 4        
                    WHEN 'Internal-Non-Critical Per File' THEN 5        
                    WHEN 'ReQC-Critical' THEN 6        
                    WHEN 'ReQC-Non-Critical' THEN 7        
                    WHEN 'ReQC-Critical Per File' THEN 8        
                    WHEN 'ReQC-Non-Critical Per File' THEN 9        
                    WHEN 'Total-Critical Per File' THEN 10        
                    WHEN 'Total-Non-Critical Per File' THEN 11        
                    WHEN '% No Error Files' THEN 12        
                END AS MetricOrder        
            FROM #UnpivotData        
        ) A        
        ORDER BY FromDt DESC, MetricOrder        
        FOR XML PATH(''), TYPE        
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, '')        
        
        
    -----------------------------------------        
    -- STEP 6: Pivot Execution        
    -----------------------------------------        
    DECLARE @sql NVARCHAR(MAX)        
        
    SET @sql = '        
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS SrNo,Reviewer,         
    cast(E.JoiningDate as date) as DOJ,         
    Datediff(month, cast(E.JoiningDate as date), cast(getdate() as date)) as [Company Tenured],        
    ' + @colsSelect + '        
    FROM (        
        SELECT         
            Reviewer,        
            Week + ''-'' + Metric AS ColName,        
            Value        
        FROM #UnpivotData        
  ) src        
    PIVOT (        
        MAX(Value)        
        FOR ColName IN (' + @cols + ')        
    ) p        
    Left join EmployeeConfiguration EC on EC.Psuedoname=p.Reviewer and EC.EmpConfigrationID=(        
    select top 1 EC1.EmpConfigrationID from EmployeeConfiguration EC1 where EC1.Code=EC.Code and isnull(EC1.IsDelete,0)=0 order by EC1.AddedDate desc)        
    left join EmployeeInfo E on E.Code=EC.Code        
    ORDER BY Reviewer        
    '        
    print @sql      EXEC(@sql)        
        
            
    -----------------------------------------        
    -- CLEANUP        
    -----------------------------------------        
    DROP TABLE #LoopDates        
    DROP TABLE #FinalData        
    DROP TABLE #UnpivotData        
        
END
GO
IF OBJECT_ID('dbo.usp_ServicingDFR_ReviewVsQCCount','P') IS NOT NULL DROP PROCEDURE dbo.usp_ServicingDFR_ReviewVsQCCount;
GO
CREATE PROCEDURE dbo.usp_ServicingDFR_ReviewVsQCCount @BatchID uniqueidentifier, @UserID int AS          
BEGIN          
    SET NOCOUNT ON;          
          
    ----------------------------------------------------------------          
    -- 1️⃣ Precompute week ranges once for each QC Date          
    ----------------------------------------------------------------          
    ;WITH BaseData AS          
    (          
        SELECT           
            F1.[UW Name],          
            F1.[QC Name],          
            F1.[Loan Number],          
            F1.[Feedback Type],          
            F1.[QC Date],          
            F1.[Emp Status],          
            WeekRange =           
                CONVERT(varchar(10), DATEADD(dd, @@DATEFIRST - DATEPART(dw, CAST(F1.[QC Date] AS date)) - 5, CAST(F1.[QC Date] AS date)), 101)          
                + '~-'          
                + CONVERT(varchar(10), DATEADD(dd, @@DATEFIRST - DATEPART(dw, CAST(F1.[QC Date] AS date)) + 1, CAST(F1.[QC Date] AS date)), 101)          
        FROM (SELECT DISTINCT ProjectID,LoanNo FROM dbo.ServicingDetailedFeedbackSelection WHERE BatchID=@BatchID AND UserID=@UserID) S INNER JOIN dbo.ImportedFeedbacks_Servicing F1 ON LTRIM(RTRIM(CONVERT(nvarchar(1000),F1.[Loan Number])))=LTRIM(RTRIM(S.LoanNo))          
        INNER JOIN Project P       
            ON P.ProjectName = F1.Client AND P.ProjectID=S.ProjectID      
        WHERE F1.[Emp Status] = 'Active'          
),          
          
    ----------------------------------------------------------------          
    -- 2️⃣ Compute tenure once          
    ----------------------------------------------------------------          
    TenureData AS          
    (          
        --SELECT           
        --    PJ.Employee AS UWName,          
        --    DATEDIFF(MONTH, CAST(PJ.JoiningDate AS DATE), GETDATE()) AS Tenured          
        --FROM ProcessJoiningDate PJ          
          
        --UNION ALL          
          
        SELECT           
            EC.PsuedoName AS UWName,          
            cast(CAST(EI.JoiningDate AS DATE) as nvarchar(100)) AS Tenured          
        FROM EmployeeInfo EI          
        INNER JOIN EmployeeConfiguration EC           
            ON EI.Code = (          
                SELECT TOP 1 Code           
                FROM EmployeeConfiguration           
                WHERE PsuedoName = EC.PsuedoName           
                ORDER BY AddedDate DESC          
            )          
    ),          
          
    ReviewQC AS          
    (          
        SELECT           
            B.WeekRange AS [Week],          
            B.[UW Name] AS Reviewer,          
            B.[QC Name] AS Qcer,          
            COUNT(Distinct B.[Loan Number]) AS LoanCount,          
            SUM(CASE WHEN B.[Feedback Type] = 'No Error' THEN 0 ELSE 1 END) AS ErrorCount          
        FROM BaseData B          
        GROUP BY B.WeekRange, B.[QC Name], B.[UW Name]          
    ),          
          
    QCWeekSummary AS          
    (          
        SELECT           
            WeekRange,          
            [QC Name],          
            COUNT(Distinct[Loan Number]) AS TotalLoanCount,          
            SUM(CASE WHEN [Feedback Type] = 'No Error' THEN 0 ELSE 1 END) AS TotalErrorCount          
        FROM BaseData          
        GROUP BY WeekRange, [QC Name]          
    ),          
          
    Combined AS          
    (          
        SELECT           
            R.[Week],          
            R.Reviewer,          
            ISNULL(T.Tenured, 0) AS Tenured,          
            ISNULL(T.Tenured, 0) AS Tenured1,          
            R.Qcer,          
            R.LoanCount,          
            Q.TotalLoanCount,          
            CASE WHEN R.LoanCount = 0 THEN 0          
                 ELSE CAST((CAST(R.ErrorCount AS DECIMAL(18,2)) / CAST(R.LoanCount AS DECIMAL(18,2))) AS DECIMAL(18,1))          
            END AS ErrorPerLoan,          
            ISNULL(Q.TotalErrorCount,0) AS TotalErrorCount,          
            ISNULL(Q.TotalLoanCount,0) AS ToDivideTotalLoanCount          
        FROM ReviewQC R       
        LEFT JOIN QCWeekSummary Q           
            ON R.Week = Q.WeekRange AND R.Qcer = Q.[QC Name]          
        LEFT JOIN (          
 SELECT UWName, MAX(Tenured) AS Tenured          
            FROM TenureData          
            GROUP BY UWName          
        ) T          
            ON T.UWName = R.Reviewer          
    )          
       
    ----------------------------------------------------------------          
    -- 3️⃣ Materialize formatted output into a temp table          
    ----------------------------------------------------------------          
    SELECT           
        [Week],          
        Reviewer,          
        Tenured,          
        Tenured1,          
        Qcer,          
        CAST(          
            CAST(LoanCount AS NVARCHAR(50)) + ' (' +           
            CAST(ISNULL(TotalLoanCount,0) AS NVARCHAR(50)) + ') / ' +          
            CAST(ISNULL(ErrorPerLoan,0) AS NVARCHAR(50)) + ' (' +          
            CAST(          
                CASE WHEN ISNULL(ToDivideTotalLoanCount,0) = 0 THEN 0          
                     ELSE CAST((CAST(TotalErrorCount AS DECIMAL(18,2)) / CAST(ToDivideTotalLoanCount AS DECIMAL(18,2))) AS DECIMAL(18,1))          
                END AS NVARCHAR(50)          
            ) + ')'          
            AS NVARCHAR(200)          
        ) AS [ErrorPerLoan]          
    INTO #Formatted          
    FROM Combined          
    WHERE [Week] IS NOT NULL;          
          
    ----------------------------------------------------------------          
    -- 4️⃣ Normalize QC names and store distinct list for pivot columns          
    ----------------------------------------------------------------          
    IF OBJECT_ID('tempdb..#CleanQC') IS NOT NULL DROP TABLE #CleanQC;          
          
    SELECT DISTINCT           
        QCNameClean = UPPER(LTRIM(RTRIM([QC Name])))          
    INTO #CleanQC          
    FROM ImportedFeedbacks          
    WHERE [QC Name] IS NOT NULL      
AND LTRIM(RTRIM([QC Name])) <> ''      
    --WHERE [QC Name] IS NOT NULL;          
          
    ----------------------------------------------------------------          
    -- 5️⃣ Build dynamic column lists from #CleanQC          
    ----------------------------------------------------------------          
    DECLARE @Cols NVARCHAR(MAX), @ColsAvg NVARCHAR(MAX), @Qry NVARCHAR(MAX);          
          
    SELECT           
        @Cols = STUFF((          
            SELECT ',' + QUOTENAME(QCNameClean)          
            FROM #CleanQC          
            ORDER BY QCNameClean          
            FOR XML PATH(''), TYPE          
        ).value('.', 'NVARCHAR(MAX)'), 1, 1, '');          
          
    SELECT           
        @ColsAvg = STUFF((          
            SELECT ',' + QUOTENAME(QCNameClean) + ' AS ' + QUOTENAME(QCNameClean + ' (Count / Error)')          
            FROM #CleanQC          
            ORDER BY QCNameClean          
            FOR XML PATH(''), TYPE          
        ).value('.', 'NVARCHAR(MAX)'), 1, 1, '');          
          
    ----------------------------------------------------------------          
    -- 6️⃣ Final dynamic pivot query          
    ----------------------------------------------------------------          
    SET @Qry = N'          
        SELECT [Week], Reviewer,          
               Tenured AS [DOJ],          
               Tenured1 AS [Company Tenured],          
               ' + @ColsAvg + '          
        FROM (          
            SELECT           
                Reviewer,           
                [Week],           
                Tenured,           
                Tenured1,           
                UPPER(LTRIM(RTRIM(Qcer))) AS Qcer,           
                [ErrorPerLoan]          
            FROM #Formatted          
        ) AS src          
        PIVOT (          
            MAX([ErrorPerLoan]) FOR Qcer IN (' + @Cols + ')          
        ) pvt          
        ORDER BY           
            CAST(LEFT([Week], CHARINDEX(''~'', [Week]) - 1) AS DATE) DESC,          
            Reviewer;';          
          
    EXEC sp_executesql @Qry;          
          
    ----------------------------------------------------------------          
    -- 7️⃣ Cleanup          
    ----------------------------------------------------------------         
    IF OBJECT_ID('tempdb..#Formatted') IS NOT NULL DROP TABLE #Formatted;          
    IF OBJECT_ID('tempdb..#CleanQC') IS NOT NULL DROP TABLE #CleanQC;          
          
END;
GO
IF OBJECT_ID('dbo.usp_ServicingDFR_NoErrorAnalysis','P') IS NOT NULL DROP PROCEDURE dbo.usp_ServicingDFR_NoErrorAnalysis;
GO
CREATE PROCEDURE dbo.usp_ServicingDFR_NoErrorAnalysis @BatchID uniqueidentifier, @UserID int AS      
begin      
select [QC Name] as [QCer], count(distinct [Loan Number]) as [Loan QCed],       
sum(case when [Feedback Type]='No Error' then 1 else 0 end) as [No Error Files],      
Floor((sum(case when [Feedback Type]='No Error' then 1 else 0 end) /     
cast(count(distinct [Loan Number]) as decimal(18,2))) * 100) as [No Error %]      
FROM (SELECT DISTINCT ProjectID,LoanNo FROM dbo.ServicingDetailedFeedbackSelection WHERE BatchID=@BatchID AND UserID=@UserID) S INNER JOIN dbo.ImportedFeedbacks_Servicing F1 ON LTRIM(RTRIM(CONVERT(nvarchar(1000),F1.[Loan Number])))=LTRIM(RTRIM(S.LoanNo))        
INNER JOIN Project P     
ON P.ProjectName = F1.Client AND P.ProjectID=S.ProjectID    
and len([QC Name])>1    
group by [QC Name]      
end
GO
IF OBJECT_ID('dbo.usp_ServicingDFR_ReviewerClientError','P') IS NOT NULL DROP PROCEDURE dbo.usp_ServicingDFR_ReviewerClientError;
GO
CREATE PROCEDURE dbo.usp_ServicingDFR_ReviewerClientError @BatchID uniqueidentifier, @UserID int AS            
BEGIN            
    SET NOCOUNT ON;            
            
    -----------------------------------------            
    -- STEP 1: Date Ranges            
    -----------------------------------------            
    CREATE TABLE #LoopDates (            
        loopid INT IDENTITY(1,1) PRIMARY KEY,            
        [Date] NVARCHAR(100),            
        Week NVARCHAR(500),            
        FromDate NVARCHAR(100),            
        ToDate NVARCHAR(100)            
    )            
            
    INSERT INTO #LoopDates            
    EXEC usp_GetMonthQuarterWeekDates_Client_Servicing_Infinity            
            
            
    -----------------------------------------            
    -- STEP 2: Aggregation            
    -----------------------------------------            
    ;WITH cte AS (            
        SELECT             
            I.[UW Name] as Reviewer,          
            I.Client,            
            L.Week,            
            L.FromDate,            
            
            COUNT(DISTINCT I.[Loan Number]) AS [Loan Count],            
            
            SUM(CASE WHEN [Source]='Internal' AND Severity='Critical' THEN 1 ELSE 0 END) AS [Internal-Critical],            
            SUM(CASE WHEN [Source]='Internal' AND Severity IN ('Non Critical','Non-Critical') THEN 1 ELSE 0 END) AS [Internal-Non-Critical],            
            
            SUM(CASE WHEN [Source] IN ('ReQC','Re QC','Re-QC') AND Severity='Critical' THEN 1 ELSE 0 END) AS [ReQC-Critical],            
            SUM(CASE WHEN [Source] IN ('ReQC','Re QC','Re-QC') AND Severity IN ('Non Critical','Non-Critical') THEN 1 ELSE 0 END) AS [ReQC-Non-Critical],            
            
            SUM(CASE WHEN [Source] IN ('Internal','ReQC','Re QC','Re-QC') AND Severity='Critical' THEN 1 ELSE 0 END) AS TotalCritical,            
            SUM(CASE WHEN [Source] IN ('Internal','ReQC','Re QC','Re-QC') AND Severity IN ('Non Critical','Non-Critical') THEN 1 ELSE 0 END) AS TotalNonCritical,            
            
            SUM(CASE WHEN Severity='No Error' THEN 1 ELSE 0 END) AS NoErrorCount            
            
        FROM #LoopDates L
        INNER JOIN (SELECT DISTINCT ProjectID,LoanNo,OrderID,DispatchDate FROM dbo.ServicingDetailedFeedbackSelection WHERE BatchID=@BatchID AND UserID=@UserID) S
            ON S.DispatchDate BETWEEN CAST(L.FromDate AS date) AND CAST(L.ToDate AS date)            
        INNER JOIN ImportedFeedbacks_Servicing I             
            ON LTRIM(RTRIM(CONVERT(nvarchar(1000),I.[Loan Number])))=LTRIM(RTRIM(S.LoanNo))            
        INNER JOIN Project P             
            ON P.ProjectName = I.Client AND P.ProjectID=S.ProjectID            
            
        GROUP BY I.[UW Name], I.Client, L.Week, L.FromDate            
    )            
            
    SELECT *,            
        CASE WHEN [Loan Count]=0 THEN 0 ELSE CAST([Internal-Critical]*1.0/[Loan Count] AS DECIMAL(18,2)) END AS [Internal-Critical Per File],            
        CASE WHEN [Loan Count]=0 THEN 0 ELSE CAST([Internal-Non-Critical]*1.0/[Loan Count] AS DECIMAL(18,2)) END AS [Internal-Non-Critical Per File],            
        CASE WHEN [Loan Count]=0 THEN 0 ELSE CAST([ReQC-Critical]*1.0/[Loan Count] AS DECIMAL(18,2)) END AS [ReQC-Critical Per File],            
        CASE WHEN [Loan Count]=0 THEN 0 ELSE CAST([ReQC-Non-Critical]*1.0/[Loan Count] AS DECIMAL(18,2)) END AS [ReQC-Non-Critical Per File],            
        CASE WHEN [Loan Count]=0 THEN 0 ELSE CAST(TotalCritical*1.0/[Loan Count] AS DECIMAL(18,2)) END AS [Total-Critical Per File],          
        CASE WHEN [Loan Count]=0 THEN 0 ELSE CAST(TotalNonCritical*1.0/[Loan Count] AS DECIMAL(18,2)) END AS [Total-Non-Critical Per File],          
        CASE WHEN [Loan Count]=0 THEN 0 ELSE case when CAST(NoErrorCount*100.0/[Loan Count] AS DECIMAL(18,2))>100 then 100 else          
        CAST(NoErrorCount*100.0/[Loan Count] AS DECIMAL(18,2)) end END AS [% No Error Files]          
    INTO #FinalData            
    FROM cte            
            
    --select * from #FinalData            
    -----------------------------------------            
    -- STEP 3: UNPIVOT            
    -----------------------------------------            
    SELECT             
        Reviewer,          
        Client,            
        Week,            
        FromDate,            
        Metric,            
        Value            
    INTO #UnpivotData            
    FROM #FinalData            
    CROSS APPLY (            
        VALUES            
        ('Loan Count', [Loan Count]),            
        ('Internal-Critical', [Internal-Critical]),            
        ('Internal-Non-Critical', [Internal-Non-Critical]),            
        ('ReQC-Critical', [ReQC-Critical]),            
        ('ReQC-Non-Critical', [ReQC-Non-Critical]),            
        ('Total-Critical Per File', [Total-Critical Per File]),            
        ('Total-Non-Critical Per File', [Total-Non-Critical Per File]),            
        ('Internal-Critical Per File', [Internal-Critical Per File]),            
        ('Internal-Non-Critical Per File', [Internal-Non-Critical Per File]),            
        ('ReQC-Critical Per File', [ReQC-Critical Per File]),            
        ('ReQC-Non-Critical Per File', [ReQC-Non-Critical Per File]),            
        ('% No Error Files', [% No Error Files])            
    ) AS U(Metric, Value)            
            
   -- select * from #UnpivotData            
    -----------------------------------------            
    -- STEP 4: Column List (Ordered)            
    -----------------------------------------            
    DECLARE @cols NVARCHAR(MAX),            
            @colsSelect NVARCHAR(MAX)            
            
    SELECT @cols = STUFF((            
        SELECT ',' + QUOTENAME(Week + '-' + Metric)            
        FROM (            
            SELECT DISTINCT             
                Week,            
                Metric,            
                CAST(FromDate AS DATE) AS FromDt,            
                CASE Metric            
                    WHEN 'Loan Count' THEN 1            
                    WHEN 'Internal-Critical' THEN 2            
                    WHEN 'Internal-Non-Critical' THEN 3            
                    WHEN 'Internal-Critical Per File' THEN 4            
                    WHEN 'Internal-Non-Critical Per File' THEN 5            
                    WHEN 'ReQC-Critical' THEN 6            
                    WHEN 'ReQC-Non-Critical' THEN 7            
                    WHEN 'ReQC-Critical Per File' THEN 8            
                    WHEN 'ReQC-Non-Critical Per File' THEN 9            
                    WHEN 'Total-Critical Per File' THEN 10            
                    WHEN 'Total-Non-Critical Per File' THEN 11            
                    WHEN '% No Error Files' THEN 12            
                END AS MetricOrder            
            FROM #UnpivotData            
        ) A            
        ORDER BY FromDt DESC, MetricOrder            
        FOR XML PATH(''), TYPE            
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, '')            
            
            
    -----------------------------------------            
    -- STEP 5: SELECT with ISNULL (0 instead of NULL)            
    -----------------------------------------            
    SELECT @colsSelect = STUFF((            
        SELECT ',' +             
               'ISNULL(' + QUOTENAME(Week + '-' + Metric) + ',0) AS '             
               + QUOTENAME(Week + '-' + Metric)            
        FROM (            
            SELECT DISTINCT             
                Week,            
                Metric,            
                CAST(FromDate AS DATE) AS FromDt,            
                CASE Metric            
                    WHEN 'Loan Count' THEN 1            
                    WHEN 'Internal-Critical' THEN 2            
                    WHEN 'Internal-Non-Critical' THEN 3            
                    WHEN 'Internal-Critical Per File' THEN 4            
                    WHEN 'Internal-Non-Critical Per File' THEN 5            
                    WHEN 'ReQC-Critical' THEN 6            
                    WHEN 'ReQC-Non-Critical' THEN 7            
                    WHEN 'ReQC-Critical Per File' THEN 8            
                    WHEN 'ReQC-Non-Critical Per File' THEN 9            
                    WHEN 'Total-Critical Per File' THEN 10            
                   WHEN 'Total-Non-Critical Per File' THEN 11            
                    WHEN '% No Error Files' THEN 12            
                END AS MetricOrder            
            FROM #UnpivotData            
        ) A            
        ORDER BY FromDt DESC, MetricOrder            
 FOR XML PATH(''), TYPE            
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, '')            
            
            
    -----------------------------------------            
    -- STEP 6: Pivot Execution            
    -----------------------------------------            
    DECLARE @sql NVARCHAR(MAX)            
            
    SET @sql = '            
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS SrNo,Reviewer,p.Client,      
    cast(E.JoiningDate as date) as DOJ,  
    Datediff(month, cast(E.JoiningDate as date), cast(getdate() as date)) as [Company Tenured],           
    ' + @colsSelect + '            
    FROM (            
        SELECT             
            Reviewer,          
            Client,            
            Week + ''-'' + Metric AS ColName,            
            Value            
        FROM #UnpivotData            
    ) src            
    PIVOT (            
        MAX(Value)            
        FOR ColName IN (' + @cols + ')            
    ) p            
     Left join EmployeeConfiguration EC on EC.Psuedoname=p.Reviewer and EC.EmpConfigrationID=(            
    select top 1 EC1.EmpConfigrationID from EmployeeConfiguration EC1 where EC1.Code=EC.Code and isnull(EC1.IsDelete,0)=0 order by EC1.AddedDate desc)            
    left join EmployeeInfo E on E.Code=EC.Code          
    left join ImportedFeedbacks F1 on F1.[UW Name]=p.Reviewer and F1.Client=p.Client and F1.FeedbackID=(          
    select top 1 F2.FeedbackID from ImportedFeedbacks F2 where F2.[UW Name]=F1.[UW Name] and F2.Client=F1.Client order by cast([QC Date] as date))          
    ORDER BY Reviewer,Client            
    '            
    print @sql            
    EXEC(@sql)            
            
            
    -----------------------------------------            
    -- CLEANUP            
    -----------------------------------------            
    DROP TABLE #LoopDates            
    DROP TABLE #FinalData            
    DROP TABLE #UnpivotData            
            
END
GO
IF OBJECT_ID('dbo.usp_ServicingDFR_ReviewerQCClientError','P') IS NOT NULL DROP PROCEDURE dbo.usp_ServicingDFR_ReviewerQCClientError;
GO
CREATE PROCEDURE dbo.usp_ServicingDFR_ReviewerQCClientError @BatchID uniqueidentifier, @UserID int AS        
BEGIN        
    SET NOCOUNT ON;        
        
    -----------------------------------------        
    -- STEP 1: Date Ranges        
    -----------------------------------------        
    CREATE TABLE #LoopDates (        
        loopid INT IDENTITY(1,1) PRIMARY KEY,        
        [Date] NVARCHAR(100),        
        Week NVARCHAR(500),        
        FromDate NVARCHAR(100),        
        ToDate NVARCHAR(100)        
    )        
        
    INSERT INTO #LoopDates        
    EXEC usp_GetMonthQuarterWeekDates_Client_Servicing_Infinity  
        
        
    -----------------------------------------        
    -- STEP 2: Aggregation        
    -----------------------------------------        
    ;WITH cte AS (        
        SELECT         
            I.[UW Name] as Reviewer,      
            I.[QC Name] as QCer,      
            I.Client,        
            L.Week,        
            L.FromDate,        
        
            COUNT(DISTINCT I.[Loan Number]) AS [Loan Count],        
        
            SUM(CASE WHEN [Source]='Internal' AND Severity='Critical' THEN 1 ELSE 0 END) AS [Internal-Critical],        
            SUM(CASE WHEN [Source]='Internal' AND Severity IN ('Non Critical','Non-Critical') THEN 1 ELSE 0 END) AS [Internal-Non-Critical],        
        
            SUM(CASE WHEN [Source] IN ('ReQC','Re QC','Re-QC') AND Severity='Critical' THEN 1 ELSE 0 END) AS [ReQC-Critical],        
            SUM(CASE WHEN [Source] IN ('ReQC','Re QC','Re-QC') AND Severity IN ('Non Critical','Non-Critical') THEN 1 ELSE 0 END) AS [ReQC-Non-Critical],        
        
            SUM(CASE WHEN [Source] IN ('Internal','ReQC','Re QC','Re-QC') AND Severity='Critical' THEN 1 ELSE 0 END) AS TotalCritical,        
            SUM(CASE WHEN [Source] IN ('Internal','ReQC','Re QC','Re-QC') AND Severity IN ('Non Critical','Non-Critical') THEN 1 ELSE 0 END) AS TotalNonCritical,        
        
            SUM(CASE WHEN Severity='No Error' THEN 1 ELSE 0 END) AS NoErrorCount        
        
        FROM #LoopDates L
        INNER JOIN (SELECT DISTINCT ProjectID,LoanNo,OrderID,DispatchDate FROM dbo.ServicingDetailedFeedbackSelection WHERE BatchID=@BatchID AND UserID=@UserID) S
            ON S.DispatchDate BETWEEN CAST(L.FromDate AS date) AND CAST(L.ToDate AS date)        
        INNER JOIN ImportedFeedbacks_Servicing I         
            ON LTRIM(RTRIM(CONVERT(nvarchar(1000),I.[Loan Number])))=LTRIM(RTRIM(S.LoanNo))        
        INNER JOIN Project P         
            ON P.ProjectName = I.Client AND P.ProjectID=S.ProjectID        
          
        
        GROUP BY I.[UW Name], I.[QC Name], I.Client, L.Week, L.FromDate        
    )        
        
    SELECT *,        
        CASE WHEN [Loan Count]=0 THEN 0 ELSE CAST([Internal-Critical]*1.0/[Loan Count] AS DECIMAL(18,2)) END AS [Internal-Critical Per File],        
        CASE WHEN [Loan Count]=0 THEN 0 ELSE CAST([Internal-Non-Critical]*1.0/[Loan Count] AS DECIMAL(18,2)) END AS [Internal-Non-Critical Per File],        
        CASE WHEN [Loan Count]=0 THEN 0 ELSE CAST([ReQC-Critical]*1.0/[Loan Count] AS DECIMAL(18,2)) END AS [ReQC-Critical Per File],        
        CASE WHEN [Loan Count]=0 THEN 0 ELSE CAST([ReQC-Non-Critical]*1.0/[Loan Count] AS DECIMAL(18,2)) END AS [ReQC-Non-Critical Per File],        
        CASE WHEN [Loan Count]=0 THEN 0 ELSE CAST(TotalCritical*1.0/[Loan Count] AS DECIMAL(18,2)) END AS [Total-Critical Per File],      
        CASE WHEN [Loan Count]=0 THEN 0 ELSE CAST(TotalNonCritical*1.0/[Loan Count] AS DECIMAL(18,2)) END AS [Total-Non-Critical Per File],      
        CASE WHEN [Loan Count]=0 THEN 0 ELSE case when CAST(NoErrorCount*100.0/[Loan Count] AS DECIMAL(18,2))>100 then 100 else      
        CAST(NoErrorCount*100.0/[Loan Count] AS DECIMAL(18,2)) end END AS [% No Error Files]      
    INTO #FinalData        
    FROM cte        
        
    --select * from #FinalData        
    -----------------------------------------        
    -- STEP 3: UNPIVOT        
    -----------------------------------------        
    SELECT         
        Reviewer,      
        QCer,      
        Client,        
        Week,        
        FromDate,        
  Metric,        
        Value        
    INTO #UnpivotData        
    FROM #FinalData        
    CROSS APPLY (        
        VALUES        
  ('Loan Count', [Loan Count]),        
        ('Internal-Critical', [Internal-Critical]),        
        ('Internal-Non-Critical', [Internal-Non-Critical]),        
        ('ReQC-Critical', [ReQC-Critical]),        
        ('ReQC-Non-Critical', [ReQC-Non-Critical]),        
        ('Total-Critical Per File', [Total-Critical Per File]),        
        ('Total-Non-Critical Per File', [Total-Non-Critical Per File]),        
        ('Internal-Critical Per File', [Internal-Critical Per File]),        
        ('Internal-Non-Critical Per File', [Internal-Non-Critical Per File]),        
        ('ReQC-Critical Per File', [ReQC-Critical Per File]),        
        ('ReQC-Non-Critical Per File', [ReQC-Non-Critical Per File]),        
        ('% No Error Files', [% No Error Files])        
    ) AS U(Metric, Value)        
        
   -- select * from #UnpivotData        
    -----------------------------------------        
    -- STEP 4: Column List (Ordered)        
    -----------------------------------------        
    DECLARE @cols NVARCHAR(MAX),        
            @colsSelect NVARCHAR(MAX)        
        
    SELECT @cols = STUFF((        
        SELECT ',' + QUOTENAME(Week + '-' + Metric)        
        FROM (        
            SELECT DISTINCT         
                Week,        
                Metric,        
                CAST(FromDate AS DATE) AS FromDt,        
                CASE Metric        
                    WHEN 'Loan Count' THEN 1        
                    WHEN 'Internal-Critical' THEN 2        
                    WHEN 'Internal-Non-Critical' THEN 3        
                    WHEN 'Internal-Critical Per File' THEN 4        
                    WHEN 'Internal-Non-Critical Per File' THEN 5        
                    WHEN 'ReQC-Critical' THEN 6        
                    WHEN 'ReQC-Non-Critical' THEN 7        
                    WHEN 'ReQC-Critical Per File' THEN 8        
                    WHEN 'ReQC-Non-Critical Per File' THEN 9        
                    WHEN 'Total-Critical Per File' THEN 10        
                    WHEN 'Total-Non-Critical Per File' THEN 11        
                    WHEN '% No Error Files' THEN 12        
                END AS MetricOrder        
            FROM #UnpivotData        
        ) A        
        ORDER BY FromDt DESC, MetricOrder        
        FOR XML PATH(''), TYPE        
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, '')        
        
        
    -----------------------------------------        
    -- STEP 5: SELECT with ISNULL (0 instead of NULL)        
    -----------------------------------------        
    SELECT @colsSelect = STUFF((        
        SELECT ',' +         
               'ISNULL(' + QUOTENAME(Week + '-' + Metric) + ',0) AS '         
               + QUOTENAME(Week + '-' + Metric)        
        FROM (        
            SELECT DISTINCT         
                Week,        
                Metric,        
                CAST(FromDate AS DATE) AS FromDt,        
                CASE Metric        
                    WHEN 'Loan Count' THEN 1        
                    WHEN 'Internal-Critical' THEN 2        
                    WHEN 'Internal-Non-Critical' THEN 3        
                    WHEN 'Internal-Critical Per File' THEN 4        
                    WHEN 'Internal-Non-Critical Per File' THEN 5        
                    WHEN 'ReQC-Critical' THEN 6        
                    WHEN 'ReQC-Non-Critical' THEN 7        
                    WHEN 'ReQC-Critical Per File' THEN 8        
                    WHEN 'ReQC-Non-Critical Per File' THEN 9        
                    WHEN 'Total-Critical Per File' THEN 10        
                    WHEN 'Total-Non-Critical Per File' THEN 11        
                    WHEN '% No Error Files' THEN 12        
                END AS MetricOrder        
            FROM #UnpivotData        
        ) A        
     ORDER BY FromDt DESC, MetricOrder        
        FOR XML PATH(''), TYPE        
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, '')        
        
        
    -----------------------------------------        
    -- STEP 6: Pivot Execution        
    -----------------------------------------        
    DECLARE @sql NVARCHAR(MAX)        
        
    SET @sql = '        
    SELECT Reviewer,QCer,p.Client,       
    cast(E.JoiningDate as date) as DOJ,       
    Datediff(month, cast(E.JoiningDate as date), cast(getdate() as date)) as [Company Tenured],       
    ' + @colsSelect + '        
    FROM (        
        SELECT         
            Reviewer,      
            QCer,       
            Client,        
            Week + ''-'' + Metric AS ColName,        
            Value        
        FROM #UnpivotData        
    ) src        
    PIVOT (        
        MAX(Value)        
        FOR ColName IN (' + @cols + ')        
    ) p        
     Left join EmployeeConfiguration EC on EC.Psuedoname=p.Reviewer and EC.EmpConfigrationID=(        
    select top 1 EC1.EmpConfigrationID from EmployeeConfiguration EC1 where EC1.Code=EC.Code and isnull(EC1.IsDelete,0)=0 order by EC1.AddedDate desc)        
    left join EmployeeInfo E on E.Code=EC.Code      
    left join ImportedFeedbacks F1 on F1.[UW Name]=p.Reviewer and F1.Client=p.Client and F1.FeedbackID=(      
    select top 1 F2.FeedbackID from ImportedFeedbacks F2 where F2.[UW Name]=F1.[UW Name] and F2.Client=F1.Client order by cast([QC Date] as date))      
    ORDER BY Reviewer, QCer,Client        
    '        
    print @sql        
    EXEC(@sql)        
        
        
    -----------------------------------------        
    -- CLEANUP        
    -----------------------------------------        
    DROP TABLE #LoopDates        
    DROP TABLE #FinalData        
    DROP TABLE #UnpivotData        
        
END
GO
IF OBJECT_ID('dbo.usp_ServicingDFR_QCerPerformance','P') IS NOT NULL DROP PROCEDURE dbo.usp_ServicingDFR_QCerPerformance;
GO
CREATE PROCEDURE dbo.usp_ServicingDFR_QCerPerformance @BatchID uniqueidentifier, @UserID int AS              
BEGIN              
    SET NOCOUNT ON;              
              
    -----------------------------------------              
    -- STEP 1: Date Ranges              
    -----------------------------------------              
    CREATE TABLE #LoopDates (              
        loopid INT IDENTITY(1,1) PRIMARY KEY,              
        [Date] NVARCHAR(100),              
        Week NVARCHAR(500),              
        FromDate NVARCHAR(100),              
        ToDate NVARCHAR(100)              
    )              
              
    INSERT INTO #LoopDates              
    EXEC usp_GetMonthQuarterWeekDates_Client_Servicing_Infinity    
              
              
    -----------------------------------------              
    -- STEP 2: Aggregation              
    -----------------------------------------              
    ;WITH cte AS (              
        SELECT               
            I.[QC Name] as QCer,            
            L.Week,              
            L.FromDate,              
              
            COUNT(DISTINCT I.[Loan Number]) AS [File Qced],              
              
            SUM(CASE WHEN Severity not in ('No Error') THEN 1 ELSE 0 END) AS [Errors Found],              
            SUM(CASE WHEN [Feedback Type]='Incorrect feedback' THEN 1 ELSE 0 END) AS [Incorrect Errors],              
              
            SUM(CASE WHEN [Source] IN ('ReQC','Re QC','Re-QC') AND Severity='Critical' THEN 1 ELSE 0 END) AS [ReQC Critical Errors],              
            SUM(CASE WHEN [Source] IN ('ReQC','Re QC','Re-QC') AND Severity IN ('Non Critical','Non-Critical') THEN 1 ELSE 0 END) AS [ReQC Non-Critical Errors],              
            
            SUM(CASE WHEN [Source] IN ('Client') AND Severity='Critical' THEN 1 ELSE 0 END) AS [Client Critical Errors],              
            SUM(CASE WHEN [Source] IN ('Client') AND Severity IN ('Non Critical','Non-Critical') THEN 1 ELSE 0 END) AS [Client Non-Critical Errors],              
              
            SUM(CASE WHEN [Source] IN ('Client','ReQC','Re QC','Re-QC') AND Severity='Critical' THEN 1 ELSE 0 END) AS [Total Critical Errors],              
            SUM(CASE WHEN [Source] IN ('Client','ReQC','Re QC','Re-QC') AND Severity IN ('Non Critical','Non-Critical') THEN 1 ELSE 0 END) AS [Total Non-Critical Errors],              
              
            SUM(CASE WHEN Severity='No Error' THEN 1 ELSE 0 END) AS NoErrorCount              
              
        FROM #LoopDates L
        INNER JOIN (SELECT DISTINCT ProjectID,LoanNo,OrderID,DispatchDate FROM dbo.ServicingDetailedFeedbackSelection WHERE BatchID=@BatchID AND UserID=@UserID) S
            ON S.DispatchDate BETWEEN CAST(L.FromDate AS date) AND CAST(L.ToDate AS date)              
        INNER JOIN ImportedFeedbacks_Servicing I               
            ON LTRIM(RTRIM(CONVERT(nvarchar(1000),I.[Loan Number])))=LTRIM(RTRIM(S.LoanNo))              
        INNER JOIN Project P               
            ON P.ProjectName = I.Client AND P.ProjectID=S.ProjectID              
        WHERE Len([QC Name])>1   --and [Source] in ('Client','ReQC','Re-QC')      -- and [UW Name]='Nicole Sullivan'  
              
        GROUP BY I.[QC Name], L.Week, L.FromDate              
    ),
    cteloans as (
    SELECT               
            I.[QC Name] as QCer,            
            L.Week,              
            L.FromDate,              
            I.[Loan Number]          
        FROM #LoopDates L
        INNER JOIN (SELECT DISTINCT ProjectID,LoanNo,OrderID,DispatchDate FROM dbo.ServicingDetailedFeedbackSelection WHERE BatchID=@BatchID AND UserID=@UserID) S
            ON S.DispatchDate BETWEEN CAST(L.FromDate AS date) AND CAST(L.ToDate AS date)              
        INNER JOIN ImportedFeedbacks_Servicing I               
            ON LTRIM(RTRIM(CONVERT(nvarchar(1000),I.[Loan Number])))=LTRIM(RTRIM(S.LoanNo))              
        INNER JOIN Project P               
            ON P.ProjectName = I.Client AND P.ProjectID=S.ProjectID              
        WHERE Len([QC Name])>1   and [Source] in ('Internal')      -- and [UW Name]='Nicole Sullivan'  
    ),
    cteUW as
    (
        SELECT               
            I.[UW Name] as QCer,            
            L.Week,              
            L.FromDate,              
              
            COUNT(DISTINCT I.[Loan Number]) AS [File Qced],              
              
           isnull(SUM(CASE WHEN Severity not in ('No Error') THEN 1 ELSE 0 END),0) AS [Errors Found],              
            isnull(SUM(CASE WHEN [Feedback Type]='Incorrect feedback' THEN 1 ELSE 0 END),0) AS [Incorrect Errors],              
              
            isnull(SUM(CASE WHEN [Source] IN ('ReQC','Re QC','Re-QC') AND Severity='Critical' THEN 1 ELSE 0 END),0) AS [ReQC Critical Errors],              
            isnull(SUM(CASE WHEN [Source] IN ('ReQC','Re QC','Re-QC') AND Severity IN ('Non Critical','Non-Critical') THEN 1 ELSE 0 END),0) AS [ReQC Non-Critical Errors],              
            
            isnull(SUM(CASE WHEN [Source] IN ('Client') AND Severity='Critical' THEN 1 ELSE 0 END),0) AS [Client Critical Errors],              
            isnull(SUM(CASE WHEN [Source] IN ('Client') AND Severity IN ('Non Critical','Non-Critical') THEN 1 ELSE 0 END),0) AS [Client Non-Critical Errors],              
              
            isnull(SUM(CASE WHEN [Source] IN ('Client','ReQC','Re QC','Re-QC') AND Severity='Critical' THEN 1 ELSE 0 END),0) AS [Total Critical Errors],              
            isnull(SUM(CASE WHEN [Source] IN ('Client','ReQC','Re QC','Re-QC') AND Severity IN ('Non Critical','Non-Critical') THEN 1 ELSE 0 END),0) AS [Total Non-Critical Errors],              
              
            isnull(SUM(CASE WHEN Severity='No Error' THEN 1 ELSE 0 END),0) AS NoErrorCount              
              
        FROM #LoopDates L
        INNER JOIN (SELECT DISTINCT ProjectID,LoanNo,OrderID,DispatchDate FROM dbo.ServicingDetailedFeedbackSelection WHERE BatchID=@BatchID AND UserID=@UserID) S
            ON S.DispatchDate BETWEEN CAST(L.FromDate AS date) AND CAST(L.ToDate AS date)              
        INNER JOIN ImportedFeedbacks_Servicing I               
            ON LTRIM(RTRIM(CONVERT(nvarchar(1000),I.[Loan Number])))=LTRIM(RTRIM(S.LoanNo))              
        INNER JOIN Project P               
            ON P.ProjectName = I.Client AND P.ProjectID=S.ProjectID              
        WHERE Len([UW Name])>1   and [Source] in ('Client','ReQC','Re-QC')      -- and [UW Name]='Nicole Sullivan'  
              and I.[Loan Number] in (select C1.[Loan Number] from cteloans C1 where C1.QCer=I.[UW Name])
        GROUP BY I.[UW Name], L.Week, L.FromDate              
    )
           
    SELECT C.QCer, C.Week, C.FromDate, C.[File Qced], C.[Errors Found],              
        CASE WHEN C.[File Qced]=0 THEN 0 ELSE CAST(C.[Errors Found]*1.0/C.[File Qced] AS DECIMAL(18,2)) END AS [Error Finding Rate],            
        C.[Incorrect Errors], isnull(U.[ReQC Critical Errors],0) as [ReQC Critical Errors], isnull(U.[ReQC Non-Critical Errors],0) as [ReQC Non-Critical Errors], 
        isnull(U.[Client Critical Errors],0) as [Client Critical Errors], isnull(U.[Client Non-Critical Errors],0) as [Client Non-Critical Errors],            
        isnull(U.[Total Critical Errors],0) as [Total Critical Errors], isnull(U.[Total Non-Critical Errors],0) as [Total Non-Critical Errors],              
        CASE WHEN C.[File Qced]=0 THEN 0 ELSE 
        CAST(
        cast(((isnull(C.[Incorrect Errors],0)+isnull(U.[Total Critical Errors],0)+ isnull(U.[Total Non-Critical Errors],0))) as decimal(18,2))
        /cast(C.[File Qced] as decimal(18,2)) AS DECIMAL(18,2)) END AS [Error/Loan]            
    INTO #FinalData              
    FROM cte C left join cteUW U on U.QCer=C.QCer and U.Week=C.Week     
   -- where C.QCer='ALICIA FERACHO'
              
        --      SELECT               
        --    I.[QC Name] as QCer,            
        --    L.Week,              
        --    L.FromDate,              
        --    I.[Loan Number]          
        --FROM #LoopDates L
        --INNER JOIN ImportedFeedbacks_Servicing I               
        --    ON CAST(I.[QC Date] AS DATE)               
        --       BETWEEN CAST(L.FromDate AS DATE) AND CAST(L.ToDate AS DATE)              
        --INNER JOIN Project P               
        --    ON P.ProjectName = I.Client              
        --WHERE Len([QC Name])>1   and [Source] in ('Internal') 
        --and dbo.ToProperCase([QC Name])=dbo.ToProperCase('Peter Donaldson')
        --and [Loan Number]='167953'
    --select * from ImportedFeedbacks_Servicing where [Loan Number]='145934'
    --select * from #FinalData              
    -----------------------------------------              
    -- STEP 3: UNPIVOT              
    -----------------------------------------              
    SELECT               
        QCer,            
        Week,         
        FromDate,              
        Metric,              
        Value              
    INTO #UnpivotData              
    FROM #FinalData              
    CROSS APPLY (              
        VALUES              
('File Qced', [File Qced]),              
        ('Errors Found', [Errors Found]),              
        ('Error Finding Rate', [Error Finding Rate]),              
        ('Incorrect Errors', [Incorrect Errors]),              
        ('ReQC Critical Errors', [ReQC Critical Errors]),              
        ('ReQC Non-Critical Errors', [ReQC Non-Critical Errors]),              
        ('Client Critical Errors', [Client Critical Errors]),              
        ('Client Non-Critical Errors', [Client Non-Critical Errors]),              
        ('Total Critical Errors', [Total Critical Errors]),              
        ('Total Non-Critical Errors', [Total Non-Critical Errors]),              
        ('Error/Loan', [Error/Loan])            
    ) AS U(Metric, Value)              
              
   -- select * from #UnpivotData              
    -----------------------------------------              
    -- STEP 4: Column List (Ordered)              
    -----------------------------------------              
    DECLARE @cols NVARCHAR(MAX),              
            @colsSelect NVARCHAR(MAX)              
              
    SELECT @cols = STUFF((              
        SELECT ',' + QUOTENAME(Week + '-' + Metric)              
        FROM (              
            SELECT DISTINCT               
                Week,              
                Metric,              
                CAST(FromDate AS DATE) AS FromDt,              
                CASE Metric              
                    WHEN 'File Qced' THEN 1              
                    WHEN 'Errors Found' THEN 2              
                    WHEN 'Error Finding Rate' THEN 3              
                    WHEN 'Incorrect Errors' THEN 4              
                    WHEN 'ReQC Critical Errors' THEN 5              
                    WHEN 'ReQC Non-Critical Errors' THEN 6              
                    WHEN 'Client Critical Errors' THEN 7              
                    WHEN 'Client Non-Critical Errors' THEN 8              
                    WHEN 'Total Critical Errors' THEN 9              
                    WHEN 'Total Non-Critical Errors' THEN 10              
                    WHEN 'Error/Loan' THEN 11              
                END AS MetricOrder              
            FROM #UnpivotData              
        ) A              
        ORDER BY FromDt DESC, MetricOrder              
        FOR XML PATH(''), TYPE              
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, '')              
              
              
    -----------------------------------------              
    -- STEP 5: SELECT with ISNULL (0 instead of NULL)              
    -----------------------------------------              
    SELECT @colsSelect = STUFF((              
        SELECT ',' +               
               'ISNULL(' + QUOTENAME(Week + '-' + Metric) + ',0) AS '               
               + QUOTENAME(Week + '-' + Metric)              
        FROM (              
            SELECT DISTINCT               
                Week,              
                Metric,              
                CAST(FromDate AS DATE) AS FromDt,              
                CASE Metric              
                   WHEN 'File Qced' THEN 1              
                    WHEN 'Errors Found' THEN 2              
                    WHEN 'Error Finding Rate' THEN 3              
                    WHEN 'Incorrect Errors' THEN 4              
                    WHEN 'ReQC Critical Errors' THEN 5              
                    WHEN 'ReQC Non-Critical Errors' THEN 6              
                    WHEN 'Client Critical Errors' THEN 7              
                    WHEN 'Client Non-Critical Errors' THEN 8              
                    WHEN 'Total Critical Errors' THEN 9              
                    WHEN 'Total Non-Critical Errors' THEN 10              
                    WHEN 'Error/Loan' THEN 11              
                END AS MetricOrder              
            FROM #UnpivotData              
        ) A              
        ORDER BY FromDt DESC, MetricOrder              
        FOR XML PATH(''), TYPE              
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, '')          
              
              
    -----------------------------------------              
    -- STEP 6: Pivot Execution              
    -----------------------------------------              
    DECLARE @sql NVARCHAR(MAX)              
              
    SET @sql = '              
    SELECT             
        ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS SrNo,QCer,            
        ' + @colsSelect + '              
    FROM (              
        SELECT               
            QCer,             
            Week + ''-'' + Metric AS ColName,              
            Value              
        FROM #UnpivotData              
    ) src              
    PIVOT (              
        MAX(Value)              
        FOR ColName IN (' + @cols + ')              
    ) p              
                
    ORDER BY QCer              
    '              
    print @sql              
    EXEC(@sql)              
              
              
    -----------------------------------------              
    -- CLEANUP              
    -----------------------------------------              
    DROP TABLE #LoopDates              
    DROP TABLE #FinalData              
    DROP TABLE #UnpivotData              
              
END
GO
IF OBJECT_ID('dbo.usp_ServicingDFR_Category','P') IS NOT NULL DROP PROCEDURE dbo.usp_ServicingDFR_Category;
GO
CREATE PROCEDURE dbo.usp_ServicingDFR_Category @BatchID uniqueidentifier, @UserID int AS        
BEGIN        
    SET NOCOUNT ON;        
        
    -----------------------------------------        
    -- STEP 1: Date Ranges        
    -----------------------------------------        
    CREATE TABLE #LoopDates (        
        loopid INT IDENTITY(1,1) PRIMARY KEY,        
        [Date] NVARCHAR(100),        
        Week NVARCHAR(500),        
        FromDate NVARCHAR(100),        
        ToDate NVARCHAR(100)        
    )        
        
    INSERT INTO #LoopDates        
    EXEC usp_GetMonthQuarterWeekDates_Client_Servicing_Infinity        
        
        
    -----------------------------------------        
    -- STEP 2: Aggregation        
    -----------------------------------------        
    ;WITH cte AS (        
        SELECT         
            Category,      
            L.Week,        
            L.FromDate,        
            COUNT(DISTINCT I.[Loan Number]) AS [Loan Count],      
            COUNT(DISTINCT I.[FeedbackID]) AS [Total Errors]      
      
        FROM #LoopDates L
        INNER JOIN (SELECT DISTINCT ProjectID,LoanNo,OrderID,DispatchDate FROM dbo.ServicingDetailedFeedbackSelection WHERE BatchID=@BatchID AND UserID=@UserID) S
            ON S.DispatchDate BETWEEN CAST(L.FromDate AS date) AND CAST(L.ToDate AS date)        
        INNER JOIN ImportedFeedbacks_Servicing I         
            ON LTRIM(RTRIM(CONVERT(nvarchar(1000),I.[Loan Number])))=LTRIM(RTRIM(S.LoanNo))        
        INNER JOIN Project P         
            ON P.ProjectName = I.Client AND P.ProjectID=S.ProjectID        
        WHERE Len([QC Name])>1 and Len(Category)>1 and Category not in ('No Error')      
        
        GROUP BY I.Category, L.Week,  L.FromDate        
    )        
        
    SELECT Category, Week, FromDate, [Total Errors],       
        CASE WHEN [Loan Count]=0 THEN 0 ELSE CAST([Total Errors]*1.0/[Loan Count] AS DECIMAL(18,2)) END AS [Error/Loan]      
    INTO #FinalData        
    FROM cte        
        
    --select * from #FinalData        
    -----------------------------------------        
    -- STEP 3: UNPIVOT        
    -----------------------------------------        
    SELECT         
        Category,      
        Week,        
        FromDate,        
        Metric,        
        Value        
    INTO #UnpivotData        
    FROM #FinalData        
    CROSS APPLY (        
        VALUES        
        ('Total Errors', [Total Errors]),        
        ('Error/Loan', [Error/Loan])      
    ) AS U(Metric, Value)        
        
   -- select * from #UnpivotData        
    -----------------------------------------        
    -- STEP 4: Column List (Ordered)        
    -----------------------------------------        
    DECLARE @cols NVARCHAR(MAX),        
            @colsSelect NVARCHAR(MAX)        
        
    SELECT @cols = STUFF((        
        SELECT ',' + QUOTENAME(Week + '-' + Metric)        
        FROM (        
            SELECT DISTINCT         
                Week,        
                Metric,        
                CAST(FromDate AS DATE) AS FromDt,        
                CASE Metric        
                    WHEN 'Total Errors' THEN 1        
                    WHEN 'Error/Loan' THEN 2        
                       
                END AS MetricOrder        
            FROM #UnpivotData        
        ) A        
        ORDER BY FromDt DESC, MetricOrder        
        FOR XML PATH(''), TYPE        
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, '')        
        
        
    -----------------------------------------        
    -- STEP 5: SELECT with ISNULL (0 instead of NULL)        
    -----------------------------------------        
    SELECT @colsSelect = STUFF((        
        SELECT ',' +         
               'ISNULL(' + QUOTENAME(Week + '-' + Metric) + ',0) AS '         
               + QUOTENAME(Week + '-' + Metric)        
        FROM (        
            SELECT DISTINCT         
                Week,        
                Metric,        
                CAST(FromDate AS DATE) AS FromDt,        
                CASE Metric        
                     WHEN 'Total Errors' THEN 1        
                    WHEN 'Error/Loan' THEN 2        
                END AS MetricOrder        
            FROM #UnpivotData        
        ) A        
        ORDER BY FromDt DESC, MetricOrder        
        FOR XML PATH(''), TYPE        
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, '')        
        
        
    -----------------------------------------        
    -- STEP 6: Pivot Execution        
    -----------------------------------------        
    DECLARE @sql NVARCHAR(MAX)        
        
    SET @sql = '        
    SELECT       
        ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS SrNo,Category,      
        ' + @colsSelect + '        
    FROM (        
        SELECT         
            Category,       
            Week + ''-'' + Metric AS ColName,        
            Value        
        FROM #UnpivotData        
    ) src        
    PIVOT (        
        MAX(Value)        
        FOR ColName IN (' + @cols + ')        
    ) p        
          
    ORDER BY Category        
    '        
    print @sql        
    EXEC(@sql)        
        
        
    -----------------------------------------        
    -- CLEANUP        
    -----------------------------------------        
    DROP TABLE #LoopDates        
    DROP TABLE #FinalData        
    DROP TABLE #UnpivotData        
        
END
GO
IF OBJECT_ID('dbo.usp_ServicingDFR_SubCategory','P') IS NOT NULL DROP PROCEDURE dbo.usp_ServicingDFR_SubCategory;
GO
CREATE PROCEDURE dbo.usp_ServicingDFR_SubCategory @BatchID uniqueidentifier, @UserID int AS        
BEGIN        
    SET NOCOUNT ON;        
        
    -----------------------------------------        
    -- STEP 1: Date Ranges        
    -----------------------------------------        
    CREATE TABLE #LoopDates (        
        loopid INT IDENTITY(1,1) PRIMARY KEY,        
        [Date] NVARCHAR(100),        
        Week NVARCHAR(500),        
        FromDate NVARCHAR(100),        
        ToDate NVARCHAR(100)        
    )        
        
    INSERT INTO #LoopDates        
    EXEC usp_GetMonthQuarterWeekDates_Client_Servicing_Infinity       
        
        
    -----------------------------------------        
    -- STEP 2: Aggregation        
    -----------------------------------------        
    ;WITH cte AS (        
        SELECT         
            [Sub Category] as SubCategory,      
            L.Week,        
            L.FromDate,        
            COUNT(DISTINCT I.[Loan Number]) AS [Loan Count],      
            COUNT(DISTINCT I.[FeedbackID]) AS [Total Errors]      
      
        FROM #LoopDates L
        INNER JOIN (SELECT DISTINCT ProjectID,LoanNo,OrderID,DispatchDate FROM dbo.ServicingDetailedFeedbackSelection WHERE BatchID=@BatchID AND UserID=@UserID) S
            ON S.DispatchDate BETWEEN CAST(L.FromDate AS date) AND CAST(L.ToDate AS date)        
        INNER JOIN ImportedFeedbacks_Servicing I         
            ON LTRIM(RTRIM(CONVERT(nvarchar(1000),I.[Loan Number])))=LTRIM(RTRIM(S.LoanNo))        
        INNER JOIN Project P         
            ON P.ProjectName = I.Client AND P.ProjectID=S.ProjectID        
        WHERE Len([QC Name])>1 and Len([Sub Category])>1 and Category not in ('No Error')      
        
        GROUP BY I.[Sub Category], L.Week,  L.FromDate        
    )        
        
    SELECT SubCategory, Week, FromDate, [Total Errors],       
        CASE WHEN [Loan Count]=0 THEN 0 ELSE CAST([Total Errors]*1.0/[Loan Count] AS DECIMAL(18,2)) END AS [Error/Loan]      
    INTO #FinalData        
    FROM cte        
        
    --select * from #FinalData        
    -----------------------------------------        
    -- STEP 3: UNPIVOT        
    -----------------------------------------        
    SELECT         
        SubCategory,      
        Week,        
        FromDate,        
        Metric,        
        Value        
    INTO #UnpivotData        
    FROM #FinalData        
    CROSS APPLY (        
        VALUES        
        ('Total Errors', [Total Errors]),        
        ('Error/Loan', [Error/Loan])      
    ) AS U(Metric, Value)        
        
   -- select * from #UnpivotData        
    -----------------------------------------        
    -- STEP 4: Column List (Ordered)        
    -----------------------------------------        
    DECLARE @cols NVARCHAR(MAX),        
            @colsSelect NVARCHAR(MAX)        
        
    SELECT @cols = STUFF((        
        SELECT ',' + QUOTENAME(Week + '-' + Metric)        
        FROM (        
            SELECT DISTINCT         
                Week,        
                Metric,        
                CAST(FromDate AS DATE) AS FromDt,        
                CASE Metric        
                    WHEN 'Total Errors' THEN 1        
                    WHEN 'Error/Loan' THEN 2        
                       
                END AS MetricOrder        
            FROM #UnpivotData        
        ) A        
        ORDER BY FromDt DESC, MetricOrder        
        FOR XML PATH(''), TYPE        
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, '')        
        
        
    -----------------------------------------        
    -- STEP 5: SELECT with ISNULL (0 instead of NULL)        
    -----------------------------------------        
    SELECT @colsSelect = STUFF((        
        SELECT ',' +         
               'ISNULL(' + QUOTENAME(Week + '-' + Metric) + ',0) AS '         
               + QUOTENAME(Week + '-' + Metric)        
        FROM (        
            SELECT DISTINCT         
                Week,        
                Metric,        
                CAST(FromDate AS DATE) AS FromDt,        
                CASE Metric        
                     WHEN 'Total Errors' THEN 1        
                    WHEN 'Error/Loan' THEN 2        
                END AS MetricOrder        
            FROM #UnpivotData        
        ) A        
        ORDER BY FromDt DESC, MetricOrder        
        FOR XML PATH(''), TYPE        
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, '')        
        
        
    -----------------------------------------        
    -- STEP 6: Pivot Execution        
    -----------------------------------------        
    DECLARE @sql NVARCHAR(MAX)        
        
    SET @sql = '        
   SELECT       
        ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS SrNo,SubCategory,      
        ' + @colsSelect + '        
    FROM (        
        SELECT         
            SubCategory,       
            Week + ''-'' + Metric AS ColName,        
            Value        
        FROM #UnpivotData        
    ) src        
    PIVOT (        
        MAX(Value)        
        FOR ColName IN (' + @cols + ')        
    ) p        
          
    ORDER BY SubCategory        
    '        
    print @sql        
    EXEC(@sql)        
        
        
    -----------------------------------------        
    -- CLEANUP        
    -----------------------------------------        
    DROP TABLE #LoopDates        
    DROP TABLE #FinalData        
    DROP TABLE #UnpivotData        
        
END
GO
IF OBJECT_ID('dbo.usp_ServicingDFR_InternalFeedbacks','P') IS NOT NULL DROP PROCEDURE dbo.usp_ServicingDFR_InternalFeedbacks;
GO
CREATE PROCEDURE dbo.usp_ServicingDFR_InternalFeedbacks @BatchID uniqueidentifier, @UserID int AS            
begin            
select FeedbackID, [Loan Number], Client, [UW Name], [QC Name], convert(nvarchar(12),cast([Date Reviewed] as date),101) as [Date Reviewed], convert(nvarchar(12),cast([QC Date] as date),101)         
as [QC Date], Category, [Sub category], [Error Field], Screen,          
[Error Type], Finding, [Feedback Type], Severity, RCA,  Source, convert(nvarchar(12),cast([Feedback Received Date] as date),101) as [Feedback Received Date], [Emp Status]          
FROM (SELECT DISTINCT ProjectID,LoanNo FROM dbo.ServicingDetailedFeedbackSelection WHERE BatchID=@BatchID AND UserID=@UserID) S INNER JOIN dbo.ImportedFeedbacks_Servicing F ON LTRIM(RTRIM(CONVERT(nvarchar(1000),F.[Loan Number])))=LTRIM(RTRIM(S.LoanNo))    
INNER JOIN Project P ON P.ProjectName = F.Client AND P.ProjectID=S.ProjectID      
WHERE [Source]='Internal' and     
cast([QC Date] as date) between cast(dateadd(year,-1,cast(getdate() as date)) as date) and cast(getdate() as date)    
      
end
GO
IF OBJECT_ID('dbo.usp_ServicingDFR_ReQCFeedbacks','P') IS NOT NULL DROP PROCEDURE dbo.usp_ServicingDFR_ReQCFeedbacks;
GO
CREATE PROCEDURE dbo.usp_ServicingDFR_ReQCFeedbacks @BatchID uniqueidentifier, @UserID int AS            
begin            
select FeedbackID, [Loan Number], Client, [UW Name], [QC Name], convert(nvarchar(12),cast([Date Reviewed] as date),101) as [Date Reviewed], convert(nvarchar(12),cast([QC Date] as date),101)         
as [QC Date], Category, [Sub category], [Error Field], Screen,          
[Error Type], Finding, [Feedback Type], Severity, RCA,  Source, convert(nvarchar(12),cast([Feedback Received Date] as date),101) as [Feedback Received Date], [Emp Status]          
FROM (SELECT DISTINCT ProjectID,LoanNo FROM dbo.ServicingDetailedFeedbackSelection WHERE BatchID=@BatchID AND UserID=@UserID) S INNER JOIN dbo.ImportedFeedbacks_Servicing F ON LTRIM(RTRIM(CONVERT(nvarchar(1000),F.[Loan Number])))=LTRIM(RTRIM(S.LoanNo))    
INNER JOIN Project P ON P.ProjectName = F.Client AND P.ProjectID=S.ProjectID      
WHERE [Source]='ReQC' and     
cast([QC Date] as date) between cast(dateadd(year,-1,cast(getdate() as date)) as date) and cast(getdate() as date)    
     
end
GO
IF OBJECT_ID('dbo.usp_ServicingDFR_ClientFeedbacks','P') IS NOT NULL DROP PROCEDURE dbo.usp_ServicingDFR_ClientFeedbacks;
GO
CREATE PROCEDURE dbo.usp_ServicingDFR_ClientFeedbacks @BatchID uniqueidentifier, @UserID int AS              
begin              
select FeedbackID, [Loan Number], Client, [UW Name], [QC Name], convert(nvarchar(12),cast([Date Reviewed] as date),101) as [Date Reviewed], convert(nvarchar(12),cast([QC Date] as date),101)           
as [QC Date], Category, [Sub category], [Error Field], Screen,            
[Error Type], Finding, [Feedback Type], Severity, RCA,  Source, convert(nvarchar(12),cast([Feedback Received Date] as date),101) as [Feedback Received Date], [Emp Status]            
FROM (SELECT DISTINCT ProjectID,LoanNo FROM dbo.ServicingDetailedFeedbackSelection WHERE BatchID=@BatchID AND UserID=@UserID) S INNER JOIN dbo.ImportedFeedbacks_Servicing F ON LTRIM(RTRIM(CONVERT(nvarchar(1000),F.[Loan Number])))=LTRIM(RTRIM(S.LoanNo))      
INNER JOIN Project P ON P.ProjectName = F.Client AND P.ProjectID=S.ProjectID        
WHERE [Source]='Client' and       
cast([QC Date] as date) between cast(dateadd(year,-1,cast(getdate() as date)) as date) and cast(getdate() as date)          
end
GO
IF OBJECT_ID('dbo.usp_ServicingDFR_RebuttalFeedbacks','P') IS NOT NULL DROP PROCEDURE dbo.usp_ServicingDFR_RebuttalFeedbacks;
GO
CREATE PROCEDURE dbo.usp_ServicingDFR_RebuttalFeedbacks @BatchID uniqueidentifier, @UserID int AS            
begin            
select FeedbackID, [Loan Number], Client, [UW Name], [QC Name], convert(nvarchar(12),cast([Date Reviewed] as date),101) as [Date Reviewed], convert(nvarchar(12),cast([QC Date] as date),101)         
as [QC Date], Category, [Sub category], [Error Field], Screen,          
[Error Type], Finding, [Feedback Type], Severity, RCA,  Source, convert(nvarchar(12),cast([Feedback Received Date] as date),101) as [Feedback Received Date], [Emp Status]          
FROM (SELECT DISTINCT ProjectID,LoanNo FROM dbo.ServicingDetailedFeedbackSelection WHERE BatchID=@BatchID AND UserID=@UserID) S INNER JOIN dbo.ImportedFeedbacks_Servicing F ON LTRIM(RTRIM(CONVERT(nvarchar(1000),F.[Loan Number])))=LTRIM(RTRIM(S.LoanNo))    
INNER JOIN Project P ON P.ProjectName = F.Client AND P.ProjectID=S.ProjectID      
WHERE [Source]='Rebuttal' and     
cast([QC Date] as date) between cast(dateadd(year,-1,cast(getdate() as date)) as date) and cast(getdate() as date)    
end
GO
IF OBJECT_ID('dbo.usp_ServicingDFR_ClientQualityReport','P') IS NOT NULL DROP PROCEDURE dbo.usp_ServicingDFR_ClientQualityReport;
GO
CREATE PROCEDURE dbo.usp_ServicingDFR_ClientQualityReport @BatchID uniqueidentifier, @UserID int AS        
;WITH WeeklyData AS        
(        
select         
                CONVERT(varchar(10), DATEADD(dd, @@DATEFIRST - DATEPART(dw, CAST([QC Date] AS date)) - 5, CAST([QC Date] AS date)), 101)          
                + '~-'          
                + CONVERT(varchar(10), DATEADD(dd, @@DATEFIRST - DATEPART(dw, CAST([QC Date] AS date)) + 1, CAST([QC Date] AS date)), 101)         
    as  Week,        
[QC Name] as [QCer], count(distinct [Loan Number]) as [Loan QCed],           
sum(case when [Severity]='No Error' then 1 else 0 end) as [No Error],          
sum(case when [Severity]='Critical' then 1 else 0 end) as [Critical]  ,      
sum(case when [Severity]='Non Critical' then 1 else 0 end) as [Non Critical]         
FROM (SELECT DISTINCT ProjectID,LoanNo FROM dbo.ServicingDetailedFeedbackSelection WHERE BatchID=@BatchID AND UserID=@UserID) S INNER JOIN dbo.ImportedFeedbacks_Servicing F ON LTRIM(RTRIM(CONVERT(nvarchar(1000),F.[Loan Number])))=LTRIM(RTRIM(S.LoanNo))    
INNER JOIN Project P ON P.ProjectName = F.Client AND P.ProjectID=S.ProjectID      
WHERE     
cast([QC Date] as date) between cast(dateadd(year,-1,cast(getdate() as date)) as date) and cast(getdate() as date)           
group by [QC Name],        
 CONVERT(varchar(10), DATEADD(dd, @@DATEFIRST - DATEPART(dw, CAST([QC Date] AS date)) - 5, CAST([QC Date] AS date)), 101)          
                + '~-'          
                + CONVERT(varchar(10), DATEADD(dd, @@DATEFIRST - DATEPART(dw, CAST([QC Date] AS date)) + 1, CAST([QC Date] AS date)), 101)         
)        
select * , ([Critical] + [Non Critical]) as Total,        
 (        
 ([Critical] + [Non Critical])/[Loan QCed]        
 ) as [Avg Errors per Loan(Total Loans)],        
 (        
 ((([Critical] + [Non Critical])-[No Error])/[Loan QCed]))        
 as [Avg Errors per Loan(Error loans)]        
from WeeklyData
GO
