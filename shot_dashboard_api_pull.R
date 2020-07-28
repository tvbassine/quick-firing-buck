require(httr)

y <- list()
shot_clock_range <- c('24-22',
                      '22-18 Very Early',
                      '18-15 Early', '15-7 Average',
                      '7-4 Late',
                      '4-0 Very Late')

season <- c(
            '2015-16','2016-17','2017-18','2018-19','2019-20')

count <- 1

for(i in 1:length(season)){
  for(j in 1:length(shot_clock_range)){

headers = c(
  `Connection` = 'keep-alive',
  `Accept` = 'application/json, text/plain, */*',
  `x-nba-stats-token` = 'true',
  `X-NewRelic-ID` = 'VQECWF5UChAHUlNTBwgBVw==',
  `User-Agent` = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.87 Safari/537.36',
  `x-nba-stats-origin` = 'stats',
  `Sec-Fetch-Site` = 'same-origin',
  `Sec-Fetch-Mode` = 'cors',
  `Referer` = 'https://stats.nba.com/team/shot-shotclock/',
  `Accept-Encoding` = 'gzip, deflate, br',
  `Accept-Language` = 'en-US,en;q=0.9'
)

params = list(
  `PerMode` = "Totals",
  `LeagueID` ="00",
  `Season` = season[i],
  `SeasonType` = "Regular Season",
  `PORound` = '0',
  `CloseDefDistRange` = '',
  `ShotClockRange` = shot_clock_range[j],
  `ShotDistRange` = '',
  `TouchTimeRange` = '',
  `DribbleRange` = '',
  `GeneralRange` = '',
  `TeamID` = '0',
  `Outcome` = '',
  `Location` = '',
  `Month` = '0',
  `SeasonSegment` = '',
  `OpponentTeamID` = '0',
  `VsConference` = '',
  `VsDivision` = '',
  `Conference` = '',
  `Division` = '',
  `GameSegment` = '',
  `Period` = '0',
  `LastNGames`= '0',
  `DateFrom` = '',
  `DateTo` = ''
  
)

res <- httr::GET(url = 'https://stats.nba.com/stats/leaguedashteamptshot', httr::add_headers(.headers=headers), query = params)
# res <- httr::GET(url = url, httr::add_headers(.headers=headers))

json_resp <- jsonlite::fromJSON(content(res, "text"))
y[[count]] <- data.frame(json_resp$resultSets$rowSet, stringsAsFactors = F)
y[[count]]$season = season[i]
y[[count]]$shot_clock_range = shot_clock_range[j]

count <- count + 1
print(j)

  }
}

z <- do.call('rbind', y)
colnames(z)[1:18] = json_resp$resultSets$headers[[1]]

for(j in 4:18){
  z[,j] <- as.numeric(z[,j])
}

write.csv(z, 'team_shot_data.csv')
