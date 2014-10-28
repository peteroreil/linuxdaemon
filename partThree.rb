
# Author: Peter O'Reilly
# peter.oreilly6@student.dit.ie
# DT340A - Linux System Administartion - Assignment

# Ruby Script that groups all log files by yyyy-mm-dd
# and places them into an archive file with their respective name.
# If multiple archives on same day will time stamp each subsequent archive file
# to prevent over-writing


module FileManager
	class FileZip
		
		require 'fileutils'

		attr_accessor :logFiles, :trimmedLogFiles, :fileOccurences, :filesAlreadyLocated, :application_log_dir
		
		def initialize()

			workingDirectory = Dir.pwd
			@application_log_dir = workingDirectory<<'/application-logs'
			Dir.chdir(@application_log_dir)
			@logFiles =Dir.entries(Dir.pwd).select {|file| !File.directory?(file) &&  file=~/\d/ && !file.include?('tar')}
			@fileOccurences = Array.new
			@filesAlreadyLocated = Array.new
			@trimmedLogFiles = Array.new
		end


		def trimHoursFromLogFiles()	

			@logFiles.each do |file|
				
				file.chomp()
				file = file[0...-3]	
				@trimmedLogFiles << file					
			end			
		end


		def getIndeciesOfMatchingFiles()
						
			@trimmedLogFiles.each do |file|

				if !@filesAlreadyLocated.include?(file) 
					results_with_index = @trimmedLogFiles.each_with_index.select { |name, index| name.eql?(file)}			
					result_arr = results_with_index.map! { |i| i[1] } 
					@fileOccurences << result_arr
					@filesAlreadyLocated << file
				end
			end			
		end


		def placeFilesInDirectory()
			
			@fileOccurences.each_with_index do |fileIndexArray, index|
				dirName = @filesAlreadyLocated[index]
				
				if !File.directory?(dirName) 
					Dir.mkdir(dirName)				
				end

				fileIndexArray.each do |fileIndex|
					FileUtils.mv(@logFiles[fileIndex], dirName)
				end
			
				readContentsOfDirectory(dirName)

			end

		end

		def readContentsOfDirectory(directory)
			dir = @application_log_dir +"/"+ directory			
			logDirectory = Dir.entries(dir).select {|logFile| !File.directory?(logFile)}
			uniqueMovieTitles = Array.new
			
			logDirectory.each do |file|
				
				File.open(dir+"/"+file, 'r').each_line do |line|
				splitArr = line.split(' ', 8)
				movie = splitArr[7]

					if !uniqueMovieTitles.include?(movie) 
						uniqueMovieTitles << movie
					end					
				end
			end 

			generateReport(dir, uniqueMovieTitles, directory)

		end

		
		def generateReport(directory, movieArrayList, newFileName)
			
			fileName = newFileName+"_report_summary.txt"
			title = "Unique Movies in this archive \n"
			underline = "---------------------------------\n"
			report = ""
			report << title << underline

			movieArrayList.each do |movie|
				report << movie+"\n"
			end

			file = File.new(fileName, 'w')				
			file.write(report)
			file.close()
			FileUtils.mv(fileName, directory)

			zippedFile = newFileName+".tar.gz"

			if File.exists?(zippedFile) 
				hour = Time.now.hour.to_s
				minutes = Time.now.min.to_s
				seconds = Time.now.sec.to_s
				timeString = hour+"-"+minutes+"-"+seconds+"-"
				zippedFile.prepend(timeString)
			end
						
			`tar -zcvf #{zippedFile} #{newFileName}`
			`rm -rf #{directory}`
			
		end
		
	end 
end


#!/bin/ruby
fileManager = FileManager::FileZip.new()
fileManager.trimHoursFromLogFiles()
fileManager.getIndeciesOfMatchingFiles()
fileManager.placeFilesInDirectory()