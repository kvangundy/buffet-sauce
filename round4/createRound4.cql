//round4 e8
LOAD CSV WITH HEADERS FROM "https://dl.dropboxusercontent.com/u/313565755/2016bracketRound4.csv" AS line
WITH line
CREATE (n:BracketGame {type:'Elite 8', round:4})
WITH line, n
MATCH (team1:Team {name:line.team1})
MATCH (team2:Team {name:line.team2})
MERGE (team1)-[:PLAYED_IN]->(n)
MERGE (team2)-[:PLAYED_IN]->(n);
