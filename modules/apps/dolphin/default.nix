{ config, options, lib, pkgs, ... }:

# Default values are set for almost every option, mirroring Dolphin's defaults.
# I chose to do this because of a limitation in plasma-manager; setting a value
# to null will *not* remove it from dolphinrc, so any previously-set options will persist.
# I don't know of a way around this, so I added option defaults for reproducibility,
# but this does unfortunately mean anything the user has set before enabling this
# module will be overwritten with the defaults.

let
  cfg = config.programs.dolphin;
  opt = options.programs.dolphin;
in
{
  imports = [ 
    ./interface.nix
    ./view.nix
  ];

  options.programs.dolphin = with lib; {
    enable = mkEnableOption "configuration module for KDE dolphin";
    package =
      mkPackageOption pkgs
        [
          "kdePackages"
          "dolphin"
        ]
        {
          nullable = true;
          example = "pkgs.libsForQt5.dolphin";
          extraDescription = ''
            Use `pkgs.libsForQt5.dolphin` for Plasma 5 or `pkgs.kdePackages.dolphin` for Plasma 6.
            You can also set this to `null` if you're using a system-wide installation of Dolphin on NixOS.
          '';
        };
  };

  # Write the config file
  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];
    /*
    programs.plasma.configFile."dolphinrc" = lib.foldr lib.recursiveUpdate {} [
      {
        # Context Menu
        # Not sure if I will end up implementing this...
        ContextMenu = {};
        VersionControl = {};
      };
    ];
    */
    # (also) Context Menu
    #programs.plasma.configFile."kservicemenurc".Show = {};


    assertions = with lib; [
      (let
        path = [ "view" "general" "backgroundDoubleClick" ];
        c = getAttrFromPath path cfg;
        o = getAttrFromPath path opt;
       in {
        assertion = !(c.action == "custom" && c.command == null);
        message = "${showOption o.action.loc} is set to \"custom\", but ${showOption o.customCommand.loc} is null";
      })
    ];
  };
}
