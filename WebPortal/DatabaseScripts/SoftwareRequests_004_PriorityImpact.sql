/* Priority approval, impact and accountability - SQL Server 2016 compatible. */
SET NOCOUNT ON;
IF COL_LENGTH('dbo.SRM_Request','PriorityApprovedBy') IS NULL ALTER TABLE dbo.SRM_Request ADD PriorityApprovedBy int NULL;
IF COL_LENGTH('dbo.SRM_Request','PriorityApprovedOn') IS NULL ALTER TABLE dbo.SRM_Request ADD PriorityApprovedOn datetime2(0) NULL;
IF COL_LENGTH('dbo.SRM_Request','PriorityChangeReason') IS NULL ALTER TABLE dbo.SRM_Request ADD PriorityChangeReason nvarchar(1000) NULL;
IF COL_LENGTH('dbo.SRM_Request','RevisedETA') IS NULL ALTER TABLE dbo.SRM_Request ADD RevisedETA date NULL;
IF COL_LENGTH('dbo.SRM_Request','ManagementOverride') IS NULL ALTER TABLE dbo.SRM_Request ADD ManagementOverride bit NOT NULL CONSTRAINT DF_SRM_Request_ManagementOverride DEFAULT(0);
IF OBJECT_ID('dbo.SRM_PriorityChange','U') IS NULL
BEGIN
 CREATE TABLE dbo.SRM_PriorityChange(PriorityChangeID bigint IDENTITY PRIMARY KEY,RequestID bigint NOT NULL REFERENCES dbo.SRM_Request(RequestID),OldPriority varchar(20) NULL,NewPriority varchar(20) NOT NULL,RequestedBy int NOT NULL,RequestedOn datetime2(0) NOT NULL DEFAULT(SYSDATETIME()),ChangeReason nvarchar(1000) NOT NULL,PreviousETA date NULL,RevisedETA date NULL,ChangeStatus varchar(20) NOT NULL DEFAULT('Pending'),ApprovedBy int NULL,ApprovedOn datetime2(0) NULL,ManagementOverride bit NOT NULL DEFAULT(0));
 CREATE INDEX IX_SRM_PriorityChange_Request ON dbo.SRM_PriorityChange(RequestID,RequestedOn DESC);
END;
IF OBJECT_ID('dbo.SRM_PriorityImpact','U') IS NULL
BEGIN
 CREATE TABLE dbo.SRM_PriorityImpact(PriorityImpactID bigint IDENTITY PRIMARY KEY,PriorityChangeID bigint NOT NULL REFERENCES dbo.SRM_PriorityChange(PriorityChangeID),CausedByRequestID bigint NOT NULL REFERENCES dbo.SRM_Request(RequestID),ImpactedRequestID bigint NOT NULL REFERENCES dbo.SRM_Request(RequestID),PreviousETA date NULL,RevisedETA date NULL,DelayDays int NOT NULL,CreatedOn datetime2(0) NOT NULL DEFAULT(SYSDATETIME()),NotifiedOn datetime2(0) NULL);
 CREATE INDEX IX_SRM_PriorityImpact_Request ON dbo.SRM_PriorityImpact(ImpactedRequestID,CreatedOn DESC);
END;
GO
