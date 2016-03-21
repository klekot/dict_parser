class Parser

	@@eng_alphabet = []; ('a'..'z').each { |l| @@eng_alphabet.push l }
	@@rus_alphabet = []; ('а'..'я').each { |l| @@rus_alphabet.push l }; @@rus_alphabet.push "ё"
	@@special_words = [
		"abbr.", "adj.", "adv.", "chem.", "coll.", "econ.", "(I)", "interj.", "interj.;",
		"noun", "noun;", "obs.", "pref.", "pron.;", "phys.", "radio", "suf.", "v.", "v.;"]
	@@special_chars = ['(']
	@@dictionary  = {}
	@@articles = []
	#@@pairs = []
	
	def read_file(file)
		contents = File.open(file, "r:utf-8").read
		contents.split("\n   ").each do |article|
			@@articles.push article
		end
		@@articles.each do |article|
			key = []
			value = []
			flag = false
			article.split(' ').each_with_index do |word, i|
				if (i == 0) or ((@@eng_alphabet.include? word[0] or
								@@special_chars.include? word[0]) and
								!@@special_words.include? word and
								flag == false)
					key.push word
				else
					value.push word
					flag = true
				end
			end
			@@dictionary[key.join(' ')] = value.join(' ')
			#@@pairs.push [key.join(' '), value.join(' ')]
		end
	end

	def search(query)
		begin
			puts format_article @@dictionary.fetch(query)
			search_vars(query)
		rescue KeyError => ke
			search_vars(query)
		end
	end

	private

	def search_vars(query)
		query = query + " "
		keys = []
		@@dictionary.each_pair do |key, value|
			keys.push key if (key.start_with? query) or
			(key.start_with? (query.strip + "-")) or
			(key.end_with? ("-" + query.strip)) or
			(key.include? ("-" + query.strip + "-"))
		end
		puts "\nВозможно Вас заинтересует следующий вариант:" if keys.size == 1
		puts "\nВозможно Вас заинтересуют следующие варианты:" if keys.size >  1
		keys.each do |key|
			puts "\t" + key
		end
	end

	def format_article(article)
		article
	end

end
