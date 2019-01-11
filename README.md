# fercform1
R Tools for aquiring and processing FERC FORM 1 DBF files

getFercForm1.txt contains a few short R code blocks that download zipfiles containing the FERC Form 1 databases files from 1994 to 2017, extracts the .DBF files and writes them to a directory of your choosing on your local machine.  This may take several hours to complete.

The .DBF files for each annual Form 1 will be stored in subdirectories of the directory of your choosing with the following form

f1_1994  
f1_1995  
f1_1996  
...  
f1_2017  

The .DBF files can be converted using LibreOffice, which can be downloaded from: https://www.libreoffice.org/download/download/ for your appropriate operating system.

LibreOffice can be called from the command line to process all .DBF files in any one subdirectory. For instance to convert all the .DBF files to .csv in f1_1994, the following can be used. 

$ cd pathTo/directoryOfYourChoosing/f1_1994/  
pathTo/directoryOfYourChoosing/f1_1994/$ for f in *.DBF; do soffice --headless --convert-to csv $f; done  

This can be applied iteratively to get the job done, moving into each directory each time to avoid writing to some higher directory where they will be overwritten on each iteration becuase the .DBF files have the same names in each directory.

$ cd pathTo/directoryOfYourChoosing/f1_1995/  
pathTo/directoryOfYourChoosing/f1_1995/$ for f in *.DBF; do soffice --headless --convert-to csv $f; done

...  

$ cd pathTo/directoryOfYourChoosing/f1_2017/  
pathTo/directoryOfYourChoosing/f1_2017/$ for f in *.DBF; do soffice --headless --convert-to csv $f; done  

Alternatively, the same outcome can be achieved by the following two lines from the directoryOfYourChoosing, which finds all the paths to all .DBF files in subdirectories, writes them to a text file, and then traverses the text file to convert to csv writing to each subdirectory.  

$ cd pathTo/directoryOfYourChoosing/
pathTo/directoryOfYourChoosing$ find . -name '*.DBF' > dbfPaths.txt  
pathTo/directoryOfYourChoosing$ for f in $(cat dbfPaths.txt); do soffice --headless --convert-to csv $f; done

For illustration my pathTo/directoryOfYourChoosing was Documents/fercform1/downloads

Once the .DBF files are converted to csv, they can be read by the R interpreter and used for analysis.  The foreign package in R contains a read.dbf function, but with default arguments it produces non-unique representations of the key field which links all tables across the Form 1 to each other and to utility company names. 

 
