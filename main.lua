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
windowSize = 11
hiddenSize = 50
emptyVec = torch.Tensor(3):zeros()

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

function getWordsVec(words)
	local wordsVec = torch.Tensor(#words+(windowSize-1), dims)
	--need to test this
	wordsVec[{1, windowSize-1}] = emptyVec
	for wordNum, word in ipairs(words) do
		if wordVecs[word] then
			wordVecs[word].seen = wordVecs[word].seen + 1
		else
			wordVecs[word] = {seen = 1,vec=getRandomVec()}
		end
		local wordsVec[wordNum+(windowSize-1)/2] = wordVecs[word].vec
	end
	return wordsVec
end

function getRandomVec()
	return torch.rand(dims)
end

comments = scrapeComments(1900)

for commentNum, comment in ipairs(comments) do
	words = seperateWords(comment) --end
	wordsVec = getWordVec(words)
end

wordPredictNet = nn.Sequential() --stuff
criterion = MSECriterion()

local input = torch.Tensor(windowSize)
for i = 1, size do
	input[{{1,(windowSize-1)/2}}] = wordsVec[{{i,i+(windowSize-1)/2}}]
	input[{{(windowSize-1)/2+1}, windowSize-1}] = wordsVec[{{i+(windowSize-1)/2+2,windowSize}}]
	local out = wordPredictNet:forward(wordsVec({{i, i+windowSize}}))
	--get gradients and such
end

--wordPredictNet = nn.TemporalConvolution(dims, hiddenSize, windowSize)

--output = forward(wordPredictNet, wordsVec)
--output:apply(function(a



