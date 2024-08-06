INSERT INTO Dimensional.DimensionTime(data, Day, Month, Year, DayWeek, Quarter)
SELECT datum AS Data,
       EXTRACT(DAY FROM datum) AS Day,
       EXTRACT(MONTH FROM datum) AS Month,
       EXTRACT(year FROM datum) AS Year,
       EXTRACT(dow FROM datum) AS DayWeek,
	   EXTRACT(quarter FROM datum) AS Quarter
FROM (SELECT '1970-01-01'::DATE+ SEQUENCE.DAY AS datum
      FROM GENERATE_SERIES (0,29219) AS SEQUENCE (DAY)
      GROUP BY SEQUENCE.DAY) DQ
ORDER BY 1