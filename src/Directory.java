package ie.dit;


 /**
 * @author Peter O'Reilly
 *
 */

public class Directory { 
	
	/** 
	 * @return returns a String path of the directory where the jar is stored.
	 */
	public static String getRootDirectory()
	{
		String jarName = "/DaemonsLogger-0.0.1-SNAPSHOT-jar-with-dependencies.jar";
		String fullPath = Directory.class.getProtectionDomain().getCodeSource().getLocation().getPath();		
		return fullPath.replace(jarName, "");
	}
	
	/** 
	 * @return returns a String path to the application log directory.
	 */	
	public static String getLogDirectory()
	{
		return getRootDirectory()+"/application-logs";
	}
	
	
	/** 
	 * @return returns a String path to converted source movie-file directory which contains the movie report.
	 */
	public static String getMovieDirectory()
	{
		return getRootDirectory()+"/movie-data";
	}
}
