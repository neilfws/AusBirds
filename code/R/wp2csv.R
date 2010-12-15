# wp2csv
# convert http://en.wikipedia.org/wiki/List_of_Australian_Birds to CSV

library(XML)
library(plyr)

wp        <- readHTMLTable("http://en.wikipedia.org/wiki/List_of_Australian_Birds")
birds     <- ldply(wp[3:98])
birds$.id <- NULL

write.table(birds, file = "../../data/ausbirds.csv", quote = T, col.names = T, row.names = F, sep = ",")
