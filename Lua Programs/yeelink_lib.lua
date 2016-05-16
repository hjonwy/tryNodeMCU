local moduleName = ...
local M = {}
_G[moduleName] = M

local dns = "0.0.0.0"

local device = ""
local sensor = ""
local apikey = ""

local debug = false --<<<<<<<<<<<<< Don't forget to "false" it before using

local sk=net.createConnection(net.TCP, 0)

local datapoint = 0

if wifi.sta.getip() == nil then
    print("Please Connect WIFI First")
    tmr.alarm(1,1000,1,function ()
        if wifi.sta.getip() ~= nil then
            tmr.stop(1)
            sk:dns("api.yeelink.net",function(conn,ip) 
            dns=ip
            print("DNS YEELINK OK... IP: "..dns)
            end)
        end
    end)
end

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

function  M.getDNS()

    if dns == "0.0.0.0" then
        return nil
    else
        return dns
    end

end

function M.update(_datapoint)

    datapoint = tostring(_datapoint)

    sk:on("connection", function(conn) 
        print("connect OK...") 
    local a=[[{"value":]]
    local b=[[}]]

    local st=a..datapoint..b

        sk:send("POST /v1.0/device/"..device.."/sensor/"..sensor.."/datapoints HTTP/1.1\r\n"
.."Host: www.yeelink.net\r\n"
.."Content-Length: "..string.len(st).."\r\n"--the length of json is important
.."Content-Type: application/x-www-form-urlencoded\r\n"
.."U-ApiKey:"..apikey.."\r\n"
.."Cache-Control: no-cache\r\n\r\n"
..st.."\r\n" )

    end)

    sk:on("receive", function(sck, content) 
    
    if debug then
    print("\r\n"..content.."\r\n") 
    else
    print("Date Receive")
    end

    end)

    sk:connect(80,dns)


end
--================end==========================
return M
