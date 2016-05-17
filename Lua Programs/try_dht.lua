dht = require("dht_lib")
yeelink = require("yeelink_lib")

yeelink.init(347794,388717,"9a181908773eadd2cd4596a1f2be76d2")

local sec = 10

  tmr.alarm(1,12000,1,function()
	print('read dht')

	dht.read(1)

	print('read dht done')

	t = dht.getTemperature()
	
	if t == nil then
        print("dht is not ready")	
	else
t=t/10
	    print("tempareture :" .. t .. ", update yeelink.")
        yeelink.update(t, sec)	
		sec = sec+10
	end
 
  end)
