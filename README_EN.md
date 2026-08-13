# OBS Realtime Clock Script

A powerful Lua script for OBS Studio that displays real-time date and time in your live stream, with extensive customization options.

## Features

- **Multi-language UI**: Switch between Chinese and English interface at any time
- **Text Source Association**: Link to any text source in your OBS scene (GDI+ Text / FreeType 2 Text)
- **Multiple Format Presets**: Choose from 7 predefined date/time formats
- **Custom Format Support**: Create your own format using standard date/time specifiers
- **Timezone Support**: Local timezone or UTC
- **Flexible Update Interval**: 50ms to 5000ms for fine-grained refresh control
- **Visual Customization**: Font size, color, and typeface (14 popular presets + custom font)
- **Show/Hide Elements**: Toggle seconds, date, and time
- **Custom Separators**: Modify date and time separators
- **Prefix/Suffix**: Add custom text before and after the clock
- **Uppercase Option**: Display text in all caps
- **Alignment**: Left, center, or right alignment

## Installation

1. Download `realtime_clock.lua`
2. Open OBS Studio
3. Go to **Tools → Scripts**
4. Click the "+" button
5. Select `realtime_clock.lua`
6. Configure the script settings

> Requires OBS Studio 28 or newer (supports the `obslua` Lua scripting API).

## Usage

### Basic Setup

1. Create a Text source in your OBS scene (**GDI+ Text** or **FreeType 2 Text**)
2. Open the Scripts window (**Tools → Scripts**)
3. Select the "Realtime Clock" script
4. Choose your text source from the "Text Source" dropdown
5. Customize the remaining settings as desired

### Configuration Reference

| Setting | Description | Values / Options |
|---------|-------------|------------------|
| Language | UI display language | Chinese / English |
| Text Source | Target text source name | Text source in scene |
| Format Type | Date/time format scheme | Custom, Default, Short Date, Long Date, 24H Time, 12H Time, DateTime (Short), DateTime (Long) |
| Custom Format | Custom format string (used when format type is "Custom") | Lua `os.date` specifiers |
| Timezone | Time calculation basis | Local / UTC |
| Update Interval | Refresh frequency | 50 – 5000 ms |
| Font Size | Text size | 8 – 200 |
| Font Color | Text color | Color picker |
| Font Style | Font name | 14 presets / Custom |
| Custom Font | Font name entered when "Custom" is selected | Any system font name |
| Show Seconds | Whether to show seconds | On / Off |
| Show Date | Whether to show the date portion | On / Off |
| Show Time | Whether to show the time portion | On / Off |
| Date Separator | Separator between date fields | Any char (default `-`) |
| Time Separator | Separator between time fields | Any char (default `:`) |
| Prefix Text | Constant text prepended to the clock | Any text |
| Suffix Text | Constant text appended to the clock | Any text |
| Uppercase | Force result to all caps | On / Off |
| Alignment | Alignment within the text source | Left / Center / Right |

### Format Specifiers

Use these in custom formats (based on Lua `os.date`):

| Specifier | Description | Example |
|-----------|-------------|---------|
| %Y | 4-digit year | 2024 |
| %y | 2-digit year | 24 |
| %m | Month (01-12) | 05 |
| %B | Full month name | May |
| %b | Abbreviated month name | May |
| %d | Day (01-31) | 23 |
| %A | Full weekday name | Thursday |
| %a | Abbreviated weekday name | Thu |
| %H | Hour (00-23) | 14 |
| %I | Hour (01-12) | 02 |
| %M | Minute (00-59) | 30 |
| %S | Second (00-59) | 45 |
| %p | AM/PM indicator | PM |

> Tip: Enabling "Uppercase" mainly affects alphabetic output (e.g. the AM/PM of `%p`); Chinese weekday/month names are unaffected.

### Configuration Examples

- **Default**: `%Y-%m-%d %H:%M:%S` → `2026-08-13 14:30:45`
- **Time only (no seconds)**: Format Type "24H Time", turn off "Show Seconds" → `14:30`
- **With prefix**: Prefix `Beijing: `, Format Type "Custom", format `%H:%M:%S` → `Beijing: 14:30:45`

## File Structure

```
obs_realtime_clock/
├── realtime_clock.lua    # Main script file
├── README.md             # Chinese documentation (default)
├── README_EN.md          # English documentation
├── CHANGELOG.md          # Changelog (Chinese)
├── CHANGELOG_EN.md       # Changelog (English)
├── LICENSE               # MIT License
└── openspec/
    └── project.md        # Project specification
```

## FAQ

**Q: The clock does not update?**
A: Make sure you selected the correct "Text Source" and that it is a GDI+ Text or FreeType 2 Text source; also ensure the update interval is not 0.

**Q: My format change did not take effect?**
A: The script re-registers its timer on setting changes. If it still fails, uncheck and re-check the script in the Scripts window to reload it.

**Q: My custom font is not showing?**
A: Verify the font is installed on your system and that the font name is spelled exactly (case-sensitive).

## Contributing

Issues and Pull Requests are welcome to improve this script. Before submitting, please ensure:

- The Lua script passes basic syntax checks
- Documentation stays in sync with code changes
- Commit messages follow the Conventional Commits specification

## Version

v1.1.2

## License

MIT License, see [LICENSE](LICENSE).
