array1 <- "С";
array2 <- 's';

function FindCompare(word, subword)
{
	word = word.tolower();
	subword = subword.tolower();
	printl(word + " comapre " + subword);
	local iContains = 0;
	for (local i = 0; i < word.len(); i++)
	{
		for (local a = 0; a < subword.len(); a++)
		{
			printl(format("%c - %c", word[i], subword[a]));
			if (word[i] == subword[a])
			{
				iContains++;
				i++;
			}
		}

		if (iContains > 1)
		{
			return true;
		}
	}

	return false;
}




// printl("w: " + FindCompare(array1, array2));