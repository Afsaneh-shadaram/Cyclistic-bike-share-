/*Combined the last 12 mounth of bike share datasets and copied the result into a new table as
"Combined_Bike_Share" by using "UNION"*/
USE [GoogleCapstoneProject Ride share]
GO
SELECT *
	   INTO Combined_Bike_Share
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