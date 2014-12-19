--ask for some scraped words (eventually make parallel)

--loop through each comment

--cut up the words into a table, throw out any "nonwords" or "suspicious" words
--(e.g. any text not just letters separated by whitespace or punctuation.
--Punctuation counts as it's own word.)

--get the associated word vector for every word and build a table of these for each sentence
--if the word is new, assign it a random vector
--and high step size and few online updates
L = require 'lpeg'
dofile "get_data.lua"

l = L.locale(l)

function seperateWords(str)
	local rawElements = {}
	for k,v in str:lower():gmatch("%s?([^%s]+)%s?") do
		table.insert(rawElements,v)
	end
	local elements = {}
	--add only words that don't contain non-letters
	for k,v in ipairs(rawElements) do
		if not v:find("[^%a]") then
			table.insert(elements, v)
		end
	end
	
	--[[string.find(str, "%a+")
	a = (l.space^0*C(l.alpha^1)*L.S('.',',',"'s","'")^0*l.space^0)
	b = a*b]]
end

comments = scrapeComments(100)

for commentNum, comment in ipairs(comments) do
	
end