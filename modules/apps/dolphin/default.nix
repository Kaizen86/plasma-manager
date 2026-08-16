{ config, lib, pkgs, ... }:

let
  cfg = config.programs.dolphin;
in
{
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

    # https://invent.kde.org/system/dolphin/-/blob/master/src/settings/dolphin_generalsettings.kcfg

    interface = {
      foldersAndTabs = {
        startupLocation = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "/home/user";
          description = ''
            The absolute folder path to open on launch. If set to null, the folders, tabs, and window state from last time will be restored.
          '';
        };

        launchInNewTab = mkOption {
          type = types.bool;
          default = false;
          example = true;
          description = ''
            When Dolphin is launched externally, it can either open a tab in an existing window or create a new window.
          '';
        };

        window = {
          fullPath = mkOption {
            type = types.bool;
            default = false;
            example = true;
            description = ''
              Show the absolute folder path (e.g. /home/user/Documents) in the application title, instead of the basename (e.g Documents).
            '';
          };

          showFilterBar = mkOption {
            type = types.bool;
            default = false;
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
        ShowFullPathInTitlebar = window.fullPath;
        FilterBar = window.showFilterBar;
      };
    };
  };
}
