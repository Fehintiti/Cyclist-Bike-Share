Alter Table	dec_2020 alter Column start_station_id nvarchar(255) 
Alter Table	dec_2020 alter Column end_station_id nvarchar(255)

Alter Table	jan_2021 alter Column start_station_id nvarchar(255) 
Alter Table	jan_2021 alter Column end_station_id nvarchar(255)

Alter Table	feb_2021 alter Column start_station_id nvarchar(255) 
Alter Table	feb_2021 alter Column end_station_id nvarchar(255)

Alter Table	march_2021 alter Column start_station_id nvarchar(255) 
Alter Table	march_2021 alter Column end_station_id nvarchar(255)

Alter Table	April_2021 alter Column start_station_id nvarchar(255) 
Alter Table	April_2021 alter Column end_station_id nvarchar(255)

Alter Table	May_2021 alter Column start_station_id nvarchar(255) 
Alter Table	May_2021 alter Column end_station_id nvarchar(255)

Alter Table	June_2021 alter Column start_station_id nvarchar(255) 
Alter Table	June_2021 alter Column end_station_id nvarchar(255)

Alter Table	July_2021 alter Column start_station_id nvarchar(255) 
Alter Table	July_2021 alter Column end_station_id nvarchar(255)

Alter Table	August_2021 alter Column start_station_id nvarchar(255) 
Alter Table	August_2021 alter Column end_station_id nvarchar(255)

Alter Table	Sept_2021 alter Column start_station_id nvarchar(255) 
Alter Table	Sept_2021 alter Column end_station_id nvarchar(255)

Alter Table	Oct_2021 alter Column start_station_id nvarchar(255)
Alter Table	Oct_2021 alter Column end_station_id nvarchar(255)

Alter Table	Nov_2021 alter Column start_station_id nvarchar(255) 
Alter Table	Nov_2021 alter Column end_station_id nvarchar(255)

---------------COMBINING ALL TABLES-----------

SELECT * INTO yearly_Datas

FROM

(
SELECT * from dec_2020
union all
select * from jan_2021
UNION ALL
select * from feb_2021
union all
select * from march_2021
union all
select * from April_2021
union all
select * from May_2021
UNION ALL
SELECT * from June_2021
union all 
select * from July_2021
union all
select * from August_2021
union all
select * from Sept_2021
union all 
select * from Oct_2021
union all
select * from Nov_2021) A

select * from yearly_Datas




-------REMOVING NUNLL VALUES--------------
SELECT *INTO null_cleaned 
from 
(
SELECT * FROM yearly_Datas
	where start_station_name IS NOT NULL
					AND end_station_name IS NOT NULL
					 and start_station_id IS NOT NULL
						and end_station_id IS NOT NULL
							and start_lng IS NOT NULL
									and end_lat IS NOT NULL
										and end_lng IS NOT NULL
										) B

SELECT * FROM  null_cleaned 

------CLEANING STATION NANES AND FINDING RIDES WITH TOTAL MINUTES >1
select  * into final_datasss
 from
 (
SELECT DISTINCT ride_id,rideable_type as bike_type,started_at,ended_at,Total_minutes,Week_day,
	trim(replace(replace(start_station_name,'(*)',''),'TEMP','')) as  start_station_name_clean,
			TRIM(replace(replace(end_station_name,'(*)',''),'TEMP','')) AS end_station_name_cleaned,	
			start_lat,end_lat,start_lng,end_lng,member_casual as user_type
			from null_cleaned
				where start_station_name not like '%(LBS-WH-TEST)%'
					AND end_station_name not like '%(LBS-WH-TEST)%'
					AND len (ride_id) =16 ) C


SELECT * INTO FINALE_DATAS
FROM 
(
select ride_id,bike_type,started_at,ended_at,Total_minutes,Week_day,user_type,
			REPLACE(start_station_name_clean,'NULL','') AS start_station_name,
				replace(end_station_name_cleaned,'NULL','') AS end_station_name,
				replace(start_lat,'NULL','') as start_latitude,
				replace(end_lat,'NULL','') AS end_latitude,
				replace(start_lng,'NULL','') as start_longitude,
				replace(end_lng,'NULL','')as  end_longitude
				from final_datasss)
				D


			select * from  FINALE_DATAS


			SELECT *INTO OVERALL_DATA
from 
(
SELECT * FROM FINALE_DATAS
	where start_station_name IS NOT NULL
					AND end_station_name IS NOT NULL
						and  IS NOT NULL
							and start_lng IS NOT NULL
									and end_lat IS NOT NULL
										and end_lng IS NOT NULL
										) B

SELECT * FROM  null_cleaned 

SELECT * FROM FINALE_DATAS


--------------------------------DATA ANALYSIS---------------------



----------RIDES PER MONTHS, USER TYPE AND BIKE TYPE---------

SELECT DISTINCT DATEADD(MONTH,DATEDIFF(MONTH,0,started_at),0) as year_month,bike_type,user_type,count(*) as no_of_rides
FROM FINALE_DATAS
group by DATEADD(MONTH,DATEDIFF(MONTH,0,started_at),0), bike_type,user_type


--datename(m,column)+' '+cast(datepart(yyyy,column) as varchar) as MonthYear

 select  distinct datename(m,started_at)+ ' '+cast(datepart(yyyy,started_at) as varchar) as year_month, bike_type,user_type,count(*) as no_of_rides
 from FINALE_DATAS
 group by datename(m,started_at)+ ' '+cast(datepart(yyyy,started_at) as varchar),bike_type,user_type



 --------------------Rides per month----

 select count(*) as no_of_rides,DATENAME(month,started_at)+ ' '+ CAST(datepart(year,started_at)as varchar) as year_month from FINALE_DATAS
 group by DATENAME(month,started_at)+ ' '+ CAST(datepart(year,started_at)as varchar) 
 order by 1

 -------------------CASUAL RIDES PER MONTH--------------------
 SELECT distinct  count(*) as no_of_rides,DATENAME(month,started_at)+ ' '+ CAST(datepart(year,started_at)as varchar) as year_month from FINALE_DATAS
 where user_type= 'casual'
 group by DATENAME(month,started_at)+ ' '+ CAST(datepart(year,started_at)as varchar) 
 order by 1

 -------------------MEMEBER RIDES PER MONTH
  SELECT distinct  count(*) as no_of_rides,DATENAME(month,started_at)+ ' '+ CAST(datepart(year,started_at)as varchar) as year_month from FINALE_DATAS
 where user_type= 'member'
 group by DATENAME(month,started_at)+ ' '+ CAST(datepart(year,started_at)as varchar) 
 order by 1


 --------------RIDES BY SEASON-----------


 SELECT distinct DATENAME(month,started_at) as Month,count(started_at) as number_of_rides, user_type,
 case when DATENAME(month,started_at) like 'January' or DATENAME(month,started_at)  like 'February' or DATENAME(month,started_at) like 'December'
	then 'Winter'
		when DATENAME(month,started_at) like 'March' or DATENAME(month,started_at) like 'April' or DATENAME(month,started_at) like 'May' 
		then 'Spring'
			when DATENAME(month,started_at) like 'June' or DATENAME(month,started_at) like 'July' or DATENAME(month,started_at) like 'August'
			then 'Summer'
					when DATENAME(month,started_at) like 'September' or DATENAME(month,started_at) like 'October' or DATENAME(month,started_at) like 'Novemebr'
					 then 'Autum'
					 else 'Unknown'
						end as Season
						from FINALE_DATAS
group by DATENAME(month,started_at), user_type,  case when DATENAME(month,started_at) like 'January' or DATENAME(month,started_at)  like 'February' or DATENAME(month,started_at) like 'December'
	then 'Winter'
		when DATENAME(month,started_at) like 'March' or DATENAME(month,started_at) like 'April' or DATENAME(month,started_at) like 'May' 
		then 'Spring'
			when DATENAME(month,started_at) like 'June' or DATENAME(month,started_at) like 'July' or DATENAME(month,started_at) like 'August'
			then 'Summer'
					when DATENAME(month,started_at) like 'September' or DATENAME(month,started_at) like 'October' or DATENAME(month,started_at) like 'Novemebr'
					 then 'Autum'
					 else 'Unknown' end 


 ------ ----------OPTIONAL METHODS----------STILL GETS THE SAME ANSWER-----


					 SELECT distinct DATENAME(month,started_at) as Month,count(started_at) as number_of_rides, user_type,
 case when DATENAME(month,started_at) in ('January', 'February', 'December')
	then 'Winter'
		when DATENAME(month,started_at) in ('March', 'April', 'May')
		then 'Spring'
			when DATENAME(month,started_at)in ('June', 'July', 'August')
			then 'Summer'
					when DATENAME(month,started_at)in ('September' , 'October' , 'November')
					 then 'Autum'
					 else 'Unknown'
						end as Season
						from FINALE_DATAS
group by DATENAME(month,started_at), user_type,  case when DATENAME(month,started_at) in ('January', 'February', 'December')
	then 'Winter'
		when DATENAME(month,started_at) in ('March', 'April', 'May')
		then 'Spring'
			when DATENAME(month,started_at)in ('June', 'July', 'August')
			then 'Summer'
					when DATENAME(month,started_at)in ('September' , 'October' , 'November')
					 then 'Autum'
					 else 'Unknown'
						end


	-------RIDES BY WEEKDAYS--------------

	SELECT Week_day,count(*) as Total_rides_by_weekday
		from FINALE_DATAS
		group by Week_day
		order by 1


		------------Causual rides by weekdays---
SELECT Week_day,count(*) as Total_rides_by_weekday
		from FINALE_DATAS
		where user_type= 'casual'
		group by Week_day
		order by 1


----------------MEMBER RIDES BY WEEKDAYS------

		SELECT Week_day,count(*) as Total_rides_by_weekday
		from FINALE_DATAS
		where user_type= 'member'
		group by Week_day
		order by 1


------RIDES BY WEEKENDS AND WEEKDAYS ----------
	Select Week_day, count(Week_day) as number_of_rides,
	case when Week_day in ('1','2','3','4','5') then 'Weekdays'
	else 'Weekends'
		end as Week_daysCaetgory
		from FINALE_DATAS
		group by Week_day,case when Week_day in ('1','2','3','4','5') then 'Weekdays'
	else 'Weekends'
		end
		order by 1 


--------------RIDES TAKEN BY CAUSUAL RIDERS ON WEEDAYS AND WEEKENDS ----------
Select Week_day, count(Week_day) as number_of_rides,
	case when Week_day in ('1','2','3','4','5') then 'Weekdays'
	else 'Weekends'
		end as Week_daysCaetgory
		from FINALE_DATAS
		WHERE user_type= 'casual'
		group by Week_day,case when Week_day in ('1','2','3','4','5') then 'Weekdays'
	else 'Weekends'
		end
		order by 1 



-----------RIDES TAKEN BY MEMBER RIDERS ON WEEKDAYS AND WEEKENDS
		Select Week_day, count(Week_day) as number_of_rides,
	case when Week_day in ('1','2','3','4','5') then 'Weekdays'
	else 'Weekends'
		end as Week_daysCaetgory
		from FINALE_DATAS
		WHERE user_type= 'member'
		group by Week_day,case when Week_day in ('1','2','3','4','5') then 'Weekdays'
	else 'Weekends'
		end
		order by 1 



----select started_at, cast(started_at as time) from FINALE_DATAS------
		
------RIDES BY TIMEOF DAY AND WEEKDAY ---------------

Select  distinct Week_day, count(Week_day) as number_of_rides,user_type, 
	case when cast(started_at as time) >='06:00' and cast(started_at as time) <'12:00' then 'Morning'
		when cast(started_at as time) >='12:00' and cast( started_at as time) <'17:00' then 'Afteroon'
			 when cast(started_at as time) >='17:00' and cast( started_at as time) <'20:00' then 'Evening'
				else 'Night'
					End as Time_of_day
					from FINALE_DATAS
						group by Week_day , user_type,
	case when cast(started_at as time) >='06:00' and cast( started_at as time) <'12:00' then 'Morning'
	 when cast(started_at as time) >='12:00' and cast( started_at as time) <'17:00' then 'Afteroon'
			 when cast(started_at as time) >='17:00' and cast( started_at as time) <'20:00' then 'Evening'
				else 'Night'
				end
				order by Week_day 

				---Select started_at from FINALE_DATAS


		---------- RIDES BY MONTH AND TIME---------------------- 

		Select  DATENAME(mm,started_at) as Month_name, count(Week_day) as number_of_rides,user_type, 
	case when cast(started_at as time) >='06:00' and cast(started_at as time) <'12:00' then 'Morning'
		when cast(started_at as time) >='12:00' and cast( started_at as time) <'17:00' then 'Afteroon'
			 when cast(started_at as time) >='17:00' and cast( started_at as time) <'20:00' then 'Evening'
				else 'Night'
					End as Time_of_day
					from FINALE_DATAS
						group by DATENAME(mm,started_at), user_type,
	case when cast(started_at as time) >='06:00' and cast( started_at as time) <'12:00' then 'Morning'
	 when cast(started_at as time) >='12:00' and cast( started_at as time) <'17:00' then 'Afteroon'
			 when cast(started_at as time) >='17:00' and cast( started_at as time) <'20:00' then 'Evening'
				else 'Night'
				end
				order by Month_name


		-----RIDES BY BIKE_TYPE------------
	select bike_type,count(ride_id) as number_of_rides
	from FINALE_DATAS
	group by bike_type

	---RIDES BY BIKE_TYPE AND USER_TYPE------

	select bike_type,count(ride_id) as number_of_rides,user_type 
	from FINALE_DATAS
	group by bike_type,user_type

	----RIDES BY USER_TYPE------

	select user_type,count(ride_id) as number_of_rides
	from FINALE_DATAS
	group by user_type

	------RIDES TYPE BY USER TYPE-----
	 select bike_type, count(bike_type) as number_of_rides,user_type
	 from FINALE_DATAS 
	 group by bike_type,user_type
	 order by 2


	 -----Avg RIDE-lenght by User_type ????
--- TRIED EVRY MEANS AND IT ISNT CONVERTING!!!

-----DEPARTING STATIONS --------

with casual_departing_stations as
	(
	select count (user_type) as Casual, start_station_name 
		from FINALE_DATAS
			where user_type ='casual'
				Group by start_station_name),
member_departing_stations as
	(
	select count (user_type) as Member, start_station_name 
		from FINALE_DATAS
			where user_type = 'member'
			group by start_station_name ),
departing_from_station as
 (
	select cds.start_station_name ,Casual,Member 
		from casual_departing_stations as cds
			join member_departing_stations as mds
				 on cds.start_station_name= mds.start_station_name),
depart_lat_lng as
(
	select distinct start_station_name, (avg(cast(start_latitude as float))) as dept_lat, (avg (cast(start_longitude as float))) as dept_long
		 from FINALE_DATAS
			group by start_station_name)

		select ds.start_station_name ,ds.casual,ds.member,round(dl.dept_lat,4) as  depart_lat,round(dl.dept_long,4) as depart_long 
			from departing_from_station as ds 
				join
					depart_lat_lng as dl
					 on ds.start_station_name= dl.start_station_name


-----ARRIVING STATIONS -----
  with casual_arriving_stations as
	(
	select count (user_type) as Casual, end_station_name 
		from FINALE_DATAS
			where user_type ='casual'
				Group by end_station_name),
member_arriving_stations as
	(
	select count (user_type) as Member, end_station_name 
		from FINALE_DATAS
			where user_type = 'member'
			group by end_station_name ),
arriving_from_station as
 (
	select cds.end_station_name ,Casual,Member 
		from casual_arriving_stations as cds
			join member_arriving_stations as mds
				 on cds.end_station_name= mds.end_station_name),
arriving_lat_lng as
(
	select distinct end_station_name, (avg(cast(end_latitude as float))) as arrive_lat, (avg (cast(end_longitude as float))) as arrive_long
		 from FINALE_DATAS
			group by end_station_name)

		select ass.end_station_name ,ass.casual,ass.member,round(al.arrive_lat,4) as  arrives_lat,round(al.arrive_long,4) as arrives_long 
			from arriving_from_station as ass 
				join
					arriving_lat_lng as al
					 on ass.end_station_name= al.end_station_name


	---- Avg Rides_length by user_type ----
Select user_type, AVG(CAST(Total_minutes as int)) as Ride_length
 from FINALE_DATAS
	group by user_type
		order by Ride_length

---- Avg Rides_length by bike-type ----

Select bike_type, AVG(CAST(Total_minutes as int)) as Ride_length
 from FINALE_DATAS
	group by bike_type
		order by Ride_length



--total rides 

select count(*) as Total_Rides  from FINALE_DATAS
