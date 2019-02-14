# z80-terminal

**Product is under construction!**

Terminal(s) for RS232 and ZIFI uart communication

* windows library: https://github.com/asve79/xasconv
* Emulator: https://github.com/tslabs/zx-evo/raw/master/pentevo/unreal/Unreal/bin/unreal.7z or https://github.com/asve79/Xpeccy

## Done
* ZX Evolution Base RS232 port Version
* ZX Evolution TS-CONF Zifi (eRS) port version
* ZX Evolution TS-CONF RS232 port Version

## Testing
* Profi RS232 (terme232.$c in hobeta file)

## Build
Assembler:  https://github.com/z00m128/sjasmplus
```bash
git clone git@github.com:asve79/z80-terminal.git

cd z80-termianl
./get_depencies.sh
./_make.sh
```

## Demo:
![Demo](https://github.com/asve79/z80-terminal/blob/master/demo/terminal-evo-rs232.gif)
![Demo](https://github.com/asve79/z80-terminal/blob/master/demo/terminal-tsconf-zifi.gif)
