IF EXISTS(
        SELECT*
        FROM sys.objects
        WHERE object_id = OBJECT_ID(N'[dbo].[Sbsp_UpdateSkuCount]')

            AND type IN (
                N'P'
				, N'PC'
				) 
		)
	DROP PROCEDURE[dbo].[Sbsp_UpdateSkuCount]
GO 
CREATE PROCEDURE [dbo].[Sbsp_UpdateSkuCount]
(	
	@UserID  INT,
	@campId BIGINT,
	@status TINYINT
)  
AS
BEGIN     
DECLARE @StartDate datetime;
DECLARE @EndDate datetime;
SET @StartDate = (SELECT Top 1 bl.PlanStartDate FROM Billing bl WHERE bl.MppUserId=@UserID order by ID desc);
SET @EndDate = (SELECT Top 1 bl.PlanEndDate FROM Billing bl WHERE bl.MppUserId=@UserID order by ID desc);

UPDATE Campaigns SET
		LastActiveOn=CASE WHEN (@status=1 AND Active=0) AND ((LastActiveOn NOT BETWEEN @StartDate AND @EndDate) OR (LastActiveOn IS NULL) OR DATEDIFF(DAY,LastActiveOn,LastDeactiveOn)<1) THEN GETDATE()  ELSE LastActiveOn END,
        LastDeactiveOn=CASE WHEN (@status=0 AND Active=1) AND ((LastDeactiveOn NOT BETWEEN @StartDate AND @EndDate) OR (LastDeactiveOn IS NULL) OR DATEDIFF(DAY,LastActiveOn,GETDATE())<1) THEN GETDATE() ELSE LastDeactiveOn END
WHERE MppUserID=@UserID and RecordID=@campId			   

UPDATE Campaigns SET 
		IncludeSku=(CASE WHEN @status=1 THEN 1
		WHEN @status=0 AND (DATEADD(DAY,1,LastActiveOn)<GETDATE() OR LastActiveOn IS NULL) THEN IncludeSku
		ELSE 0 END),
		ModifiedOn=GetDate() 
WHERE MppUserID=@UserID and RecordID=@campId

END