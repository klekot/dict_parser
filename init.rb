require_relative 'parser'
require 'sequel'

parser = Parser.new
dictionary = parser.read_file 'muller_dict.txt'
#parser.search("persistence")


DB = Sequel.connect('sqlite://dictionary.db') # requires sqlite3

DB.create_table :articles do
  primary_key :id
  String :title
  String :description
end

articles = DB[:articles] # Create a dataset

# Populate the table
dictionary.each_pair do |key, value|
	articles.insert(:title => key, :description => value)
end

# Print out the number of records
puts "Articles count: #{articles.count}"
