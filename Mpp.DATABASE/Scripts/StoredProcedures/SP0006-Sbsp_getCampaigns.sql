 IF EXISTS(
        SELECT*
        FROM sys.objects
        WHERE object_id = OBJECT_ID(N'[dbo].[Sbsp_getCampaigns]')

            AND type IN (
                N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE[dbo].[Sbsp_getCampaigns]
GO  
CREATE PROCEDURE [dbo].[Sbsp_getCampaigns]
(
@userId int,
@term varchar(50)
)
AS
BEGIN
	SET NOCOUNT ON;
IF EXISTS(SELECT * FROM MppUser WHERE MppUserID=@userId)
BEGIN
SELECT Name CampaignName,RecordID FROM Campaigns WHERE MppUserID=@userId and Name like @term+'%'
END
END
