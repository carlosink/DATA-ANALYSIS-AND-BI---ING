
-- Creating goals table 
select DimensionTime.Year as "Year",
       DimensionTime.Month as "Month",
       sum( FactSales.TotalValue) as TotalSales
  
     INTO Dimensional.KPIs
       
  from  Dimensional.FactSales  
        inner join 
        Dimensional.DimensionTime

       on (DimensionTime.KeyTime = Dimensional.FactSales.KeyTime)

group by DimensionTime.Year,
         DimensionTime.Month
order by 1,2 asc

--WAS ADDED A NEW COLUMN Goal
ALTER TABLE Dimensional.KPIs ADD COLUMN Goal numeric
    
--WAS ADDED THE DATA CONTAINING Goals per Month 
UPDATE Dimensional.KPIs SET Goal = 220000   where "Month" =1  and "Year" = 2016;
UPDATE Dimensional.KPIs SET Goal = 220000   where "Month" =2  and "Year" = 2016;
UPDATE Dimensional.KPIs SET Goal = 230000   where "Month" =3  and "Year" = 2016;
UPDATE Dimensional.KPIs SET Goal = 235000   where "Month" =4  and "Year" = 2016;
UPDATE Dimensional.KPIs SET Goal = 240000   where "Month" =5  and "Year" = 2016;
UPDATE Dimensional.KPIs SET Goal = 250000   where "Month" =6  and "Year" = 2016;
UPDATE Dimensional.KPIs SET Goal = 255000   where "Month" =7  and "Year" = 2016;
UPDATE Dimensional.KPIs SET Goal = 260000   where "Month" =8  and "Year" = 2016;
UPDATE Dimensional.KPIs SET Goal = 262500   where "Month" =9  and "Year" = 2016;
UPDATE Dimensional.KPIs SET Goal = 265000   where "Month" =10 and "Year" = 2016;
UPDATE Dimensional.KPIs SET Goal = 267000   where "Month" =11 and "Year" = 2016;
UPDATE Dimensional.KPIs SET Goal = 270000   where "Month" =12 and "Year" = 2016;


Select * from Dimensional.KPIs