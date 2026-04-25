# hoststat
> 一个设备运行状态检查工具，检查您的linux设备是否正常运行

结合了一些基本的systemd指令的简单shell代码。
这也许能帮助你检查设备运行的错误，做出简要的诊断，避免陷入直接关机重启和无效等待的情况

## 如何使用？
赋予脚本基本权限，使用./ hoststat.sh通过默认shell编译器运行

推荐将它加入你的bash配置文件作为常驻指令

`echo -e '\nalias hsat="/your_path_to_hoststat"' >> /.bashrc`

## 组成部分
完全使用shell代码

## 使用依赖
带有systemd的linux发行版本(大部分流行发行版)， 没有其他额外依赖
