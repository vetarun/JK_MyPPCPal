IF NOT EXISTS(SELECT * FROM SYS.COLUMNS WHERE Name = N'LastActiveOn' AND ObJECT_ID = OBJECT_ID('Campaigns'))
BEGIN
    ALTER TABLE Campaigns ADD LastActiveOn DATETIME  NULL 
END
GO
IF NOT EXISTS(SELECT * FROM SYS.COLUMNS WHERE Name = N'LastDeactiveOn' AND ObJECT_ID = OBJECT_ID('Campaigns'))
BEGIN
    ALTER TABLE Campaigns ADD LastDeactiveOn DATETIME  NULL 
END
GO