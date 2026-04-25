# hoststat
> A hoststat checksum to ensure your linux device work well
Other language: [简体中文](README-zh.md)

A simple shell code that integrate some basic Debian linux command. This might help you to check out what's wrong with your device by making a rough diagnosis, while you are in a dilemma between shut down your device and wait helplessly.

## How to use?
give basical permission to hoststat.sh
`./ hoststat.sh`
this will use the default shell script compiler to run it

It is also recommended to add it to your **.bashrc** as an extra commmand
```shell
echo -e ‘\nalias hsat="/your_path_to_hoststat/"’ >> /.bashrc  
```

## How it compose?
using purely shell code, bash especially

## Reqirements
linux distribution with systemd(popular releases), no outer requirements included

