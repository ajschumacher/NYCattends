
boxplot(attd$pct ~ attd$ATTN_DATE_YMD)






# Here are the first hundred characters of that:
cat(substr(raw_xml, 1, 100))
# There are this many characters:
nchar(raw_xml)

# For some reason there are ridiculous non-printing characters in there.
# This breaks everything, so we'll change all non-graphical stuff to spaces.
sane_xml <- gsub('[^[:graph:]]', ' ', raw_xml)
# We changed this many non-graphical characters:
nchar(gsub('[[:graph:]]', '', raw_xml))

# Now we use a function from the XML package to transform
# the XML-formatted data into a useable format.
library(XML)
attd <- xmlToDataFrame(sane_xml, stringsAsFactors=FALSE)

# Here is the structure of the data.
str(attd)

# `ATTN_PCT` is reading as a string because some schools have a value of
# 'NS' for 'Not Submitted'.
table(attd$ATTN_PCT)

# We'll convert to numeric and induce missing values.
attd$pct <- as.numeric(attd$ATTN_PCT)

# For fun, we can poke around by school name.
attd[grep('Mott Hall', attd$SCHOOL_NAME, ignore.case=TRUE),]

# Let's start to explore.
# We can do this numerically:
aggregate(pct ~ Borough, data=attd, mean)
# and/or graphically:
boxplot(pct ~ Borough, data=attd)

# What's going on with the empty Borough codes?
attd[attd$Borough=='',]

# Load in another data set which has latitude and longitude:
loc <- read.csv('http://bit.ly/someSchoolData')

# Merge the two data sets by DBN so we have attendance
# and other data points, like location, for each school.
schools <- merge(loc, attd, by.x="dbn",by.y="DBN")


# Note that we just merged very recent attendance with historical
# data, losing some things along the way, and the following demonstrations
# are demonstrations and not necessarily good ideas. (Danger zone!)


# Now we can start looking at things geographically/graphically.
library(ggplot2)
qplot(y=lat, x=long,data=schools,size=1/pct) + theme_bw()
qplot(x=long, y=lat, color=pct, size=sqrt(X2011enrollment), data=schools) +
  scale_color_gradient(low="red", high="white", limits=c(70, 100)) +
  theme_bw()
# More on ggplot2 shortly!

# We can also try to model 2011 performance based on recent attendance.
# (Note again, this is kind of a crazy thing to do.)
plot(X2011performance ~ pct, data=schools, pch=19, cex=0.3)
model <- lm(X2011performance ~ pct, data=schools)
abline(model, col='red')