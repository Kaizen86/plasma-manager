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
              Should the Filter Bar be shown by default.
            '';
          };
        };

        tabs = {
          alwaysShow = mkOption {
            type = types.bool;
            default = false;
            example = true;
            description = ''
              Should the tab bar always be shown, even when there is only one tab.
            '';
          };

          closeButtons = mkOption {
            type = types.bool;
            default = true;
            example = false;
            description = ''
              Should tabs have a button to close them
            '';
          };

          width = mkOption {
            type = types.enum [ "adapt" "fixed" "full" ];
            default = "adapt";
            example = "fixed";
            description = ''
              Behaviour for how wide each tab should be, also known as Tab Style.
              adapt: Tab width adapts to folder name
              fixed: Tabs all have the same fixed width
              wide: Tabs span the available width
            '';
            apply = val: {
              "auto" = "AutoSize";
              "fixed" = "FixedWidth";
              "wide" = "FullWidth";
            }.${val};
          };

          openAtEnd = mkOption {
            type = types.bool;
            default = false;
            example = true;
            description = ''
              Should new tabs be placed at end of tab bar, instead of next to current tab.
            '';
          };
        };

        splitView = {
          close = mkOption {
            type = types.enum [ "active" "inactive" "right" ];
            default = "active";
            example = true;
            description = ''
              When leaving split-view mode, which pane should be closed.
              active: Close the selected pane
              inactive: Close the opposite pane
              right: Always close the right pane
            '';
            apply = val: {
              "active" = "ActiveView";
              "inactive" = "InactiveView";
              "right" = "RightView";
            }.${val};
          };

          default = mkOption {
            type = types.bool;
            default = false;
            example = true;
            description = ''
              Open new windows in split-view mode
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

        AlwaysShowTabBar = tabs.alwaysShow;
        ShowCloseButtonOnTabs = tabs.closeButtons;
        TabStyle = tabs.width;
        OpenNewTabAfterLastTab = tabs.openAtEnd;

        SplitView = splitView.default;
        CloseSplitViewChoice = splitView.close;
      };
    };
  };
}
