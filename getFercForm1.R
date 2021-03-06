### Get FERC FORM 1 DBF files from ferc.gov, unzip and write them to disk
### Currently read.dbf fails to convert at least one very important data column in the raw DBF files
### Therefore an alternative means is used to convert these DBFs to csv which then can be read 
### and analysed with R or another language.  

getForm1 = function(datadir) {

  ### Load necessary libraries, install with install.packages('packageName') if necessary

  if(! "RCurl" %in% installed.packages()){
  install.packages("RCurl")
  } 
  library(RCurl)

  if(! "XML" %in% installed.packages()){
  install.packages("XML")
  } 
  library(XML)

  ### Check if datadir exists and if FALSE create it, and set as working directory

  if(dir.exists(datadir)){
    setwd(datadir)
    } else {
    dir.create(datadir)
    setwd(datadir)
  }

  ### Define the FERC Form 1 Data page

  u = "https://www.ferc.gov/docs-filing/forms/form-1/data.asp?csrt=8422989235775158613"

  ### HTTP Get the page, parse the contents of the page, and extract the annual zipfile URLs 

  con = getCurlHandle(followlocation = TRUE, cookiejar = "", verbose = TRUE, useragent = "R")
  d = getURLContent(u, curl = con)
  t = htmlParse(d)
  h = getNodeSet(t, "//ul/table/tr/td[2]/a")
  l = sapply(h, function(x) xmlGetAttr(x, 'href'))
  fileNames = sapply(l, function(x) strsplit(x, "/")[[1]][5])
  newdir = sapply(fileNames, function(x) strsplit(x, "\\.")[[1]][1])

  ### Download each zipfile to a temp file, unzip the files, get all the database tables (.DBF) file names, extract only those files and write them to disk  

  for(i in 1:length(fileNames)){
    temp = tempfile()
    download.file(names(fileNames[i]), temp)
    zfiles = unzip(temp, list=TRUE)
    exfiles = zfiles$Name[grepl(".DBF", zfiles$Name)]
    unzip(temp, files = exfiles, exdir = paste(datadir, newdir[i], sep="/"), junkpaths=TRUE)
    unlink(temp)
  }

  ### Renaming files avoids overwriting (e.g. all 1994 files are overwritten by 1995 files) that happens without it at conversion to CSV.
 
  for (i in 1:length(list.files())) {
    setwd(list.files()[i])
    a = as.character(strsplit(getwd(), "/")[[1]])
    b = a[length(a)]
    #print(paste0(getwd(), "/", b, "_", list.files()))
    file.rename(list.files(), paste0(getwd(), "/", b, "_", list.files()))
    setwd(datadir)
  }

}
