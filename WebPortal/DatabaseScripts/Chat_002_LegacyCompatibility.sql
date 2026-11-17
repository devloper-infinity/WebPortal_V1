/*
 Infinity ERP Chat - compatibility repair for databases below compatibility level 110.
 Run after Chat_001 when it reported TRY_CONVERT/THROW errors. Existing chat tables/data are preserved.
*/
SET XACT_ABORT ON;
GO
IF OBJECT_ID('dbo.Chat_AuthorizeAttachment','P') IS NOT NULL DROP PROCEDURE dbo.Chat_AuthorizeAttachment;
IF OBJECT_ID('dbo.Chat_StageAttachment','P') IS NOT NULL DROP PROCEDURE dbo.Chat_StageAttachment;
IF OBJECT_ID('dbo.Chat_MarkRead','P') IS NOT NULL DROP PROCEDURE dbo.Chat_MarkRead;
IF OBJECT_ID('dbo.Chat_SendMessage','P') IS NOT NULL DROP PROCEDURE dbo.Chat_SendMessage;
IF OBJECT_ID('dbo.Chat_GetMessages','P') IS NOT NULL DROP PROCEDURE dbo.Chat_GetMessages;
IF OBJECT_ID('dbo.Chat_CreateGroup','P') IS NOT NULL DROP PROCEDURE dbo.Chat_CreateGroup;
IF OBJECT_ID('dbo.Chat_OpenDirectConversation','P') IS NOT NULL DROP PROCEDURE dbo.Chat_OpenDirectConversation;
IF OBJECT_ID('dbo.Chat_Bootstrap','P') IS NOT NULL DROP PROCEDURE dbo.Chat_Bootstrap;
IF OBJECT_ID('dbo.Chat_AssertMember','P') IS NOT NULL DROP PROCEDURE dbo.Chat_AssertMember;
GO
IF OBJECT_ID('dbo.ChatEmployeeSubdomain','FN') IS NOT NULL DROP FUNCTION dbo.ChatEmployeeSubdomain;
GO
CREATE FUNCTION dbo.ChatEmployeeSubdomain(@EmployeeID int) RETURNS nvarchar(100) AS
BEGIN
 RETURN (SELECT NULLIF(UPPER(LTRIM(RTRIM(CONVERT(nvarchar(100),SubDomain)))),N'') FROM dbo.EmployeeInfo WHERE EmployeeID=@EmployeeID AND ISNULL(IsDelete,0)=0);
END;
GO
CREATE PROCEDURE dbo.Chat_AssertMember @ActorEmployeeID int,@ConversationID bigint AS
BEGIN SET NOCOUNT ON; DECLARE @S nvarchar(100);SET @S=dbo.ChatEmployeeSubdomain(@ActorEmployeeID);
 IF @S IS NULL BEGIN RAISERROR('Employee has no valid subdomain.',16,1);RETURN 1;END
 IF NOT EXISTS(SELECT 1 FROM dbo.ChatConversation c JOIN dbo.ChatConversationMember m ON m.ConversationID=c.ConversationID AND m.EmployeeID=@ActorEmployeeID AND m.IsActive=1 WHERE c.ConversationID=@ConversationID AND c.IsActive=1 AND c.IsCrossDomain=0 AND c.SubdomainID=@S) BEGIN RAISERROR('Conversation access denied.',16,1);RETURN 1;END
 RETURN 0;END;
GO
CREATE PROCEDURE dbo.Chat_Bootstrap @ActorEmployeeID int,@Search nvarchar(100)=N'' AS
BEGIN SET NOCOUNT ON;DECLARE @S nvarchar(100);SET @S=dbo.ChatEmployeeSubdomain(@ActorEmployeeID);IF @S IS NULL BEGIN RAISERROR('Employee has no valid subdomain.',16,1);RETURN;END
 SELECT e.EmployeeID,e.Code+CASE WHEN NULLIF(LTRIM(RTRIM(ISNULL(ec.PsuedoName,''))),'') IS NULL THEN '' ELSE ' - '+LTRIM(RTRIM(ec.PsuedoName)) END Code,LTRIM(RTRIM(ISNULL(e.FirstName,'')+' '+ISNULL(e.lastName,''))) EmployeeName FROM dbo.EmployeeInfo e OUTER APPLY(SELECT TOP 1 c.PsuedoName FROM dbo.EmployeeConfiguration c WHERE (c.EmployeeID=e.EmployeeID OR c.Code=e.Code) AND c.DataSource='ERP' AND ISNULL(c.IsDelete,0)=0 ORDER BY c.AddedDate DESC,c.EmpConfigrationID DESC)ec WHERE e.EmployeeID<>@ActorEmployeeID AND ISNULL(e.IsDelete,0)=0 AND dbo.ChatEmployeeSubdomain(e.EmployeeID)=@S AND (@Search=N'' OR e.Code LIKE '%'+@Search+'%' OR e.FirstName LIKE '%'+@Search+'%' OR e.lastName LIKE '%'+@Search+'%' OR ec.PsuedoName LIKE '%'+@Search+'%') ORDER BY EmployeeName;
 SELECT c.ConversationID,c.ConversationType,CASE WHEN c.ConversationType='G' THEN c.ConversationName ELSE LTRIM(RTRIM(ISNULL(o.FirstName,'')+' '+ISNULL(o.lastName,''))) END ConversationName,MAX(msg.MessageID) LastMessageID,MAX(msg.SentOn) LastMessageOn,COUNT(CASE WHEN msg.MessageID>ISNULL(me.LastReadMessageID,0) AND msg.SenderEmployeeID<>@ActorEmployeeID THEN 1 END) UnreadCount FROM dbo.ChatConversationMember me JOIN dbo.ChatConversation c ON c.ConversationID=me.ConversationID AND c.SubdomainID=@S AND c.IsCrossDomain=0 AND c.IsActive=1 LEFT JOIN dbo.ChatConversationMember om ON om.ConversationID=c.ConversationID AND om.EmployeeID<>@ActorEmployeeID AND c.ConversationType='D' LEFT JOIN dbo.EmployeeInfo o ON o.EmployeeID=om.EmployeeID LEFT JOIN dbo.ChatMessage msg ON msg.ConversationID=c.ConversationID AND msg.IsDeleted=0 WHERE me.EmployeeID=@ActorEmployeeID AND me.IsActive=1 GROUP BY c.ConversationID,c.ConversationType,c.ConversationName,o.FirstName,o.lastName,me.LastReadMessageID ORDER BY LastMessageOn DESC;
 SELECT @ActorEmployeeID EmployeeID,@S SubdomainID;END;
GO
CREATE PROCEDURE dbo.Chat_OpenDirectConversation @ActorEmployeeID int,@OtherEmployeeID int AS
BEGIN SET NOCOUNT ON;SET XACT_ABORT ON;DECLARE @S nvarchar(100),@OS nvarchar(100),@Key varchar(50),@ID bigint;SET @S=dbo.ChatEmployeeSubdomain(@ActorEmployeeID);SET @OS=dbo.ChatEmployeeSubdomain(@OtherEmployeeID);IF @S IS NULL OR @OS<>@S OR @ActorEmployeeID=@OtherEmployeeID BEGIN RAISERROR('Employee is outside your subdomain.',16,1);RETURN;END
 SET @Key=CONVERT(varchar(20),CASE WHEN @ActorEmployeeID<@OtherEmployeeID THEN @ActorEmployeeID ELSE @OtherEmployeeID END)+':'+CONVERT(varchar(20),CASE WHEN @ActorEmployeeID<@OtherEmployeeID THEN @OtherEmployeeID ELSE @ActorEmployeeID END);
 BEGIN TRAN;SELECT @ID=ConversationID FROM dbo.ChatConversation WITH(UPDLOCK,HOLDLOCK) WHERE SubdomainID=@S AND DirectKey=@Key AND IsCrossDomain=0 AND IsActive=1;IF @ID IS NULL BEGIN INSERT dbo.ChatConversation(SubdomainID,ConversationType,DirectKey,CreatedBy)VALUES(@S,'D',@Key,@ActorEmployeeID);SET @ID=SCOPE_IDENTITY();INSERT dbo.ChatConversationMember(ConversationID,EmployeeID)VALUES(@ID,@ActorEmployeeID),(@ID,@OtherEmployeeID);END COMMIT;SELECT @ID ConversationID;END;
GO
CREATE PROCEDURE dbo.Chat_CreateGroup @ActorEmployeeID int,@Name nvarchar(120),@MemberEmployeeIDs nvarchar(max) AS
BEGIN SET NOCOUNT ON;SET XACT_ABORT ON;DECLARE @S nvarchar(100),@Xml xml,@ID bigint;SET @S=dbo.ChatEmployeeSubdomain(@ActorEmployeeID);IF @S IS NULL OR NULLIF(LTRIM(RTRIM(@Name)),'') IS NULL BEGIN RAISERROR('Valid group name required.',16,1);RETURN;END
 SET @Xml=CAST('<x>'+REPLACE(REPLACE(ISNULL(@MemberEmployeeIDs,''),'&','&amp;'),',','</x><x>')+'</x>' AS xml);DECLARE @M TABLE(EmployeeID int PRIMARY KEY);INSERT @M SELECT DISTINCT CONVERT(int,n.value('.','varchar(20)')) FROM @Xml.nodes('/x')t(n) WHERE n.value('.','varchar(20)')<>'' AND LEN(n.value('.','varchar(20)'))<=9 AND n.value('.','varchar(20)') NOT LIKE '%[^0-9]%';INSERT @M SELECT @ActorEmployeeID WHERE NOT EXISTS(SELECT 1 FROM @M WHERE EmployeeID=@ActorEmployeeID);
 IF EXISTS(SELECT 1 FROM @M m LEFT JOIN dbo.EmployeeInfo e ON e.EmployeeID=m.EmployeeID AND ISNULL(e.IsDelete,0)=0 AND dbo.ChatEmployeeSubdomain(e.EmployeeID)=@S WHERE e.EmployeeID IS NULL) BEGIN RAISERROR('All group members must belong to your subdomain.',16,1);RETURN;END
 BEGIN TRAN;INSERT dbo.ChatConversation(SubdomainID,ConversationType,ConversationName,CreatedBy)VALUES(@S,'G',LTRIM(RTRIM(@Name)),@ActorEmployeeID);SET @ID=SCOPE_IDENTITY();INSERT dbo.ChatConversationMember(ConversationID,EmployeeID,IsAdmin)SELECT @ID,EmployeeID,CASE WHEN EmployeeID=@ActorEmployeeID THEN 1 ELSE 0 END FROM @M;COMMIT;SELECT @ID ConversationID;END;
GO
CREATE PROCEDURE dbo.Chat_GetMessages @ActorEmployeeID int,@ConversationID bigint,@BeforeMessageID bigint=NULL,@PageSize int=40,@Search nvarchar(100)=N'' AS
BEGIN SET NOCOUNT ON;DECLARE @R int;EXEC @R=dbo.Chat_AssertMember @ActorEmployeeID,@ConversationID;IF @R<>0 RETURN;SELECT TOP(@PageSize) m.MessageID,m.ConversationID,m.SenderEmployeeID,LTRIM(RTRIM(ISNULL(e.FirstName,'')+' '+ISNULL(e.lastName,''))) SenderName,m.Body,m.SentOn,a.AttachmentID,a.OriginalFileName,a.ContentType,a.FileSize,(SELECT COUNT(*) FROM dbo.ChatConversationMember cm WHERE cm.ConversationID=m.ConversationID AND cm.EmployeeID<>m.SenderEmployeeID AND cm.LastReadMessageID>=m.MessageID) ReadCount FROM dbo.ChatMessage m JOIN dbo.EmployeeInfo e ON e.EmployeeID=m.SenderEmployeeID LEFT JOIN dbo.ChatAttachment a ON a.MessageID=m.MessageID AND a.IsActive=1 WHERE m.ConversationID=@ConversationID AND m.IsDeleted=0 AND (@BeforeMessageID IS NULL OR m.MessageID<@BeforeMessageID) AND (@Search=N'' OR m.Body LIKE '%'+@Search+'%' OR a.OriginalFileName LIKE '%'+@Search+'%') ORDER BY m.MessageID DESC;END;
GO
CREATE PROCEDURE dbo.Chat_SendMessage @ActorEmployeeID int,@ConversationID bigint,@Body nvarchar(4000),@UploadToken uniqueidentifier=NULL AS
BEGIN SET NOCOUNT ON;SET XACT_ABORT ON;DECLARE @R int,@ID bigint;EXEC @R=dbo.Chat_AssertMember @ActorEmployeeID,@ConversationID;IF @R<>0 RETURN;IF NULLIF(LTRIM(RTRIM(@Body)),N'') IS NULL AND @UploadToken IS NULL BEGIN RAISERROR('Message or attachment required.',16,1);RETURN;END IF @UploadToken IS NOT NULL AND NOT EXISTS(SELECT 1 FROM dbo.ChatAttachment WHERE UploadToken=@UploadToken AND UploadedBy=@ActorEmployeeID AND MessageID IS NULL AND IsActive=1) BEGIN RAISERROR('Invalid attachment.',16,1);RETURN;END
 BEGIN TRAN;INSERT dbo.ChatMessage(ConversationID,SenderEmployeeID,Body)VALUES(@ConversationID,@ActorEmployeeID,NULLIF(LTRIM(RTRIM(@Body)),N''));SET @ID=SCOPE_IDENTITY();IF @UploadToken IS NOT NULL UPDATE dbo.ChatAttachment SET MessageID=@ID WHERE UploadToken=@UploadToken AND UploadedBy=@ActorEmployeeID AND MessageID IS NULL;COMMIT;SELECT m.MessageID,m.ConversationID,m.SenderEmployeeID,m.Body,m.SentOn FROM dbo.ChatMessage m WHERE m.MessageID=@ID;SELECT EmployeeID FROM dbo.ChatConversationMember WHERE ConversationID=@ConversationID AND IsActive=1;END;
GO
CREATE PROCEDURE dbo.Chat_MarkRead @ActorEmployeeID int,@ConversationID bigint,@ThroughMessageID bigint AS
BEGIN SET NOCOUNT ON;DECLARE @R int;EXEC @R=dbo.Chat_AssertMember @ActorEmployeeID,@ConversationID;IF @R<>0 RETURN;IF NOT EXISTS(SELECT 1 FROM dbo.ChatMessage WHERE ConversationID=@ConversationID AND MessageID=@ThroughMessageID) BEGIN RAISERROR('Invalid message.',16,1);RETURN;END UPDATE dbo.ChatConversationMember SET LastReadMessageID=CASE WHEN ISNULL(LastReadMessageID,0)<@ThroughMessageID THEN @ThroughMessageID ELSE LastReadMessageID END WHERE ConversationID=@ConversationID AND EmployeeID=@ActorEmployeeID;SELECT @ConversationID ConversationID,@ThroughMessageID MessageID,@ActorEmployeeID EmployeeID;END;
GO
CREATE PROCEDURE dbo.Chat_StageAttachment @ActorEmployeeID int,@UploadToken uniqueidentifier,@OriginalFileName nvarchar(255),@StoredFileName nvarchar(255),@ContentType varchar(100),@FileSize bigint AS
BEGIN SET NOCOUNT ON;IF dbo.ChatEmployeeSubdomain(@ActorEmployeeID) IS NULL BEGIN RAISERROR('Employee has no valid subdomain.',16,1);RETURN;END INSERT dbo.ChatAttachment(UploadToken,UploadedBy,OriginalFileName,StoredFileName,ContentType,FileSize)VALUES(@UploadToken,@ActorEmployeeID,@OriginalFileName,@StoredFileName,@ContentType,@FileSize);END;
GO
CREATE PROCEDURE dbo.Chat_AuthorizeAttachment @ActorEmployeeID int,@AttachmentID bigint AS
BEGIN SET NOCOUNT ON;SELECT a.AttachmentID,a.OriginalFileName,a.StoredFileName,a.ContentType,a.FileSize FROM dbo.ChatAttachment a JOIN dbo.ChatMessage m ON m.MessageID=a.MessageID JOIN dbo.ChatConversation c ON c.ConversationID=m.ConversationID AND c.IsCrossDomain=0 AND c.SubdomainID=dbo.ChatEmployeeSubdomain(@ActorEmployeeID) JOIN dbo.ChatConversationMember cm ON cm.ConversationID=c.ConversationID AND cm.EmployeeID=@ActorEmployeeID AND cm.IsActive=1 WHERE a.AttachmentID=@AttachmentID AND a.IsActive=1 AND m.IsDeleted=0;END;
GO
