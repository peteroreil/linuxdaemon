package ie.dit;

import org.apache.commons.daemon.Daemon;
import org.apache.commons.daemon.DaemonContext;
import org.apache.commons.daemon.DaemonInitException;

public class LogDaemon implements Daemon
{
	private FileLogger fileLogger;		
	
	public void init(DaemonContext arg0) throws DaemonInitException, Exception {
		
		System.out.println("Initialising Daemon...........");		
		this.fileLogger = new FileLogger();	
	}	
	
	public void destroy() 
	{
		System.out.println("Daemon Destroyed...........");
		this.fileLogger.setRunning(false);		
	}	

	public void start() throws Exception 
	{	
		System.out.println("Daemon Starting..............");
		this.fileLogger.start();
	}

	public void stop() throws Exception 
	{
		System.out.println("Daemon Stopped.............");
		this.fileLogger.setRunning(false);
	}
}
