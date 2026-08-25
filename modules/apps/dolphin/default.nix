{ config, lib, pkgs, ... }:

# Default values are set for almost every option, mirroring Dolphin's defaults.
# I chose to do this because of a limitation in plasma-manager; setting a value
# to null will *not* remove it from dolphinrc, so any previously-set options will persist.
# I don't know of a way around this, so I added option defaults for reproducibility,
# but this does unfortunately mean anything the user has set before enabling this
# module will be overwritten with the defaults.

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
              true: /home/user/Documents
              false: Documents
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
            example = "fixed";
            description = ''
              Behaviour for how wide each tab should be, also known as Tab Style.
              adapt: Tab width adapts to folder name
              fixed: Tabs all have the same fixed width
              wide: Tabs span the available width
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
            example = "inactive";
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

      bars = {
        status = mkOption {
          type = types.enum [ "small" "full" "fullWithZoom" "disabled" ];
          default = "small";
          example = "full";
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

    view = {
      general = {
        rememberPerFolder = mkOption {
          type = types.bool;
          default = false; # Opposite of GlobalViewProps default
          description = ''
            Whether the display style mode will be remembered on a per-folder basis.
            If true, Dolphin will add file system metadata to folders you change the view properties for. If that is not possible, a hidden .directory will be made instead.
            If false, folders will always use the same view mode. (Except for some special views like Search, Recent Files, or Wastebin, will still use a custom display style)
          '';
        };

        iconsModeForMedia = mkOption {
          type = types.bool;
          default = false;
          description = "Use icons view mode for locations which mostly contain media files.";
        };

        # Browsing
        browseArchives = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Allow browsing compressed archives as if they were folders.
            If false, the file will be opened normally in another program.
          '';
        };

        dragOpenFolders = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Open a folder automatically while dragging an item over it.
            Similar to MacOS' "Spring Loading" behaviour.
          '';
        };

        # Miscellaneous
        hoverForInfo = mkOption {
          type = types.bool;
          default = false;
          description = "Show item information on hover.";
        };

        selectionMarkers = mkOption {
          type = types.bool;
          default = true;
          description = "Show +/- select button on top-left of hovered files.";
        };
        
        renameInline = mkOption {
          type = types.bool;
          default = true;
          description = "For single items, renaming can either be done inline (next to the icon), or in a dialog box.";
        };
        
        hideBackupFiles = mkOption {
          type = types.bool;
          default = false;
          description = "Hide backup files along with regular hidden files.";
        };

        # Background double-click action
        backgroundDoubleClick = {
          action = let
            # Python-style argument unpacking
            apply = fn: args:
              if builtins.length args > 0 then
                apply (fn (builtins.head args)) (builtins.tail args)
              else fn; # Ends up being the answer

            entries = builtins.mapAttrs
              (_: args: apply (k: d: {key=k; description=d;}) args)
            {
              # enumVariant     = [ "config_value"           "Description" ];
              "none"            = [ "none"                   "No action" ];
              "custom"          = [ "CUSTOM_COMMAND"         "Run a shell command (set in `customCommand option`)" ];
              "newTab"          = [ "new_tab"                "New Tab" ];
              "newWindow"       = [ "file_new"               "New Window" ];
              "placesPanel"     = [ "show_places_panel"      "Places panel" ];
              "infoPanel"       = [ "show_information_panel" "Information panel" ];
              "foldersPanel"    = [ "show_folders_panel"     "Folders panel" ];
              "terminalPanel"   = [ "show_terminal_panel"    "Terminal panel" ];
              "terminalOpen"    = [ "open_terminal"          "Open Terminal externally" ];
              "goUp"            = [ "go_up"                  "Parent folder" ];
              "goBack"          = [ "go_back"                "Previous location" ];
              "goHome"          = [ "go_home"                "Home location" ];
              "refresh"         = [ "view_redisplay"         "Refresh" ];
              "split"           = [ "split_view"             "Toggle split view" ];
              "selectAll"       = [ "edit_select_all"        "Select all items" ];
              "selectionMode"   = [ "toggle_selection_mode"  "Toggle Selection Mode" ];
              "createFolder"    = [ "create_dir"             "Create folder" ];
              "createFile"      = [ "create_file"            "Create new file" ];
              "showPreviews"    = [ "show_preview"           "Toggle Icon mode previews" ];
              "showHiddenFiles" = [ "show_hidden_files"      "Toggle hidden files" ];
              "group"           = [ "show_in_groups"         "Show in Groups" ];
              "adjustView"      = [ "view_properties"        "Adjust View Display Style" ];
            };

            # Bullet-pointed list for the documentation
            descriptionDocs = lib.concatMapAttrsStringSep # what a mouthful!
              "\n"
              (name: val: "- `${name}`: ${val.description}")
              entries;

          in mkOption {
            type = types.enum (lib.attrNames entries);
            default = "selectAll";
            example = "showHiddenFiles";
            description = ''
              Action to perform when double-clicking the window background.
            ''+descriptionDocs;
            apply = val: entries.${val}.key;
          };

          customCommand = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "xdg-open {path}";
            description = ''
              Shell command to execute when option `action = "custom";`

              Tip: `{path}` will be substituted with the current location path.
            '';
          };
            };
      };

      contentDisplay = {

      };

      modes = {
        icons = {};
        compact = {};
        details = {};
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
        General = with cfg.interface.bars; {
          ShowStatusBar = status.size;
          ShowZoomSlider = status.zoom;

          EditableUrl = location.editable;
          ShowFullPath = location.showFullPath;
        };
      }
      {
        # View > General
        General = with cfg.view.general; {
          GlobalViewProps = ! rememberPerFolder; # Invert
          DynamicView = iconsModeForMedia;

          BrowseThroughArchives = browseArchives;
          AutoExpandFolders = dragOpenFolders;

          ShowToolTips = hoverForInfo;
          ShowSelectionToggle = selectionMarkers;
          RenameInline = renameInline;
          HideXTrashFile = hideBackupFiles;

          DoubleClickViewAction = backgroundDoubleClick.action;
          DoubleClickViewCustomAction = backgroundDoubleClick.customCommand;
        };
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
