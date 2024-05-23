SELECT
    sk_calendar,
    FullDate,
    Year,
    Quarter,
    Month,
    Week,
    WeekOfMonth,
    DayName,
    DayofWeek,
    DayofMonth,
    IsWeekend,
    LEFT(CLD.MonthName, 3) AS Short_Month,
    LEFT(CLD.MonthName, 3) + '-' + RIGHT(CAST(CLD.Year AS VARCHAR), 2) AS MonthYear,
    CONVERT(date, CLD.FullDate, 23) AS Date,
    CONCAT(CAST(CLD.Year AS VARCHAR), RIGHT('00' + CAST(CLD.Month AS VARCHAR), 2)) AS MonthYearNum,
    (YEAR(CLD.FullDate) - YEAR(GETDATE())) * 12 + MONTH(CLD.FullDate) - MONTH(GETDATE()) AS CurMonthOffset,
    CASE WHEN (YEAR(CLD.FullDate) - YEAR(GETDATE())) * 12 + MONTH(CLD.FullDate) - MONTH(GETDATE()) <= -1 THEN 'Past' ELSE 'Future' END AS FutureDate,
    MonthName,
    CASE
        WHEN CLD.MonthName = 'January' THEN 'Janeiro'
        WHEN CLD.MonthName = 'February' THEN 'Fevereiro'
        WHEN CLD.MonthName = 'March' THEN 'Março'
        WHEN CLD.MonthName = 'April' THEN 'Abril'
        WHEN CLD.MonthName = 'May' THEN 'Maio'
        WHEN CLD.MonthName = 'June' THEN 'Junho'
        WHEN CLD.MonthName = 'July' THEN 'Julho'
        WHEN CLD.MonthName = 'August' THEN 'Agosto'
        WHEN CLD.MonthName = 'September' THEN 'Setembro'
        WHEN CLD.MonthName = 'October' THEN 'Outubro'
        WHEN CLD.MonthName = 'November' THEN 'Novembro'
        WHEN CLD.MonthName = 'December' THEN 'Dezembro'
    END AS MonthLong_PT,
    CASE
        WHEN CLD.MonthName = 'January' THEN 'Enero'
        WHEN CLD.MonthName = 'February' THEN 'Febrero'
        WHEN CLD.MonthName = 'March' THEN 'Marzo'
        WHEN CLD.MonthName = 'April' THEN 'Abril'
        WHEN CLD.MonthName = 'May' THEN 'Mayo'
        WHEN CLD.MonthName = 'June' THEN 'Junio'
        WHEN CLD.MonthName = 'July' THEN 'Julio'
        WHEN CLD.MonthName = 'August' THEN 'Agosto'
        WHEN CLD.MonthName = 'September' THEN 'Septiembre'
        WHEN CLD.MonthName = 'October' THEN 'Octubre'
        WHEN CLD.MonthName = 'November' THEN 'Noviembre'
        WHEN CLD.MonthName = 'December' THEN 'Diciembre'
    END AS MonthLong_ES,
    CASE
        WHEN CLD.MonthName = 'January' THEN 'Gennaio'
        WHEN CLD.MonthName = 'February' THEN 'Febbraio'
        WHEN CLD.MonthName = 'March' THEN 'Marzo'
        WHEN CLD.MonthName = 'April' THEN 'Aprile'
        WHEN CLD.MonthName = 'May' THEN 'Maggio'
        WHEN CLD.MonthName = 'June' THEN 'Giugno'
        WHEN CLD.MonthName = 'July' THEN 'Luglio'
        WHEN CLD.MonthName = 'August' THEN 'Agosto'
        WHEN CLD.MonthName = 'September' THEN 'Settembre'
        WHEN CLD.MonthName = 'October' THEN 'Ottobre'
        WHEN CLD.MonthName = 'November' THEN 'Novembre'
        WHEN CLD.MonthName = 'December' THEN 'Dicembre'
    END AS MonthLong_IT,
    CASE
        WHEN CLD.MonthName = 'January' THEN 'Styczeń'
        WHEN CLD.MonthName = 'February' THEN 'Luty'
        WHEN CLD.MonthName = 'March' THEN 'Marzec'
        WHEN CLD.MonthName = 'April' THEN 'Kwiecień'
        WHEN CLD.MonthName = 'May' THEN 'Maj'
        WHEN CLD.MonthName = 'June' THEN 'Czerwiec'
        WHEN CLD.MonthName = 'July' THEN 'Lipiec'
        WHEN CLD.MonthName = 'August' THEN 'Sierpień'
        WHEN CLD.MonthName = 'September' THEN 'Wrzesień'
        WHEN CLD.MonthName = 'October' THEN 'Październik'
        WHEN CLD.MonthName = 'November' THEN 'Listopad'
        WHEN CLD.MonthName = 'December' THEN 'Grudzień'
    END AS MonthLong_PL
FROM
    DW.dim_sf_Calendar AS CLD
