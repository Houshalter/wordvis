--ask for some scraped words (eventually make parallel)

--loop through each comment

--cut up the words into a table, throw out any "nonwords" or "suspicious" words
--(e.g. any text not just letters separated by whitespace or punctuation.
--Punctuation counts as it's own word.)

--get the associated word vector for every word and build a table of these for each sentence
--if the word is new, assign it a random vector
--and high step size and few online updates
--L = require 'lpeg'
dofile "get_data.lua"

--l = L.locale(l)
dims = 3

function seperateWords(str)
	local rawElements = {}
	--for k,v in str:lower():gmatch("%s?([^%s]+)%s?") do
	for k,v in str:lower():gmatch("(%a+)") do
		table.insert(rawElements,v)
	end
	return rawElements
	--[[local elements = {}
	--add only words that don't contain non-letters
	for k,v in ipairs(rawElements) do
		if not v:find("[^%a]") then
			table.insert(elements, v)
		end
	end]]
	
	--[[string.find(str, "%a+")
	a = (l.space^0*C(l.alpha^1)*L.S('.',',',"'s","'")^0*l.space^0)
	b = a*b]]
end

function getWordVec(words)
	local wordsVec = torch.Tensor(#words, dims)
	for wordNum, word in ipairs(words) do
		if wordVecs[word] then
			wordVecs[word].seen = wordVecs[word].seen + 1
		else
			wordVecs[word] = {seen = 1,vec=getRandomVec()}
		end
		local wordsVec[wordNum] = wordVecs[word].vec
	end
	return wordsVec
end

function getRandomVec()
	torch.rand(dims)
end

comments = scrapeComments(1900)

for commentNum, comment in ipairs(comments) do
	words = seperateWords(comment)
	wordVec = getWordVec(words)
end

