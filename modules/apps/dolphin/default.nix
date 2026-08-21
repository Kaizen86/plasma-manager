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

      previews = let 
        plugins = [
          "appimagethumbnail"
          "audiothumbnail"
          "blenderthumbnail"
          "comicbookthumbnail"
          "cursorthumbnail"
          "djvuthumbnail"
          "ebookthumbnail"
          "exrthumbnail"
          "directorythumbnail"
          "fontthumbnail"
          "FreeCAD"
          "imagethumbnail"
          "jpegthumbnail"
          "kraorathumbnail"
          "windowsexethumbnail"
          "windowsimagethumbnail"
          "mltpreview"
          "mobithumbnail"
          "opendocumentthumbnail"
          "gsthumbnail"
          "rawthumbnail"
          "svgthumbnail"
          "textthumbnail"
          "ffmpegthumbs"
        ];
        
      in mkOption {
        type = types.listOf types.str;
        default = builtins.filter (i: i != "textthumbnail") plugins;
        example = plugins;
        description = ''
          List of preview plugins to use. Default is all except for "textthumbnail".
        '';
        apply = val: builtins.concatStringsSep "," val;
      };

      confirmations = {
        closingWithMultipleTabs = mkOption {
          type = types.bool;
          default = true;
          example = false;
          description = ''
            Confirm closing windows with multiple tabs.
          '';
        };

        closingWithTerminal = mkOption {
          type = types.bool;
          default = true;
          example = false;
          description = ''
            Confirm closing windows with a program running in the Terminal panel.
          '';
        };

        openingManyFolders = mkOption {
          type = types.bool;
          default = true;
          example = false;
          description = ''
            Confirm opening many folders at once.
          '';
        };

        openingManyTerminals = mkOption {
          type = types.bool;
          default = true;
          example = false;
          description = ''
            Confirm opening many terminals at once.
          '';
        };
        
        administrator = mkOption {
          type = types.bool;
          default = true;
          example = false;
          description = ''
            Warn when switching to act as an administrator.
          '';
        };
        
        renamingFileType = mkOption {
          type = types.bool;
          default = true;
          example = false;
          description = ''
            Warn when changing a file's extension.
          '';
        };
      };

      # Currently only one type of panel
      # src/panels/information/dolphin_informationpanelsettings.kcfg
      panels.information = {
        showPreviews = mkOption {
          type = types.bool;
          default = true;
          example = false;
          description = ''
            Enables file previews by default.
          '';
        };

        autoPlayMedia = mkOption {
          type = types.bool;
          default = false;
          example = true;
          description = ''
            For previews of video files, begin playback automatically.
          '';
        };

        showHovered = mkOption {
          type = types.bool;
          default = true;
          example = false;
          description = ''
            Allow hovering over a file to show its information.
          '';
        };

        dateFormat = mkOption {
          type = types.enum [ "long" "short" ];
          default = "long";
          example = "short";
          description = ''
            Dates can either be displayed in a long or short format.
            long: Wednesday, 28 February 2024 at 10:00
            short: 28/02/2024 at 10:00
          '';
          apply = val: {
            "long" = "LongFormat";
            "short" = "ShortFormat";
          }.${val};
        };
      };
    };
  };

  # Write the config file
  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];
    programs.plasma.configFile."dolphinrc" = lib.foldr lib.recursiveUpdate {} [
      {
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

      # Interface > Previews
      PreviewSettings.Plugins = cfg.interface.previews;
      }
      {
      # Interface > Confirmations
      General = with cfg.interface.confirmations; {
        ConfirmClosingMultipleTabs = closingWithMultipleTabs;
        ConfirmClosingTerminalRunningProgram = closingWithTerminal;
      };
      "Notification Messages" = with cfg.interface.confirmations; {
        ConfirmOpenManyFolders = openingManyFolders;
        ConfirmOpenManyTerminals = openingManyTerminals;
        # Oddly, this one does not appear in any Dolphin .kcfg
        # Looks to be hardcoded in Dolphin src/admin/workerintegration.h
        warnAboutRisksBeforeActingAsAdmin = administrator;
        ConfirmRenameFileType = renamingFileType;
      };

      # Interface > Panels
      InformationalPanel = with cfg.interface.panels.information; {
        previewsShown = showPreviews;
        previewsAutoPlay = autoPlayMedia;
        showHovered = showHovered;
        dateFormat = dateFormat;
      };
      }
      {
      # Interface > Status & Location bars
      General = {};
      }
      {
      # View > General
      General = {};
      }
      {
      # View > Content Display
      General = {};
      ContentDisplay = {};

      # View > Icons view mode
      IconsMode = {};

      # View > Compact view mode
      CompactMode = {};

      # View > Details view mode
      DetailsMode = {};
      }
      /*
      {
    # Context Menu
        # Not sure if I will end up implementing this...
        ContextMenu = {};
        VersionControl = {};
      };
      */  
    ];
    # (also) Context Menu
    #programs.plasma.configFile."kservicemenurc".Show = {};
  };
}
