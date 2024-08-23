
--**********DATA OBSERVATION AND CLEANING*************

--CLEANING DUPLICATES:
--Lets check if there were any duplicate records in ride_id

USE [GoogleCapstoneProject Ride share]
GO

SELECT COUNT([ride_id]) AS ride_records ,
COUNT(DISTINCT([ride_id])) AS ride_records_without_duplicate 
FROM [dbo].[Combined_Bike_Share];

/*In output we had 5715693 total ride_records and 5715482 for ride_records without duplicate, 
so we need to delete duplicate records by running codes below*/

WITH mycte AS (SELECT ROW_NUMBER()
OVER (PARTITION BY [ride_id] 
ORDER BY [ride_id]) AS rownumber,* 
FROM [dbo].[Combined_Bike_Share])
DELETE mycte WHERE mycte.rownumber > 1;

--CLEANING OUTLIERS:
/*Lets check how many outliers the dataset has in which the duration between start and end time 
(calculated by using DATEDIFF() function)
are more than one day or less than 1 minute*/

SELECT COUNT(*) AS outliers FROM [dbo].[Combined_Bike_Share]
WHERE DATEDIFF(mi,[started_at],[ended_at]) > 1440 OR DATEDIFF(mi,[started_at],[ended_at]) < 1

--The result shows 86944 records are considerd as outliers

--By running code below the outliers are deleted 

WITH mycte2 AS (
SELECT *, DATEDIFF(mi,[started_at],[ended_at]) AS duration_in_minutes
FROM [dbo].[Combined_Bike_Share]
)
DELETE mycte2 
WHERE mycte2.duration_in_minutes > 1440 OR mycte2.duration_in_minutes < 1

--CLEANING NULLS:
--The output of code below shows that how many records contain nulls:

SELECT COUNT(*) AS null_count FROM [dbo].[Combined_Bike_Share]
WHERE [ride_id] IS NULL OR [rideable_type] IS NULL
OR [started_at] IS NULL OR [ended_at] IS NULL OR [start_station_name] IS NULL OR [start_station_id] IS NULL
OR [end_station_name] IS NULL OR [end_station_id] IS NULL OR [start_lat] IS NULL
OR [start_lng] IS NULL OR [end_lat] IS NULL OR [end_lng] IS NULL OR [member_casual] IS NULL

/*The results show that there are 1423222 records which contain nulls and by running the code below the 
NULLS are deleted*/

WITH mycte3 AS (
SELECT * FROM [dbo].[Combined_Bike_Share]
WHERE [ride_id] IS NULL OR [rideable_type] IS NULL
OR [started_at] IS NULL OR [ended_at] IS NULL OR [start_station_name] IS NULL OR [start_station_id] IS NULL
OR [end_station_name] IS NULL OR [end_station_id] IS NULL OR [start_lat] IS NULL
OR [start_lng] IS NULL OR [end_lat] IS NULL OR [end_lng] IS NULL OR [member_casual] IS NULL)
DELETE mycte3


