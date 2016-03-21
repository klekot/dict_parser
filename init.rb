require_relative 'parser'

parser = Parser.new
parser.read_file 'muller_dict.txt'
parser.search("seldom")
