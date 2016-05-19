
yeelink = require("yeelink_lib")

local device = 347794
local apiKey = "9a181908773eadd2cd4596a1f2be76d2"
local tSensor=388717 --temperature sensor id
local hSensor=388982 --humidity sensor id

print("init yeelink")
yeelink.init(device,apiKey)

local readDHTAndSubmit = function(curTime)
  print('read dht')
  
  local status, temp, humi, temp_dec, humi_dec = dht.read(1)

  if status ~= dht.OK then
    print("dht is not ready")
  else
    print("tempareture :" .. temp)
    print("humidity :" .. humi)
    print("update yeelink.")

    dataPoint = [[{"timestamp":]] .. curTime .. [[,"value":]]..temp
    yeelink.addDatapoint(tSensor, dataPoint)

    --dataPoint = [[{"timestamp":]] .. curTime .. [[,"value":]]..humi
    --yeelink.addDatapoint(hSensor, dataPoint)
  end
end

local sk = net.createConnection(net.TCP, 0)

local updateDatapoints = function()

  local curTime = nil
  local ip='23.21.227.249'
  print("get current time from webapi.")

  sk:on("connection", function(conn)
    print("connect OK...")

    sk:send([[GET http://www.timeapi.org/utc/now HTTP/1.1
Host: www.timeapi.org
Connection: keep-alive
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36
Referer: http://www.timeapi.org/
Accept-Encoding: gzip, deflate, sdch
Accept-Language: en-US,en;q=0.8
Cookie: __utmt=1; __utma=56994735.1451350290.1463545272.1463624413.1463647328.4; __utmb=56994735.2.10.1463647328; __utmc=56994735; __utmz=56994735.1463624413.3.3.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided)

    
    ]])

  end)

  sk:on("receive", function(sck, c) print(c) curTime=c end)

  sk:connect(80,ip)

--  local cnt = 0
--  tmr.alarm(3, 1000, 1, function()
--    if (curTime == nil) and (cnt < 20) then
--      print("curent time unavaiable, Waiting...")
--      cnt = cnt + 1
--    else
--      tmr.stop(3)
--      if (cnt < 20) then
--        print("cur time is "..curTime)
--        --readDHTAndSubmit(curTime)
--      else
--        print("get cur time fail due to overtime.")
--      end
--    end
--  end)

end

--update datapoints to yeelink each 12 seconds
print("start timer")
if tmr.alarm(2,12000,1, updateDatapoints) then
  print('tmr 2 is start')
else
  print('tmr 2 start failed.')
end
