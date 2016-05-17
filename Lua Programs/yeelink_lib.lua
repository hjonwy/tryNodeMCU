
local moduleName = ...
local M = {}
_G[moduleName] = M

local dns = "42.96.164.52"

local device = ""
local sensor = ""
local apikey = ""

local sk=net.createConnection(net.TCP, 0)

local datapoint = 0

function M.init(_device, _sensor, _apikey)
    device = tostring(_device)
    sensor = tostring(_sensor)
    apikey = _apikey
end

function M.update(_datapoint, sec)

    datapoint = tostring(_datapoint)
	--d=os.date("*t")
	--timestamp=string.format("%x", d.year, d.month/10, d.month%10, d.day/10, d.day%10, d.hour/10, d.hour%10, d.min/10, d.min%10, d.sec/10, d.sec%10)
  
    sk:on("connection", function(conn) 
        print("connect OK...") 
    local key=[[{"timestamp":"2016-05-16T23:11:]]
	local value=[[","value":]]
	local value=[["value":]]
    local e=[[}]]
	
    local st=key..sec..value..datapoint..e
	local st=value..datapoint..e

        sk:send("POST /v1.0/device/"..device.."/sensor/"..sensor.."/datapoints HTTP/1.1\r\n"
.."Host: www.yeelink.net\r\n"
.."Content-Length: "..string.len(st).."\r\n"--the length of json is important
.."Content-Type: application/x-www-form-urlencoded\r\n"
.."U-ApiKey:"..apikey.."\r\n"
.."Cache-Control: no-cache\r\n\r\n"
..st.."\r\n" )

    end)

    sk:connect(80,dns)

end

return M
