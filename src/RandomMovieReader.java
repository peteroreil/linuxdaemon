package ie.dit;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Random;

import org.apache.commons.io.FileUtils;

public class RandomMovieReader {
	
	private String movieDirectory;
	private String filePath;
	private static final String fileName = "formattedList.txt";
	private File movieFile;
	
	public RandomMovieReader()
	{
		this.movieDirectory = Directory.getMovieDirectory();
		this.filePath = this.movieDirectory+"/"+fileName;
		this.movieFile = new File(this.filePath);
	}
	
	public String readRandomMovie()
	{
		String movie = "";
		
		try 
		{
			ArrayList<String> movies = (ArrayList<String>)FileUtils.readLines(movieFile);
			int randomNumber = generateRandomNumber(movies.size());
			movie = movies.get(randomNumber);
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
		}
		
		return movie;
	}

	private int generateRandomNumber(int maxSize) 
	{
		Random random = new Random();
		return random.nextInt(maxSize);		
	}

}
