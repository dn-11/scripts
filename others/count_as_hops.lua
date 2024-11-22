#!/usr/bin/env lua

local as_paths = io.popen("birdc show route all | grep -A 1 'BGP' | grep as_path"):read("*a")
local as_hops = {}
for line in string.gmatch(as_paths, "BGP%.as%_path:([^\n]-)\n") do
    local asn = nil
    local hop = 0
    for this_asn in string.gmatch(line, "%d+") do
        asn = this_asn
        hop = hop + 1
    end
    if not as_hops[asn] then
        as_hops[asn] = hop
    else
        if as_hops[asn] > hop then
            as_hops[asn] = hop
        end
    end
end

local as_info_hops = {}
for asn, hop in pairs(as_hops) do
    table.insert(as_info_hops, { asn = asn, hop = hop })
end
table.sort(as_info_hops, function(a, b) return a.hop > b.hop end)

-- 加了-n参数就从github上获取metadata然后把asn解析到name
if arg[1] == "-n" then
    local http = require("socket.http")
    io.write("Fetching metadata from github...")
    local metadata = http.request("https://raw.githubusercontent.com/dn-11/metadata/refs/heads/main/README.md")
    print("Done.")
    --|   Moncak  |`4211110712`|
    for index, info in ipairs(as_info_hops) do
        as_info_hops[index].name = string.match(metadata, "|%s*([^|]-)%s*|`" .. info.asn .. "`|")
    end
    print("ASN\t\tHops\tName")
    for _, info in ipairs(as_info_hops) do
        print(info.asn, info.hop, info.name)
    end
else
    print("ASN\t\tHops")
    for _, info in ipairs(as_info_hops) do
        print(info.asn, info.hop)
    end
end
