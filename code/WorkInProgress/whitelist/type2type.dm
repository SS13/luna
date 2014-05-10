/*
 * Holds procs designed to change one type of value, into another.
 * Contains:
 *			hex2num & num2hex
 *			text2list & list2text
 *			file2list
 *			angle2dir
 *			angle2text
 *			worldtime2text
 */



//slower then dd_list2text, but correctly processes associative lists.
proc/tg_list2text(list/list, glue=",")
	if(!istype(list) || !list.len)
		return
	var/output
	for(var/i=1 to list.len)
		output += (i!=1? glue : null)+(!isnull(list["[list[i]]"])?"[list["[list[i]]"]]":"[list[i]]")
	return output


//Converts a text string into a list by splitting the string at each seperator found in text (discarding the seperator)
//Returns an empty list if the text cannot be split, or the split text in a list.
//Not giving a "" seperator will cause the text to be broken into a list of single letters.
/proc/text2list(text, seperator="\n")
	. = list()

	var/text_len = length(text)					//length of the input text
	var/seperator_len = length(seperator)		//length of the seperator text

	if(text_len >= seperator_len)
		var/i
		var/last_i = 1

		for(i=1,i<=(text_len+1-seperator_len),i++)
			if( cmptext(copytext(text,i,i+seperator_len), seperator) )
				if(i != last_i)
					. += copytext(text,last_i,i)
				last_i = i + seperator_len

		if(last_i <= text_len)
			. += copytext(text, last_i, 0)
	else
		. += text
	return .

//Converts a text string into a list by splitting the string at each seperator found in text (discarding the seperator)
//Returns an empty list if the text cannot be split, or the split text in a list.
//Not giving a "" seperator will cause the text to be broken into a list of single letters.
//Case Sensitive!
/proc/text2listEx(text, seperator="\n")
	. = list()

	var/text_len = length(text)					//length of the input text
	var/seperator_len = length(seperator)		//length of the seperator text

	if(text_len >= seperator_len)
		var/i
		var/last_i = 1

		for(i=1,i<=(text_len+1-seperator_len),i++)
			if( cmptextEx(copytext(text,i,i+seperator_len), seperator) )
				if(i != last_i)
					. += copytext(text,last_i,i)
				last_i = i + seperator_len

		if(last_i <= text_len)
			. += copytext(text, last_i, 0)
	else
		. += text
	return .

//Splits the text of a file at seperator and returns them in a list.
/proc/file2list(filename, seperator="\n")
	return text2list(return_file_text(filename),seperator)


//Turns a direction into text











