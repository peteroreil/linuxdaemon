package ie.dit;

import java.io.File;
import java.io.IOException;

import org.apache.log4j.DailyRollingFileAppender;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.apache.log4j.PatternLayout;

public class DailyFileLogger extends Thread
{
	private Logger logger;
	private PatternLayout layout;
	private DailyRollingFileAppender appender;
	private File logFileDirectory;
	private static final String logFile = "applicationLog.log";

		
	public DailyFileLogger() throws IOException
	{
		super();
		this.createLogDirectory();
		this.logger = LogManager.getLogger(FileLogger.class);		
		this.layout = new PatternLayout();
		this.layout.setConversionPattern("%d [%t] %-5p %c [%x] - %m%n");
		this.appender =  new DailyRollingFileAppender(this.layout, logFileDirectory+"/"+logFile, "'.'yyyy-MM-dd-HH");
		this.logger.addAppender(this.appender);	
	}
	
	private void createLogDirectory() 
	{
		this.logFileDirectory = new File(Directory.getLogDirectory());
		
		if(!this.logFileDirectory.exists())
		{
			this.logFileDirectory.mkdir();
			System.out.println("making directory "+ Directory.getLogDirectory()+".........");
		}
		
		System.out.println(Directory.getLogDirectory()+" directory created.........");
	}
	
	public void writeInfo(String logMessage)
	{
		this.logger.info(logMessage);
	}
}
