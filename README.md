# Google Data Analytics Capstone project on Cyclistic bike-share case study (SQL and Tableau)

## Introduction

This repository includes the Google Data Analytics Capstone project on the Cyclistic bike-share case study. Since the data set in this case study had more than 5 million records, I preferred to use SQL  and Tableau visualization instead of spreadsheets and pivot tables. 

## Scenario

I am assumed to be a junior data analyst working on the marketing analyst team at Cyclsitic, a fiction bike-share company in Chicago. The director of marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore, my team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these
insights, my team will design a new marketing strategy to convert casual riders into annual
members. 

## Characters and teams

● Cyclistic: A bike-share program that features more than 5,800 bicycles and 600
docking stations. 

● Lily Moreno: The director of marketing and my manager. Moreno is responsible for
the development of campaigns and initiatives to promote the bike-share program.
These may include email, social media, and other channels.

● Cyclistic marketing analytics team: A team of data analysts who are responsible for
collecting, analyzing, and reporting data that helps guide Cyclistic marketing strategy.
I joined this team and have been busy learning about Cyclistic’s mission and business goals—as well as how I, as a junior data analyst, can help
Cyclistic achieve them.

● Cyclistic executive team: The notoriously detail-oriented executive team will decide
whether to approve the recommended marketing program.

## ASK

Three questions will guide the future marketing program:
1. How do annual members and casual riders use Cyclistic bikes differently?
2. Why would casual riders buy Cyclistic annual memberships?
3. How can Cyclistic use digital media to influence casual riders to become members?

Moreno has assigned me the first question to answer: How do annual members and casual
riders use Cyclistic bikes differently?

## Prepare data

The data set used for this case study is the previous 12 months of Cyclistic trip data collected from [here](https://divvy-tripdata.s3.amazonaws.com/index.html). 
The data has been made available by Motivate International Inc. under this [license](https://divvybikes.com/data-license-agreement) .

The last 12 months of Cyclistic trip data were from 08/2023 to 07/2024 each month in separate .csv files. 
So, I combined all 12 months into a new table as "Combined_Bike_Share" by using the UNION function in SQL:

```SQL
USE [GoogleCapstoneProject Ride share]
GO
SELECT * INTO Combined_Bike_Share
FROM [dbo].[202308-divvy-tripdata]
UNION
SELECT *
FROM [dbo].[202309-divvy-tripdata]
UNION
SELECT *
FROM [dbo].[202310-divvy-tripdata]
UNION
SELECT *
FROM [dbo].[202311-divvy-tripdata]
UNION
SELECT *
FROM [dbo].[202312-divvy-tripdata]
UNION
SELECT *
FROM [dbo].[202401-divvy-tripdata]
UNION
SELECT *
FROM [dbo].[202402-divvy-tripdata]
UNION
SELECT *
FROM [dbo].[202403-divvy-tripdata]
UNION
SELECT *
FROM [dbo].[202404-divvy-tripdata]
UNION
SELECT *
FROM [dbo].[202405-divvy-tripdata]
UNION
SELECT *
FROM [dbo].[202406-divvy-tripdata]
UNION
SELECT *
FROM [dbo].[202407-divvy-tripdata]
```

There is a total of 5,715,693 rows in the combined dataset.


![1](https://github.com/user-attachments/assets/d441f2e0-65f6-4a12-9096-dddf4dd642e3)


The column's name and properties are the same below:


![2](https://github.com/user-attachments/assets/4ddf358a-7e43-42d9-81a3-8a7a4b94b82d)


## Processing and cleaning

In this step, I checked if there were any duplicates, outliers, and null data and then cleaned them.

### CLEANING DUPLICATES:

Let's check if there were any duplicate records in ride_id:

```SQL
USE [GoogleCapstoneProject Ride share]
GO

SELECT COUNT([ride_id]) AS ride_records ,
COUNT(DISTINCT([ride_id])) AS ride_records_without_duplicate 
FROM [dbo].[Combined_Bike_Share];
```
In output, we had 5,715,693 total ride_records and 5,715,482 for ride_records without duplicates, so we need to delete duplicate records by running the codes below:

```SQL
WITH mycte AS (SELECT ROW_NUMBER()
OVER (PARTITION BY [ride_id] 
ORDER BY [ride_id]) AS rownumber,* 
FROM [dbo].[Combined_Bike_Share])
DELETE mycte WHERE mycte.rownumber > 1;
```
### CLEANING OUTLIERS:

Let's check how many outliers the dataset has in which the duration between start and end time(calculated by using DATEDIFF() function) is more than one day or less than 1 minute.

```SQL
SELECT COUNT(*) AS outliers FROM [dbo].[Combined_Bike_Share]
WHERE DATEDIFF(mi,[started_at],[ended_at]) > 1440 
OR DATEDIFF(mi,[started_at],[ended_at]) < 1
```
The result shows that 86,944 records are considered outliers. By running the code below the outliers are deleted. 

```SQL
WITH mycte2 AS (
SELECT *, DATEDIFF(mi,[started_at],[ended_at]) AS duration_in_minutes
FROM [dbo].[Combined_Bike_Share]
)
DELETE mycte2 
WHERE mycte2.duration_in_minutes > 1440 OR mycte2.duration_in_minutes < 1
```
### CLEANING NULLS:

The output of the code below shows how many records contain nulls:

```SQL
SELECT COUNT(*) AS null_count FROM [dbo].[Combined_Bike_Share]
WHERE [ride_id] IS NULL OR [rideable_type] IS NULL
OR [started_at] IS NULL OR [ended_at] IS NULL OR [start_station_name] IS NULL OR [start_station_id] IS NULL
OR [end_station_name] IS NULL OR [end_station_id] IS NULL OR [start_lat] IS NULL
OR [start_lng] IS NULL OR [end_lat] IS NULL OR [end_lng] IS NULL OR [member_casual] IS NULL
```
The results show that there are 1,423,222 records that contain nulls and by running the code below the NULLS are deleted.

```SQL
WITH mycte3 AS (
SELECT * FROM [dbo].[Combined_Bike_Share]
WHERE [ride_id] IS NULL OR [rideable_type] IS NULL
OR [started_at] IS NULL OR [ended_at] IS NULL OR [start_station_name] IS NULL OR [start_station_id] IS NULL
OR [end_station_name] IS NULL OR [end_station_id] IS NULL OR [start_lat] IS NULL
OR [start_lng] IS NULL OR [end_lat] IS NULL OR [end_lng] IS NULL OR [member_casual] IS NULL)
DELETE mycte3
```
After cleaning there are 4,205,316 records left for analysis:
```SQL
SELECT COUNT(*) AS total_recors_after_cleaning FROM [dbo].[Combined_Bike_Share]
```


![3](https://github.com/user-attachments/assets/22a585ad-9886-4ab5-87c7-c0f73298fc8c)


## Analyzing:
Once the data were cleaned I analyzed the data through SQL to understand how annual members and casual riders use Cyclistic bikes differently.
I compared the member and casual customers' behavior on their rides per month, weekdays, peak hours, trip duration, and location of stations.

-	Comparing the member and casual customers by the percentage of the number of rides :

```SQL
USE [GoogleCapstoneProject Ride share]
GO

SELECT [member_casual],COUNT([ride_id]) AS ride_count,
ROUND(CAST(COUNT([ride_id]) AS FLOAT)*100/(
SELECT CAST(COUNT([ride_id]) AS FLOAT)
FROM [dbo].[Combined_Bike_Share] 
) ,1)
AS ride_count_percentage
FROM [dbo].[Combined_Bike_Share]
GROUP BY [member_casual]
```

![4](https://github.com/user-attachments/assets/7b7d3533-57f2-444e-8541-5cc05dfd3e98)

 
- Comparing the number of member and casual users by month:
  
```SQL
SELECT [member_casual], DATENAME(MONTH,[started_at]) AS month, COUNT([ride_id]) AS ride_count 
FROM [dbo].[Combined_Bike_Share]
GROUP BY [member_casual],DATENAME(MONTH,[started_at])
ORDER BY [member_casual], COUNT([ride_id]) DESC
``` 

![MONTH](https://github.com/user-attachments/assets/94cb2633-44fb-4c22-bd5c-cce0b5fe3267)


-	Comparing the number of member and casual users by weekdays:
	
```SQL
SELECT [member_casual], DATENAME(WEEKDAY,[started_at]) AS weekday, COUNT([ride_id]) AS ride_count 
FROM [dbo].[Combined_Bike_Share]
GROUP BY [member_casual],DATENAME(WEEKDAY,[started_at])
ORDER BY [member_casual], COUNT([ride_id]) DESC
```

![WEEKDAY](https://github.com/user-attachments/assets/244a5115-283b-48c5-9b5b-fc46417f1494)


- Comparing the number of member and casual users by hours:
  
```SQL
SELECT [member_casual], DATENAME(HH,[started_at]) AS hour, COUNT([ride_id]) AS ride_count 
FROM [dbo].[Combined_Bike_Share]
GROUP BY [member_casual],DATENAME(HH,[started_at])
ORDER BY [member_casual], COUNT([ride_id]) DESC
```
![hours1-1](https://github.com/user-attachments/assets/e6992634-e9b4-42a5-b495-bea42a63e9d6)

![hours2-2](https://github.com/user-attachments/assets/9924d86f-4fc6-43c4-a415-ac9378b8f340)

 
-	Comparing the member and casual users by average time duration:
  
```SQL
SELECT[member_casual] , AVG(DATEDIFF(mi,[started_at],[ended_at])) AS avg_duration_in_minutes
FROM [dbo].[Combined_Bike_Share]
GROUP BY [member_casual]  
```

![AVG DURATION](https://github.com/user-attachments/assets/ee927cb4-1439-4735-85f3-6e52b3a1a2f6)

 
-	Comparing the number of member and casual users by rideable type:

```SQL
SELECT [member_casual], [rideable_type], COUNT([ride_id]) AS ride_count
FROM [dbo].[Combined_Bike_Share]
GROUP BY [member_casual],[rideable_type]
ORDER BY [member_casual],COUNT([ride_id]) DESC
```

![RIDE TYPE](https://github.com/user-attachments/assets/9c2b5fd0-8039-4468-bbd1-27363f788521)

 
-	Comparing the number of member and casual customers by the most popular location of start stations (In this case, I considered the first 5 locations for each type of riders):
  
```SQL
SELECT TOP 5 WITH TIES [member_casual],[start_station_name],[start_lat] ,[start_lng],
COUNT([ride_id]) AS ride_count
FROM [dbo].[Combined_Bike_Share]
WHERE [member_casual] = 'casual'
GROUP BY [member_casual],[start_station_name],[start_lat] ,[start_lng]
ORDER BY [member_casual], COUNT([ride_id]) DESC
```
![START CASUAL](https://github.com/user-attachments/assets/1c4d3ec1-fe60-4a4e-be83-ddd17a002647)


```SQL
SELECT TOP 5 WITH TIES [member_casual],[start_station_name],[start_lat] ,[start_lng],
COUNT([ride_id]) AS ride_count
FROM [dbo].[Combined_Bike_Share]
WHERE [member_casual] = 'member'
GROUP BY [member_casual],[start_station_name],[start_lat] ,[start_lng]
ORDER BY [member_casual], COUNT([ride_id]) DESC
```

![START MEMBER](https://github.com/user-attachments/assets/5420321d-19e9-4485-9cd7-2cad2d1abe67)

 
-	Comparing the number of member and casual customers by the most popular location of end stations (In this case, I considered the first 5 locations for each type of riders):
  
```SQL
SELECT TOP 5 WITH TIES [member_casual],[end_station_name],[end_lat] ,[end_lng],
COUNT([ride_id]) AS ride_count
FROM [dbo].[Combined_Bike_Share]
WHERE [member_casual] = 'casual'
GROUP BY [member_casual],[end_station_name],[end_lat] ,[end_lng]
ORDER BY [member_casual], COUNT([ride_id]) DESC
```
![END CASUAL](https://github.com/user-attachments/assets/055cd122-afbf-4a23-b5ef-c5208750390b)

```SQL
SELECT TOP 5 WITH TIES [member_casual],[end_station_name],[end_lat] ,[end_lng],
COUNT([ride_id]) AS ride_count
FROM [dbo].[Combined_Bike_Share]
WHERE [member_casual] = 'member'
GROUP BY [member_casual],[end_station_name],[end_lat] ,[end_lng]
ORDER BY [member_casual], COUNT([ride_id]) DESC
```
![END MEMBER](https://github.com/user-attachments/assets/8a98bffd-538c-4221-8696-2a3509bef98e)


 ## Sharing and visualization:


![percentage (2)](https://github.com/user-attachments/assets/e70d4c81-d828-481d-a819-418a6ad2f213)

 •	64.8% of total customers are member_users and 35.2% are casual users 

 









![month](https://github.com/user-attachments/assets/17323547-ecfe-4229-8fc0-c6fd4b21d172)

 •	The result shows that both the member and the casual users tend to ride most in June, July, August, and September.

 









 ![weekday](https://github.com/user-attachments/assets/d4cdc46d-439a-457b-9a39-b55fc4d55d22)

•	The result shows that the member_users tend to  ride  most on the weekdays (it seems to be for riding to work) and casual users tend to ride most on weekends.










![peak hour](https://github.com/user-attachments/assets/a4c53cb6-1083-4ef0-a81b-3d88499db1e4)

•	The result shows that for both member and casual customers the pick hours are between 16 to 18.









 
![time duration](https://github.com/user-attachments/assets/a5720bb8-93a6-473d-b940-70a32694692e)

•	The average time duration in casual users (24 minutes) is more than the average time duration in member users (12 minutes)











 ![rideable type](https://github.com/user-attachments/assets/3505ff49-024f-4d3b-ae72-f165b274a945)

•	The most favorite ride type for both member and casual customers is the classic bike followed by the electric bike and very low percentage of casual customers use docked bikes.

 









![start station (2)](https://github.com/user-attachments/assets/19822dcf-8c05-40cd-b82c-82fa3cd6444e)

•	As the results show the most popular start stations for casual riders are :

1-	Streeter Dr & Grand Ave

2-	DuSable Lake Shore Dr & Monroe St

3-	Michigan Ave & Oak St

4-	DuSable Lake Shore Dr & North Blvd 

5-	Shedd Aquarium 

• The most popular start stations for member riders are :

1-	Kingsbury St & Kinzie St

2-	Clark St & Elm St

3-	Clinton St & Washington Blvd

4-	University Ave & 57th St

5-	Clinton St & Madison St











 ![end station](https://github.com/user-attachments/assets/0946d2c6-7bcc-4b3d-b241-ba85049f275e)

•	As the result shows the most popular end stations for casual riders are: 

1-	Streeter Dr & Grand Ave

2-	DuSable Lake Shore Dr & Monroe St

3-	DuSable Lake Shore Dr & North Blvd

4-	Michigan Ave & Oak St 

5-	Millennium Park 

•	The most popular end stations for member riders are: 

1-	Clinton St & Washington Blvd

2-	Kingsbury St & Kinzie St

3-	Clinton St & Madison St

4-	Clark St & Elm St

5-	Wells St & Concord Ln


## Recommendations:

### Summer membership discounts and events: 

Since casual riders tend to rise most in summer, create discounts for signing up for membership in summer or hold annual summer events, competitions, and entertainment for members.

### Weekend Member Benefits: 

Since casual customers ride more on the weekends it seems they ride for sport or entertainment. Develop member-specific perks that cater to weekend riders, such as exclusive weekend ride events, 
a training program for cyclists, or free accessories tools on electric bikes such as recording ride distance, calorie expenditure, heartbeat, blood pressure, etc. 

### Special Offers During Peak Hours and Benefits: 

Since both user groups ride between 16:00 and 18:00, consider running time-limited promotions during these hours to capture their attention drive membership sign-ups, 
and emphasize how membership can make riding during these peak times more convenient, such as guaranteed bike availability or reduced wait times.

### Create “Member Zones” Near Popular Casual Stations: 

Identify and promote certain stations near popular casual rider areas as “Member Zones”. Organize community events or partner with local organizations to promote cycling and membership benefits 
such as student membership discounts, etc.

### Improve Ride Duration and Convenience: 

Since casual riders have longer average ride durations, consider offering features that cater to this, such as the option for a membership plan that provides extra time allowances.

