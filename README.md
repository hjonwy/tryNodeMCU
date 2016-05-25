# tryNodeMCU
##目标
1. 初步探索NodeMCU板子的基本功能,固件的烧写.
2. 学习Lua语言以及NodeMCU提供的库.
3. DHT11模块的实践.
4. 网络访问功能，将DHT11的数据上传到Yeelink.
![images/Device.PNG](https://github.com/hjonwy/tryNodeMCU/blob/master/images/Device.PNG)

##NodeMCU固件烧录
1. 买板子，某宝搜NodeMCU.
2. 拿到板子后，看NodeMCU官方的GitHub说明文档，上面的readme.md里面会告诉你最新的flasher, 最新的文档，最新的固件版本在哪里.
3. 安装驱动. 用USB连接到电脑上后，我所用的芯片是CP210, 安装文件在Resource/CP210x_VCP_Windows.装好后是这样的:
![images/Ports.PNG](https://github.com/hjonwy/tryNodeMCU/blob/master/images/Ports.PNG)
4. 下到最新的flasher.
5. 现在的固件需要自己自定义编译，在[http://nodemcu-build.com/](http://nodemcu-build.com/)上选好自己想要的库，编译。
6. 编译完成后使用flasher烧录，具体可以看flash的官方github教程[https://github.com/nodemcu/nodemcu-flasher](https://github.com/nodemcu/nodemcu-flasher).
7. 烧录完后，一定要把USB线拔掉再重新上电.
8. 看官司方的文档，要确定是否和你的固件版本一致.可以使用node.info来获取你所烧录固件的版本信息.
9. 固件烧录完成后可以使用Tera Term来连接调试, 也可以使用NodeMCU Studio来连接.
![images/Tera.PNG](https://github.com/hjonwy/tryNodeMCU/blob/master/images/Tera.PNG)
![images/Studio.PNG](https://github.com/hjonwy/tryNodeMCU/blob/master/images/Studio.PNG)

##Tera Term调试
1. 连接成功后可以直接向NodeMCU发送lua指令，马上看到结果. 比如运行node.info()来查看固件的版本信息.
2. 可以做一些文件操作,比如调用file.list()列出所有文件，file.remove()来删除某个文件.
![images/Tera2.PNG](https://github.com/hjonwy/tryNodeMCU/blob/master/images/Tera2.PNG)

##init.lua
1. 可以在板子上电后自动运行.可以在init.lua中做一些初始化的工作，比如初始化wifi.
```lua
	if true then
		print("set up wifi mode")
		wifi.setmode(wifi.STATION)
		wifi.sta.config("wifi","pwd")
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
```

	
##DHT11模块
1. 这个模块跟NodeMCU板连接是通过杜邦线连接的.
2. 代码中用的1号接口对应NodeMCU板子上的D1, 2号对应D2, 以此类推.

![images/DHT11.PNG](https://github.com/hjonwy/tryNodeMCU/blob/master/images/DHT11.PNG)

##连接Yeelink
1. 用Restful Web PAI的方式来增删改查设备和传感器.
2. 充当云的作用，用来存储数据，而且各个平台都很容易获取.
3. 先学习一下官方API，注册一个帐号，添加Device和Sensor.
4. 注意在发送数据的时候，报文里面的timestamp是可以省略的，服务器会自动设置成当前的时间.(我开始还用了一个web api来拿当前的时间 [http://www.timeapi.org/utc/now](http://www.timeapi.org/utc/now).
	
```lua
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
```

##经验总结
1. 开始的时候看NodeMCu的论坛，有些论坛里面的贴子已经过时了，可以理解那些大牛的思想，但是下固件，flasher等，一定要到NodeMCU官司方的GitHub上去找最新的版本.我开始因为用了老版本的flasher，导致固件一直没有刷成功，走了不少弯路.
2. NodeMCU官司网的github首面ReadMe.md里面提到了一些有用的link.https://github.com/nodemcu/nodemcu-firmware
3. NodeMCU使用的是回调函数机制,类似于Node.js, 如果按顺序执行一系列操作，应该在前面一个动作完成时，在回调函数里面去做第二个动作.
4. tmr的使用，如果使用tmr来定时做某些操作，如果中间某个操作可能比较费时，应该在开始前先停止(tmr.stop), 在动作完成后再重新启动.
