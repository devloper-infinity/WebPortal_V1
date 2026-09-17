SET XACT_ABORT ON;
BEGIN TRANSACTION;

IF OBJECT_ID('dbo.RNR_Questionnaire','U') IS NULL
BEGIN
 CREATE TABLE dbo.RNR_Questionnaire(
  QuestionnaireID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_RNR_Questionnaire PRIMARY KEY,
  Title nvarchar(200) NOT NULL, Description nvarchar(1000) NULL,
  Status varchar(12) NOT NULL CONSTRAINT CK_RNR_Questionnaire_Status CHECK(Status IN('Draft','Published')),
  IsActive bit NOT NULL CONSTRAINT DF_RNR_Questionnaire_Active DEFAULT(1),
  Priority int NOT NULL CONSTRAINT DF_RNR_Questionnaire_Priority DEFAULT(0),
  CreatedBy int NOT NULL, CreatedDate datetime2(0) NOT NULL CONSTRAINT DF_RNR_Questionnaire_Created DEFAULT(SYSDATETIME()),
  ModifiedBy int NULL, ModifiedDate datetime2(0) NULL, PublishedBy int NULL, PublishedDate datetime2(0) NULL
 );
 CREATE TABLE dbo.RNR_Question(
  QuestionID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_RNR_Question PRIMARY KEY,
  QuestionnaireID int NOT NULL, QuestionText nvarchar(1000) NOT NULL,
  QuestionType varchar(20) NOT NULL CONSTRAINT CK_RNR_Question_Type CHECK(QuestionType IN('Text','SingleChoice','MultipleChoice','YesNo','Rating')),
  IsRequired bit NOT NULL CONSTRAINT DF_RNR_Question_Required DEFAULT(0), SortOrder int NOT NULL,
  RatingMin tinyint NULL, RatingMax tinyint NULL,
  CONSTRAINT FK_RNR_Question_Questionnaire FOREIGN KEY(QuestionnaireID) REFERENCES dbo.RNR_Questionnaire(QuestionnaireID) ON DELETE CASCADE,
  CONSTRAINT CK_RNR_Question_Rating CHECK(QuestionType<>'Rating' OR (RatingMin>=1 AND RatingMax<=10 AND RatingMin<RatingMax))
 );
 CREATE TABLE dbo.RNR_Option(
  OptionID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_RNR_Option PRIMARY KEY,
  QuestionID int NOT NULL, OptionText nvarchar(500) NOT NULL, SortOrder int NOT NULL,
  CONSTRAINT FK_RNR_Option_Question FOREIGN KEY(QuestionID) REFERENCES dbo.RNR_Question(QuestionID) ON DELETE CASCADE
 );
 CREATE TABLE dbo.RNR_Assignment(
  AssignmentID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_RNR_Assignment PRIMARY KEY,
  QuestionnaireID int NOT NULL, EmployeeID int NOT NULL, IsMandatory bit NOT NULL CONSTRAINT DF_RNR_Assignment_Mandatory DEFAULT(1),
  SurveyYear smallint NOT NULL CONSTRAINT DF_RNR_Assignment_Year DEFAULT(YEAR(GETDATE())),
  QuarterMask tinyint NOT NULL CONSTRAINT DF_RNR_Assignment_QuarterMask DEFAULT(15),
  IsActive bit NOT NULL CONSTRAINT DF_RNR_Assignment_Active DEFAULT(1), AssignedBy int NOT NULL,
  AssignedDate datetime2(0) NOT NULL CONSTRAINT DF_RNR_Assignment_Date DEFAULT(SYSDATETIME()), DueDate datetime2(0) NULL,
  CONSTRAINT FK_RNR_Assignment_Questionnaire FOREIGN KEY(QuestionnaireID) REFERENCES dbo.RNR_Questionnaire(QuestionnaireID)
 );
 CREATE TABLE dbo.RNR_Response(
  ResponseID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_RNR_Response PRIMARY KEY,
  AssignmentID bigint NOT NULL, EmployeeID int NOT NULL, SubmittedDate datetime2(0) NOT NULL CONSTRAINT DF_RNR_Response_Date DEFAULT(SYSDATETIME()),
  CONSTRAINT FK_RNR_Response_Assignment FOREIGN KEY(AssignmentID) REFERENCES dbo.RNR_Assignment(AssignmentID),
  CONSTRAINT UQ_RNR_Response_Assignment UNIQUE(AssignmentID)
 );
 CREATE TABLE dbo.RNR_AnswerDetail(
  AnswerDetailID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_RNR_AnswerDetail PRIMARY KEY,
  ResponseID bigint NOT NULL, QuestionID int NOT NULL, OptionID int NULL, TextAnswer nvarchar(max) NULL, RatingAnswer tinyint NULL,
  CONSTRAINT FK_RNR_Answer_Response FOREIGN KEY(ResponseID) REFERENCES dbo.RNR_Response(ResponseID) ON DELETE CASCADE,
  CONSTRAINT FK_RNR_Answer_Question FOREIGN KEY(QuestionID) REFERENCES dbo.RNR_Question(QuestionID),
  CONSTRAINT FK_RNR_Answer_Option FOREIGN KEY(OptionID) REFERENCES dbo.RNR_Option(OptionID),
  CONSTRAINT CK_RNR_Answer_Value CHECK(OptionID IS NOT NULL OR NULLIF(LTRIM(RTRIM(TextAnswer)),'') IS NOT NULL OR RatingAnswer IS NOT NULL)
 );
 CREATE TABLE dbo.RNR_Audit(
  AuditID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_RNR_Audit PRIMARY KEY,
  EntityType varchar(30) NOT NULL, EntityID bigint NULL, Action varchar(30) NOT NULL,
  Details nvarchar(2000) NULL, PerformedBy int NOT NULL, PerformedDate datetime2(0) NOT NULL CONSTRAINT DF_RNR_Audit_Date DEFAULT(SYSDATETIME()),
  IPAddress varchar(45) NULL
 );
 CREATE INDEX IX_RNR_Assignment_ActivePeriod ON dbo.RNR_Assignment(QuestionnaireID,EmployeeID,SurveyYear,IsActive) INCLUDE(QuarterMask);
 CREATE INDEX IX_RNR_Assignment_EmployeePending ON dbo.RNR_Assignment(EmployeeID,IsActive,IsMandatory) INCLUDE(QuestionnaireID,AssignedDate);
 CREATE INDEX IX_RNR_Assignment_Questionnaire ON dbo.RNR_Assignment(QuestionnaireID,AssignedDate);
 CREATE INDEX IX_RNR_Question_Order ON dbo.RNR_Question(QuestionnaireID,SortOrder);
 CREATE INDEX IX_RNR_Option_Order ON dbo.RNR_Option(QuestionID,SortOrder);
 CREATE INDEX IX_RNR_Answer_Response ON dbo.RNR_AnswerDetail(ResponseID,QuestionID);
END;

IF COL_LENGTH('dbo.RNR_Assignment','SurveyYear') IS NULL
 ALTER TABLE dbo.RNR_Assignment ADD SurveyYear smallint NOT NULL CONSTRAINT DF_RNR_Assignment_Year DEFAULT(YEAR(GETDATE()));
IF COL_LENGTH('dbo.RNR_Assignment','QuarterMask') IS NULL
 ALTER TABLE dbo.RNR_Assignment ADD QuarterMask tinyint NOT NULL CONSTRAINT DF_RNR_Assignment_QuarterMask DEFAULT(15);
IF EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.RNR_Assignment') AND name='UX_RNR_Assignment_Active')
 DROP INDEX UX_RNR_Assignment_Active ON dbo.RNR_Assignment;
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.RNR_Assignment') AND name='IX_RNR_Assignment_ActivePeriod')
 CREATE INDEX IX_RNR_Assignment_ActivePeriod ON dbo.RNR_Assignment(QuestionnaireID,EmployeeID,SurveyYear,IsActive) INCLUDE(QuarterMask);

IF NOT EXISTS(SELECT 1 FROM dbo.RNR_Questionnaire WHERE Title=N'RNR Feedback')
BEGIN
 INSERT dbo.RNR_Questionnaire(Title,Description,Status,IsActive,Priority,CreatedBy,PublishedBy,PublishedDate)
 VALUES(N'RNR Feedback',N'Team Feedback Form — Infinity IPS. Responses are confidential and used only to improve the support we provide.','Published',1,100,0,0,SYSDATETIME());
 DECLARE @Q int=CONVERT(int,SCOPE_IDENTITY()),@Question int;
 INSERT dbo.RNR_Question(QuestionnaireID,QuestionText,QuestionType,IsRequired,SortOrder) VALUES(@Q,N'How would you rate your overall experience with the RNR event?','SingleChoice',1,1); SET @Question=SCOPE_IDENTITY();
 INSERT dbo.RNR_Option(QuestionID,OptionText,SortOrder) VALUES(@Question,N'Satisfied',1),(@Question,N'Neutral',2),(@Question,N'Dissatisfied',3);
 INSERT dbo.RNR_Question(QuestionnaireID,QuestionText,QuestionType,IsRequired,SortOrder) VALUES(@Q,N'How satisfied were you with the RNR prize and certificate distribution?','SingleChoice',1,2); SET @Question=SCOPE_IDENTITY();
 INSERT dbo.RNR_Option(QuestionID,OptionText,SortOrder) VALUES(@Question,N'Excellent',1),(@Question,N'Good',2),(@Question,N'Fair',3),(@Question,N'Poor',4);
 INSERT dbo.RNR_Question(QuestionnaireID,QuestionText,QuestionType,IsRequired,SortOrder) VALUES(@Q,N'How enjoyable did you find the games and team activities?','SingleChoice',1,3); SET @Question=SCOPE_IDENTITY();
 INSERT dbo.RNR_Option(QuestionID,OptionText,SortOrder) VALUES(@Question,N'Very Enjoyable',1),(@Question,N'Neutral',2),(@Question,N'Not Enjoyable',3);
 INSERT dbo.RNR_Question(QuestionnaireID,QuestionText,QuestionType,IsRequired,SortOrder) VALUES(@Q,N'Did the RNR event help you feel more connected and engaged with your team?','YesNo',1,4);
 INSERT dbo.RNR_Question(QuestionnaireID,QuestionText,QuestionType,IsRequired,SortOrder) VALUES(@Q,N'What did you like most about the R&R Program?','Text',1,5);
 INSERT dbo.RNR_Question(QuestionnaireID,QuestionText,QuestionType,IsRequired,SortOrder) VALUES(@Q,N'What suggestions do you have to make future RNR events more enjoyable and engaging?','Text',1,6);
END;
COMMIT;
