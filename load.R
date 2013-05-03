# Install this package if you don't have it yet.
#install.packages("XML")

# Load packages
library(XML)

filenames <- list.files(pattern="[0-9]{8}\\.xml$")
attd <- NULL
for (filename in filenames) {
  # where are we in this process?
  print(filename)
  # read file as text
  raw_xml <- readLines(filename)
  # remove non-printing characters
  sane_xml <- gsub('[^[:graph:]]', ' ', raw_xml)
  # transform to data.frame
  day_attd <- xmlToDataFrame(sane_xml, stringsAsFactors=FALSE)
  # attach new data (this is not memory-efficient but I don't care)
  attd <- rbind(attd, day_attd)
}

# add column with numeric (and missing) values
attd$pct <- as.numeric(attd$ATTN_PCT)

# add date, week, and day-of-week columns
attd$date <- strptime(attd$ATTN_DATE_YMD, format='%Y%m%d')
attd$week <- as.numeric(strftime(attd$date, '%W'))
attd$day <- as.numeric(strftime(attd$date, '%w'))
