
yeelink = require("yeelink_lib")

local device = 347794
local apiKey = "9a181908773eadd2cd4596a1f2be76d2"
local tSensor = 388717 --temperature sensor id
local hSensor = 388982 --humidity sensor id
local mainTimerId = 2

yeelink.init(device,apiKey)

local readDHTAndSubmit = function()
  local status, temp, humi, temp_dec, humi_dec = dht.read(1)

  if status ~= dht.OK then
    print("dht is not ready")
  else
    print("tempareture:" .. temp .. ", humidity: " ..humi)
    print("update yeelink.")

    dataPoint = [[{"value":]] .. temp .."}"
    yeelink.addDatapoint(tSensor, dataPoint, function()
      print("finish update temperature")
      dataPoint = [[{"value":]] .. humi .."}"
      yeelink.addDatapoint(hSensor, dataPoint, function()
        print("finish udpate humidity, restart main timer")
        tmr.start(mainTimerId)
      end)
    end)
  end
end

--update datapoints to yeelink each 12 seconds
tmr.alarm(mainTimerId,12000,1, function()
  tmr.stop(mainTimerId);
  status,result = pcall(readDHTAndSubmit)
  if not status then
    print("read dht and submit failed due to " .. result)
    tmr.start(mainTimerId)
  end
  
end)

