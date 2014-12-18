--ask for some scraped words (eventually make parallel)

--loop through each comment

--cut up the words into a table, throw out any "nonwords" or "suspicious" words
--(e.g. any text not just letters separated by whitespace or punctuation.
--Punctuation counts as it's own word.)

--get the associated word vector for every word and build a table of these for each sentence
--if the word is new, assign it a random vector
--and high step size and few online updates
dofile "get_data.lua"

function seperateWords(str)
	for k, m in str:gmatch("(%a+)")
end

comments = scrapeComments(100)

for commentNum, comment in ipairs(comments) do
	
end