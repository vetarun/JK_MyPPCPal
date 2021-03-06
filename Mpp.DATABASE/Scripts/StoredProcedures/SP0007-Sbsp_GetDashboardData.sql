IF EXISTS(
        SELECT*
        FROM sys.objects
        WHERE object_id = OBJECT_ID(N'[dbo].[Sbsp_GetDashboardData]')

            AND type IN (
                N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE[dbo].[Sbsp_GetDashboardData]
GO  
CREATE PROCEDURE [dbo].[Sbsp_GetDashboardData]
	@type int
AS
BEGIN
SET NOCOUNT ON;
	IF (@type=1) --paying
	SELECT u.MppUserID,Email,stp_custId,FirstName,LastName,Active,ProfileId,ProfileAccess,StartDate,PlanID,PlanStatus 
	FROM MppUser u join Billing b ON u.MppUserID = b.MppUserId WHERE PlanID not in  (1, 7)  and IsArchive = 0 
	and Active = 1 and stp_cardId is not null and PlanStatus = 1 and 
	b.CreatedOn = (SELECT MAX(CreatedOn) FROM Billing WHERE MppUserId = u.MppUserID)and b.Amount_off > 0
   
   ELSE 
   IF(@type=2)--new paying
   SELECT MppUser.MppUserID,Email,stp_custId,FirstName,LastName,Active,ProfileId,ProfileAccess,StartDate,PlanID,PlanStatus FROM MppUser
   WHERE MppUserID in (select u.MppUserID  FROM MppUser u join Billing b on b.MppUserId =u.MppUserID WHERE b.MppUserId in
   (SELECT  b.MppUserId  FROM  Billing b  WHERE CurrentPaymentStatus=1 and Amount_off>0 GROUP BY b.MppUserId
   HAVING count( b.CreatedOn)=1) and IsArchive=0 and Active=1 and PlanID not in (1,7) and PlanStatus=1 and  
   Amount_off in (SELECT sum(Amount_off ) FROM  Billing b  where CurrentPaymentStatus=1 and Amount_off>0 and 
   month(CreatedOn)=MONTH(getdate()) GROUP BY  b.MppUserId  HAVING COUNT( b.CreatedOn)=1))
   ELSE 
   IF(@type=3) --active trial
   SELECT MppUserID,Email,stp_custId,FirstName,LastName,Active,ProfileId,ProfileAccess,StartDate,PlanID,PlanStatus  
   FROM MppUser WHERE PlanID = 1 AND Active=1 and IsArchive=0 and ProfileAccess!=0 and ProfileId IS NOT NULL 
   and PlanStatus = 1
                     
   ELSE IF (@type=4) --pending confirmation
   SELECT MppUser.MppUserID,Email,stp_custId,FirstName,LastName,Active,ProfileId,ProfileAccess,StartDate,PlanID,PlanStatus 
   FROM MppUser join MppUserActivation ON MppUser.MppUserID = MppUserActivation.MppUserID  
   WHERE   IsArchive=0 and Active=0
                       
   ELSE 
   IF(@type=5) --pending access
   SELECT MppUser.MppUserID,Email,stp_custId,FirstName,LastName,Active,ProfileId,ProfileAccess,StartDate,PlanID,PlanStatus
   FROM MppUser  WHERE PlanID = 1 and  active=1 and ProfileAccess=0  and IsArchive=0 
                       
   ELSE IF (@type=6) --trial ended
   SELECT MppUser.MppUserID,Email,stp_custId,FirstName,LastName,Active,ProfileId,ProfileAccess,StartDate,PlanID,PlanStatus
   FROM MppUser  WHERE PlanID=7 and PlanStatus!=1 and stp_cardId is null and  IsArchive=0 and TrailEndDate<getDate() 
                       
   ELSE IF (@type = 7)  --un subscribe
   SELECT MppUser.MppUserID,Email,stp_custId,FirstName,LastName,Active,ProfileId,ProfileAccess,StartDate,PlanID,PlanStatus
   FROM MppUser  WHERE active = 1  and PlanStatus =2 and IsArchive=0                        
   ELSE
   SELECT MppUserID,Email,stp_custId,FirstName,LastName,Active,ProfileId,ProfileAccess,StartDate,PlanID,PlanStatus 
   FROM MppUser WHERE IsArchive=0 
END