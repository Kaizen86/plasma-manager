{ config, lib, pkgs, ... }:

let
  cfg = config.programs.dolphin;
in
{
  options.programs.dolphin = {
    enable = lib.mkEnableOption "configuration module for KDE dolphin";
    package =
      lib.mkPackageOption pkgs
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

    interface = {
      foldersAndTabs = {
        startupLocation = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;

          example = "/home/user";
          description = ''
            The absolute folder path to open on launch. If set to null, the folders, tabs, and window state from last time will be restored.
          '';
        };

        launchInNewTab = lib.mkOption {
          type = lib.types.nullOr lib.types.bool;
          default = null;

          example = true;
          description = ''
            When Dolphin is launched externally, it can either open a tab in an existing window or create a new window.
          '';
        };

        window = {
          fullPathInTitle = lib.mkOption {
            type = lib.types.nullOr lib.types.bool;
            default = null;
          
            example = true;
            description = ''
              Show the absolute folder path (e.g. /home/user/Documents) in the application title, instead of the basename (e.g Documents).
            '';
          };

          showFilterBar = lib.mkOption {
            type = lib.types.nullOr lib.types.bool;
            default = null;
          
            example = true;
            description = ''
              Launch with the Filter Bar shown by default.
            '';
          };
        };

      };
    };
  };

  # Write the config file
  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];
    programs.plasma.configFile."dolphinrc" = {
      # Interface > Folders & Tabs
      General = with cfg.interface.foldersAndTabs; {
        RememberOpenedTabs = startupLocation == null;
        HomeUrl = startupLocation;

        OpenExternallyCalledFolderInNewTab = launchInNewTab;
        ShowFullPathInTitlebar = window.fullPathInTitle;
        FilterBar = window.showFilterBar;
      };
    };
  };
}
