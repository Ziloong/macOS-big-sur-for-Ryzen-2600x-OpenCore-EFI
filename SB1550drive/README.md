# Sound Blaster Audigy FX SB1550 驱动方法以及说明

------


## 驱动方法1（建议使用）

- 挂载EFI分区，将kXAudioDriver.kext复制到OpenCore，并在config添加

## 驱动方法2

- [关闭SIP](https://dortania.github.io/OpenCore-Install-Guide/troubleshooting/troubleshooting.html#disabling-sip)

- 解锁SLE修改权限 打开终端依次输入

  `sudo su`

  `sudo mount -uw /`

- 将Installer  pack文件夹里面的Installer.sh拖入到终端里运行

  首先输入`i` 安装

  然后按Ctrl+C退出

  接着手动修复权限

  `Chmod 777 /usr/bin/kxctrl`

  `Chmod 777 /usr/bin/edspctrl`

  `Chmod 777 /usr/lib/kXAPI.dylib`

  `Chmod 777 /usr/bin/kxctrl`

  `Chmod 777 /usr/bin/edspctrl`

  `Chmod 777 /usr/lib/kXAPI.dylib`

- 然后再将Installer  pack文件夹里面的Installer.sh拖入到终端里运行

  输入`r` 

  然后到系统安全性里面解锁



- 最后重启电脑

  

  

## 说明

麦克风输入需要使用kX AC97.app 勾选rec





