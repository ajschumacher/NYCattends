
boxplot(attd$pct ~ attd$ATTN_DATE_YMD)
boxplot(attd$pct ~ attd$day)

library(ggplot2)

# citywide
ggplot(subset(attd, DBN=='TOTAL' & day %in% 1:5)) + aes(x=day, y=pct) + geom_point() + geom_point() + facet_grid(week ~ .) + theme_bw() + scale_y_continuous(limits=c(86,94))

# each school
ggplot(subset(attd, DBN!='TOTAL' & day %in% 1:5)) + aes(x=day, y=pct, group=DBN) + geom_point(alpha=I(0.01)) + theme_bw() + facet_grid(week ~ .) + scale_y_continuous(limits=c(80,100))



# Here is the structure of the data.
str(attd)

# For fun, we can poke around by school name.
unique(attd[grep('mott', attd$SCHOOL_NAME, ignore.case=TRUE),c("DBN","SCHOOL_NAME")])

# top attendance
head(attd[order(-attd$pct),])

subset(attd, DBN=='02M475', select=-c(4:6))
subset(attd, DBN=='05M304', select=-c(4:6))
subset(attd, DBN=='02M343', select=-c(4:6))
subset(attd, DBN=='09X058', select=-c(4:6))






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
schools <- merge(loc, subset(attd, ATTN_DATE_YMD="20130412"), by.x="dbn",by.y="DBN")

# Note that we just merged very recent attendance with historical
# data, losing some things along the way, and the following demonstrations
# are demonstrations and not necessarily good ideas. (Danger zone!)

# Now we can start looking at things geographically/graphically.
library(ggplot2)
qplot(y=lat, x=long,data=schools,size=1/pct) + theme_bw()
qplot(x=long, y=lat, color=pct, size=sqrt(X2011enrollment), data=schools) +
  scale_color_gradient(low="red", high="white", limits=c(70, 100)) +
  theme_bw()
