{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd.availableKernelModules = [
      "xhci_pci"
      "ehci_pci"
      "ahci"
      "usb_storage"
      "sd_mod"
      "rtsx_pci_sdmmc"
    ];

    kernelModules = [
      "kvm-intel"
      "fbcon"
      "tun"
      "virtio"
      "coretemp"
      "psmouse"
      "fuse"
      "tp_smapi"
      "hdaps"
      "bluetooth"
      "btusb"
      "uvcvideo"
    ];

    blacklistedKernelModules = [
      "pcpskr"
      "snd_pcsp"
      "xpad"
      "uhci_hcd"
      "pcmcia"
      "yenta_socket"
      "sierra_net"
      "cdc_mbim"
      "cdc_ncm"
    ];

    extraModulePackages = [
      config.boot.kernelPackages.tp_smapi
    ];

    kernel.sysctl = {
      "vm.laptop_mode" = 5;
      "kernel.nmi_watchdog" = 60;
    };

    extraModprobeConfig = ''
      options snd_hda_intel index=1,0 power_save=1
      options iwlwifi power_save=1 d0i3_disable=0 uapsd_disable=0
    '';

    initrd.luks.devices = [
      {
        device = "/dev/vg/root";
        name = "root";
        preLVM = false;
      }
    ];

    cleanTmpDir = true;
  };

  fileSystems = [
    {
      device = "/dev/disk/by-uuid/6106-6BF8";
      fsType = "vfat";
      mountPoint = "/boot";
    }

    {
      device = "/dev/mapper/root";
      fsType = "ext4";
      mountPoint = "/";
    }
  ];

  swapDevices = [
    {
      device = "/dev/vg/swap";
    }
  ];

  networking = {
    hostName = "vulpo";
    hostId = "6B1548AD";
    enableIPv6 = true;
    networkmanager = {
      enable = true;
    };

    firewall = {
      enable = true;
    };

    extraHosts = builtins.readFile ./dat/blokitaj.txt + builtins.readFile ./dat/diversaj.txt;
  };

  i18n = {
    consoleKeyMap = "dvorak";
    defaultLocale = "eo.utf8";
    supportedLocales = [
      "eo/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
  };

  environment = {
    systemPackages = with pkgs; [ zsh ];
  };

  fonts = {
    fontconfig.enable = true;
    enableCoreFonts = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      dejavu_fonts
      liberation_ttf
      ttf_bitstream_vera
      terminus_font
      cantarell_fonts
      noto-fonts
      dosemu_fonts
      powerline-fonts
      proggyfonts
      ucsFonts
    ];
  };

  time.timeZone = "Asia/Manila";

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: rec {
     avahi = pkgs.avahi.overrideDerivation(args: rec {
       airprint = ./AirPrint-HP_Deskjet_1510_series.service;
       postInstall = ''
         ln -s $airprint $out/etc/avahi/services/AirPrint-HP_Deskjet_1510_series.service
       '';
     });
    };
  };

  nix = {
    maxJobs = lib.mkDefault 4;
    gc.automatic = false;
    trustedBinaryCaches = [
      "http://hydra.nixos.org"
      "http://cache.nixos.org"
      "http://hydra.cryp.to"
    ];
    useSandbox = true;
    package = pkgs.nix;
  };

  programs = {
    ssh.startAgent = true;
    command-not-found.enable = true;
  };

  documentation = {
    man.enable = true;
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    opengl.driSupport = true;
    opengl.driSupport32Bit = true;
    opengl.extraPackages = [ pkgs.vaapiIntel ];
    trackpoint.enable = false;
    trackpoint.emulateWheel = false;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
  };

  virtualisation = {
    virtualbox = {
      host.enable = true;
    };
    docker = {
      enable = true;
      extraOptions = "-H tcp://0.0.0.0:2375 -s overlay2 --dns 1.1.1.1";
    };
  };

  users = {
    defaultUserShell = "/run/current-system/sw/bin/zsh";

    extraUsers.ebzzry = {
      uid = 1000;
      name = "ebzzry";
      description = "Rommel MARTINEZ";
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "docker" "kvm" "scanner" "lp" ];
    };
  };

  services = {
    xserver = {
      autorun = true;
      defaultDepth = 24;
      enable = true;
      layout = "dvorak";
      displayManager.lightdm = {
        enable = true;
        extraSeatDefaults = ''
        '';
      };

      videoDrivers = [ "intel" ];

      wacom.enable = true;

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
    };

    nixosManual = {
      enable = false;
      showManual = true;
    };

    ntp = {
      enable = true;
      servers = [ "asia.pool.ntp.org" "0.pool.ntp.org" "1.pool.ntp.org" "2.pool.ntp.org" ];
    };

    acpid = {
      enable = true;
      powerEventCommands = "echo 2 > /proc/acpi/ibm/beep";
      lidEventCommands = "echo 3 > /proc/acpi/ibm/beep";
      acEventCommands = "echo 4 > /proc/acpi/ibm/beep";
    };

    udev.extraRules = ''
      SUBSYSTEM=="net", KERNEL=="eth*", RUN+="${pkgs.ethtool}/bin/ethtool -s %k wol d"
      SUBSYSTEM=="net", KERNEL=="enp*", RUN+="${pkgs.ethtool}/bin/ethtool -s %k wol d"
      ACTION=="add", SUBSYSTEM=="net", KERNEL=="wlan*", RUN+="${pkgs.iw}/bin/iw dev %k set power_save on"
      ACTION=="add", SUBSYSTEM=="pci", ATTR{power/control}="auto"
    '';

    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint pkgs.hplipWithPlugin pkgs.canon-cups-ufr2 ];
      browsing = true;
      defaultShared = true;
    };

    avahi = {
      enable = true;
      hostName = config.networking.hostName;
      ipv4 = true;
      nssmdns = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };

    fail2ban.enable = true;
    tlp.enable = true;
    unifi.enable = false;
    saned.enable = true;

    postgresql.enable = true;
  };

  systemd.services = {
    tune-power-management = {
      description = "Tune Power Management";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = false;
      };

      unitConfig.RequiresMountsFor = "/sys";
      script = ''
        echo 6000 > /proc/sys/vm/dirty_writeback_centisecs
        echo 1 > /sys/module/snd_hda_intel/parameters/power_save

        for knob in \
            /sys/bus/i2c/devices/i2c-0/device/power/control \
            /sys/bus/i2c/devices/i2c-1/device/power/control \
            /sys/bus/i2c/devices/i2c-2/device/power/control \
            /sys/bus/i2c/devices/i2c-3/device/power/control \
            /sys/bus/i2c/devices/i2c-4/device/power/control \
            /sys/bus/i2c/devices/i2c-5/device/power/control \
            /sys/bus/i2c/devices/i2c-6/device/power/control \
            /sys/bus/pci/devices/0000:00:00.0/power/control \
            /sys/bus/pci/devices/0000:00:02.0/power/control \
            /sys/bus/pci/devices/0000:00:16.0/power/control \
            /sys/bus/pci/devices/0000:00:19.0/power/control \
            /sys/bus/pci/devices/0000:00:1b.0/power/control \
            /sys/bus/pci/devices/0000:00:1c.0/power/control \
            /sys/bus/pci/devices/0000:00:1c.1/power/control \
            /sys/bus/pci/devices/0000:00:1d.0/power/control \
            /sys/bus/pci/devices/0000:00:1f.0/power/control \
            /sys/bus/pci/devices/0000:00:1f.2/power/control \
            /sys/bus/pci/devices/0000:00:1f.3/power/control \
            /sys/bus/pci/devices/0000:00:1f.6/power/control \
            /sys/bus/pci/devices/0000:03:00.0/power/control \
        ; do echo auto > $knob; done

        for knob in \
            /sys/class/scsi_host/host0/link_power_management_policy \
            /sys/class/scsi_host/host1/link_power_management_policy \
            /sys/class/scsi_host/host2/link_power_management_policy \
        ; do echo min_power > $knob; done
      '';
    };

    tune-usb-autosuspend = {
      description = "Disable USB autosuspend";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = { Type = "oneshot"; };
      unitConfig.RequiresMountsFor = "/sys";
      script = ''
        echo -1 > /sys/module/usbcore/parameters/autosuspend
      '';
    };

    screenlock = {
      description = "Lock screen when system sleeps";
      before = [ "sleep.target" ];
      wantedBy = [ "sleep.target" ];
      environment = { DISPLAY = ":0"; };

      serviceConfig = {
        SyslogIdentifier = "screenlock";
        ExecStart = "${pkgs.xscreensaver}/bin/xscreensaver-command -l";
        Type = "forking";
        User = "ebzzry";
      };
    };
  };

  system = {
    autoUpgrade = {
      enable = true;
      channel = https://nixos.org/channels/nixos-18.09;
      dates = "00:00";
    };
  };
}
