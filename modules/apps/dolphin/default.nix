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

  # pilfered and plundered from ../kate/default.nix
  qfont = import ../../../lib/qfont.nix { inherit lib; };

  styleStrategyType = lib.types.submodule {
    options = with qfont.styleStrategy; {
      prefer = lib.mkOption {
        type = prefer;
        default = "default";
        description = ''
          Which type of font is preferred by the font when finding an appropriate default family.

          `default`, `bitmap`, `device`, `outline`, `forceOutline` correspond to the
          `PreferDefault`, `PreferBitmap`, `PreferDevice`, `PreferOutline`, `ForceOutline` enum flags
          respectively.
        '';
      };
      matchingPrefer = lib.mkOption {
        type = matchingPrefer;
        default = "default";
        description = ''
          Whether the font matching process prefers exact matches, or best quality matches.

          `default` corresponds to not setting any enum flag, and `exact` and `quality`
          correspond to `PreferMatch` and `PreferQuality` enum flags respectively.
        '';
      };
      antialiasing = lib.mkOption {
        type = antialiasing;
        default = "default";
        description = ''
          Whether antialiasing is preferred for this font.

          `default` corresponds to not setting any enum flag, and `prefer` and `disable`
          correspond to `PreferAntialias` and `NoAntialias` enum flags respectively.
        '';
      };
      noSubpixelAntialias = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          If set to `true`, this font will try to avoid subpixel antialiasing.

          Corresponds to the `NoSubpixelAntialias` enum flag.
        '';
      };
      noFontMerging = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          If set to `true`, this font will not try to find a substitute font when encountering missing glyphs.

          Corresponds to the `NoFontMerging` enum flag.
        '';
      };
      preferNoShaping = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          If set to `true`, this font will not try to apply shaping rules that may be required for some scripts
          (e.g. Indic scripts), increasing performance if these rules are not required.

          Corresponds to the `PreferNoShaping` enum flag.
        '';
      };
    };
  };

  fontType = lib.types.submodule {
    options = {
      family = lib.mkOption {
        type = lib.types.str;
        description = "The font family of this font.";
        example = "Noto Sans";
      };
      pointSize = lib.mkOption {
        type = lib.types.nullOr lib.types.numbers.positive;
        default = null;
        description = ''
          The point size of this font.

          Could be a decimal, but usually an integer. Mutually exclusive with pixel size.
        '';
      };
      pixelSize = lib.mkOption {
        type = lib.types.nullOr lib.types.ints.u16;
        default = null;
        description = ''
          The pixel size of this font.

          Mutually exclusive with point size.
        '';
      };
      styleHint = lib.mkOption {
        type = qfont.styleHint;
        default = "anyStyle";
        description = ''
          The style hint of this font.

          See https://doc.qt.io/qt-6/qfont.html#StyleHint-enum for more.
        '';
      };
      weight = lib.mkOption {
        type = lib.types.either (lib.types.ints.between 1 1000) qfont.weight;
        default = "normal";
        description = ''
          The weight of the font, either as a number between 1 to 1000 or as a pre-defined weight string.

          See https://doc.qt.io/qt-6/qfont.html#Weight-enum for more.
        '';
      };
      style = lib.mkOption {
        type = qfont.style;
        default = "normal";
        description = "The style of the font.";
      };
      underline = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the font is underlined.";
      };
      strikeOut = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the font is struck out.";
      };
      fixedPitch = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the font has a fixed pitch.";
      };
      capitalization = lib.mkOption {
        type = qfont.capitalization;
        default = "mixedCase";
        description = ''
          The capitalization settings for this font.

          See https://doc.qt.io/qt-6/qfont.html#Capitalization-enum for more.
        '';
      };
      letterSpacingType = lib.mkOption {
        type = qfont.spacingType;
        default = "percentage";
        description = ''
          Whether to use percentage or absolute spacing for this font.

          See https://doc.qt.io/qt-6/qfont.html#SpacingType-enum for more.
        '';
      };
      letterSpacing = lib.mkOption {
        type = lib.types.number;
        default = 0;
        description = ''
          The amount of letter spacing for this font.

          Could be a percentage or an absolute spacing change (positive increases spacing, negative decreases spacing),
          based on the selected `letterSpacingType`.
        '';
      };
      wordSpacing = lib.mkOption {
        type = lib.types.number;
        default = 0;
        description = ''
          The amount of word spacing for this font, in pixels.

          Positive values increase spacing while negative ones decrease spacing.
        '';
      };
      stretch = lib.mkOption {
        type = lib.types.either (lib.types.ints.between 1 4000) qfont.stretch;
        default = "anyStretch";
        description = ''
          The stretch factor for this font, as an integral percentage (i.e. 150 means a 150% stretch),
          or as a pre-defined stretch factor string.
        '';
      };
      styleStrategy = lib.mkOption {
        type = styleStrategyType;
        default = { };
        description = ''
          The strategy for matching similar fonts to this font.

          See https://doc.qt.io/qt-6/qfont.html#StyleStrategy-enum for more.
        '';
      };
      styleName = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          The style name of this font, overriding the `style` and `weight` parameters when set.
          Used for special fonts that have styles beyond traditional settings.
        '';
      };
    };
  };
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

    view = {
      general = {
        rememberPerFolder = mkOption {
          type = types.bool;
          default = false; # Opposite of GlobalViewProps default
          description = ''
            Whether the display style mode will be remembered on a per-folder basis.
            - `true`: Dolphin will add file system metadata to folders you change the view properties for. If that is not possible, a hidden .directory will be made instead.
            - `false`: folders will always use the same view mode. (Except for some special views like Search, Recent Files, or Wastebin, will still use a custom display style)
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
            Similar to macOS Finder's "Spring-Loaded Folders" feature.
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
            descriptionDocs = concatMapAttrsStringSep # what a mouthful!
              "\n"
              (name: val: "- `${name}`: ${val.description}")
              entries;

          in mkOption {
            type = types.enum (attrNames entries);
            default = "selectAll";
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
        sortMode = mkOption {
          type = types.enum [ "natural" "caseInsensitive" "caseSensitive" ];
          default = "natural";
          description = ''
            Order to sort items in.
            - `natural`: File2, file2, File10, file10
            - `caseInsensitive`: File10, file10, File2, file2
            - `caseSensitive`: File10, File2, file10, file2
            '';
          apply = val: {
            "natural" = "NaturalSorting";
            "caseSensitive" = "CaseSensitiveSorting";
            "caseInsensitive" = "CaseInsensitiveSorting";
          }.${val};
        };

        folderSize = {
          mode = mkOption {
            type = types.enum [ "none" "count" "size" ];
            default = "count";
            description = ''
              How to display the size of directories.
              - `none`: Show no size.
              - `count`: Show number of items.
              - `size`: Show size of contents up to N levels deep. (see maxDepth)
            '';
            apply = val: {
              "none" = "None";
              "count" = "ContentCount";
              "size" = "ContentSize";
            }.${val};
          };

          maxDepth = mkOption {
            type = types.ints.between 1 20;
            default = 10;
            example = 20;
            description = "Maximum folder scan depth when option `mode`=\"size\". Must be between 1-20.";
          };
        };

        relativeDates = mkOption {
          type = types.bool;
          default = true;
          description = "Whether item dates should be shown relative to the current time (e.g. `30 minutes ago`) or as an absolute timestamp (e.g. `29/08/2026 16:40`).";
        };

        permissionsStyle = mkOption {
          type = types.enum [ "symbolic" "numeric" "combined" ];
          default = "symbolic";
          description = ''
            Format used for displaying UNIX permissions.
            - `symbolic`: drwxr-xr-x
            - `numeric`: 755
            - `combined`: drwxr-xr-x (755)
          '';
          apply = val: {
            "symbolic" = "SymbolicFormat";
            "numeric" = "NumericFormat";
            "combined" = "CombinedFormat";
          }.${val};
        };

        elideLongNamesAt = mkOption {
          type = types.enum [ "middle" "right" ];
          default = "middle";
          description = ''
            Where to elide (shorten) long file names. Can either happen in the middle or near the end.
            - `middle`: Some very ... name.txt
            - `right: Some very long....txt
          '';
          apply = val: {
            "middle" = "Middle";
            "right" = "Right";
          }.${val};
        };
      };

      # src/settings/dolphin_*modesettings.kcfg

      modes = let
        #validSizes = types.enum [ 16 22 32 48 64 80 96 112 128 144 160 176 192 208 224 240 256 ];
        validSizes = types.ints.between 16 256;
        # https://github.com/KDE/kiconthemes/blob/master/src/kiconloader.h#L188
        KIconLoader = {
          SizeSmall = 16;
          SizeSmallMedium = 22;
          SizeMedium = 32;
          SizeLarge = 48;
          SizeHuge = 64;
          SizeEnormous = 128;
        };
      in mapAttrs
        (name: extends: recursiveUpdate
          # A few options are common for all modes, so we can save some boilerplate
          {
            iconSize = mkOption {
              type = validSizes;
              description = "Icon size when previews are disabled.";
            };
            previewSize = mkOption {
              type = validSizes;
              description = "Icon size when previews are enabled.";
            };
            font = mkOption {
              type = types.nullOr fontType;
              default = null;
              description = "Set the font to use for this mode. If left null, the system font is used.";
              apply = font: if font == null then null else qfont.fontToString font;
            };
          } extends
        )
        {
          icons = {
            iconSize.default = KIconLoader.SizeMedium;
            previewSize.default = KIconLoader.SizeHuge;

            labelMinWidth = mkOption {
              type = types.enum [ "small" "medium" "large" "huge" ];
              default = "medium";
              description = "Minimum width reserved for text beneath icons.";
              apply = val: {
                "small" = 0;
                "medium" = 1;
                "large" = 2;
                "huge" = 3;
              }.${val};
            };

            labelMaxLines = mkOption {
              type = types.ints.between 0 5;
              default = 3;
              description = "Maximum number of lines for text beneath icons.";
            };
          };

          compact = {
            iconSize.default = KIconLoader.SizeSmall;
            previewSize.default = KIconLoader.SizeLarge;

            labelMaxWidth = mkOption {
              type = types.enum [ "unlimited" "small" "medium" "large" ];
              default = "unlimited";
              description = "Maximum width reserved for text beneath icons.";
              apply = val: {
                "unlimited" = 0;
                "small" = 1;
                "medium" = 2;
                "large" = 3;
              }.${val};
            };
          };

          details = {
            iconSize.default = KIconLoader.SizeSmall;
            previewSize.default = KIconLoader.SizeLarge;

            expandableFolders = mkOption {
              type = types.bool;
              default = true;
              description = "Allow expanding folders into a tree view, where sub-folders can be further expanded.";
            };

            openByClickingAnywhereOnRow = mkOption {
              type = types.bool;
              default = true;
              description = "Open files and folders by clicking anywhere on the row, or only on the icon or name.";
            };
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
      (with cfg.view.contentDisplay; {
        # View > Content Display
        General.SortingChoice = sortMode;
        ContentDisplay = {
          DirectorySizeMode = folderSize.mode;
          RecursiveDirectorySizeLimit = folderSize.maxDepth;

          UseShortRelativeDates = relativeDates;
          UsePermissionsFormat = permissionsStyle;
          ElidingMode = elideLongNamesAt;
        };
      })
      (lib.recursiveUpdate
        (lib.mapAttrs
          (_: loc: {
            # All modes implement these settings
            IconSize = loc.iconSize;
            PreviewSize = loc.previewSize;
            UseSystemFont = loc.font == null;
            ViewFont = loc.font;
          })
          (with cfg.view.modes; {
            IconsMode = icons;
            CompactMode = compact;
            DetailsMode = details;
          })
        )

        # Mode-specific settings
        (with cfg.view.modes; {
          # View > Icons view mode
          IconsMode = {
            TextWidthIndex = icons.labelMinWidth;
            MaximumTextLines = icons.labelMaxLines;
          };

          # View > Compact view mode
          CompactMode.MaximumTextWidthIndex = compact.labelMaxWidth;

          # View > Details view mode
          DetailsMode = let
            padding = if details.openByClickingAnywhereOnRow then 20 else 0;
          in {
            ExpandableFolders = details.expandableFolders;
            HighlightEntireRow = details.openByClickingAnywhereOnRow;
            LeftPadding = padding;
            RightPadding = padding;
          };
        })
      )
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
