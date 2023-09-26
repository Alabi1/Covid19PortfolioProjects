-- Dataset: European Soccer Database 
-- Source: https://www.kaggle.com/code/dimarudov/data-analysis-using-sql/input
-- Queried using: Mysql


SELECT 
    country.id, league.name League_Name, country.name Country
FROM
    country
        JOIN
    league ON country.id = league.country_id;
    
-- List of all european league team order by team long name    
SELECT 
    *
FROM
    european_leagues.team
ORDER BY team_long_name;


-- Detailed list of matches. The where clause can be used to specify the stage, league and season
SELECT 
    country.name Country,
    league.name League,
    season,
    stage,
    date,
    HT.team_long_name Home_Team,
    AT.team_long_name Away_Team,
    CONCAT(home_team_goal, ' - ', away_team_goal) AS Scores
FROM
    european_leagues.matches
        JOIN
    country ON matches.country_id = country.id
        JOIN
    league ON matches.league_id = league.id
        JOIN
    team AS HT ON matches.home_team_api_id = HT.team_api_id
        JOIN
    team AS AT ON matches.away_team_api_id = AT.team_api_id
ORDER BY stage , league;


-- List of teams with their leagues using Inner Join and Group By Statement 
SELECT 
    country.name AS Country,
    league.name AS League,
    HT.team_long_name Home_Team
FROM
    european_leagues.matches
        JOIN
    country ON matches.country_id = country.id
        JOIN
    league ON matches.league_id = league.id
        JOIN
    team AS HT ON matches.home_team_api_id = HT.team_api_id
        JOIN
    team AS AT ON matches.away_team_api_id = AT.team_api_id
WHERE
    League.name = 'England Premier League'
        AND season = '2008/2009'
GROUP BY Country , League , Home_Team
ORDER BY Country;


-- List of leagues with their total stages and total matches
SELECT 
    league.name,
    COUNT(DISTINCT (stage)) AS Total_Stages,
    COUNT(matches.id) AS Total_Matches
FROM
    european_leagues.matches
        JOIN
    country ON matches.country_id = country.id
        JOIN
    league ON matches.league_id = league.id
        JOIN
    team AS HT ON matches.home_team_api_id = HT.team_api_id
        JOIN
    team AS AT ON matches.away_team_api_id = AT.team_api_id
WHERE
    season = '2008/2009'
GROUP BY league.name
ORDER BY league.name;


-- List of leagues with number of stages, number of teams , average goals(home, away and together), avgerage goal diffrence, and total goals
SELECT 
    Country.name AS country_name,
    League.name AS league_name,
    season,
    COUNT(DISTINCT stage) AS number_of_stages,
    COUNT(DISTINCT HT.team_long_name) AS number_of_teams,
    AVG(home_team_goal) AS avg_home_team_scors,
    AVG(away_team_goal) AS avg_away_team_goals,
    AVG(home_team_goal - away_team_goal) AS avg_goal_dif,
    AVG(home_team_goal + away_team_goal) AS avg_goals,
    SUM(home_team_goal + away_team_goal) AS total_goals
FROM
    Matches
        JOIN
    Country ON Country.id = Matches.country_id
        JOIN
    League ON League.id = Matches.league_id
        LEFT JOIN
    Team AS HT ON HT.team_api_id = Matches.home_team_api_id
        LEFT JOIN
    Team AS AT ON AT.team_api_id = Matches.away_team_api_id
WHERE
    Country.name IN ('Spain' , 'Germany', 'France', 'Italy', 'England')
GROUP BY Country.name , League.name , season
HAVING COUNT(DISTINCT stage) > 10
ORDER BY Country.name , League.name , season DESC
;




