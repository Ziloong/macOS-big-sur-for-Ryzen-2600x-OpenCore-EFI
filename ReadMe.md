
## MSI X470 Gaming Plus_Ryzen 2600X Hackintosh Opencore



- 主板：MSI X470 Gaming Plus 

- 系统：macOS Big Sur 11.0 Beta (20A4300b)

- CPU：AMD Ryzen2600x six-core

- 闪存：GALAX 8G 3600Mhz X4

- 硬盘：intel 760p 500G nvme

- 显卡
  - Powercolor RX580 2048sp （刷 Vbios RX570免驱）
  - Nvdia GTX1070ti  (无法驱动，我A+N双显卡，这个不影响)

- 声卡
  - Realtek ALC892 
  - Sound Blaster Audigy FX SB1550 7.1  （请自行在opencore删除kXAudioDriver.kext，否则AppleALC不能正常加载）

- 网卡：RealtekRTL8111 



## 什么东西可以做的更好？

- ### 休眠唤醒


  - `sudo pmset -a hibernatemode 0` 
  - `sudo pmset autopoweroff 0 ` 禁用自动关机功能：这是一种休眠方式
  - `sudo pmset powernap 0 `禁用电源小睡：用于定期唤醒计算机以进行网络连接和更新（但不显示）
  - `sudo pmset standby 0`禁用待机：用作从睡眠到休眠的时间段
  - `sudo pmset proximitywake 0`禁用从iPhone / Watch唤醒：特别是当iPhone或Apple Watch靠近时，机器将唤醒

  - 在您的BIOS中：

    - 禁用：局域网唤醒
    - 启用：蓝牙唤醒（如果使用蓝牙设备像键盘一样唤醒，则可以禁用）



- ### 开启Hidpi

  - `bash -c "$(curl -fsSL https://raw.githubusercontent.com/xzhih/one-key-hidpi/master/hidpi.sh)"`

- ### [修复Adobe在AMD平台上崩溃的问题](https://gist.github.com/naveenkrdy/26760ac5135deed6d0bb8902f6ceb6bd)
  - 经过测试的Adobe（2020）Photopshop，LightRoom Classic，Illustrator，Premier Pro，After Effects Bridge，Indesign，XD。如果重新安装任何Adobe应用程序，则将需要再次重做STEP-3。
  - Photoshop 图像打开、拖放和图像大小更改崩溃修复：使用 [Camera Raw 9.12.1](http://download.adobe.com/pub/adobe/photoshop/cameraraw/mac/9.x/CameraRaw_9_12_1_mac.zip)
  - Photoshop 液化完美使用
- ### [如果你拥有创新声卡请看这里](https://github.com/Ziloong/macOS-big-sur-for-Ryzen-2600x-OpenCore-EFI/blob/master/SB1550drive/README.md)

- ### Drivers
  - AudioDxe.efi UEFI音频驱动
  - HFSPlus.efi  文件系统驱动
  - OpenCanopy.efi  OpenCore主题
  - OpenRuntime.efi 内存驱动
  
- ### intel 760p nvme外置硬盘改内置问题

  使用[Hackintool](http://headsoft.com.au/download/mac/Hackintool.zip) 进入到PCie选项 找到硬盘的设备地址 `PciRoot(0x0)/Pci(0x1,0x1)/Pci(0x0,0x0)` 

  Properties方式注入`built-in` 数据类型DATA写上`01`


- ### 修复无WIFI导致状态栏卡顿问题
  - 方法1
    - [关闭SIP](https://dortania.github.io/OpenCore-Install-Guide/troubleshooting/troubleshooting.html#disabling-sip)
    - `sudo mount -uw /` 
    - `killall Finder`
    - 进入/System/Library/LaunchAgentsIgnored/   然后删除com.apple.wifi.WiFiAgent.plist
  - 方法2
    - 在Recovery模式使用终端输入
    - `mv Volumes/你的启动硬盘名字/System/Library/LaunchAgentsIgnored/com.apple.wifi.WiFiAgent.plist Volumes/你的启动硬盘名字/System/Library/LaunchAgents/`



## 配置说明

### 处理器：AMD Ryzen 2600x 6c8t

- 使用AMD OS X Vanilla beta注入[AMD Kernel Patches](https://github.com/AMD-OSX/AMD_Vanilla/tree/experimental-opencore)
- AMD 17h处理器的CPU电源管理  [SMCAMDProcessor](https://github.com/trulyspinach/SMCAMDProcessor)    ！！！在Big Sur上不可用！！！

### 显卡：PowerColor RX580 2048sp

- 显卡免驱，支持硬解加速
- [刷入RX570 Vbios](http://bbs.pcbeta.com/viewthread-1822790-1-1.html)

![image-20200719040550344](https://github.com/Ziloong/macOS-big-sur-for-Ryzen-2600x-OpenCore-EFI/blob/master/Readme_jpg/image-20200719040550344.png?raw=true)

### 声卡：Realtek ALC892 

- 驱动：[AppleALC 1.5.1](https://github.com/acidanthera/AppleALC)
- 采用 `DeviceProperties`方法注入 , 注入[layout-ID](https://github.com/acidanthera/AppleALC/wiki/Supported-codecs)  具体注入ID自行尝试
- HDMI、DP音频输出正常

![image-20200719042134445](https://github.com/Ziloong/macOS-big-sur-for-Ryzen-2600x-OpenCore-EFI/blob/master/Readme_jpg/image-20200719042134445.png?raw=true)



### 独立声卡(PCIE)： Sound Blaster Audigy FX SB1550 7.1

- [使用Kx Driver驱动](https://www.insanelymac.com/forum/topic/321954-kx-audio-driver-mod-sound-blaster-live-audigy-124rx-emu-edsp/)
- 音频MIDI设置 需要修改格式 44100hz 8声道32位
- 配置扬声器声道 5、6

![image-20200719042308970](https://github.com/Ziloong/macOS-big-sur-for-Ryzen-2600x-OpenCore-EFI/blob/master/Readme_jpg/image-20200719042308970.png?raw=true)

![image-20200719042817705](https://github.com/Ziloong/macOS-big-sur-for-Ryzen-2600x-OpenCore-EFI/blob/master/Readme_jpg/image-20200719042817705.png?raw=true)

![image-20200719045442289](https://github.com/Ziloong/macOS-big-sur-for-Ryzen-2600x-OpenCore-EFI/blob/master/Readme_jpg/image-20200719045442289.png?raw=true)

![image-20200719045451385](https://github.com/Ziloong/macOS-big-sur-for-Ryzen-2600x-OpenCore-EFI/blob/master/Readme_jpg/image-20200719045451385.png?raw=true)

### 网卡：RTL8111 

- 驱动：[RealtekRTL8111.kext](https://github.com/Mieze/RTL8111_driver_for_OS_X/releases)
- 网卡内建  采用 `DeviceProperties`方法注入built-in 01
- iCloud正常，Facetime正常，iMessage正常

![image-20200719043320005](https://github.com/Ziloong/macOS-big-sur-for-Ryzen-2600x-OpenCore-EFI/blob/master/Readme_jpg/image-20200719043320005.png?raw=true)

### USB : 端口定制

- 驱动：SSDT-EC-USBX.aml
- 使用 [Hackintool](http://headsoft.com.au/download/mac/Hackintool.zip) 定制USB



![image-20200719043629540](https://github.com/Ziloong/macOS-big-sur-for-Ryzen-2600x-OpenCore-EFI/blob/master/Readme_jpg/image-20200719043629540.png?raw=true)

### 杂项

- [工具](https://github.com/Ziloong/macOS-big-sur-for-Ryzen-2600x-OpenCore-EFI/tree/master/tools)
  - [编辑config工具](https://github.com/Ziloong/macOS-big-sur-for-Ryzen-2600x-OpenCore-EFI/tree/master/tools/ProperTree-master)
  - [生成SMBIOS](https://github.com/Ziloong/macOS-big-sur-for-Ryzen-2600x-OpenCore-EFI/tree/master/tools/GenSMBIOS-master)
  - [SSDT生成](https://github.com/Ziloong/macOS-big-sur-for-Ryzen-2600x-OpenCore-EFI/tree/master/tools/SSDTTime-master)
  


  
  

## 感谢

**Acidanthera** 提供 [OpenCore](https://github.com/acidanthera/OpenCorePkg) 和 [相关驱动](https://github.com/acidanthera)




#### AMD_Vanilla

- [AlGrey](https://github.com/AlGreyy)提出了这个想法并创建了补丁。
- [XLNC](https://github.com/XLNCs)用于维护各种macOS版本的补丁。
- Sinetek，Andy Vandijck，spakk，Bronya，Tora Chi Yo，Shaneeee等分享了他们的AMD / XNU内核知识
- [0xD81CF](https://github.com/0xD81CF)，[dosprintfwork](https://github.com/doesprintfwork)和[erikjara](https://github.com/erikjara)用于自述翻译。

##### [Opencore安装指南](https://dortania.github.io/OpenCore-Install-Guide/)

**@ITzTravelInTime** [kx-audio-driver](https://github.com/ITzTravelInTime/kx-audio-driver)
