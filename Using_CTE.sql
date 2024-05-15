/*
Task Description:

By combining data from four tables, identify the campaign with the highest Return on Marketing Investment (ROMI) among all campaigns with total expenditures exceeding 500,000. 
Within this campaign, identify the ad set group (adset_name) with the highest ROMI.
*/


WITH a AS (
SELECT fabd.ad_date, 
fc.campaign_name,
fa.adset_name,
fabd.spend,
fabd.impressions,
fabd.reach,
fabd.clicks,
fabd.leads,
fabd.value
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
value
from google_ads_basic_daily gabd
),

b AS (SELECT 
campaign_name,
sum(spend) AS calkowity_koszt,
((sum(value::float)-sum(spend::float))/sum(spend::float))*100 as ROMI
FROM a
WHERE campaign_name IS NOT NULL AND spend > 0
GROUP BY campaign_name
 ),

c AS (SELECT 
campaign_name,
calkowity_koszt,
ROMI
FROM b
WHERE calkowity_koszt > 500000
ORDER BY ROMI DESC
LIMIT 1)

SELECT 
campaign_name,
adset_name,
((sum(value::float)-sum(spend::float))/sum(spend::float))*100 as ROMI
FROM a 
WHERE campaign_name IN (SELECT campaign_name FROM c)
GROUP BY campaign_name, adset_name
ORDER BY ROMI DESC
LIMIT 1


