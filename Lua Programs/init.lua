if true then
	print("set up wifi mode")
	wifi.setmode(wifi.STATION)
	--wifi.sta.config("Home-Woaiwojia","Wo@cao#ni$ma159357")
	wifi.sta.config("jike","Abc_123456")
	wifi.sta.connect()
	
	local cnt = 0
	tmr.alarm(1, 1000, 1, function() 
	    if (wifi.sta.getip() == nil) and (cnt < 20) then 
	    	print("IP unavaiable, Waiting...")
	    	cnt = cnt + 1 
	    else 
	    	tmr.stop(1)
	    	tmr.unregister(1)
	    	if (cnt < 20) then 
	    	  print("Config done, IP is "..wifi.sta.getip())
	    	  --dofile("try_dht.lua")
	    	else 
	    	  print("Wifi setup time more than 20s, Please verify wifi.sta.config() function. Then re-download the file.")
	    	end
	    end 
	 end)
else
	print("\nPlease edit 'init.lua' first:")
end