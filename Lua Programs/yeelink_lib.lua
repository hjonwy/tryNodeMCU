
local moduleName = ...
local M = {}
_G[moduleName] = M

local device = ""
local apikey = ""

local sensor = nil
local datapoint = nil

local sk=net.createConnection(net.TCP, 0)

function M.init(_device, _apikey)
  device = tostring(_device)
  apikey = _apikey
end

sk:on("connection", function(conn)
  print("connect OK...")

  sk:send("POST /v1.0/device/"..device.."/sensor/"..sensor.."/datapoints HTTP/1.1\r\n"
    .."Host: api.yeelink.net\r\n"
    .."Content-Length: "..string.len(st).."\r\n"--the length of json is important
    .."Content-Type: application/x-www-form-urlencoded\r\n"
    .."U-ApiKey:"..apikey.."\r\n"
    .."Cache-Control: no-cache\r\n\r\n"
    ..datapoint.."\r\n" )

end)
  
function M.addDatapoint(_sensor, _datapoint)
  
  if _datapoint ~= nil and _sensor ~= nil then
    sensor = _sensor
    datapoint = _datapoint
 
    sk:connect(80,"api.yeelink.net")
  end
  
end

return M
