# OBS Realtime Clock Script

A powerful Lua script for OBS Studio that displays real-time date and time with extensive customization options.

## Features

- **Text Source Association**: Link to any text source in your OBS scene
- **Multiple Format Presets**: Choose from 7 predefined date/time formats
- **Custom Format Support**: Create your own format using standard date/time specifiers
- **Timezone Support**: Local timezone or UTC
- **Flexible Update Interval**: 50ms to 5000ms
- **Visual Customization**: Font size, color, and face
- **Show/Hide Elements**: Toggle seconds, date, and time
- **Custom Separators**: Modify date and time separators
- **Prefix/Suffix**: Add custom text before and after the clock
- **Uppercase Option**: Display text in all caps
- **Alignment**: Left, center, or right alignment

## Installation

1. Download `realtime_clock.lua`
2. Open OBS Studio
3. Go to Tools → Scripts
4. Click the "+" button
5. Select `realtime_clock.lua`
6. Configure the script settings

## Usage

### Basic Setup

1. Create a Text source in your OBS scene (GDI+ Text or FreeType 2 Text)
2. Open the Scripts window (Tools → Scripts)
3. Select the "Realtime Clock" script
4. Choose your text source from the "文本源" dropdown
5. Customize settings as desired

### Format Specifiers

Use these in custom formats:

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

## File Structure

```
obs_realtime_clock/
├── realtime_clock.lua    # Main script file
├── README.md             # English documentation
└── README_CN.md          # Chinese documentation
```

## Version

v1.0.0

## License

MIT License
