
//Assigning Pythagorean Expectation (Direct Win Power)
MATCH (a:Team)-[aa:PLAYED_IN]->(game)<-[bb:PLAYED_IN]-(b:Team)
WHERE a<>b
WITH toFloat(aa.scored*aa.scored) as team2, toFloat(bb.scored*bb.scored) as opp2, game, a,b
WITH ((team2)/(team2+opp2)) as PyEx, game,a,b
MATCH (game)-[:OCCURED_ON]->(day)<-[:HAS_DAY]-(month)<-[:HAS_MONTH]-(year)
WITH (365*2016 + 2016 /4 - 2016 /100 + 2016 /400 + 15 + (153*3+8)/5) as dayBeforeTournament,
(365*(year.year) + (year.year)/4 - (year.year)/100 + (year.year)/400 + (day.day) + (153*(month.month)+8)/5) as oldYear, PyEx,a,b
WITH ((4*365.25)-(dayBeforeTournament-oldYear))/(4*365.25) as weight, PyEx, a, b
WITH SUM(weight*PyEx) as winPower, a, b
MERGE (a)-[w:WINPOWER]->(b)
SET w.winPower = winPower, w.simulated = FALSE;

//Estimating Win Power (Indirect Win Power)
MATCH (a:Team)-[aa:WINPOWER]->(intermediate:Team)-[bb:WINPOWER]->(other:Team)
WITH  a, other, SUM(aa.winPower) + SUM(bb.winPower) AS numer, SIZE(COLLECT(intermediate)) * 2 AS denom
WHERE a <> other AND SIZE((a)-[:WINPOWER]-(other)) = 0
MERGE (a)-[w:WINPOWER]->(other)
SET w.winPower = numer * 1.0 / denom, w.simulated = TRUE;
