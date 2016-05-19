
yeelink = require("yeelink_lib")

local device = 347794
local apiKey = "9a181908773eadd2cd4596a1f2be76d2"
local tSensor=388717 --temperature sensor id
local hSensor=388982 --humidity sensor id

local mainTimerId = 2
local curTime = nil

print("init yeelink")
yeelink.init(device,apiKey)

local readDHTAndSubmit = function()
  print('read dht')

  local status, temp, humi, temp_dec, humi_dec = dht.read(1)

  if status ~= dht.OK then
    print("dht is not ready")
  else
    print("tempareture :" .. temp)
    print("humidity :" .. humi)
    print("update yeelink.")

    --dataPoint = [[{"timestamp":]] .. curTime .. [[,"value":]]..temp
    --yeelink.addDatapoint(tSensor, dataPoint)

    --dataPoint = [[{"timestamp":]] .. curTime .. [[,"value":]]..humi
    --yeelink.addDatapoint(hSensor, dataPoint)
  end
end

local request = "GET /timezoneJSON?lat=31.2&lng=121.59&username=hjonwy HTTP/1.1\r\n".."Host: api.geonames.org\r\n\r\n"

local updateDatapoints = function()

  print("get current time from webapi. cur heap:" .. node.heap())
  
  local sk = net.createConnection(net.TCP, 0)

  sk:on("connection", function(conn)
    print("connect OK...")   
    sk:send(request)
  end)

  sk:on("receive", function(sck, c)
    print(c)
    curTime=c

    readDHTAndSubmit()
    
    tmr.start(mainTimerId)
    sk:close()
    sk=nil
  end)

  sk:connect(80,"api.geonames.org")

end

--update datapoints to yeelink each 12 seconds
print("start timer")
if tmr.alarm(mainTimerId,12000,1, function() tmr.stop(mainTimerId); updateDatapoints();  end) then
  print('main timer is start')
else
  print('main timer start failed.')
end
