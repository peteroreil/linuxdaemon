

Linux System Administration & Virtualization Assignment
*******************************************************

@Author: Peter O'Reilly
@E-mail: peter.oreilly6@student.dit.ie
@StudentId: D12123601




Instruction on Running 
*******************************************************
running ruby version: 1.9.3p0 (2011-10-30 revision 33570) [i686-linux]

 1) run part one      ./partOne.sh

 	when completed successfully will create a directory called 'Movie-Data' with a file 
 	called 'formattedList.txt' inside (formatted movie list)

 
 2) once part one is completed the user will have to modify the partTwo.sh
 	to add themselves as user to access the logs (log.err etc) once the daemon
 	starts.

 	run part two      ./partTwo.sh start    to start LogDaemon
 					  ./partTwo.sh stop     to stop LogDaemon
 					  ./partTwo.sh restart  to restart LogDaemon

 	once started correctly will create a directory called 'application-log' in the current working 
 	directory which will output the daily rolling file append log files to (see below for more details)
 	and will output the logger.err and logger.out and logger.pid (when running) to the 'logs' directory.


 3) to execute part three     ruby ./partThree.rb

 	once run successfully should archive all log files by day, eg after 72hrs of logging there should be 
 	three archived files each with 24 files and a report after running this script.

I have attempted to sand box this assignment to the current directory that everything is packaged in.
All files and directories will be created in the current directory to alleviate permissions writing 
to certain directories.

*****  The testFileCreator.sh was used to populate the application-logs directory with a months worth of files to test the 
archiving ruby script in part three ********





Commentary
*******************************************************

Part-One  -  partone.sh
--------------------------------------------------------

Part-One is a script using Linux Core Utilities using Shell Scripting.
It downloads all movies with their respective rating from the url below:

ftp://ftp.fu-berlin.de/pub/misc/movies/database/ratings.list.gz

As each Movie has its attached rating there was only a single file downloaded.
The Script attempts to extract a report simply listing unique movies between 2000 and 2010.


1) the script checks for the existence of previously created directories that this script 
	creates and removes them if they are present

2) It then makes the required directories which are used for extracting and storing the filtered file.

3) It then extracts the file and filters the file. First filtering by grepping the inverse years 
	defined in the first two expressions. Then it replaces all multiple white spaces with a single space, 
	then by using a combination of cut and Awk selects the movie name and year. 
	(it does not attempt to remove on straight to video etc '(V)')

4) Once filtered, the file is moved to a directory called 'movie-data' and placed in the current working 
	directory of the script.





Part-Two   DaemonsLogger.jar  -&  partTwo.sh 
--------------------------------------------------------
Builds a Java application packaged as a single executable jar file plus associated libraries that
periodically logs a randomly chosen Movie from the report that is produced in Part 1 to a logfile.


Java Application summary
-------------------------
The java application uses log4j and is configured at runtime to output to a directory called "application-log"
which is created by the java application once the Daemon is started. 

The application contains a DailyFileLogger.java file which has a logger and configures the appender type, layout and
rollover of the logger. It is also of type Thread. 

FileLogger.java extends DailyFileLogger and implemenst its run method which is where while the logger isRunning (a boolean condition to)
will select at random a movie from the formattedList.txt file and append it to the currently active log file.

The RandomMovieReader class selects at random from the formattedList.txt and returns a string representing the random line read from the formattedList.txt file.

The Directory class is used to get the absolute path to the jar file and is used to help sandbox the application to the current 
directory that the application is running in, facilitating the output of files to the application-log directory, which also exists in the 
same directory.

The LogDaemon class instantiates the aforementioned classes (excluding the Directory class) and implements the init(), start(), stop() and 
destroy() methods required by the apache.commons.Daemon. The init method creates an instance of the FileLogger, the start calls the FileLogger's
(Thread) start() method which starts the logger (which currently ouputs a random movie to file at a 10 second interval) the Stop and Destroy method both set the boolean flag isRunning to false allowing the thread to gracefully exist from it's run method.


partTwo.sh summary
-------------------
This contains the shell script for starting, stopping and the restarting fo the Daemon.

The script has a number of variables, one being BASEDIR which is the path to the current directory.
This variable is used to access the jar and writes the logger.out, the logger.err and logger.pid (when running)
to the log directory.

Ownership of these files are currently set to "ubuntu" so if the user wishes to access them there will be a requirement to 
change the user in the script.

The script facilitates the starting stopping and restarting of the LogDaemon application.





PART THREE - partThree.rb
--------------------------------------------------------

This ruby script effectively archives all the log files into a tar.gz file (with contents grouped by day i.e. in a full day there will be 24 files in the zipped directory) titled by the day that the log files were created and generates a report in 
each of the compressed files indicating all of the unique movie names that are contained in the log files that are within
the compressed file. 

The script attempts to prevent the over-writing of multiple archives within the same day by prepending a time stamp to archive files which are created after any initial archive in the same day, that is, if the script is run once a day, all archive files will be titles 
applicationLog.log-yyyy-mm-dd, in the event that the script is run again the same day, the result will be hh-mm-ss-applicationLog.log-yyyy-mm-dd
for all subsequent archives within the same day.

partThree.rb summary
---------------------
on initialisation, creates class variables , such as the curent working directory, string paths to these directories and arrays which are used to store references to all those files.

A list of all the files in the directory is obtained excluding the log file currently being written to, any previously compressed files and both the '.' and '..' directories.

This list is then duplicated and within the duplicated list the last three characters (the seconds and '-') are trimmed from the file name.
This list is then again duplicated and the first modifed file name is searched for in the original trimmed array, once it is found its index is recorded and so on until all occurrences of the file are recorded. This trimmed file name is added to an array which acts as a guard into this loop, that is, if the file has already been detected, it need not be iterated again.

Once all the indexes have beec collected they, files in the original directory listing (the full file names) are then moved from the current directory to an individual directory titled by applicationLog.log-YYYY-HH-MM, once all files are moved to this directory each of the files are read with each line being added to an array, if the movie already exists in the array it is not added.

From this the report is generated, written to file and placed into the named directory, it is then zipped.
As mentioned previously, if the archive process takes place more than once a day, a time stamp is prepended to the archived file.

