http = require "socket.http"
cjson = require "cjson"
http.USERAGENT = "wordvis comment scraper by /u/Noncomment"
local bots = {}

function scrapeComments(numComments)
	local dataset = {}
	local seen = {}
	local nextId = ""
	local oldcomments, done = 0, false
	while true do
		local res, sts = http.request("http://www.reddit.com/r/all/comments.json?limit=100"..nextId)
		if sts == 200 then
			local children = cjson.decode(res).data.children
			done = false
			for k, v in ipairs(children) do
				if not seen[v.data.id] then seen[v.data.id] = true
				else done = true break end
				if v.data.author ~= "AutoModerator" then
					if not v.data.author:lower():find("bot") then
						table.insert(dataset, v.data.body)
					else
						if not bots[v.data.author] then
							print("Bot found: "..v.data.author)
							bots[v.data.author] = true
						end
					end
				end
			end
			if not (#children == 100) then done = true end
			if not done then nextId = "&after="..tostring(children[#children].data.name)
			else nextId = "" end
			if (#dataset-oldcomments == 100 and done) then error("Not possible to have 100 new unique comments and set off the detector for non unique comment found.", #children) end
			print(string.format("scraped %i new comments", #dataset-oldcomments))
			oldcomments = #dataset
		else print("error status "..sts) end 
		print("\n\n\n"..dataset[#dataset])
		if #dataset >= numComments then break end
		socket.sleep(done and 10 or 2)
		print("\n"..(done and "Loading first page." or "Going to next page."))
	end
	return dataset
end

local function test(n)
	start = os.time()
	local dataset = scrapeComments(n)

	seconds = os.difftime(os.time(), start)
	total = 0
	for k, v in ipairs(dataset) do
		total = total + v:len()
	end
	average = total/#dataset

	print(string.format([[%i comments harvested in %i seconds. Or %.3f comments per second.\nAn average of %.2f characters per comment. %i characters total.\n%.3f characters per second. %.3f words per second at 5 characters per word.]],
	#dataset, seconds, #dataset/seconds, average, total, total/seconds, total/seconds/5))
	print("\nBots Found:")
	table.foreach(bots, function(a) print(a) end)
end

--test(500)

--[[14969 comments harvested in 2918 seconds. Or 5.130 comments per second.
An average of 162.85 characters per comment. 2437715 characters total.
835.406 characters per second. 167.081 words per second at 5 characters per word.]]

