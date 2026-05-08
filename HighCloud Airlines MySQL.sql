use highcloudairlines;


-- 1. calcuate the following fields from the Year Month (#) Day fields ( First Create a Date Field from Year , Month , Day fields)" 
--    A.Year B.Monthno C.Monthfullname D.Quarter(Q1,Q2,Q3,Q4) E. YearMonth ( YYYY-MMM) 
-- 	  F. Weekdayno G.Weekdayname H.FinancialMOnth I. Financial Quarter "

SELECT 
    FlightDate,
    YEAR(FlightDate) AS Year,
    MONTH(FlightDate) AS MonthNo,
    MONTHNAME(FlightDate) AS MonthFullName,
    CONCAT('Q', QUARTER(FlightDate)) AS Quarter,
    DATE_FORMAT(FlightDate, '%Y-%b') AS YearMonth,
    WEEKDAY(FlightDate) + 1 AS WeekdayNo,
    DAYNAME(FlightDate) AS WeekdayName,
    CASE 
        WHEN MONTH(FlightDate) >= 4 THEN MONTH(FlightDate) - 3
        ELSE MONTH(FlightDate) + 9
    END AS FinancialMonth,
    CASE 
        WHEN MONTH(FlightDate) BETWEEN 4 AND 6 THEN 'Q1'
        WHEN MONTH(FlightDate) BETWEEN 7 AND 9 THEN 'Q2'
        WHEN MONTH(FlightDate) BETWEEN 10 AND 12 THEN 'Q3'
        ELSE 'Q4'
    END AS FinancialQuarter
FROM maindata;


-- 2. Find the load Factor percentage on a yearly , Quarterly , Monthly basis ( Transported passengers / Available seats)

-- Yearly
SELECT
    YEAR(FlightDate) AS Year,
    ROUND(SUM(`# Transported Passengers`) / SUM(`# Available Seats`) * 100, 2) AS LoadFactorPercentage
FROM maindata
GROUP BY YEAR(FlightDate)
ORDER BY Year;

-- Quarterly
SELECT
    YEAR(FlightDate) AS Year,
    CONCAT('Q', QUARTER(FlightDate)) AS Quarter,
    ROUND(SUM(`# Transported Passengers`) / SUM(`# Available Seats`) * 100, 2) AS LoadFactorPercentage
FROM maindata
GROUP BY YEAR(FlightDate), CONCAT('Q', QUARTER(FlightDate))
ORDER BY Year, Quarter;

-- Monthly
SELECT
    DATE_FORMAT(FlightDate, '%Y-%b') AS YearMonth,
    ROUND(SUM(`# Transported Passengers`) / SUM(`# Available Seats`) * 100, 2) AS LoadFactorPercentage
FROM maindata
GROUP BY DATE_FORMAT(FlightDate, '%Y-%b')
ORDER BY MIN(FlightDate);


-- 3. Find the load Factor percentage on a Carrier Name basis ( Transported passengers / Available seats)

SELECT
    `Carrier Name`,
    ROUND(SUM(`# Transported Passengers`) / SUM(`# Available Seats`) * 100, 2) AS LoadFactorPercentage
FROM maindata
GROUP BY `Carrier Name`
ORDER BY LoadFactorPercentage DESC;


-- 4. Identify Top 10 Carrier Names based passengers preference

SELECT
    `Carrier Name`,
    SUM(`# Transported Passengers`) AS TotalPassengers
FROM maindata
GROUP BY `Carrier Name`
ORDER BY TotalPassengers DESC
LIMIT 10;


-- 5. Display top Routes ( from-to City) based on Number of Flights

SELECT
    CONCAT(`Origin City`, ' - ', `Destination City`) AS Route,
    COUNT(*) AS NumberOfFlights
FROM maindata
GROUP BY `Origin City`, `Destination City`
ORDER BY NumberOfFlights DESC
LIMIT 10;


-- 6. Identify the how much load factor is occupied on Weekend vs Weekdays.

SELECT
    CASE
        WHEN DAYOFWEEK(FlightDate) IN (1,7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS DayType,
    ROUND(SUM(`# Transported Passengers`) / SUM(`# Available Seats`) * 100, 2) AS LoadFactorPercentage
FROM maindata
GROUP BY DayType;


-- 7. Identify number of flights based on Distance group now tell every question in one kpi in mysql

SELECT
    `%Distance Group ID`,
    COUNT(*) AS NumberOfFlights
FROM maindata
GROUP BY `%Distance Group ID`
ORDER BY `%Distance Group ID`;