class BasicFiles 
	attr_accessor :name
	attr_accessor :content
	def initialize (name, filePath)
		@name = name; 
		@content = File.read(filePath).split("");
	end

	def print () 
		puts @content
	end

	def changeName newName
		@name = newName
	end

	def getContent 
		return @content 
	end
end

myFile =  BasicFiles.new "Lots of Numbers", "sample_file.txt"

class BetterFile < BasicFiles 
	attr_accessor :lines
	attr_accessor :characters
	def initialize (name, filePath)
		super 
		@characters = content.length
		@lines = 0
		content.each do |char|
			if char == ","
				@lines+=1
			end
		end 		
	end

	def findreplace 
		puts "Please enter a string to search for"
		#myString = ""+gets()
		#puts myString
		input = gets().chomp
		num = findstring content.join(""), input
		puts ("Found " + num.to_s + " times in the document")
		puts "Enter a value to replace with, or just hit enter to skip"
		replaceValue = gets.chomp
		if replaceValue != "" 
			newText = content.join("").gsub! input, replaceValue
		end
		puts "Please enter a filename including the .txt extension" 
		fileName = gets.chomp
		newFile = File.new(fileName, "w")
		newFile.puts(newText)
		newFile.close
		puts newText
	end

end

def findstring (string, substring)
	indexes = Array.new 
	for i in 0..string.length
		if substring[0] == string[i]
			indexes.push(i)
		end
	end
	strings = Array.new 
	for k in 0..indexes.length-1 
		stringToPush = ""
		if (indexes[k]+substring.length-1) < string.length
			for n in indexes[k]..(indexes[k]+substring.length-1) 
				stringToPush += string[n]
			end
			strings.push(stringToPush)
		end
	end
	count = 0
	for i in 0..strings.length 
		if strings[i] == substring
			count+=1
		end
	end
	return count
end

myBetterFile = BetterFile.new "Lots of Numbers", "sample_file.txt"
myBetterFile.findreplace