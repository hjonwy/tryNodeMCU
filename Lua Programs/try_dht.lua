dht = require("dht_lib")
yeelink = require("yeelink_lib")

yeelink.init(347794,388717,"9a181908773eadd2cd4596a1f2be76d2",function()

  print("Yeelink Init OK...")
  tmr.alarm(1,20000,1,function()
  
    dht.read(1)
	t = dht.getTemperature()
	
	if(t) then
		print("tempareture :" .. t .. ", update yeelink.")
		yeelink.update(t)
	else
		print("dht is not ready")
	end
 
  end)
end)
