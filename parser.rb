class Parser

	@@eng_alphabet = []; ('a'..'z').each { |l| @@eng_alphabet.push l }
	@@rus_alphabet = []; ('а'..'я').each { |l| @@rus_alphabet.push l }; @@rus_alphabet.push "ё"
	@@special_words = [
		"abbr.", "abbr.;", "adj.", "adj.;", "adv.", "adv.;", "biol.", "biol.;", "chem.", "chem.;",
		"coll.", "coll.;", "econ.", "econ.;", "euphem.", "euphem.;", "(I)", "interj.", "interj.;",
		"germ.", "germ.;", "naut.", "naut.;", "noun", "noun;", "obs.", "obs.;", "pref.", "pref.;",
		"pron.", "pron.;", "phys.", "phys.;", "radio", "radio;", "suf.", "suf.;", "v.", "v.;"]
	@@special_chars = ['(']
	@@dictionary  = {}
	@@articles = []
	
	def read_file(file)
		raw_contents = File.open(file, "r:utf-8").read
		contents = anti_return raw_contents
		contents.split("   ").each do |article|
			@@articles.push article
		end
		@@articles.each do |article|
			key = []
			value = []
			flag = false
			article.split(' ').each_with_index do |word, i|
				if (i == 0) or ((@@eng_alphabet.include? word[0] or
								(word.start_with? "(" and word.end_with? ")")) and
								!@@special_words.include? word and
								flag == false)
					key.push word
				else
					value.push word
					flag = true
				end
			end
			@@dictionary[key.join(' ')] = value.join(' ')
		end
		@@dictionary
	end

	def search(query)
		begin
			puts "Перевод для \"" + query + "\""
			puts format_article @@dictionary.fetch(query)
			search_vars(query)
		rescue KeyError => ke
			puts "ke"
			search_vars(query)
		end
	end

	def wrong_articles
		wrong_array = []
		@@dictionary.each_pair do |key, value|
			wrong_array.push value if (@@eng_alphabet.include? value[0] and
			                          !@@special_words.include? value.split(' ')[0])
		end
		@@dictionary.each_pair do |key, value|
			if value.split(' ')[0] == "I"
				value[0].gsub!("I", "(I)")
			end
		end
		puts wrong_array.size
	end

	private

	def search_vars(query)
		keys = []
		@@dictionary.each_pair do |key, value|
			keys.push key if (key.start_with? query + " ") or
			(key.start_with? (query + "-")) or
			(key.end_with? ("-" + query)) or
			(key.include? ("-" + query + "-"))
		end
		puts "\nВозможно Вас заинтересует следующий вариант:" if keys.size == 1
		puts "\nВозможно Вас заинтересуют следующие варианты:" if keys.size >  1
		keys.each do |key|
			puts "\t" + key
		end
	end

	def format_article(article)
		article.gsub("(I)", "(I)\n").gsub("(II)", "\n(II)\n")
		.gsub("(III)", "\n(III)\n").gsub("(IV)", "\n(IV)\n")
		.gsub("(V)", "\n(V)\n").gsub("(VI)", "\n(VI)\n")
		.gsub("(VII)", "\n(VII)\n").gsub("(VIII)", "\n(VIII)\n")
		.gsub("(IX)", "\n(IX)\n").gsub("(X)", "\n(X)\n")
		.gsub("1)", "\n\t1)").gsub("2)", "\n\t2)").gsub("3)", "\n\t3)").gsub("4)", "\n\t4)")
		.gsub("5)", "\n\t5)").gsub("6)", "\n\t6)").gsub("7)", "\n\t7)").gsub("8)", "\n\t8)")
		.gsub("9)", "\n\t9)").gsub("10)", "\n\t10)").gsub("11)", "\n\t11)").gsub("12)", "\n\t12)")
		.gsub("1.", "\n1.").gsub("2.", "\n2.").gsub("3.", "\n3.").gsub("4.", "\n4.").gsub("5.", "\n5.")
		.gsub("6.", "\n6.").gsub("7.", "\n7.").gsub("8.", "\n8.").gsub("9.", "\n9.")
		.gsub("10.", "\n10.").gsub("11.", "\n11.").gsub("12.", "\n12.").gsub("13.", "\n13.")
	end

	def anti_return(raw_contents)
		contents = []
		final    = []
		raw_contents.split("\n").each do |word|
			if word[-1] = ' '
				contents.push word.chop
			else
				contents.push word
			end
		end
		contents.each do |word|
			if @@eng_alphabet.include? word[-1]
				final.push word + " "
			elsif @@rus_alphabet.include? word[-1]
				final.push word + " "
			elsif @@rus_alphabet.include? word[-2] and word[-1] == '-'
				final.push word.chop
			else
				final.push word
			end
		end
		final.join("")
	end

end
