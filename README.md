# fercform1

## R Tools for aquiring and processing FERC FORM 1 DBF files

getFercForm1.R contains a function `getForm1()` which downloads zipfiles containing the FERC Form 1 databases files from 1994 to 2017, extracts the .DBF files and writes them to a local directory of your choosing. The write directory is the single argument passed to `getForm1()`. For example, I assign the directory path to a variable called `datadir` and pass it to `getForm1()`.  

First source the function in getFercForm1.R.  Alternatively, getFercForm1.R can be opened in a text editor, the contents copied and then pasted into the interpreter for execution and the equivilent result.  

```
> source('getFercForm1.R')
```

And the assign the write path to `datadir` and pass it to `getForm1`.

```
> datadir = "/home/nicholas/Documents/FERCFORM1/fercform1/download/"
> getForm1(datadir)

```

The .DBF files for each annual Form 1 will be written in subdirectories in the directory of your choosing with the following form

f1_1994  
f1_1995  
f1_1996  
...  
f1_2017  

The combined size of the subdirectories is approximately 2.4 GB.  

## Converting the .DBF files to .csv files

The .DBF files can be converted using [LibreOffice](https://www.libreoffice.org/download/download/).

LibreOffice can be called from the command line to process all .DBF files in any one subdirectory. For instance to convert all the .DBF files to .csv in f1_1994, the following can be used.  The commands below are for Bash, but equivalent commands should exist in Microsoft Powershell (hopefully soon to come here).

```
$ cd pathTo/directoryOfYourChoosing/f1_1994/  
pathTo/directoryOfYourChoosing/f1_1994/$ for f in *.DBF; do soffice --headless --convert-to csv $f; done  
```  

This can be applied iteratively to get the job done, moving into each directory each time to avoid writing to some higher directory where they will be overwritten on each iteration becuase the .DBF files have the same names in each directory.

Alternatively, the same outcome can be achieved by the following two lines from the directoryOfYourChoosing, which finds all the paths to all .DBF files in subdirectories, writes them to a text file, and then traverses the text file to convert to csv writing to each subdirectory.  

```
$ cd pathTo/directoryOfYourChoosing/  
pathTo/directoryOfYourChoosing$ find . -name '*.DBF' > dbfPaths.txt  
pathTo/directoryOfYourChoosing$ for f in $(cat dbfPaths.txt); do soffice --headless --convert-to csv $f; done  
```  
For illustration my pathTo/directoryOfYourChoosing was `Documents/FERCFORM1/fercform1/download/`  

```
$ cd Documents/FERCFORM1/fercform1/download/  
Documents/FERCFORM1/fercform1/download/$ find . -name '*.DBF' > dbfPaths.txt  
Documents/FERCFORM1/fercform1/download/$ for f in $(cat dbfPaths.txt); do soffice --headless --convert-to csv $f; done  

```  

There are a 2704 csv files with a total size of approximately 850 MB. For good housekeeping create a new directory and move the .csv files into it. 

```
pathTo/directoryOfYourChoosing$ mkdir csvFiles
pathTo/directoryOfYourChoosing$ mv *.csv csvFiles
```

Once the .DBF files are converted to csv, they can be read by the R interpreter and used for analysis.  The foreign package in R contains a read.dbf function, but with default arguments it produces non-unique representations of the key field which links all tables across the Form 1 to each other and to utility company names. 

The extractPlantInService.R file contains the `extractPlantInService()` function. Pass the location of the csv files to this function and it will return a list of dataframes. Each data frame is a panel of annual utility plant is service dollar values. The list includes intangible plant (it), steam power plant (spp), nuclear power plant (npp), hydroelectric power plant (hpp), other power plant (opp), total power plant (tpp), transmission plant (tps), distribution plant (dps), ISO plant (iso), general plant (gps), and total plant in service (ps).

```
> source('extractPlantInService.R')
> datadir = "home/nicholas/Documents/FERCFORM1/fercform1/csvfiles"
> d = extractPlantInService(datadir)
```

If you load the ggplot2 library, then the different panel datasets can be visualized.  For instance, the `endBal` variable tells us the value of plant in service at the end of the year for each utility. The time series visualization of the panel of total power plant (tpp) in service illustrates one measure of restructuring that is slightly different from others used in academic research, i.e. generation divestiture rather than IPP ownership shares or ISO participation.  In addition, the visualization of transmission plant in service illustrates a measure of transmission investment year to year.  Transmission investment has been a object of interest in ISO/RTOs since 2000.     

```
> library(ggplot2)
> ggplot(d$tpp, aes(year, endBal, color=as.factor(fercID))) + geom_line(show.legend = FALSE) + geom_text(aes(label=ifelse(year == 2016, fercID, "")), show.legend = FALSE)
> ggplot(d$tps, aes(year, endBal, color=as.factor(fercID))) + geom_line(show.legend = FALSE) + geom_text(aes(label=ifelse(year == 2016, fercID, "")), show.legend = FALSE)
```

