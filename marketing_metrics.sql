/* the task was :
In the SQL query with CTE, combine data from these tables to obtain:

ad_date: the date of displaying ads on Google and Facebook;
campaign_name: the name of the campaign on Google and Facebook;
spend, impressions, reach, clicks, leads, value: campaign metrics and ad set metrics on specific days.
Similar to the task in the previous topic, create a sample from the resulting combined table (CTE):

ad_date: date of ad display
campaign_name: campaign name
Aggregate values for the following metrics grouped by date and campaign_name:
Total cost,
Number of impressions,
Number of clicks,
Total conversion value.
To accomplish this task, group the table by the ad_date and campaign_name fields.
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
)

SELECT ad_date,
campaign_name,
sum(spend) AS calkowity_koszt,
sum(impressions) AS liczba_wyswietlen,
sum(clicks) AS liczba_clickniec,
sum(value) AS calkowita_wartosc_konwersji
FROM a
GROUP BY 1,2
