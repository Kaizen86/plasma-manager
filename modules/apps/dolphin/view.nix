{ config, lib, ... }:

let
  cfg = config.programs.dolphin;
  qfont = import ../../../lib/qfont.nix { inherit lib; };
  fontType = (import ./qfont.nix { inherit lib qfont; }).fontType;
in
{
  options.programs.dolphin = with lib; {
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


  config = lib.mkIf cfg.enable {
    programs.plasma.configFile."dolphinrc" = lib.foldr lib.recursiveUpdate {} [
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
    ];
  };
}