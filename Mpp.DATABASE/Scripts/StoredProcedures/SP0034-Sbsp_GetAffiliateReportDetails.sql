IF EXISTS(
        SELECT*
        FROM sys.objects
        WHERE object_id = OBJECT_ID(N'[dbo].[Sbsp_GetAffiliateReportDetails]')

            AND type IN (
                N'P'
				, N'PC'
				) 
		)
	DROP PROCEDURE[dbo].[Sbsp_GetAffiliateReportDetails]
GO

CREATE PROCEDURE [dbo].[Sbsp_GetAffiliateReportDetails] 
(	
	@AffiliateID    int
)
AS
BEGIN
SELECT YEAR(PlanStartDate) as SalesYear,
MONTH(PlanStartDate) as SalesMonth,
SUM(Amount_off) AS TotalSales,
SUM(Amount) AS TotalPreSales,
COUNT(MppUserId) AS TotalUsers,
SUM(ISNULL(AffiliateEarning,0.0)) AS Commision
FROM Billing where AffiliateID = @AffiliateID
GROUP BY YEAR(PlanStartDate), MONTH(PlanStartDate), AffiliateID
ORDER BY YEAR(PlanStartDate), MONTH(PlanStartDate)

SELECT af.AffiliateCode,af.CreatedOn, Count(bl.MppUserId) as TotalUsers,
 ISNULL(SUM(bl.Amount_off),0)  as TotalSales,ISNULL(af.Percentile_off,0.00) Percentile_off,
 ISNULL(af.Amount,0.00) Amount,SUM(ISNULL(bl.AffiliateEarning,0.0)) AS Commision,
 ISNULL(af.Redeemby,GETDATE()) Redeemby
 from Billing bl join AffiliationCode af on bl.AffiliateID=af.AffiliateID 
where bl.AffiliateID = @AffiliateID
GROUP BY af.AffiliateCode, af.CreatedOn,af.Percentile_off,af.Amount,af.Redeemby
END

