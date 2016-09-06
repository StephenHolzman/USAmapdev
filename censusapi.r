#Data munging for everything behind the map
#This product uses the Census Bureau Data API but is not endorsed or certified by the Census Bureau.

apikey <- readLines("C:/Users/Stephen Holzman/creds/censusapi.txt")

testcall <- paste0("https://api.census.gov/data/2015/pep/population?get=POP,GEONAME,RACE5,AGE,SEX&for=county:*&DATE=8&key=",apikey)

#testresponse <- RCurl::getURL(testcall)
  
testprocess <- readLines(testcall)

tmp <- strsplit(gsub("[^[:alnum:], _]", '', testprocess), "\\,")
dat_df <- as.data.frame(do.call(rbind, tmp[-1]), stringsAsFactors=FALSE)

alldata2015 <- read.csv("C:/Users/Stephen Holzman/Downloads/CC-EST2015-ALLDATA.csv",colClasses = c(rep("factor",7),rep('numeric',73)))

library(dplyr)
for(a in 0:18){
  clay <- filter(alldata2015, YEAR==8,AGEGRP==a) %>%
    mutate(
      NHWA_ALL = NHWA_MALE + NHWA_FEMALE,
      NHBA_ALL = NHBA_MALE + NHBA_FEMALE,
      NHAA_ALL = NHAA_MALE + NHAA_FEMALE,
      H_ALL = H_MALE + H_FEMALE,
      OTHER_MALE = TOT_MALE - NHWA_MALE - NHBA_MALE - NHAA_MALE - H_MALE,
      OTHER_FEMALE = TOT_FEMALE - NHWA_FEMALE - NHBA_FEMALE - NHAA_FEMALE - H_FEMALE,
      OTHER_ALL = OTHER_MALE + OTHER_FEMALE,
      ID = paste0(STATE,COUNTY)
    )
  clay$ID <- as.numeric(clay$ID)
  selectvar_ALL <- select(clay, ID,CTYNAME,TOT_POP,NHWA_ALL, NHBA_ALL, NHAA_ALL, H_ALL, OTHER_ALL)
  selectvar_MALE <- select(clay, ID,CTYNAME,TOT_MALE,NHWA_MALE, NHBA_MALE, NHAA_MALE, H_MALE, OTHER_MALE)
  selectvar_FEMALE <- select(clay, ID,CTYNAME,TOT_FEMALE,NHWA_FEMALE, NHBA_FEMALE, NHAA_FEMALE, H_FEMALE, OTHER_FEMALE)
  
  #selectvar_ALL <- select(clay,ID,TOT_POP,CTYNAME)
  selectvar_MALE <- select(
    clay,ID,
    TOT_POP = TOT_MALE,
    NHWA_ALL = NHWA_MALE,
    NHBA_ALL=NHBA_MALE,
    NHAA_ALL=NHAA_MALE,
    OTHER_ALL=OTHER_MALE,
    H_ALL=H_MALE,
    CTYNAME)
  
  selectvar_FEMALE <- select(
    clay,ID,
    TOT_POP = TOT_FEMALE,
    NHWA_ALL = NHWA_FEMALE,
    NHBA_ALL=NHBA_FEMALE,
    NHAA_ALL=NHAA_FEMALE,
    OTHER_ALL=OTHER_FEMALE,
    H_ALL=H_FEMALE,
    CTYNAME)
  
  write.table(selectvar_ALL,file=paste0("data/Age",a,"Sex0.tsv"),sep='\t',row.names=FALSE,quote=FALSE)
  write.table(selectvar_MALE,file=paste0("data/Age",a,"Sex2.tsv"),sep='\t',row.names=FALSE,quote=FALSE)
  write.table(selectvar_FEMALE,file=paste0("data/Age",a,"Sex1.tsv"),sep='\t',row.names=FALSE,quote=FALSE)
}




#Create other variables
#All races
#both sexes
allages <- filter(alldata2015,YEAR=='8',AGEGRP==0) %>%
  select(STATE,COUNTY,AGEGRP,TOT_POP)

#Non Hispanic Whites
#Both sexes
nhwbs <- filter(alldata2015,YEAR=='8',AGEGRP==0) %>%
  select(STATE,COUNTY,NHWA_MALE,NHWA_FEMALE)
nhwbs$NHWA_MALE <- as.numeric(nhwbs$NHWA_MALE)
nhwbs$NHWA_FEMALE <- as.numeric(nhwbs$NHWA_FEMALE)
  
nhwbs <- mutate(nhwbs,NHWA_ALL = NHWA_MALE + NHWA_FEMALE)