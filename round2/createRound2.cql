//round2
LOAD CSV WITH HEADERS FROM "https://dl.dropboxusercontent.com/u/313565755/2016bracketRound2.csv" AS line
WITH line
CREATE (n:BracketGame {type:'Round of 32', round:2})
WITH line, n
MATCH (team1:Team {name:line.team1})
MATCH (team2:Team {name:line.team2})
MERGE (team1)-[:PLAYED_IN]->(n)
MERGE (team2)-[:PLAYED_IN]->(n);
