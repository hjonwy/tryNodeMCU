# tryNodeMCU
##目标
    1. NodeMCU板子的基本功能,固件的烧写.
    2. Lua语言以及NodeMCU提供的库.
    3. DHT11模块的实践.
    4. 网络访问功能，将DHT11的数据上传到Yeelink.
##NodeMCU固件烧录
    1. 买板子，某宝搜NodeMCU. 
    2. 拿到板子后，看NodeMCU官方的GitHub说明文档，上面的readme.md里面会告诉你最新的flasher, 最新的文档，最新的固件版本在哪里.
    3. 下到最新的flasher.
    4. 现在的固件需要自己自定义编译，在http://nodemcu-build.com/上选好自己想要的库，编译。
    5. 编译完成后使用flasher烧录，具体可以看flash的官方github教程https://github.com/nodemcu/nodemcu-flasher.
    6. 看官司方的文档，要确定是否和你的固件版本一致.可以使用node.info来获取你所烧录固件的版本信息.
##init.lua

##Tera Term调试

##DHT11模块

##连接Yeelink

##经验总结
    1. 开始的时候看NodeMCu的论坛，有些论坛里面的贴子已经过时了，可以理解那些大牛的思想，但是下固件，flasher等，一定要到NodeMCU官司方的GitHub上去找最新的版本.我开始因为用了老版本的flasher，导致固件一直没有刷成功，走了不少弯路.
    2. NodeMCU官司网的github首面ReadMe.md里面提到了一些有用的link.https://github.com/nodemcu/nodemcu-firmware
    3. NodeMCU使用的是回调函数机制,类似于Node.js, 如果按顺序执行一系列操作，应该在前面一个动作完成时，在回调函数里面去做第二个动作.
    4. tmr的使用，如果使用tmr来定时做某些操作，如果中间某个操作可能比较费时，应该在开始前先停止(tmr.stop), 在动作完成后再重新启动.
