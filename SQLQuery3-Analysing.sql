--*****************DATA ANALYSING************
--After cleaning there are 4205316 records left for analysing
USE [GoogleCapstoneProject Ride share]
GO
SELECT COUNT(*) AS total_recors_after_cleaning FROM [dbo].[Combined_Bike_Share]

--*******Comparing the member and casual customers by the percentage of the number of rides 

SELECT [member_casual],COUNT([ride_id]) AS ride_count,ROUND(CAST(COUNT([ride_id]) AS FLOAT)*100/(
SELECT CAST(COUNT([ride_id]) AS FLOAT)
FROM [dbo].[Combined_Bike_Share] 
) ,1)
AS ride_count_percentage
FROM [dbo].[Combined_Bike_Share]
GROUP BY [member_casual]

--The result shows that 64.8% of total customers are member_users and the 35.2% are casual users 

 
--*******Comparing the number of member and casual users by month 

SELECT [member_casual], DATENAME(MONTH,[started_at]) AS month, COUNT([ride_id]) AS ride_count 
FROM [dbo].[Combined_Bike_Share]
GROUP BY [member_casual],DATENAME(MONTH,[started_at])
ORDER BY [member_casual], COUNT([ride_id]) DESC

/*The result shows that both the member_users and the casual users 
tend to ride most in June, July, August and september */

--*******Comparing the number of member and casual users by weekdays

SELECT [member_casual], DATENAME(WEEKDAY,[started_at]) AS weekday, COUNT([ride_id]) AS ride_count 
FROM [dbo].[Combined_Bike_Share]
GROUP BY [member_casual],DATENAME(WEEKDAY,[started_at])
ORDER BY [member_casual], COUNT([ride_id]) DESC

/*The result shows that the member_users tend to  ride  most on 
the weekdays (it seems to be for riding to work) and the casual users tend to 
ride most on weekends*/

--*******Comparing the number of member and casual users by hours

SELECT [member_casual], DATENAME(HH,[started_at]) AS hour, COUNT([ride_id]) AS ride_count 
FROM [dbo].[Combined_Bike_Share]
GROUP BY [member_casual],DATENAME(HH,[started_at])
ORDER BY [member_casual], COUNT([ride_id]) DESC

/*The result shows that for both member and casual customers the pick hours are between 16 to 18*/

--*******Comparing the member and casual users by average of time duration

SELECT[member_casual] , AVG(DATEDIFF(mi,[started_at],[ended_at])) AS avg_duration_in_minutes
FROM [dbo].[Combined_Bike_Share]
GROUP BY [member_casual]  

/* The results show that  the average of time duration in casual users (24 minutes)
is more than the average of time duration in member users (12 minutes)*/

--*******Comparing the number of member and casual users by rideable type

SELECT [member_casual], [rideable_type], COUNT([ride_id]) AS ride_count
FROM [dbo].[Combined_Bike_Share]
GROUP BY [member_casual],[rideable_type]
ORDER BY [member_casual],COUNT([ride_id]) DESC

/* The result shows that the most favorite ride type for both member and casual customers 
is classic bike followed by electric bike  and very low percent of casual customers use docked bike.*/ 

--*******Comparing the number of member and casual users by location of start stations

SELECT TOP 5 WITH TIES [member_casual],[start_station_name],[start_lat] ,[start_lng],
COUNT([ride_id]) AS ride_count
FROM [dbo].[Combined_Bike_Share]
WHERE [member_casual] = 'casual'
GROUP BY [member_casual],[start_station_name],[start_lat] ,[start_lng]
ORDER BY [member_casual], COUNT([ride_id]) DESC

SELECT TOP 5 WITH TIES [member_casual],[start_station_name],[start_lat] ,[start_lng],
COUNT([ride_id]) AS ride_count
FROM [dbo].[Combined_Bike_Share]
WHERE [member_casual] = 'member'
GROUP BY [member_casual],[start_station_name],[start_lat] ,[start_lng]
ORDER BY [member_casual], COUNT([ride_id]) DESC

/*As the result show the first 5 top start stations in casual ridrs are 
1-Streeter Dr & Grand Ave,
2-DuSable Lake Shore Dr & Monroe St,
3-Michigan Ave & Oak St,
4-DuSable Lake Shore Dr & North Blvd and
5-Shedd Aquarium 
and the first 5 top start stations in member ridrs are 
1-Kingsbury St & Kinzie St,
2-Clark St & Elm St,
3-Clinton St & Washington Blvd,
4-University Ave & 57th St,
5-Clinton St & Madison St*/

--*******Comparing the number of member and casual users by location of end stations


SELECT TOP 5 WITH TIES [member_casual],[end_station_name],[end_lat] ,[end_lng],
COUNT([ride_id]) AS ride_count
FROM [dbo].[Combined_Bike_Share]
WHERE [member_casual] = 'casual'
GROUP BY [member_casual],[end_station_name],[end_lat] ,[end_lng]
ORDER BY [member_casual], COUNT([ride_id]) DESC

SELECT TOP 5 WITH TIES [member_casual],[end_station_name],[end_lat] ,[end_lng],
COUNT([ride_id]) AS ride_count
FROM [dbo].[Combined_Bike_Share]
WHERE [member_casual] = 'member'
GROUP BY [member_casual],[end_station_name],[end_lat] ,[end_lng]
ORDER BY [member_casual], COUNT([ride_id]) DESC

/*As the result show the first 5 top end stations in casual ridrs are 
1-Streeter Dr & Grand Ave,
2-DuSable Lake Shore Dr & Monroe St,
3-DuSable Lake Shore Dr & North Blvd,
4-Michigan Ave & Oak St and
5-Millennium Park 
and the first 5 top end stations in member ridrs are 
1-Clinton St & Washington Blvd,
2-Kingsbury St & Kinzie St,
3-Clinton St & Madison St,
4-Clark St & Elm St,
5-Wells St & Concord Ln*/
--************************************************************END
