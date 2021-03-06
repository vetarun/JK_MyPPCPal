IF EXISTS(
        SELECT*
        FROM sys.objects
        WHERE object_id = OBJECT_ID(N'[dbo].[Sbsp_GetOptimizedKeysToUpdateOnAmz]')

            AND type IN (
                N'P'
				, N'PC'
				) 
		)
	DROP PROCEDURE[dbo].[Sbsp_GetOptimizedKeysToUpdateOnAmz]
	GO
CREATE PROCEDURE [dbo].[Sbsp_GetOptimizedKeysToUpdateOnAmz] 
(  
 @type int,  
 @date smalldatetime  
)  
AS  
BEGIN    
    IF(@type = 3) /* Keywords */  
 BEGIN  
  SELECT TOP 5000 m.MppUserID,o.ReportID,o.CampaignID,o.AdgroupID,o.KeywordID,o.ModifiedField,o.NewValue,m.ProfileId,m.AccessToken,m.RefreshToken,m.TokenType,m.AccessTokenUpdatedOn,m.TokenExpiresIn   
  FROM MppUser m JOIN Reports r on m.MppUserID = r.MppUserID JOIN OptimizeKeyLog  o on r.ReportID = o.ReportID  
  WHERE m.ProfileAccess !=0 and o.Type = @type and o.UpdateStatus=0 and CAST(r.OptimizeDate as DATE)=CAST(@date AS DATE) order by m.MppUserID      
 END  
 ELSE IF(@type = 4) /* SearchTerm */  
 BEGIN  
        SELECT TOP 5000 m.MppUserID,o.ReportID,o.CampaignID,o.AdgroupID,o.KeywordID,o.Query,m.ProfileId,m.AccessToken,m.RefreshToken,m.TokenType,m.AccessTokenUpdatedOn,m.TokenExpiresIn   
  FROM MppUser m JOIN Reports r on m.MppUserID = r.MppUserID JOIN OptimizeKeyLog  o on r.ReportID = o.ReportID  
  WHERE m.ProfileAccess !=0 and o.Type = @type and o.UpdateStatus=0 and CAST(r.OptimizeDate as DATE)=CAST(@date AS DATE) order by m.MppUserID     
 END  
END  