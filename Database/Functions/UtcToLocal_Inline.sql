CREATE FUNCTION Tzdb.UtcToLocal_Inline
(
    @utc DATETIME2,
    @tz VARCHAR(50)
)
RETURNS TABLE
WITH SCHEMABINDING
AS RETURN
  SELECT TOP 1
         TODATETIMEOFFSET(DATEADD(MINUTE, ntrvl.[OffsetMinutes], @utc), ntrvl.[OffsetMinutes])
         AS [LocalTime]
  FROM   [Tzdb].[Intervals] ntrvl
  WHERE  ntrvl.[ZoneId] = (SELECT zn.[ZoneId] FROM [Tzdb].[GetZoneId_Inline](@tz) zn)
  AND    ntrvl.[UtcStart] <= @utc
  AND    ntrvl.[UtcEnd] > @utc;
GO
