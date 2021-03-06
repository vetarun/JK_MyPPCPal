IF EXISTS(
        SELECT*
        FROM sys.objects
        WHERE object_id = OBJECT_ID(N'[dbo].[Sbsp_GetMPPClients]')

            AND type IN (
                N'P'
				, N'PC'
				) 
		)
	DROP PROCEDURE[dbo].[Sbsp_GetMPPClients]
GO 
CREATE PROCEDURE [dbo].[Sbsp_GetMPPClients]   
@term varchar(50)=''  
AS  
BEGIN  
IF(@term<>'')  
BEGIN  
SELECT MppUserID Id,FirstName+' '+LastName Name FROM MppUser WHERE  FirstName+' '+LastName like @term+'%' --AND Active=1  
ORDER BY FirstName  
END  
END  
  