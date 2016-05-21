
local moduleName = ...
local M = {}
_G[moduleName] = M

local device = ""
local apikey = ""

function M.init(_device, _apikey)
  device = tostring(_device)
  apikey = _apikey
end

function M.addDatapoint(sensor, datapoint, callback)
  if datapoint == nil or sensor == nil then
    return
  end

  local sk=net.createConnection(net.TCP, 0)

  sk:on("connection", function(conn)
    print("connect yeelink OK...")

    local content = "POST /v1.0/device/"..device.."/sensor/"..sensor.."/datapoints HTTP/1.1\r\n"
      .."Host: api.yeelink.net\r\n"
      .."Content-Length: "..string.len(datapoint).."\r\n"--the length of json is important
      .."Content-Type: application/x-www-form-urlencoded\r\n"
      .."U-ApiKey:"..apikey.."\r\n"
      .."Cache-Control: no-cache\r\n\r\n"
      ..datapoint.."\r\n"

    sk:send(content)

  end)

  sk:on("receive", function(sck,c)
      if callback ~= nil then
        callback()
      end
      
      sk:close();
      sk=nil;
  end)

  sk:connect(80,"api.yeelink.net")

end

return M
