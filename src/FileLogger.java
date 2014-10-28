package ie.dit;

import java.io.IOException;



public class FileLogger extends DailyFileLogger{

		
	private RandomMovieReader movieReader;
	private boolean isRunning;
		
	public FileLogger() throws IOException
	{		
		super();
		this.isRunning =  true;
		this.movieReader = new RandomMovieReader();			
	}
	

	public void run() 
	{
		while(isRunning)
		{
			String randomMovie = movieReader.readRandomMovie();
			this.writeInfo(randomMovie);
			sleep(10000);
		}
		
	}
	
	private void sleep(int milliSeconds) 
	{
		try 
		{
			Thread.sleep(milliSeconds);
		} 
		
		catch (InterruptedException e) {}		
	}

	public void setRunning(boolean running)
	{
		this.isRunning = running;
	}
	
	public boolean isRunning()
	{
		return this.isRunning;
	}	
}
