#PANAGIOTIS KONTOEIDIS
#1115201900266


#erwthma 1

select airplanes.number
from airlines_has_airplanes, airlines, airplanes
where airlines.id = airlines_has_airplanes.airlines_id and airlines.name = "Lufthansa" and airplanes.manufacturer = "Airbus" and airplanes.id = airlines_has_airplanes.airplanes_id;

#erwthma 2

select airlines.name
from routes, airports, airlines
where airports.city = "Athens" and routes.source_id = airports.id and airlines.id = routes.airlines_id and airlines.name in 
												(select airlines.name 
												from airlines, routes, airports
                                                where airports.city = "Prague" and routes.destination_id = airports.id and airlines.id = routes.airlines_id);
                                                
                                                
#erwthma 3

select count(*) as number
from flights, flights_has_passengers
where flights.date = '2012-02-19' and flights_has_passengers.flights_id = flights.id and flights.id  in 
												(select routes.id
                                                    						from airlines, routes
                                                    						where airlines.name = "Aegean Airlines" and routes.id = flights.routes_id);



#erwthma 4


select 'yes' as result
from flights
where flights.date = '2014-12-12'  and exists 
									(select routes.id
                                    from airlines, routes,  airports
                                    where airlines.name = "Olympic Airways" and airports.name = "Athens El. Venizelos" and routes.source_id = airports.id and airlines.id = routes.airlines_id and airlines.name in 
												(select airlines.name 
												from airlines, routes, airports
                                                where airports.name = "London Gatwick" and routes.destination_id = airports.id and airlines.id = routes.airlines_id
                                                )
									)
union 
select 'no' as answer
from flights
where flights.date = '2014-12-12' and not exists 
									(select routes.id
                                    from airlines, routes,  airports
                                    where airlines.name = "Olympic Airways" and airports.name = "Athens El. Venizelos" and routes.source_id = airports.id and airlines.id = routes.airlines_id and airlines.name in 
												(select airlines.name 
												from airlines, routes, airports
                                                where airports.name = "London Gatwick" and routes.destination_id = airports.id and airlines.id = routes.airlines_id
                                                )
									)
;
                                  
                                  
#erwthma 5
  
                           
select avg(2022 - p1.year_of_birth) as average_age
from passengers as p1, flights_has_passengers as fp1, flights as f1
where  fp1.passengers_id = p1.id and fp1.flights_id = f1.id and f1.id in (		
																			select r1.id
																			from routes as r1, airports as airp1
																			where airp1.city = "Berlin" and r1.destination_id = airp1.id );


#erwthma 6

select p1.name as name, p1.surname as surname
from passengers as p1, flights as f1, flights_has_passengers as fp1, airplanes
where fp1.passengers_id = p1.id and fp1.flights_id = f1.id and f1.airplanes_id = airplanes.id 
group by p1.id
having count(distinct airplanes.id)=1;


#erwthma 7

select airp1.city as "from" , airp2.city as "to"
from flights as f1, routes as r1, flights_has_passengers as fp, airports as airp1, airports as airp2
where f1.date >= '2010-03-01' and f1.date <= "2014-07-17" and r1.id = f1.routes_id and fp.flights_id = f1.id and airp1.id = r1.source_id and airp2.id = r1.destination_id and airp1.id!= airp2.id
group by f1.id
having count(fp.passengers_id)>5;

#erwthma 8 

select airlines.name, airlines.code,  count(*) as num
from airlines, routes
where airlines.id = routes.airlines_id and airlines.name  in (
		select airlines.name
		from  airlines_has_airplanes as aa,  airlines
		where aa.airlines_id = airlines.id 
		group by aa.airlines_id
		having count(aa.airplanes_id) = 4
)
group by airlines.name
having count(*);


#erwthma 9 

select passengers.name as name, passengers.surname as surname
from airlines, routes, flights, passengers, flights_has_passengers as fp
where fp.flights_id = flights.id and fp.passengers_id = passengers.id  and flights.routes_id = routes.id and routes.airlines_id = airlines.id 
group by fp.passengers_id
having count(distinct(airlines.id)) = (select count(airlines.id) from airlines where airlines.active = 'Y'); 


#erwthma 10

select p.name as name,p.surname as surname
from passengers as p, flights as f, flights_has_passengers as fp, routes as r, airlines as air
where fp.flights_id = f.id and fp.passengers_id = p.id and f.routes_id  = r.id and r.airlines_id = air.id and air.name = 'Aegean Airlines' and p.id not in 
																																		(
                                                                                                                                        select p2.id
																																		from passengers as p2, flights as f2, flights_has_passengers as fp2, routes as r2, airlines as air2
                                                                                                                                        where fp2.flights_id = f2.id and fp2.passengers_id = p2.id and f2.routes_id  = r2.id and r2.airlines_id = air2.id and air2.name != 'Aegean Airlines'
                                                                                                                                        )
union
select p.name as name, p.surname as surname
from passengers as p, flights as f, flights_has_passengers as fp, routes as r, airlines 
where fp.flights_id = f.id and fp.passengers_id = p.id and f.routes_id  = r.id and r.airlines_id = airlines.id and f.date>='2011-01-02' and f.date <='2013-12-31'
group by fp.passengers_id
having count(*) >1;