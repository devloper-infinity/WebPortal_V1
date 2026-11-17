/* Infinity ERP Chat - Phase 1 (SQL Server 2016). REVIEW AND RUN MANUALLY. */
SET XACT_ABORT ON;
BEGIN TRAN;

CREATE TABLE dbo.ChatConversation(
 ConversationID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_ChatConversation PRIMARY KEY,
 SubdomainID nvarchar(100) NOT NULL, ConversationType char(1) NOT NULL CONSTRAINT CK_ChatConversation_Type CHECK(ConversationType IN('D','G')),
 ConversationName nvarchar(120) NULL, DirectKey varchar(50) NULL, CreatedBy int NOT NULL, CreatedOn datetime2(0) NOT NULL CONSTRAINT DF_ChatConversation_Created DEFAULT SYSDATETIME(),
 IsCrossDomain bit NOT NULL CONSTRAINT DF_ChatConversation_CrossDomain DEFAULT(0), /* reserved for Phase 2; all Phase 1 procedures require 0 */
 IsActive bit NOT NULL CONSTRAINT DF_ChatConversation_Active DEFAULT(1));
CREATE UNIQUE INDEX UX_ChatConversation_Direct ON dbo.ChatConversation(SubdomainID,DirectKey) WHERE ConversationType='D' AND IsActive=1;
CREATE INDEX IX_ChatConversation_Subdomain ON dbo.ChatConversation(SubdomainID,ConversationID DESC);

CREATE TABLE dbo.ChatConversationMember(
 ConversationID bigint NOT NULL, EmployeeID int NOT NULL, JoinedOn datetime2(0) NOT NULL CONSTRAINT DF_ChatMember_Joined DEFAULT SYSDATETIME(),
 LastReadMessageID bigint NULL, IsAdmin bit NOT NULL CONSTRAINT DF_ChatMember_Admin DEFAULT(0), IsActive bit NOT NULL CONSTRAINT DF_ChatMember_Active DEFAULT(1),
 CONSTRAINT PK_ChatConversationMember PRIMARY KEY(ConversationID,EmployeeID), CONSTRAINT FK_ChatMember_Conversation FOREIGN KEY(ConversationID) REFERENCES dbo.ChatConversation(ConversationID));
CREATE INDEX IX_ChatMember_Employee ON dbo.ChatConversationMember(EmployeeID,IsActive,ConversationID) INCLUDE(LastReadMessageID);

CREATE TABLE dbo.ChatMessage(
 MessageID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_ChatMessage PRIMARY KEY, ConversationID bigint NOT NULL, SenderEmployeeID int NOT NULL,
 Body nvarchar(4000) NULL, SentOn datetime2(3) NOT NULL CONSTRAINT DF_ChatMessage_Sent DEFAULT SYSDATETIME(), IsDeleted bit NOT NULL CONSTRAINT DF_ChatMessage_Deleted DEFAULT(0),
 CONSTRAINT FK_ChatMessage_Conversation FOREIGN KEY(ConversationID) REFERENCES dbo.ChatConversation(ConversationID));
CREATE INDEX IX_ChatMessage_Page ON dbo.ChatMessage(ConversationID,MessageID DESC) INCLUDE(SenderEmployeeID,SentOn,IsDeleted);

CREATE TABLE dbo.ChatAttachment(
 AttachmentID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_ChatAttachment PRIMARY KEY, UploadToken uniqueidentifier NOT NULL, MessageID bigint NULL,
 UploadedBy int NOT NULL, OriginalFileName nvarchar(255) NOT NULL, StoredFileName nvarchar(255) NOT NULL, ContentType varchar(100) NOT NULL, FileSize bigint NOT NULL,
 UploadedOn datetime2(0) NOT NULL CONSTRAINT DF_ChatAttachment_Uploaded DEFAULT SYSDATETIME(), IsActive bit NOT NULL CONSTRAINT DF_ChatAttachment_Active DEFAULT(1),
 CONSTRAINT UQ_ChatAttachment_Token UNIQUE(UploadToken), CONSTRAINT FK_ChatAttachment_Message FOREIGN KEY(MessageID) REFERENCES dbo.ChatMessage(MessageID));
CREATE INDEX IX_ChatAttachment_Message ON dbo.ChatAttachment(MessageID) INCLUDE(OriginalFileName,FileSize,ContentType);
GO

CREATE FUNCTION dbo.ChatEmployeeSubdomain(@EmployeeID int) RETURNS nvarchar(100) AS
BEGIN
 RETURN (SELECT NULLIF(UPPER(LTRIM(RTRIM(CONVERT(nvarchar(100),SubDomain)))),N'') FROM dbo.EmployeeInfo WHERE EmployeeID=@EmployeeID AND ISNULL(IsDelete,0)=0);
END;
GO
CREATE PROCEDURE dbo.Chat_AssertMember @ActorEmployeeID int,@ConversationID bigint AS
BEGIN SET NOCOUNT ON; DECLARE @S int=dbo.ChatEmployeeSubdomain(@ActorEmployeeID); IF @S IS NULL THROW 51000,'Employee has no valid subdomain.',1;
 IF NOT EXISTS(SELECT 1 FROM dbo.ChatConversation c JOIN dbo.ChatConversationMember m ON m.ConversationID=c.ConversationID AND m.EmployeeID=@ActorEmployeeID AND m.IsActive=1 WHERE c.ConversationID=@ConversationID AND c.IsActive=1 AND c.IsCrossDomain=0 AND c.SubdomainID=@S) THROW 51001,'Conversation access denied.',1; END;
GO
CREATE PROCEDURE dbo.Chat_Bootstrap @ActorEmployeeID int,@Search nvarchar(100)=N'' AS
BEGIN SET NOCOUNT ON; DECLARE @S int=dbo.ChatEmployeeSubdomain(@ActorEmployeeID); IF @S IS NULL THROW 51000,'Employee has no valid subdomain.',1;
 SELECT e.EmployeeID,e.Code+CASE WHEN NULLIF(LTRIM(RTRIM(ISNULL(ec.PsuedoName,''))),'') IS NULL THEN '' ELSE ' - '+LTRIM(RTRIM(ec.PsuedoName)) END Code,LTRIM(RTRIM(ISNULL(e.FirstName,'')+' '+ISNULL(e.lastName,''))) EmployeeName FROM dbo.EmployeeInfo e OUTER APPLY(SELECT TOP 1 c.PsuedoName FROM dbo.EmployeeConfiguration c WHERE (c.EmployeeID=e.EmployeeID OR c.Code=e.Code) AND c.DataSource='ERP' AND ISNULL(c.IsDelete,0)=0 ORDER BY c.AddedDate DESC,c.EmpConfigrationID DESC)ec WHERE e.EmployeeID<>@ActorEmployeeID AND ISNULL(e.IsDelete,0)=0 AND dbo.ChatEmployeeSubdomain(e.EmployeeID)=@S AND (@Search=N'' OR e.Code LIKE '%'+@Search+'%' OR e.FirstName LIKE '%'+@Search+'%' OR e.lastName LIKE '%'+@Search+'%' OR ec.PsuedoName LIKE '%'+@Search+'%') ORDER BY EmployeeName;
 SELECT c.ConversationID,c.ConversationType,CASE WHEN c.ConversationType='G' THEN c.ConversationName ELSE LTRIM(RTRIM(ISNULL(o.FirstName,'')+' '+ISNULL(o.lastName,''))) END ConversationName,MAX(msg.MessageID) LastMessageID,MAX(msg.SentOn) LastMessageOn,COUNT(CASE WHEN msg.MessageID>ISNULL(me.LastReadMessageID,0) AND msg.SenderEmployeeID<>@ActorEmployeeID THEN 1 END) UnreadCount FROM dbo.ChatConversationMember me JOIN dbo.ChatConversation c ON c.ConversationID=me.ConversationID AND c.SubdomainID=@S AND c.IsCrossDomain=0 AND c.IsActive=1 LEFT JOIN dbo.ChatConversationMember om ON om.ConversationID=c.ConversationID AND om.EmployeeID<>@ActorEmployeeID AND c.ConversationType='D' LEFT JOIN dbo.EmployeeInfo o ON o.EmployeeID=om.EmployeeID LEFT JOIN dbo.ChatMessage msg ON msg.ConversationID=c.ConversationID AND msg.IsDeleted=0 WHERE me.EmployeeID=@ActorEmployeeID AND me.IsActive=1 GROUP BY c.ConversationID,c.ConversationType,c.ConversationName,o.FirstName,o.lastName,me.LastReadMessageID ORDER BY LastMessageOn DESC;
 SELECT @ActorEmployeeID EmployeeID,@S SubdomainID; END;
GO
CREATE PROCEDURE dbo.Chat_OpenDirectConversation @ActorEmployeeID int,@OtherEmployeeID int AS
BEGIN SET NOCOUNT,XACT_ABORT ON; DECLARE @S int=dbo.ChatEmployeeSubdomain(@ActorEmployeeID),@OS int=dbo.ChatEmployeeSubdomain(@OtherEmployeeID); IF @S IS NULL OR @OS<>@S OR @ActorEmployeeID=@OtherEmployeeID THROW 51002,'Employee is outside your subdomain.',1; DECLARE @Key varchar(50)=CONCAT(IIF(@ActorEmployeeID<@OtherEmployeeID,@ActorEmployeeID,@OtherEmployeeID),':',IIF(@ActorEmployeeID<@OtherEmployeeID,@OtherEmployeeID,@ActorEmployeeID)),@ID bigint; BEGIN TRAN; SELECT @ID=ConversationID FROM dbo.ChatConversation WITH(UPDLOCK,HOLDLOCK) WHERE SubdomainID=@S AND DirectKey=@Key AND IsActive=1; IF @ID IS NULL BEGIN INSERT dbo.ChatConversation(SubdomainID,ConversationType,DirectKey,CreatedBy)VALUES(@S,'D',@Key,@ActorEmployeeID);SET @ID=SCOPE_IDENTITY();INSERT dbo.ChatConversationMember(ConversationID,EmployeeID)VALUES(@ID,@ActorEmployeeID),(@ID,@OtherEmployeeID);END COMMIT; SELECT @ID ConversationID; END;
GO
CREATE PROCEDURE dbo.Chat_CreateGroup @ActorEmployeeID int,@Name nvarchar(120),@MemberEmployeeIDs nvarchar(max) AS
BEGIN SET NOCOUNT,XACT_ABORT ON; DECLARE @S int=dbo.ChatEmployeeSubdomain(@ActorEmployeeID); IF @S IS NULL OR NULLIF(LTRIM(RTRIM(@Name)),'') IS NULL THROW 51003,'Valid group name required.',1; DECLARE @M TABLE(EmployeeID int PRIMARY KEY); INSERT @M SELECT DISTINCT TRY_CONVERT(int,n.value('.','varchar(20)')) FROM (SELECT TRY_CAST('<x>'+REPLACE(REPLACE(@MemberEmployeeIDs,'&','&amp;'),',','</x><x>')+'</x>' AS xml) z)a CROSS APPLY z.nodes('/x')t(n) WHERE TRY_CONVERT(int,n.value('.','varchar(20)')) IS NOT NULL; INSERT @M SELECT @ActorEmployeeID WHERE NOT EXISTS(SELECT 1 FROM @M WHERE EmployeeID=@ActorEmployeeID); IF EXISTS(SELECT 1 FROM @M m LEFT JOIN dbo.EmployeeInfo e ON e.EmployeeID=m.EmployeeID AND ISNULL(e.IsDelete,0)=0 AND TRY_CONVERT(int,NULLIF(LTRIM(RTRIM(e.SubDomain)),''))=@S WHERE e.EmployeeID IS NULL) THROW 51004,'All group members must belong to your subdomain.',1; BEGIN TRAN; INSERT dbo.ChatConversation(SubdomainID,ConversationType,ConversationName,CreatedBy)VALUES(@S,'G',LTRIM(RTRIM(@Name)),@ActorEmployeeID);DECLARE @ID bigint=SCOPE_IDENTITY();INSERT dbo.ChatConversationMember(ConversationID,EmployeeID,IsAdmin)SELECT @ID,EmployeeID,IIF(EmployeeID=@ActorEmployeeID,1,0) FROM @M;COMMIT;SELECT @ID ConversationID; END;
GO
CREATE PROCEDURE dbo.Chat_GetMessages @ActorEmployeeID int,@ConversationID bigint,@BeforeMessageID bigint=NULL,@PageSize int=40,@Search nvarchar(100)=N'' AS
BEGIN SET NOCOUNT ON; EXEC dbo.Chat_AssertMember @ActorEmployeeID,@ConversationID; SELECT TOP(@PageSize) m.MessageID,m.ConversationID,m.SenderEmployeeID,LTRIM(RTRIM(ISNULL(e.FirstName,'')+' '+ISNULL(e.lastName,''))) SenderName,m.Body,m.SentOn,a.AttachmentID,a.OriginalFileName,a.ContentType,a.FileSize,(SELECT COUNT(*) FROM dbo.ChatConversationMember cm WHERE cm.ConversationID=m.ConversationID AND cm.EmployeeID<>m.SenderEmployeeID AND cm.LastReadMessageID>=m.MessageID) ReadCount FROM dbo.ChatMessage m JOIN dbo.EmployeeInfo e ON e.EmployeeID=m.SenderEmployeeID LEFT JOIN dbo.ChatAttachment a ON a.MessageID=m.MessageID AND a.IsActive=1 WHERE m.ConversationID=@ConversationID AND m.IsDeleted=0 AND (@BeforeMessageID IS NULL OR m.MessageID<@BeforeMessageID) AND (@Search=N'' OR m.Body LIKE '%'+@Search+'%' OR a.OriginalFileName LIKE '%'+@Search+'%') ORDER BY m.MessageID DESC; END;
GO
CREATE PROCEDURE dbo.Chat_SendMessage @ActorEmployeeID int,@ConversationID bigint,@Body nvarchar(4000),@UploadToken uniqueidentifier=NULL AS
BEGIN SET NOCOUNT,XACT_ABORT ON; EXEC dbo.Chat_AssertMember @ActorEmployeeID,@ConversationID; IF NULLIF(LTRIM(RTRIM(@Body)),N'') IS NULL AND @UploadToken IS NULL THROW 51005,'Message or attachment required.',1; IF @UploadToken IS NOT NULL AND NOT EXISTS(SELECT 1 FROM dbo.ChatAttachment WHERE UploadToken=@UploadToken AND UploadedBy=@ActorEmployeeID AND MessageID IS NULL AND IsActive=1) THROW 51006,'Invalid attachment.',1; BEGIN TRAN; INSERT dbo.ChatMessage(ConversationID,SenderEmployeeID,Body)VALUES(@ConversationID,@ActorEmployeeID,NULLIF(LTRIM(RTRIM(@Body)),N''));DECLARE @ID bigint=SCOPE_IDENTITY();IF @UploadToken IS NOT NULL UPDATE dbo.ChatAttachment SET MessageID=@ID WHERE UploadToken=@UploadToken AND UploadedBy=@ActorEmployeeID AND MessageID IS NULL;COMMIT; SELECT m.MessageID,m.ConversationID,m.SenderEmployeeID,m.Body,m.SentOn FROM dbo.ChatMessage m WHERE m.MessageID=@ID; SELECT EmployeeID FROM dbo.ChatConversationMember WHERE ConversationID=@ConversationID AND IsActive=1; END;
GO
CREATE PROCEDURE dbo.Chat_MarkRead @ActorEmployeeID int,@ConversationID bigint,@ThroughMessageID bigint AS
BEGIN SET NOCOUNT ON; EXEC dbo.Chat_AssertMember @ActorEmployeeID,@ConversationID; IF NOT EXISTS(SELECT 1 FROM dbo.ChatMessage WHERE ConversationID=@ConversationID AND MessageID=@ThroughMessageID) THROW 51007,'Invalid message.',1; UPDATE dbo.ChatConversationMember SET LastReadMessageID=CASE WHEN ISNULL(LastReadMessageID,0)<@ThroughMessageID THEN @ThroughMessageID ELSE LastReadMessageID END WHERE ConversationID=@ConversationID AND EmployeeID=@ActorEmployeeID; SELECT @ConversationID ConversationID,@ThroughMessageID MessageID,@ActorEmployeeID EmployeeID; END;
GO
CREATE PROCEDURE dbo.Chat_StageAttachment @ActorEmployeeID int,@UploadToken uniqueidentifier,@OriginalFileName nvarchar(255),@StoredFileName nvarchar(255),@ContentType varchar(100),@FileSize bigint AS
BEGIN SET NOCOUNT ON; IF dbo.ChatEmployeeSubdomain(@ActorEmployeeID) IS NULL THROW 51000,'Employee has no valid subdomain.',1; INSERT dbo.ChatAttachment(UploadToken,UploadedBy,OriginalFileName,StoredFileName,ContentType,FileSize)VALUES(@UploadToken,@ActorEmployeeID,@OriginalFileName,@StoredFileName,@ContentType,@FileSize); END;
GO
CREATE PROCEDURE dbo.Chat_AuthorizeAttachment @ActorEmployeeID int,@AttachmentID bigint AS
BEGIN SET NOCOUNT ON; SELECT a.AttachmentID,a.OriginalFileName,a.StoredFileName,a.ContentType,a.FileSize FROM dbo.ChatAttachment a JOIN dbo.ChatMessage m ON m.MessageID=a.MessageID JOIN dbo.ChatConversation c ON c.ConversationID=m.ConversationID AND c.SubdomainID=dbo.ChatEmployeeSubdomain(@ActorEmployeeID) JOIN dbo.ChatConversationMember cm ON cm.ConversationID=c.ConversationID AND cm.EmployeeID=@ActorEmployeeID AND cm.IsActive=1 WHERE a.AttachmentID=@AttachmentID AND a.IsActive=1 AND m.IsDeleted=0; END;
GO
COMMIT;
