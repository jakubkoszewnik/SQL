# SQL
Using PostGres SQL i've done few tasks:

# Marketing_Metrics
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

# Using_CTE
By combining data from four tables, identify the campaign with the highest Return on Marketing Investment (ROMI) among all campaigns with total expenditures exceeding 500,000. 
Within this campaign, identify the ad set group (adset_name) with the highest ROMI.

# UTM_Markers
In the CTE query, combine data from the above tables to obtain:

ad_date: the date of displaying ads on Google and Facebook;
url_parameters: the part of the campaign's URL containing UTM parameters;
spend, impressions, reach, clicks, leads, value: campaign and ad metrics on specific days. If a table lacks values for any of these metrics (i.e., the value is NULL), set the value to zero.

Based on the results obtained using CTE, retrieve the following data:

ad_date: the date of the ad;
utm_campaign: the value of the utm_campaign parameter from the utm_parameters field, meeting the following conditions:
All letters are lowercase.
If the value of utm_campaign in utm_parameters is equal to 'nan', it should be null in the result table.

# Advanced_Marketing_Metrics
Use the CTE from the previous task in a new (second) CTE to create a sample with the following data:

ad_month: the first day of the month of the ad date (obtained from ad_date);
utm_campaign, total_cost, impressions, clicks, conversion_value, CTR, CPC, CPM, ROMI — the same fields with the same conditions as in the previous task.
Perform a final selection with the following fields:
ad_month;
utm_campaign, total_cost, impressions, clicks, conversion_value, CTR, CPC, CPM, ROMI;
For each utm_campaign in each month, add a new field: 'Difference between CPM, CTR, and ROMI' in the current month compared to the previous month in percentage.
