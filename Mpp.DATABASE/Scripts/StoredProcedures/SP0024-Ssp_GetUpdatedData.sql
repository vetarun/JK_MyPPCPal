
IF EXISTS(
        SELECT*
        FROM sys.objects
        WHERE object_id = OBJECT_ID(N'[dbo].[Sbsp_GetUpdatedData]')

            AND type IN (
                N'P'
				, N'PC'
				) 
		)
	DROP PROCEDURE[dbo].[Sbsp_GetUpdatedData]
GO 
CREATE PROCEDURE [dbo].[Sbsp_GetUpdatedData]
(
	@KeyID bigInt,
	@CID bigint,
	@AID bigint,
	@UserID bigint , 
	@ReportID int ,
	@ReasonID int ,
	@ModifiedOn smalldatetime 
)
AS
BEGIN		
     /* Keywords */
	BEGIN
		SELECT TOP 5000 m.MppUserID,o.ReportID,o.CampaignID,o.AdgroupID,o.KeywordID,o.ModifiedField,o.NewValue,m.ProfileId,m.AccessToken,m.RefreshToken,m.TokenType,m.AccessTokenUpdatedOn,m.TokenExpiresIn 
		FROM MppUser m JOIN Reports r on m.MppUserID = r.MppUserID JOIN OptimizeKeyLog  o on r.ReportID = o.ReportID join Keywords k on k.RecordID=o.KeywordID
		WHERE m.ProfileAccess !=0 and o.Type = 3 and m.MppUserID=@UserID and dateadd(day,30,o.ManuallyChangedOn )>(getdate()) and o.ReasonID=@ReasonID and o.ReportID=@ReportID and o.KeywordID=@KeyID and o.CampaignID=@CID and o.AdgroupID=@AID and cast(o.CreatedOn as date ) = cast(@ModifiedOn as date ) order by m.MppUserID    
	 /* SearchTerm */
	
        SELECT TOP 5000 m.MppUserID,o.ReportID,o.CampaignID,o.AdgroupID,o.KeywordID,o.Query,m.ProfileId,m.AccessToken,m.RefreshToken,m.TokenType,m.AccessTokenUpdatedOn,m.TokenExpiresIn 
		FROM MppUser m JOIN Reports r on m.MppUserID = r.MppUserID JOIN OptimizeKeyLog  o on r.ReportID = o.ReportID join Keywords k on k.RecordID=o.KeywordID
		WHERE m.ProfileAccess !=0 and o.Type = 4 and m.MppUserID=@UserID and  dateadd(day,30,o.ManuallyChangedOn )>(getdate())and o.KeywordID=@KeyID and o.ReasonID=@ReasonID and o.ReportID=@ReportID and o.CampaignID=@CID and o.AdgroupID=@AID and cast(o.CreatedOn as date ) = cast(@ModifiedOn as date )  order by m.MppUserID   
	END
END
