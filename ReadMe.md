
## MSI X470 Gaming Plus_Ryzen 2600X Hackintosh Opencore



主板：MSI X470 Gaming Plus 

系统：macOS Big Sur 11.0 Beta (20A4300b)

CPU：AMD Ryzen2600x six-core

闪存：GALAX 8G 3600Mhz X4

硬盘：intel 760p 500G nvme

显卡：Powercolor RX580 2048sp （flash Vbios RX570）

声卡：ALC892 and Sound Blaster Audigy FX SB1550 7.1

网卡：RealtekRTL8111 



## 什么东西可以做的更好？

- 休眠唤醒


`sudo pmset -a hibernatemode 0`

- 开启Hidpi

`bash -c "$(curl -fsSL https://raw.githubusercontent.com/xzhih/one-key-hidpi/master/hidpi.sh)"`



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

- Drivers
  - AudioDxe.efi UEFI音频驱动
  - HFSPlus.efi  文件系统驱动
  - OpenCanopy.efi  OpenCore主题
  - OpenRuntime.efi 内存驱动
  
- intel 760p nvme外置硬盘改内置问题

  使用[Hackintool](http://headsoft.com.au/download/mac/Hackintool.zip) 进入到PCie选项 找到硬盘的设备地址 `PciRoot(0x0)/Pci(0x1,0x1)/Pci(0x0,0x0)` 

  Properties方式注入`built-in` 数据类型DATA写上`01`
