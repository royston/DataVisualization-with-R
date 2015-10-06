library(dplyr)
allData <- read.csv("T:/data/datasets/tarp/tarp.csv")

allData <- allData[,c("Institution.Name", "City", "State", "Original.Investment.Amount")]

allData$Original.Investment.Amount <- gsub("\\$", "", allData$Original.Investment.Amount)
allData$Original.Investment.Amount <- gsub(",", "", allData$Original.Investment.Amount, fixed = TRUE)
allData$Original.Investment.Amount <- as.numeric(as.character(factor(allData$Original.Investment.Amount)))

#bailout <- aggregate(Original.Investment.Amount ~ State, data = allData, FUN = sum)
#merge(bailout, allData)

require(ggplot2)
require(ggmap)
require(maps)


map <- get_map(location = 'United States', zoom = 4)

allData %>% group_by(City, State) %>% mutate(Original.Investment.Amount = sum(Original.Investment.Amount)) %>% unique

allData <- cbind(geocode(as.character(allData$City, allData$State), source = "google"), allData)

mapPoints <- ggmap(map) + 
  geom_point(aes(x = lon, y = lat, size = Original.Investment.Amount), data=allData, alpha = .5)
print(mapPoints)
