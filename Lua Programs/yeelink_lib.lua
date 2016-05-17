local moduleName = ...
local M = {}
_G[moduleName] = M

local dns = "0.0.0.0"

local device = ""
local sensor = ""
local apikey = ""

local sk=net.createConnection(net.TCP, 0)

local datapoint = 0

sk:dns("api.yeelink.net",function(conn,ip) 
	dns=ip
	print("DNS YEELINK OK... IP: "..dns)
end)

function M.init(_device, _sensor, _apikey)
    device = tostring(_device)
    sensor = tostring(_sensor)
    apikey = _apikey
    if dns == "0.0.0.0" then
		tmr.alarm(2,5000,1,function ()
			if dns == "0.0.0.0" then
				print("Waiting for DNS...")
			end
        end)
		
		return false
    else
        return dns
    end
end

function M.update(_datapoint)

    datapoint = tostring(_datapoint)
	d=os.date("*t")
	timestamp=string.format("%d-%d%d-%d%dT%d%d:%d%d:%d%d", d.year, d.month/10, d.month%10, d.day/10, d.day%10, d.hour/10, d.hour%10, d.min/10, d.min%10, d.sec/10, d.sec%10)
  
    sk:on("connection", function(conn) 
        print("connect OK...") 
    local key=[[{"timestamp":"]]
	local value=[[","value":]]
    local e=[[}]]

    local st=key..timestamp..value..datapoint..e

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
