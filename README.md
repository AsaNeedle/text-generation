This is a simple random text generator written in Ruby. It listens for additions to the "lib" folder and prints them to the command line. Run the following code in your command line from the root directory.

    ruby -r "./lib/text_generation.rb" -e "TextGeneration.new.start_listener"

Then add a file to the "lib" folder and it will generate a random paragraph in the command line. You may need to open and resave the file before it registers. 