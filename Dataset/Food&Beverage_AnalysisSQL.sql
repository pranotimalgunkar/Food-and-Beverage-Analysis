create database food_and_Beverage_Analysis

select * from dim_cities
select * from dim_repondents
select * from fact_survey_responses
/*
 Demographic Insights (examples) 
a. Who prefers energy drink more?  (male/female/non-binary?) 
b. Which age group prefers energy drinks more? 
c. Which type of marketing reaches the most Youth (15-30)?
*/
--a. Who prefers energy drink more?  (male/female/non-binary?)
select gender,count(*) as Gendervise_count from dim_repondents
group by Gender
order by Gendervise_count desc;
--Most of male are prefers energy drink

--b. Which age group prefers energy drinks more? 
select age,count(*) as Age_group_count from dim_repondents
group by age
order by Age_group_count desc;
-- age group between (19-30) prefers energy drinks more

--c. Which type of marketing reaches the most Youth (15-30)?
select marketing_channels, count(*) as Youth_19_30 from fact_survey_responses f
join dim_repondents d
On f.Respondent_ID=d.Respondent_ID
where age in ('15-18' ,'19-30')
group by marketing_channels
order by Youth_19_30 desc;
--Online ads of marketing reaches the most Youth (15-30)

/*
2. Consumer Preferences: 
a. What are the preferred ingredients of energy drinks among respondents? 
b. What packaging preferences do respondents have for energy drinks?
*/

--a. What are the preferred ingredients of energy drinks among respondents?
SELECT 
	Ingredients_expected,
	count(Respondent_id) as count_respondents 
FROM fact_survey_responses
GROUP BY Ingredients_expected
ORDER BY count_respondents DESC
--mostly Caffeine ingredient is preferred among respondents

--b. What packaging preferences do respondents have for energy drinks?
select Packaging_preference, count(Respondent_id) as respondents_preference from fact_survey_responses
group by Packaging_preference
order by respondents_preference desc;
-- Compact and portable cans are mostly prefered packaging for energy drinks

/*
3. Competition Analysis: 
a. Who are the current market leaders? 
b. What are the primary reasons consumers prefer those brands over ours?
*/

--a. Who are the current market leaders? 
select Current_brands,count(*) as Total_count from fact_survey_responses
group by Current_brands
order by Total_count desc;
--Cola-Coka is current market leaders

--b. What are the primary reasons consumers prefer those brands over ours?
select Reasons_for_choosing_brands,count(*) as Total_c from fact_survey_responses
GROUP BY Reasons_for_choosing_brands 
ORDER BY Total_c DESC;
--Brand reputation primary reasons consumers prefer those brands over ours 


/*
4. Marketing Channels and Brand Awareness: 
a. Which marketing channel can be used to reach more customers? 
b. How effective are different marketing strategies and channels in reaching our 
customers?
*/
--a. Which marketing channel can be used to reach more customers? 
SELECT Marketing_channels,COUNT(*) AS TOTAL_C FROM fact_survey_responses
GROUP BY Marketing_channels
ORDER BY TOTAL_C DESC;

--Online ads used to reach more customer.

--b. How effective are different marketing strategies and channels in reaching our customers?
select * from fact_survey_responses;

select f.Marketing_channels,
	sum(case when d.Age = '15-18' then 1 else 0 end )as age15_18,
	sum(case when d.Age = '19-30' then 1 else 0 end )as age19_30,
	sum(case when d.Age = '31-45' then 1 else 0 end )as age31_45,
	sum(case when d.Age = '46-65' then 1 else 0 end )as age46_65,
	sum(case when d.Age = '65+' then 1 else 0 end )as age65
from fact_survey_responses f
join dim_repondents d
ON f.Respondent_ID=d.Respondent_ID
group by Marketing_channels
order by count(*) desc;

/*
. Brand Penetration: 
a. What do people think about our brand? (overall rating) 
b. Which cities do we need to focus more on? 
*/

--a. What do people think about our brand? (overall rating)
select * from fact_survey_responses
select cast(avg(Taste_experience) as float) as avg_rating from fact_survey_responses
--overall rating is 3

--b. Which cities do we need to focus more on? 

select c.city,c.Tier,
	sum(case when f.brand_perception in ('Positive','Neutral') THEN 1 else 0 end) as positive_AND_neutral,
	sum(case when f.brand_perception ='Negative' THEN 1 else 0 end) as Negative
from dim_cities c
join dim_repondents d On c.city_id=d.city_id
join fact_survey_responses f  ON d.Respondent_ID=f.Respondent_ID
group  by c.city,c.Tier
--Need to  more focus on Tier 2 

/*
6. Purchase Behavior: 
a. Where do respondents prefer to purchase energy drinks? 
b. What are the typical consumption situations for energy drinks among 
respondents? 
c. What factors influence respondents' purchase decisions, such as price range and 
limited edition packaging?
*/
--a. Where do respondents prefer to purchase energy drinks? 
SELECT Purchase_location,COUNT(*) AS TOTAL_c FROM fact_survey_responses
GROUP BY Purchase_location
ORDER BY TOTAL_c DESC;
--Supermarket mostly prefer to purchase energy drinks

--b. What are the typical consumption situations for energy drinks among respondents? 
select Consume_reason, count(*) as T_count from fact_survey_responses
group by Consume_reason
order by T_count desc

-- incresed energy and focus is the typical consumption situations for energy drinks among respondents

--c. What factors influence respondents' purchase decisions, such as price range and 
--limited edition packaging?

select * from fact_survey_responses
select price_range ,  count(*) as Respondents_count from fact_survey_responses
group by Price_range
order by Respondents_count desc
--- price between 50-150 mostly prefered by consumers

select Limited_edition_packaging ,count(*) as Respondents_count from fact_survey_responses
group by Limited_edition_packaging
order by Respondents_count desc
--Most of reply for  limited edition packaging is NO.

/* Insights 
Most of male are prefers energy drink
age group between (19-30) prefers energy drinks more
Online ads of marketing reaches the most Youth (15-30)
mostly Caffeine ingredient is preferred among respondents
Compact and portable cans are mostly prefered packaging for energy drinks
Cola-Coka is current market leaders 
Brand reputation primary reasons consumers prefer those brands over ours 
Online ads used to reach more customer.
Need to  more focus on Tier 2 
--Supermarket mostly prefer to purchase energy drinks
incresed energy and focus is the typical consumption situations for energy drinks among respondents
price between 50-150 mostly prefered by consumers
Most of reply for  limited edition packaging is NO.
*/