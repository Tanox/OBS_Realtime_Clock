# Changelog

## [v1.1.1] - 2026-05-24

### Improvements
- Optimized language setting initialization logic, moved UI_LANG initialization from script_properties to script_load function
- Added Lua build artifacts ignore rules to .gitignore
- Includes ignore rules for compiled artifacts, library files, executable files and more

### Documentation Updates
- Synchronized version numbers across all documentation to v1.1.1

## [v1.1.0] - 2026-05-24

### New Features
- Optimized font selection functionality with dropdown menu of popular fonts
- Includes 14 popular font presets (Arial, Helvetica, Times New Roman, Georgia, Verdana, Courier New, Consolas, Impact, Comic Sans MS, Microsoft YaHei, SimHei, KaiTi, SimSun, FangSong)
- Support for custom font input
- Added dynamic UI: display input field when selecting custom font, hide when selecting preset font
- Complete multi-language support (Chinese/English interface)

### Improvements
- Enhanced user experience, avoiding manual entry of common font names
- Version updated to 1.1.0

## [v1.0.1] - 2026-05-23

### Improvements
- Restructured project documentation, changed default language from English to Chinese
- Added separate English documentation [README_EN.md](file:///workspace/README_EN.md)
- Added [openspec/project.md](file:///workspace/openspec/project.md) project specification document
- Updated [README.md](file:///workspace/README.md) to be the default Chinese documentation
- Improved file structure description and project directory organization

## [v1.0.0] - Initial Release

### New Features
- Implemented core OBS real-time date and time display functionality
- Support for linking to any text source in OBS scenes
- Provided 7 predefined date/time format presets
- Support for creating custom formats using standard date/time format specifiers
- Timezone support: Local timezone or UTC
- Flexible update interval configuration (50ms to 5000ms)
- Visual customization: Font size, color, and typeface
- Show/hide elements: Seconds, date, time
- Custom separators: Date and time separators
- Prefix/suffix: Add custom text before and after the clock
- Uppercase option: Display in all caps
- Alignment options: Left, center, right
- Chinese interface configuration options
- [README.md](file:///workspace/README.md) Default Chinese documentation
- [README_EN.md](file:///workspace/README_EN.md) English documentation
- LICENSE file
- .gitignore and .gitattributes configuration files
