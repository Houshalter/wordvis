http = require "socket.http"
cjson = require "cjson"
http.USERAGENT = "wordvis comment scraper by /u/Noncomment"

function scrapeComments(numComments)
	local dataset = {}
	local seen = {}
	local nextId = ""
	local oldcomments, done = 0, false
	while true do
		local res, sts = http.request("http://www.reddit.com/comments.json?limit=100"..nextId)
		if sts == 200 then
			local children = cjson.decode(res).data.children
			done = false
			for k, v in ipairs(children) do
				if not seen[v.data.id] then seen[v.data.id] = true
				else done = true break end
				table.insert(dataset, v.data.body)
			end
			if not done then nextId = "&after="..tostring(children[100].data.name)
			else nextId = "" end
			print(string.format("scraped %i new comments", #dataset-oldcomments))
			oldcomments = #dataset
		else print("error status "..sts) end 
		print("\n\n\n"..dataset[#dataset])
		if #dataset >= numComments then break end
		socket.sleep(done and 10 or 2)
		print("\n"..(done and "Going to next page." or "Loading first page."))
	end
	return dataset
end

start = os.time()
local dataset = scrapeComments(1000)

seconds = os.difftime(os.time(), start)
total = 0
for k, v in ipairs(dataset) do
	total = total + v:len()
end
average = total/#dataset

print(string.format([[%i comments harvested in %i seconds. Or %.3f comments per second.
An average of %.2f characters per comment. %i characters total.
%.3f characters per second. %.3f words per second at 5 characters per word.]],
#dataset, seconds, #dataset/seconds, average, total, total/seconds, total/seconds/5))

--[[14969 comments harvested in 2918 seconds. Or 5.130 comments per second.
An average of 162.85 characters per comment. 2437715 characters total.
835.406 characters per second. 167.081 words per second at 5 characters per word.]]

