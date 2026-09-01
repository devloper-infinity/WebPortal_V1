/* Generated from workbook sheet: Error 1 to 4. Do not hand-edit source values. */

SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRANSACTION;

INSERT dbo.ErrorType1Master (ID, Name, IsActive, DisplayOrder, AddedBy, AddedDate) VALUES
    (1, N'Data_Entry', 1, 1, 0, GETDATE()),
    (2, N'Condition', 1, 2, 0, GETDATE());

INSERT dbo.ErrorType2Master (ID, ErrorType1ID, Name, IsActive, DisplayOrder, AddedBy, AddedDate) VALUES
    (1, 1, N'Incorrect_Value', 1, 1, 0, GETDATE()),
    (2, 1, N'Blank_Field', 1, 2, 0, GETDATE()),
    (3, 2, N'Missing_Condition', 1, 3, 0, GETDATE()),
    (4, 2, N'Invalid_Condition', 1, 4, 0, GETDATE()),
    (5, 2, N'Incorrect_Verbiage', 1, 5, 0, GETDATE());

INSERT dbo.ErrorType3Master (ID, ErrorType2ID, Name, IsActive, DisplayOrder, AddedBy, AddedDate) VALUES
    (1, 1, N'Typo Error', 1, 1, 0, GETDATE()),
    (2, 1, N'Incorrect Document Used', 1, 2, 0, GETDATE()),
    (3, 1, N'Document Misinterpreted', 1, 3, 0, GETDATE()),
    (4, 1, N'Document Overlooked', 1, 4, 0, GETDATE()),
    (5, 2, N'Typo Error', 1, 5, 0, GETDATE()),
    (6, 2, N'Incorrect Document Used', 1, 6, 0, GETDATE()),
    (7, 2, N'Document Misinterpreted', 1, 7, 0, GETDATE()),
    (8, 2, N'Document Overlooked', 1, 8, 0, GETDATE()),
    (9, 3, N'Missing Document', 1, 9, 0, GETDATE()),
    (10, 3, N'Incorrect Document Used', 1, 10, 0, GETDATE()),
    (11, 3, N'Incomplete Document', 1, 11, 0, GETDATE()),
    (12, 3, N'Document Misinterpreted', 1, 12, 0, GETDATE()),
    (13, 3, N'Underwriting - Calculation', 1, 13, 0, GETDATE()),
    (14, 3, N'Underwriting - Guideline Misinterpretation', 1, 14, 0, GETDATE()),
    (15, 3, N'Underwriting - Guideline not followed', 1, 15, 0, GETDATE()),
    (16, 3, N'Document Overlooked', 1, 16, 0, GETDATE()),
    (17, 4, N'Missing Document', 1, 17, 0, GETDATE()),
    (18, 4, N'Incorrect Document Used', 1, 18, 0, GETDATE()),
    (19, 4, N'Incomplete Document', 1, 19, 0, GETDATE()),
    (20, 4, N'Document Misinterpreted', 1, 20, 0, GETDATE()),
    (21, 4, N'Underwriting - Calculation', 1, 21, 0, GETDATE()),
    (22, 4, N'Underwriting - Guideline Misinterpretation', 1, 22, 0, GETDATE()),
    (23, 4, N'Underwriting - Guideline not followed', 1, 23, 0, GETDATE()),
    (24, 4, N'Document Overlooked', 1, 24, 0, GETDATE()),
    (25, 5, N'Missing Document', 1, 25, 0, GETDATE()),
    (26, 5, N'Incorrect Document Used', 1, 26, 0, GETDATE()),
    (27, 5, N'Incomplete Document', 1, 27, 0, GETDATE()),
    (28, 5, N'Document Misinterpreted', 1, 28, 0, GETDATE()),
    (29, 5, N'Underwriting - Calculation', 1, 29, 0, GETDATE()),
    (30, 5, N'Underwriting - Guideline Misinterpretation', 1, 30, 0, GETDATE()),
    (31, 5, N'Underwriting - Guideline not followed', 1, 31, 0, GETDATE()),
    (32, 5, N'Document Overlooked', 1, 32, 0, GETDATE());

INSERT dbo.ErrorType4Master (ID, Name, IsActive, DisplayOrder, AddedBy, AddedDate) VALUES
    (1, N'Collateral', 1, 1, 0, GETDATE()),
    (2, N'Property', 1, 2, 0, GETDATE()),
    (3, N'Credit', 1, 3, 0, GETDATE()),
    (4, N'Income', 1, 4, 0, GETDATE()),
    (5, N'Assets', 1, 5, 0, GETDATE()),
    (6, N'Compliance', 1, 6, 0, GETDATE()),
    (7, N'General UW', 1, 7, 0, GETDATE()),
    (8, N'Miscelleneous', 1, 8, 0, GETDATE()),
    (9, N'TRID', 1, 9, 0, GETDATE());

INSERT dbo.ErrorType8Master (ID, Name, IsActive, DisplayOrder, AddedBy, AddedDate) VALUES
    (1, N'Careless Error', 1, 1, 0, GETDATE()),
    (2, N'Knowledge Gap', 1, 2, 0, GETDATE()),
    (3, N'System Issue', 1, 3, 0, GETDATE());

INSERT dbo.ErrorType9Master (ID, Name, IsActive, DisplayOrder, AddedBy, AddedDate) VALUES
    (1, N'People', 1, 1, 0, GETDATE()),
    (2, N'Process', 1, 2, 0, GETDATE()),
    (3, N'Machine', 1, 3, 0, GETDATE());

COMMIT TRANSACTION;

GO

