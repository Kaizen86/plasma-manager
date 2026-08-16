Settings in `~/.config/dolphinrc`, as of Dolphin version 26.04.3
(Config version 202)
# Interface
## Folders & Tabs
`[General]`
- Show on startup
	- Folders, tabs, and window state from last time
		- `RememberOpenedTabs=true`
	- Location
		- `RememberOpenedTabs=false`
		- `HomeUrl="<absolute path>"`
			- *Default is `/home/$(whoami)`*
			- Expansions/wildcards like `~` are forbidden
- Opening Folders: Keep a single Dolphin window, opening new folders in tabs
	- `OpenExternallyCalledFolderInNewTab=true`
- Window:
	- Show full path in title bar
		- `ShowFullPathInTitlebar=true`
	- Show filter bar
		- `FilterBar=true`
- Tab width:
	- Always show tab bar
		- `AlwaysShowTabBar=true`
	- Show close button on tabs
		- `ShowCloseButtonOnTabs=true`
- Tab style
	- Tab width adapts to folder name
		- `TabStyle=AutoSize`
		- *Default when blank*
	- Tabs all have the same fixed width
		- `TabStyle=FixedSize`
	- Tabs span the available width
		- `TabStyle=FullWidth`
- Open new tabs
	- After current tab
		- `OpenNewTabAfterLastTab=false`
		- *Default when blank*
	- At end of tab bar
		- `OpenNewTabAfterLastTab=true`
- Split view
	- When closing a split view
		- Close the active pane
			- `CloseSplitViewChoice=ActiveView`
			- *Default when blank*
		- Close the inactive pane
			- `CloseSplitViewChoice=InactiveView`
		- Close the right pane
			- `CloseSplitViewChoice=RightView`
	~~- Switch between views with Tab key
		- `UseTabForSwitchingSplitView=true`~~
		- Will be removed soon
	- Open new  windows in split view mode
		- `SplitView=true`

## Previews
`[PreviewSettings]`
- Show previews in the view for:
	- `Plugins=comma,separated,list`
	- *See table for list of plugin names*
	- Default config is all except `textthumbnail`

| Name                          | Plugin name             |
| ----------------------------- | ----------------------- |
| AppImage                      | `appimagethumbnail`     |
| Audio files                   | `audiothumbnail`        |
| Blender files                 | `blenderthumbnail`      |
| Comic Books                   | `comicbookthumbnail`    |
| Cursor Files                  | `cursorthumbnail`       |
| DjVu Files                    | `djvuthumbnail`         |
| eBooks                        | `ebookthumbnail`        |
| EXR Images                    | `exrthumbnail`          |
| Folders                       | `directorythumbnail`    |
| Font Files                    | `fontthumbnail`         |
| FreeCAD Document files        | `FreeCAD`               |
| Images (GIF, PNG, BMP, ...)   | `imagethumbnail`        |
| JPEG Images                   | `jpegthumbnail`         |
| Krita Documents               | `kraorathumbnail`       |
| Microsoft Windows Executables | `windowsexethumbnail`   |
| Microsoft Windows Images      | `windowsimagethumbnail` |
| MLT Playlist                  | `mltpreview`            |
| Mobipocket Files              | `mobithumbnail`         |
| Office Documents              | `opendocumentthumbnail` |
| PostScript, PDF and DVI files | `gsthumbnail`           |
| RAW Photo Camera Files        | `rawthumbnail`          |
| SVG Images                    | `svgthumbnail`          |
| Text Files                    | `textthumbnail`         |
| Video Files                   | `ffmpegthumbs`          |

- Local storage: Show previews for
	- *Stored in `kdeglobals`*
- Remote storage: Show previews for
	- *Stored in `kdeglobals`*

## Confirmations
- Ask for confirmation in all KDE applications when:
	- *Stored in `kiorc`*

- Ask for confirmation in Dolphin when:
	- *All of these default to `true` when blank*
	- Closing windows with multiple tabs
		- `[General] ConfirmClosingMultipleTabs=true`
	- Closing windows with a program running in the Terminal panel
		- `[General] ConfirmClosingTerminalRunningProgram=true`
	- Opening many folders at once
		- `[Notification Messages] ConfirmOpenManyFolders=true`
	- Opening many terminals at once
		- `[Notification Messages] ConfirmOpenManyTerminals=true`
	- Switching to act as an administrator
		- `[Notification Messages] warnAboutRisksBeforeActingAsAdmin=true`

- When opening an executable file:
	- *Stored in `kiorc`*
## Panels
`[InformationPanel]`
- Information Panel:
	- Show previews
		- `previewsShown=true`
		- *Blank defaults to `true`*
	- Auto-play media files
		- `previewsAutoPlay=true`
	- Show item on hover
		- `showHovered=false`
		- *Blank defaults to `true`*

	- Use long date, for example `Wednesday, 28 February 2024 at 10:00`
		- `dateFormat=LongFormat`
		- *Default when blank*
	- Use condensed date, for example `28/02/2024 at 10:00`
		- `dateFormat=ShortFormat`
## Status & Location bars
`[General]`
- Status Bar:
	- Small
		- `ShowStatusBar=FullWidth`
	- Full width
		- `ShowStatusBar=FullWidth`
		- Show zoom slider:
			- `ShowZoomSlider=true`
	 - Disabled
		- `ShowStatusBar=Disabled`

- Location bar:
	- Make location bar editable
		- `EditableUrl=true`
	- Show full path inside location bar
		- *e.g `remote:/` when viewing Network folder*
		- `ShowFullPath=true`
# View
## General
`[General]`
- Display style:
	- Use common display style for all folders
		- `GlobalViewProps=true`
		- *Default when blank*
	- Remember display style for each folder
		- `GlobalViewProps=false`
	- Use icons view mode for locations which mostly contain media files
		- `DynamicView=true`

- Browsing:
	- Browse compressed archives as folder
		- `BrowseThroughArchives=true`
	- Open folders during drag operations
		- `AutoExpandFolders=true`

- Miscellaneous:
	- Show item information on hover
		- `ShowToolTips=true`
	- Show selection marker
		- *+/- button on top-left of hovered items*
		- `ShowSelectionToggle=true`
		- *Blank defaults to `true`*
	- Rename single items inline
		- `RenameInline=true`
		- *Blank defaults to `true`*
	- Also hide backup files while hiding hidden files
		- `HideXTrashFile=true`

- Background:
	- Double-click triggers:
		- Nothing
			- `DoubleClickViewAction=none`
		- Custom Command
			- `DoubleClickViewAction=CUSTOM_COMMAND`
			- `DoubleClickViewCustomAction="<shell command>"`
			- "Use `{path}` to get the path of the current folder. Example: `dolphin {path}`"
		- New Tab: `DoubleClickViewAction=new_tab`
		- New Window: `=file_new`
		- Places panel `=show_places_panel`
		- Information panel `=show_information_panel`
		- Folders panel `=show_folders_panel`
		- Terminal panel `=show_terminal_panel`
		- Open Terminal `=open_terminal`
		- Up `=go_up`
		- Back `=go_back`
		- Home `=go_home`
		- Refresh `=view_redisplay`
		- Split `=split_view`
		- Select All `=edit_select_all`
			- *Default when blank*
		- Selection Mode `=toggle_selection_mode`
		- Create Folder `=create_dir`
		- Create File `=create_file`
		- Show Previews `=show_preview`
		- Show Hidden Files `=show_hidden_files`
		- Show in Groups `=show_in_groups`
		- Adjust View Display Style `=view_properties`
## Content Display
`[General]`
- Sorting mode:
	- Natural
		- `SortingChoice=NaturalSorting`
	- Alphabetical, case insensitive
		- `SortingChoice=CaseInsensitiveSorting`
	- Alphabetical, case sensitive
		- `SortingChoice=CaseSensitiveSorting`

`[ContentDisplay]`
- Folder size: 
	- Show number of items
	- Show size of contents up to N levels deep
		- `DirectorySizeMode=ContentSize`
		- `RecursiveDirectorySizeLimit=<depth>`
			- Must be between 1-20 inclusive
	- Show no size
		- `DirectorySizeMode=None`

- Date style:
	- Relative (e.g. `30 minutes ago`)
		- `UseShortRelativeDates=true`
		- *Default when blank*
	- Absolute (e.g `03/12/2025 16:40`)
		- `UseShortRelativeDates=false`

- Permissions style:
	- Symbolic (e.g. `drwxr-xr-x`)
		- `UsePermissionsFormat=SymbolicFormat`
		- *Default when blank*
	- Numeric (Octal) (e.g. `755`)
		- `UsePermissionsFormat=NumericFormat`
	- Combined (e.g. `drwxr-xr-x (755)`)
		- `UsePermissionsFormat=CombinedFormat`

- Long file names:
	- Elide in the middle (e.g. `Some very ... name.txt`)
		- `ElidingMode=Middle`
		- *Default when blank*
	- Elide at the end (e.g. `Some very long....txt`)
		- `ElidingMode=Right`
## Icons view mode
`[IconsMode]`
- Default icon size:
	- `IconSize=32`
	- *Blank defaults to 32*
	- *UI limits to 16-256 but will accept 0-unlimited. Beyond 800 it starts to break.*

- Preview icon size:
	- `PreviewSize=32`
	- *Blank defaults to 64*
	- *UI limits to 16-256 but will accept 0-unlimited. Beyond 800 it starts to break.*

- Label font:
	- System Font
		- `UseSystemFont=true`
		- *Default when blank*
	- Custom Font
		- `UseSystemFont=false`
		- `ViewFont=Hack,10,-1,0,400,0,0,0,0,0,0,0,0,0,0,1`
			- Value comes from [`QFont::toString()`](https://doc.qt.io/qt-6/qfont.html#toString). In order:
			- Font family: Name of font to use
			- Point size: Default is `10`
			- Pixel size: Always seems to be `-1`, but has an effect if Point Size is -1. May be needed for bitmap fonts?
			- Style hint: No effect
			- Font weight: Line thickness. Default is `400` for Regular and typically `700` or `800` for Bold. 
			- Font style: No effect
			- Underline: No effect
			- Strike out: No effect
			- Fixed pitch: No effect
			- Always `0`
			- Capitalisation: This works, but why would you ever do this in Dolphin??
			- Letter spacing: N/A
			- Word spacing: Measured in %, and `0` is disabled.
			- Stretch: Measured in %, and `0` is disabled.
			- Style strategy: Always `1`
			- Font style: Typically omitted. No effect. Use Font Weight instead.

- Label width:
	- `TextWidthIndex=1`
	- Small = 0
	- Medium  = 1
		- *Default when blank*
	- Large = 2
	- Huge = 3

- Maximum label lines:
	- `MaximumTextLines=1`
	- Range is 0-5
	- 0 for unlimited
	- *Blank defaults to 3*
## Compact view mode
`[CompactMode]`
- Default icon size:
	- `IconSize=32`
	- *Blank defaults to 16, configured default is 32*
	- *UI limits to 16-256 but will accept 0-unlimited. Beyond 800 it starts to break.*

- Preview icon size:
	- `PreviewSize=32`
	- *Blank defaults to 64*
	- *UI limits to 16-256 but will accept 0-unlimited. Beyond 800 it starts to break.*

- Label font:
	- System Font
		- `UseSystemFont=true`
		- *Default when blank*
	- Custom Font
		- `UseSystemFont=false`
		- `ViewFont=Hack,10,-1,0,400,0,0,0,0,0,0,0,0,0,0,1`
			- Value comes from [`QFont::toString()`](https://doc.qt.io/qt-6/qfont.html#toString)

- Maximum width:
	- `MaximumTextWidthIndex=1`
	- Unlimited = `0`
		- *Default when blank*
	- Small = `1`
	- Medium  = `2`
	- Large = `3`
## Details view mode
`[DetailsMode]`
- Default icon size:
	- `IconSize=32`
	- *Blank defaults to 16, configured default is 32*
	- *UI limits to 16-256 but will accept 0-unlimited. A bit after 800 it breaks.*

- Preview icon size:
	- `PreviewSize=32`
	- *Blank defaults to 64*
	- *UI limits to 16-256 but will accept 0-unlimited. A bit after 800 it breaks.*

- Label font:
	- System Font
		- `UseSystemFont=true`
		- *Default when blank*
	- Custom Font
		- `UseSystemFont=false`
		- `ViewFont=Hack,10,-1,0,400,0,0,0,0,0,0,0,0,0,0,1`
			- Value comes from [`QFont::toString()`](https://doc.qt.io/qt-6/qfont.html#toString)

- Folders: Expandable
	- `ExpandableFolders=false`
	- *Blank defaults to `true`*

- Open files and folders:
	- By clicking anywhere on the row
		- *Default when these are blank*
		- `HighlightEntireRow=true`
		- `LeftPadding=20`
		- `RightPadding=20`
	- By clicking on icon or name
		- `HighlightEntireRow=false`
		- `LeftPadding=0`
		- `RightPadding=0`
	- *Observation: We could allow user to override left/right padding!*
# Context Menu

## Options in `dolphinrc`
### `[ContextMenu]`

| Name                                                    | Config Key                 | Default |
| ------------------------------------------------------- | -------------------------- | ------- |
| 'Copy To' and 'Move To'                                 | `ShowCopyMoveMenu`         | `false` |
| Add to Places                                           | `ShowAddToPlaces`          | `true`  |
| Change View Mode                                        | `ShowViewMode`             | `true`  |
| Copy Location...                                        | `ShowCopyLocation`         | `true`  |
| Copy to Other View...                                   | `ShowCopyToOtherSplitView` | `true`  |
| Duplicate Here...                                       | `ShowDuplicateHere`        | `true`  |
| Move to Other View...                                   | `ShowMoveToOtherSplitView` | `true`  |
| Open in New Tab                                         | `ShowOpenInNewTab`         | `true`  |
| Open in New Window                                      | `ShowOpenInNewWindow`      | `true`  |
| Open in Split View                                      | `ShowOpenInSplitView`      | `true`  |
| Open Terminal Here                                      | `ShowOpenTerminal`         | `true`  |
| Sort By                                                 | `ShowSortBy`               | `true`  |

### `[VersionControl]`
Version control plugins have a separate section to enable them:
```
[VersionControl]
enabledPlugins=Git,Subversion,Dropbox
```
Available plugins are: `Bazaar`,`Dropbox`,`Git` , `Mercurial`, `Subversion`.
## `kservicemenurc`

| Name                                                    | Config Key                                  | Default |
| ------------------------------------------------------- | ------------------------------------------- | ------- |
| 'Compress' service menu                                 | `compressfileitemaction`                    | `true`  |
| 'Extract' service menu                                  | `extractfileitemaction`                     | `true`  |
| Administrative Actions                                  | `kio-admin`                                 | `true`  |
| Compare/Merge Files/Folders with KDiff3                 | `kdiff3fileitemaction`                      | `true`  |
| Delete                                                  | `kdeglobals: [KDE] ShowDeleteCommand`       | `false` |
| Forget items from Recent Documents and Recent Locations | `forgetfileitemaction`                      | `true`  |
| Install Font                                            | `installFont`                               | `true`  |
| Link Files to Activities                                | `kactivitymanagerd_fileitem_linking_plugin` | `true`  |
| Makefile Actions                                        | `makefileactions`                           | `true`  |
| Mount ISO and disk images                               | `mountisoaction`                            | `true`  |
| Move to New Folder                                      | `movetonewfolderitemaction`                 | `true`  |
| Run in Konsole                                          | `runInKonsole`                              | `true`  |
| Set as Wallpaper                                        | `wallpaperfileitemaction`                   | `true`  |
| Set Folder Icon                                         | `setfoldericonitemaction`                   | `true`  |
| Start a Slideshow                                       | `slideshowfileitemaction`                   | `true`  |
| Tags                                                    | `tagsfileitemaction`                        | `true`  |
| View Disk Usage Statistics                              | `filelight`                                 | `true`  |

# Wastebin
`[?]`
Probably a different file and therefore out of scope

Can select from multiple paths:
- Cleanup: 
	- (probably) Blank defaults to `false`
	- Older than N days:
		- (probably) Blank defaults to `7` days
- Size:
	- (probably) Blank defaults to `false`
	- Limit to:
		- (probably) *Blank defaults to `10`%*
- Full wastebin:
	- Show a warning
	- Delete oldest files from the wastebin
	- Delete biggest files from the wastebin
# User Feedback
2 sliders
*Stored in `~/.local/state/UserFeedback.org.kde.dolphin`; out of scope*
- Contribute Statistics
	- *Default is Nothing*
- Participate in Surveys
	- *Default is Nothing*
