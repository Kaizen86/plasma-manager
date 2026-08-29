{ config, lib, ... }:

let
  cfg = config.programs.dolphin;
in
{
  options.programs.dolphin = with lib; {
    # https://invent.kde.org/system/dolphin/-/blob/master/src/settings/dolphin_generalsettings.kcfg
    interface = {
      foldersAndTabs = {
        startupLocation = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "/home/user";
          description = ''
            The absolute folder path to open on launch.

            If set to null, the folders, tabs, and window state from last time will be restored.
          '';
        };

        launchInNewTab = mkOption {
          type = types.bool;
          default = false;
          description = "When Dolphin is launched externally, it can either open a tab in an existing window or create a new window.";
        };

        window = {
          fullPath = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Show the absolute folder path in the application title instead of the basename.
              - `true`: /home/user/Documents
              - `false`: Documents
            '';
          };

          showFilterBar = mkOption {
            type = types.bool;
            default = false;
            description = "Should the Filter Bar be shown by default.";
          };
        };

        tabs = {
          alwaysShow = mkOption {
            type = types.bool;
            default = false;
            description = "Should the tab bar always be shown, even when there is only one tab.";
          };

          closeButtons = mkOption {
            type = types.bool;
            default = true;
            description = "Should tabs have a button to close them.";
          };

          width = mkOption {
            type = types.enum [ "adapt" "fixed" "wide" ];
            default = "adapt";
            description = ''
              Behaviour for how wide each tab should be, also known as Tab Style.
              - `adapt`: Tab width adapts to folder name
              - `fixed`: Tabs all have the same fixed width
              - `wide`: Tabs span the available width
            '';
            apply = val: {
              "adapt" = "AutoSize";
              "fixed" = "FixedWidth";
              "wide" = "FullWidth";
            }.${val};
          };

          openAtEnd = mkOption {
            type = types.bool;
            default = false;
            description = "Should new tabs be placed at end of tab bar, instead of next to current tab.";
          };
        };

        splitView = {
          close = mkOption {
            type = types.enum [ "active" "inactive" "right" ];
            default = "active";
            description = ''
              When leaving split-view mode, which pane should be closed.
              - `active`: Close the selected pane
              - `inactive`: Close the opposite pane
              - `right`: Always close the right pane
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
            description = "Open new windows in split-view mode";
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
          List of preview plugins to use.
          Default is all except "textthumbnail".
        '';
        apply = val: builtins.concatStringsSep "," val;
      };

      confirmations = {
        closingWithMultipleTabs = mkOption {
          type = types.bool;
          default = true;
          description = "Confirm closing windows with multiple tabs.";
        };

        closingWithTerminal = mkOption {
          type = types.bool;
          default = true;
          description = "Confirm closing windows with a program running in the Terminal panel.";
        };

        openingManyFolders = mkOption {
          type = types.bool;
          default = true;
          description = "Confirm opening many folders at once.";
        };

        openingManyTerminals = mkOption {
          type = types.bool;
          default = true;
          description = "Confirm opening many terminals at once.";
        };

        administrator = mkOption {
          type = types.bool;
          default = true;
          description = "Warn when switching to act as an administrator.";
        };

        renamingFileType = mkOption {
          type = types.bool;
          default = true;
          description = "Warn when changing a file's extension.";
        };
      };

      # Currently only one type of panel
      # https://invent.kde.org/system/dolphin/-/blob/master/src/panels/information/dolphin_informationpanelsettings.kcfg
      panels.information = {
        showPreviews = mkOption {
          type = types.bool;
          default = true;
          description = "Enables file previews by default.";
        };

        autoPlayMedia = mkOption {
          type = types.bool;
          default = false;
          description = "For previews of video files, begin playback automatically.";
        };

        showHovered = mkOption {
          type = types.bool;
          default = true;
          description = "Allow hovering over a file to show its information.";
        };

        dateFormat = mkOption {
          type = types.enum [ "long" "short" ];
          default = "long";
          description = ''
            Dates can either be displayed in a long or short format.
            - `long`: Wednesday, 28 February 2024 at 10:00
            - `short`: 28/02/2024 at 10:00
          '';
          apply = val: {
            "long" = "LongFormat";
            "short" = "ShortFormat";
          }.${val};
        };
      };

      bars = {
        status = mkOption {
          type = types.enum [ "small" "full" "fullWithZoom" "disabled" ];
          default = "small";
          description = ''
            Type of bottom Status bar.
            Full-sized can optionally include a zoom slider.
          '';
          apply = val: {
            # "Full" has a checkbox to include a zoom slider.
            # The cleanest way I could think to implement this is with a 4th enum variant, and expose 2 variables in cfg.
            # If they ever add a second checkbox, we'll need a different approach...
            size = {
              "small" = "Small";
              "full" = "FullWidth";
              "fullWithZoom" = "FullWidth";
              "disabled" = "Disabled";
            }.${val};
            zoom = val == "fullWithZoom";
          };
        };

        location = {
          editable = mkOption {
            type = types.bool;
            default = false;
            description = "Allow the location URI to be manually edited.";
          };

          showFullPath = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Always show the full path inside the location bar.
              e.g. the special Network folder will show "remote:/"
            '';
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
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
        General = with cfg.interface.bars; {
          ShowStatusBar = status.size;
          ShowZoomSlider = status.zoom;

          EditableUrl = location.editable;
          ShowFullPath = location.showFullPath;
        };
      }
    ];
  };
}