### Get FERC FORM 1 DBF files from ferc.gov, unzip and write them to disk
### Currently read.dbf fails to convert at least one very important data column in the raw DBF files
### Therefore an alternative means is used to convert these DBFs to csv which then can be read 
### and analysed with R or another language.  

### Load necessary libraries, install with install.packages('packageName') if necessary
library(RCurl)
library(XML)

### Define the directory where FERC Form 1 will be written
datadir = "/home/nicholas/Documents/FERCFORM1/DataDownload"

### Check if datadir exists and if FALSE create it, and set as working directory

if(dir.exists(datadir)){
  setwd(datadir)
  } else {
  dir.create(datadir)
  setwd(datadir)
}

### Define the FERC Form 1 Data page
u = "https://www.ferc.gov/docs-filing/forms/form-1/data.asp?csrt=8422989235775158613"

### Get and parse the contents of the page, and then collect annual zipfile URLs 
con = getCurlHandle(followlocation = TRUE, cookiejar = "", verbose = TRUE, useragent = "R")
d = getURLContent(u, curl = con)
t = htmlParse(d)
h = getNodeSet(t, "//ul/table/tr/td[2]/a")
l = sapply(h, function(x) xmlGetAttr(x, 'href'))
fileNames = sapply(l, function(x) strsplit(x, "/")[[1]][5])
newdir = sapply(fileNames, function(x) strsplit(x, "\\.")[[1]][1])

### Download each zip to a temp file, unzip the files, get all the database tables (.DBF) file names, and then extract only those files and write them to disk  
for(i in 1:length(fileNames)){
  temp = tempfile()
  download.file(names(fileNames[i]), temp)
  zfiles = unzip(temp, list=TRUE)
  exfiles = zfiles$Name[grepl(".DBF", zfiles$Name)]
  unzip(temp, files = exfiles, exdir = paste(datadir, newdir[i], sep="/"), junkpaths=TRUE)
  unlink(temp)
}
