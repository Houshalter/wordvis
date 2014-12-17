http = require "socket.http"
cjson = require "cjson"
http.USERAGENT = "wordvis comment scraper by /u/Noncomment"

local dataset = {}
local seen = {}
local nextId = ""

start = os.time()

for i = 1, 1000 do
	local res, sts = http.request("http://www.reddit.com/comments.json?limit=100"..nextId)
	if sts == 200 then
		local children, done = cjson.decode(res).data.children
		for k, v in ipairs(children) do
			if not seen[v.data.id] then seen[v.data.id] = true
			else done = true break end
			table.insert(dataset, v.data.body)
		end
		if not done then nextId = "&after="..tostring(children[100].data.name)
		else nextId = "" end
	end
	print(nextId)
	print("\n\n\n", dataset[#dataset])
	os.execute("sleep 10")
end

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



