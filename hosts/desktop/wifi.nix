{ config, pkgs, ... }:

{
  # MediaTek MT7921K / RZ608.
  hardware.firmware = with pkgs; [
    linux-firmware
  ];

  boot.kernelModules = [ "mt7921e" ];
}
