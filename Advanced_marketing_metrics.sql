/*
Use the CTE from the previous task in a new (second) CTE to create a sample with the following data:

ad_month: the first day of the month of the ad date (obtained from ad_date);
utm_campaign, total_cost, impressions, clicks, conversion_value, CTR, CPC, CPM, ROMI — the same fields with the same conditions as in the previous task.
Perform a final selection with the following fields:
ad_month;
utm_campaign, total_cost, impressions, clicks, conversion_value, CTR, CPC, CPM, ROMI;
For each utm_campaign in each month, add a new field: 'Difference between CPM, CTR, and ROMI' in the current month compared to the previous month in percentage.
*/

WITH CTE_1 
AS
( 
SELECT 
fabd.ad_date, 
fc.campaign_name,
fa.adset_name,
fabd.spend,
fabd.impressions,
fabd.reach,
fabd.clicks,
fabd.leads,
fabd.value,
fabd.url_parameters 
FROM facebook_ads_basic_daily fabd 
LEFT JOIN facebook_campaign fc USING (campaign_id)
LEFT JOIN facebook_adset fa USING (adset_id)

UNION ALL

SELECT ad_date,
campaign_name,
adset_name,
spend,
impressions,
reach,
clicks,
leads,
value,
url_parameters 
from google_ads_basic_daily gabd
),

CTE_2 
AS 
(
SELECT 
ad_date,
campaign_name,
adset_name,
CASE 
	WHEN spend = 0 THEN NULL
	ELSE spend
END AS spend,
CASE 
	WHEN impressions = 0 THEN NULL
	ELSE impressions
END AS impressions,
reach,
CASE 
	WHEN clicks = 0 THEN NULL
	ELSE clicks
END AS clicks,
leads,
value,
substring(url_parameters,'utm_source=([^&#$]+)') AS UTM_Source_parameters,
substring(url_parameters,'utm_medium=([^&#$]+)') AS UTM_Medium_parameters,
substring(url_parameters,'utm_campaign=([^&#$]+)') AS UTM_Campaign_parameters,
COALESCE (spend, 0),
COALESCE (impressions, 0),
COALESCE (reach, 0),
COALESCE (clicks, 0),
COALESCE (leads, 0),
COALESCE (value, 0)
FROM CTE_1 
),

CTE_3
AS
(
SELECT 
date_trunc ('Month',ad_date) AS ad_month,
CASE 
	WHEN utm_campaign_parameters = 'nan' THEN NULL
	WHEN utm_campaign_parameters = LOWER(utm_campaign_parameters) THEN utm_campaign_parameters
	ELSE NULL
END AS utm_z_warunkami,
 sum(spend) AS total_spend,
 sum(impressions) AS total_impressions,
 sum(clicks) AS total_clicks,
 sum(value) AS total_value,
 sum(spend)/sum(clicks) as CPC,
(sum(spend)/sum(clicks))*1000 as CPM,
(sum(clicks::float)/sum(impressions::float))*100 AS CTR,
((sum(value::float)-sum(spend::float))/sum(spend::float))*100 as ROMI

FROM CTE_2
GROUP BY ad_month, utm_z_warunkami
),

CTE_4
AS
(
SELECT 
ad_month,
utm_z_warunkami,
cpm,
ctr,
romi,
LAG (CPM,1) OVER (
PARTITION BY utm_z_warunkami
ORDER BY ad_month) AS prev_CPM,

LAG (CTR,1) OVER (
PARTITION BY utm_z_warunkami
ORDER BY ad_month) AS prev_CTR,

LAG (ROMI,1) OVER (
PARTITION BY utm_z_warunkami
ORDER BY ad_month) AS prev_ROMI

FROM CTE_3 

)

SELECT 
ad_month,
utm_z_warunkami,
prev_cpm,
cpm,
((cpm::float-prev_cpm::float)/prev_cpm::float)*100 AS diff_cpm,
prev_ctr,
ctr,
((ctr::float-prev_ctr::float)/prev_ctr::float)*100 AS diff_ctr,
prev_romi,
romi,
((romi::float-prev_romi::float)/prev_romi::float)*100 AS diff_romi
FROM CTE_4

