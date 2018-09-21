CREATE FUNCTION [Tzdb].GetZoneId_Inline
(
	@tz VARCHAR(50)
) 
RETURNS TABLE WITH SCHEMABINDING AS 
RETURN
WITH zone1 AS
 (
    SELECT TOP 1 l.[CanonicalZoneId] AS [ZoneId]
    FROM [Tzdb].[Zones] z
    INNER JOIN [Tzdb].[Links] l
      ON z.[Id] = l.[LinkZoneId]
    WHERE z.[Name] = @tz
    UNION ALL
    SELECT NULL AS [ZoneId]
 )
 SELECT TOP 1 ISNULL(zone1.[ZoneId], (
    SELECT TOP 1 [Id]
    FROM [Tzdb].[Zones]
    WHERE [Name] = @tz)) AS [ZoneId]
  FROM zone1
  ORDER BY zone1.[ZoneId] DESC;
GO