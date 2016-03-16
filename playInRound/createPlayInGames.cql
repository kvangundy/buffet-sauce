
//create play in games
LOAD CSV WITH HEADERS FROM "https://dl.dropboxusercontent.com/u/313565755/2016bracketRound.csv" AS line
WITH line
WHERE line.playIn IS NOT NULL
CREATE (n:BracketGame {type:'play-in', round:0})
WITH line, n
MATCH (team1:Team {name:line.playin1})
MATCH (team2:Team {name:line.playin2})
MERGE (team1)-[:PLAYED_IN]->(n)
MERGE (team2)-[:PLAYED_IN]->(n);
