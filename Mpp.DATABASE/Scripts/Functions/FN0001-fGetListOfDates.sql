IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE Name = N'fGetListOfDates')
BEGIN
	DROP FUNCTION fGetListOfDates
END
GO

IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE Name = N'GetRequestCount')
BEGIN
	DROP FUNCTION GetRequestCount
END
GO
CREATE FUNCTION fGetListOfDates
(
	@startDate DATETIME, -- start date
	@endDate DATETIME    -- end date
)
RETURNS  @retDates TABLE
(
	[DATE] DATETIME      -- date time
)
AS
BEGIN
    WITH tblDates([DATE]) AS
    (
	SELECT @startDate AS [DATE]
	 UNION ALL
	SELECT DATEADD(d,1,[DATE])
	  FROM tblDates
         WHERE [DATE] < @endDate
    )
 
    INSERT INTO @retDates
    SELECT [DATE]
      FROM tblDates 
 
    RETURN
END
GO
