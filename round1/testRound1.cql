
//teams with direct winpower rels
LOAD CSV WITH HEADERS FROM "https://dl.dropboxusercontent.com/u/313565755/2016bracketRound.csv" AS line
WITH line
MATCH (a:Team)-[:PLAYED_IN]->(g:BracketGame)<-[:PLAYED_IN]-(b:Team)
WHERE a.name = line.team1 AND b.name = line.team2
WITH g, a, b
MATCH (a)-[aa:WINPOWER]->(b)-[bb:WINPOWER]->(a)
WITH g, a, 1.0*(aa.winPower) as aWin, b, 1.0*(bb.winPower) as bWin
WITH g, a, aWin, b, bWin,
CASE
	WHEN aWin > bWin
	THEN a.name
	ELSE b.name END AS winName,
CASE
	WHEN aWin > bWin
	THEN b.name
	ELSE a.name END AS loseName
SET g.winnerProjected = winName
RETURN winName as Winner, loseName as Loser, ABS(aWin-bWin) as `Expected Win Power Delta`
UNION ALL
//teams without direct winpower rels
LOAD CSV WITH HEADERS FROM "https://dl.dropboxusercontent.com/u/313565755/2016bracketRound.csv" AS line
WITH line
MATCH (a:Team)-[:PLAYED_IN]->(g:BracketGame)<-[:PLAYED_IN]-(b:Team)
WITH a, b, g
WHERE
    NOT (a:Team)-[:WINPOWER]-(b:Team) 
    AND a.name = line.team1 
    AND b.name = line.team2
MATCH (a:Team)-[aa:WINPOWER]->(intermediate:Team)
MATCH (b:Team)-[bb:WINPOWER]->(intermediate:Team)
//WITH a, (avg(aa.winPower))/2 as aWin, b, (avg(bb.winPower))/2 as bWin
WITH g, a, b, aa, bb, SIZE(COLLECT(intermediate)) AS denom
WITH g, a, b, (1.0*sum(aa.winPower)/denom) as aWin, (1.0*sum(bb.winPower)/denom) as bWin
WITH g, a, aWin, b, bWin,
CASE
	WHEN aWin > bWin
	THEN a.name
	ELSE b.name END AS winName,
CASE
	WHEN aWin > bWin
	THEN b.name
	ELSE a.name END AS loseName
SET g.winnerProjected = winName	
RETURN winName as Winner, loseName as Loser, ABS(aWin-bWin) as `Expected Win Power Delta`;
