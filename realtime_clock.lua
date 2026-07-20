-- realtime_clock.lua v1.2.0
-- OBS Realtime Clock Script
-- Tags: clock, time, date, timezone, world clock, countdown, overlay, stream
-- Features: multi-timezone, custom format, font customization, i18n support

local obs = obslua

local UI_LANG = "auto"

local UI_STRINGS = {
    ["zh"] = {
        text_source = "文本源",
        format_type = "格式类型",
        custom_format = "自定义格式",
        default = "默认 (YYYY-MM-DD HH:MM:SS)",
        short_date = "短日期 (MM/DD/YYYY)",
        long_date = "长日期",
        ["24h_time"] = "24小时制时间",
        ["12h_time"] = "12小时制时间",
        datetime_short = "日期时间 (短)",
        datetime_long = "日期时间 (长)",
        timezone = "时区",
        timezone_mode = "时区模式",
        timezone_offset = "时区偏移 (小时)",
        local_tz = "本地时区",
        utc = "UTC",
        custom_tz = "自定义偏移",
        city_beijing = "北京 (UTC+8)",
        city_tokyo = "东京 (UTC+9)",
        city_seoul = "首尔 (UTC+9)",
        city_singapore = "新加坡 (UTC+8)",
        city_hongkong = "香港 (UTC+8)",
        city_taipei = "台北 (UTC+8)",
        city_bangkok = "曼谷 (UTC+7)",
        city_dubai = "迪拜 (UTC+4)",
        city_moscow = "莫斯科 (UTC+3)",
        city_london = "伦敦 (UTC+0)",
        city_paris = "巴黎 (UTC+1)",
        city_berlin = "柏林 (UTC+1)",
        city_rome = "罗马 (UTC+1)",
        city_madrid = "马德里 (UTC+1)",
        city_newyork = "纽约 (UTC-5)",
        city_losangeles = "洛杉矶 (UTC-8)",
        city_chicago = "芝加哥 (UTC-6)",
        city_toronto = "多伦多 (UTC-5)",
        city_vancouver = "温哥华 (UTC-8)",
        city_sydney = "悉尼 (UTC+10)",
        city_auckland = "奥克兰 (UTC+12)",
        city_saopaulo = "圣保罗 (UTC-3)",
        city_cairo = "开罗 (UTC+2)",
        city_johannesburg = "约翰内斯堡 (UTC+2)",
        city_mumbai = "孟买 (UTC+5:30)",
        city_karachi = "卡拉奇 (UTC+5)",
        city_bangalore = "班加罗尔 (UTC+5:30)",
        city_ho_chi_minh = "胡志明市 (UTC+7)",
        city_jakarta = "雅加达 (UTC+7)",
        city_manila = "马尼拉 (UTC+8)",
        city_kuala_lumpur = "吉隆坡 (UTC+8)",
        update_interval = "更新间隔 (毫秒)",
        font_size = "字体大小",
        font_color = "字体颜色",
        font_face = "字体样式",
        custom_font = "自定义字体",
        show_seconds = "显示秒数",
        show_date = "显示日期",
        show_time = "显示时间",
        date_separator = "日期分隔符",
        time_separator = "时间分隔符",
        prefix = "前缀文本",
        suffix = "后缀文本",
        uppercase = "大写显示",
        alignment = "对齐方式",
        left = "左对齐",
        center = "居中",
        right = "右对齐",
        custom = "自定义格式",
        show_timezone_label = "显示时区标签",
        timezone_label_position = "时区标签位置",
        label_before = "前面",
        label_after = "后面",
        label_newline = "新行"
    },
    ["en"] = {
        text_source = "Text Source",
        format_type = "Format Type",
        custom_format = "Custom Format",
        default = "Default (YYYY-MM-DD HH:MM:SS)",
        short_date = "Short Date (MM/DD/YYYY)",
        long_date = "Long Date",
        ["24h_time"] = "24H Time",
        ["12h_time"] = "12H Time",
        datetime_short = "DateTime (Short)",
        datetime_long = "DateTime (Long)",
        timezone = "Timezone",
        timezone_mode = "Timezone Mode",
        timezone_offset = "Timezone Offset (hours)",
        local_tz = "Local Timezone",
        utc = "UTC",
        custom_tz = "Custom Offset",
        city_beijing = "Beijing (UTC+8)",
        city_tokyo = "Tokyo (UTC+9)",
        city_seoul = "Seoul (UTC+9)",
        city_singapore = "Singapore (UTC+8)",
        city_hongkong = "Hong Kong (UTC+8)",
        city_taipei = "Taipei (UTC+8)",
        city_bangkok = "Bangkok (UTC+7)",
        city_dubai = "Dubai (UTC+4)",
        city_moscow = "Moscow (UTC+3)",
        city_london = "London (UTC+0)",
        city_paris = "Paris (UTC+1)",
        city_berlin = "Berlin (UTC+1)",
        city_rome = "Rome (UTC+1)",
        city_madrid = "Madrid (UTC+1)",
        city_newyork = "New York (UTC-5)",
        city_losangeles = "Los Angeles (UTC-8)",
        city_chicago = "Chicago (UTC-6)",
        city_toronto = "Toronto (UTC-5)",
        city_vancouver = "Vancouver (UTC-8)",
        city_sydney = "Sydney (UTC+10)",
        city_auckland = "Auckland (UTC+12)",
        city_saopaulo = "Sao Paulo (UTC-3)",
        city_cairo = "Cairo (UTC+2)",
        city_johannesburg = "Johannesburg (UTC+2)",
        city_mumbai = "Mumbai (UTC+5:30)",
        city_karachi = "Karachi (UTC+5)",
        city_bangalore = "Bangalore (UTC+5:30)",
        city_ho_chi_minh = "Ho Chi Minh (UTC+7)",
        city_jakarta = "Jakarta (UTC+7)",
        city_manila = "Manila (UTC+8)",
        city_kuala_lumpur = "Kuala Lumpur (UTC+8)",
        update_interval = "Update Interval (ms)",
        font_size = "Font Size",
        font_color = "Font Color",
        font_face = "Font Style",
        custom_font = "Custom Font",
        show_seconds = "Show Seconds",
        show_date = "Show Date",
        show_time = "Show Time",
        date_separator = "Date Separator",
        time_separator = "Time Separator",
        prefix = "Prefix Text",
        suffix = "Suffix Text",
        uppercase = "Uppercase",
        alignment = "Alignment",
        left = "Left",
        center = "Center",
        right = "Right",
        custom = "Custom Format",
        show_timezone_label = "Show Timezone Label",
        timezone_label_position = "Label Position",
        label_before = "Before",
        label_after = "After",
        label_newline = "New Line"
    }
}

local function get_ui_string(key)
    local lang = UI_LANG
    if lang == "auto" then
        lang = "zh"
    end
    return UI_STRINGS[lang][key] or UI_STRINGS["zh"][key] or key
end

local font_presets = {
    ["Arial"] = "Arial",
    ["Helvetica"] = "Helvetica",
    ["Times New Roman"] = "Times New Roman",
    ["Georgia"] = "Georgia",
    ["Verdana"] = "Verdana",
    ["Courier New"] = "Courier New",
    ["Consolas"] = "Consolas",
    ["Impact"] = "Impact",
    ["Comic Sans MS"] = "Comic Sans MS",
    ["Microsoft YaHei"] = "Microsoft YaHei",
    ["SimHei"] = "SimHei",
    ["KaiTi"] = "KaiTi",
    ["SimSun"] = "SimSun",
    ["FangSong"] = "FangSong",
    ["custom"] = "custom"
}

local timezone_presets = {
    { key = "local", label_key = "local_tz", offset = nil, label_short = "" },
    { key = "utc", label_key = "utc", offset = 0, label_short = "UTC" },
    { key = "custom", label_key = "custom_tz", offset = nil, label_short = "" },
    { key = "city_beijing", label_key = "city_beijing", offset = 8, label_short = "CST" },
    { key = "city_tokyo", label_key = "city_tokyo", offset = 9, label_short = "JST" },
    { key = "city_seoul", label_key = "city_seoul", offset = 9, label_short = "KST" },
    { key = "city_singapore", label_key = "city_singapore", offset = 8, label_short = "SGT" },
    { key = "city_hongkong", label_key = "city_hongkong", offset = 8, label_short = "HKT" },
    { key = "city_taipei", label_key = "city_taipei", offset = 8, label_short = "CST" },
    { key = "city_bangkok", label_key = "city_bangkok", offset = 7, label_short = "ICT" },
    { key = "city_ho_chi_minh", label_key = "city_ho_chi_minh", offset = 7, label_short = "ICT" },
    { key = "city_jakarta", label_key = "city_jakarta", offset = 7, label_short = "WIB" },
    { key = "city_manila", label_key = "city_manila", offset = 8, label_short = "PHT" },
    { key = "city_kuala_lumpur", label_key = "city_kuala_lumpur", offset = 8, label_short = "MYT" },
    { key = "city_dubai", label_key = "city_dubai", offset = 4, label_short = "GST" },
    { key = "city_moscow", label_key = "city_moscow", offset = 3, label_short = "MSK" },
    { key = "city_london", label_key = "city_london", offset = 0, label_short = "GMT" },
    { key = "city_paris", label_key = "city_paris", offset = 1, label_short = "CET" },
    { key = "city_berlin", label_key = "city_berlin", offset = 1, label_short = "CET" },
    { key = "city_rome", label_key = "city_rome", offset = 1, label_short = "CET" },
    { key = "city_madrid", label_key = "city_madrid", offset = 1, label_short = "CET" },
    { key = "city_cairo", label_key = "city_cairo", offset = 2, label_short = "EET" },
    { key = "city_johannesburg", label_key = "city_johannesburg", offset = 2, label_short = "SAST" },
    { key = "city_mumbai", label_key = "city_mumbai", offset = 5.5, label_short = "IST" },
    { key = "city_bangalore", label_key = "city_bangalore", offset = 5.5, label_short = "IST" },
    { key = "city_karachi", label_key = "city_karachi", offset = 5, label_short = "PKT" },
    { key = "city_newyork", label_key = "city_newyork", offset = -5, label_short = "EST" },
    { key = "city_chicago", label_key = "city_chicago", offset = -6, label_short = "CST" },
    { key = "city_losangeles", label_key = "city_losangeles", offset = -8, label_short = "PST" },
    { key = "city_toronto", label_key = "city_toronto", offset = -5, label_short = "EST" },
    { key = "city_vancouver", label_key = "city_vancouver", offset = -8, label_short = "PST" },
    { key = "city_sydney", label_key = "city_sydney", offset = 10, label_short = "AEST" },
    { key = "city_auckland", label_key = "city_auckland", offset = 12, label_short = "NZST" },
    { key = "city_saopaulo", label_key = "city_saopaulo", offset = -3, label_short = "BRT" }
}

local function get_timezone_offset_hours()
    if script_settings.timezone == "local" then
        local now = os.time()
        local utcdate = os.date("!*t", now)
        local localdate = os.date("*t", now)
        local diff = os.difftime(os.time(localdate), os.time(utcdate))
        return diff / 3600
    elseif script_settings.timezone == "custom" then
        return script_settings.timezone_offset
    else
        for _, tz in ipairs(timezone_presets) do
            if tz.key == script_settings.timezone then
                return tz.offset
            end
        end
    end
    return 0
end

local function get_timezone_label()
    if script_settings.timezone == "local" then
        return ""
    elseif script_settings.timezone == "custom" then
        local offset = script_settings.timezone_offset
        local sign = offset >= 0 and "+" or "-"
        local abs_offset = math.abs(offset)
        local hours = math.floor(abs_offset)
        local minutes = math.floor((abs_offset - hours) * 60)
        if minutes == 0 then
            return string.format("UTC%s%d", sign, hours)
        else
            return string.format("UTC%s%d:%02d", sign, hours, minutes)
        end
    else
        for _, tz in ipairs(timezone_presets) do
            if tz.key == script_settings.timezone then
                return tz.label_short
            end
        end
    end
    return ""
end

local script_settings = {
    ui_language = "zh",
    text_source = "",
    format_type = "custom",
    custom_format = "%Y-%m-%d %H:%M:%S",
    timezone = "local",
    timezone_offset = 8,
    show_timezone_label = false,
    timezone_label_position = "after",
    update_interval = 100,
    font_size = 48,
    font_color = 0xFFFFFFFF,
    font_face = "Arial",
    custom_font_face = "",
    show_seconds = true,
    show_date = true,
    show_time = true,
    date_separator = "-",
    time_separator = ":",
    prefix = "",
    suffix = "",
    uppercase = false,
    alignment = "center"
}

local format_presets = {
    ["default"] = "%Y-%m-%d %H:%M:%S",
    ["short_date"] = "%m/%d/%Y",
    ["long_date"] = "%A, %B %d, %Y",
    ["24h_time"] = "%H:%M:%S",
    ["12h_time"] = "%I:%M:%S %p",
    ["datetime_short"] = "%m/%d/%Y %H:%M",
    ["datetime_long"] = "%A, %B %d, %Y %I:%M:%S %p"
}

function script_description()
    return "OBS 实时时钟 / OBS Realtime Clock v1.2.0\n\n" ..
           "功能强大的实时日期时间显示脚本，支持多时区、世界时钟、自定义格式等\n" ..
           "Powerful realtime date & time display with multi-timezone, world clock, custom formats\n\n" ..
           "功能特性 | Features:\n" ..
           "• 30+ 全球城市时区预设 | 30+ global city timezone presets\n" ..
           "• 自定义时区偏移 | Custom timezone offset\n" ..
           "• 多种日期/时间格式 | Multiple date/time format presets\n" ..
           "• 自定义格式支持 | Custom format with strftime specifiers\n" ..
           "• 15+ 字体预设 + 自定义字体 | 15+ font presets + custom font\n" ..
           "• 字体颜色和大小可调 | Adjustable font color and size\n" ..
           "• 前缀/后缀文本 | Prefix/suffix text support\n" ..
           "• 中英文双语界面 | Bilingual UI (Chinese/English)\n" ..
           "• 时区标签显示 | Timezone label display\n" ..
           "• 对齐方式选择 | Text alignment options"
end

-- 时区选择回调函数，动态显示/隐藏自定义时区偏移输入框
local function timezone_callback(props, property, settings)
    local tz = obs.obs_data_get_string(settings, "timezone")
    local custom_offset_prop = obs.obs_properties_get(props, "timezone_offset")
    if custom_offset_prop then
        obs.obs_property_set_visible(custom_offset_prop, tz == "custom")
    end
    local label_pos_prop = obs.obs_properties_get(props, "timezone_label_position")
    local show_label = obs.obs_properties_get(props, "show_timezone_label")
    if label_pos_prop and show_label then
        local show_tz_label = obs.obs_data_get_bool(settings, "show_timezone_label")
        obs.obs_property_set_visible(label_pos_prop, show_tz_label and tz ~= "local")
    end
    return true
end

-- 显示时区标签回调
local function show_tz_label_callback(props, property, settings)
    local label_pos_prop = obs.obs_properties_get(props, "timezone_label_position")
    local tz = obs.obs_data_get_string(settings, "timezone")
    if label_pos_prop then
        local show_label = obs.obs_data_get_bool(settings, "show_timezone_label")
        obs.obs_property_set_visible(label_pos_prop, show_label and tz ~= "local")
    end
    return true
end

-- 字体选择回调函数，用于动态显示/隐藏自定义字体输入框
local function font_face_callback(props, property, settings)
    local font_face = obs.obs_data_get_string(settings, "font_face")
    local custom_font_prop = obs.obs_properties_get(props, "custom_font_face")
    if custom_font_prop then
        obs.obs_property_set_visible(custom_font_prop, font_face == "custom")
    end
    return true
end

function script_properties()
    local props = obs.obs_properties_create()
    
    local lang_p = obs.obs_properties_add_list(props, "ui_language", "语言 / Language", obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_STRING)
    obs.obs_property_list_add_string(lang_p, "中文", "zh")
    obs.obs_property_list_add_string(lang_p, "English", "en")
    
    local p = obs.obs_properties_add_list(props, "text_source", get_ui_string("text_source"), obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
    local sources = obs.obs_enum_sources()
    if sources ~= nil then
        for _, source in ipairs(sources) do
            local source_id = obs.obs_source_get_unversioned_id(source)
            if source_id == "text_gdiplus" or source_id == "text_ft2_source" then
                local name = obs.obs_source_get_name(source)
                obs.obs_property_list_add_string(p, name, name)
            end
        end
    end
    obs.source_list_release(sources)
    
    local format_p = obs.obs_properties_add_list(props, "format_type", get_ui_string("format_type"), obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_STRING)
    obs.obs_property_list_add_string(format_p, get_ui_string("custom"), "custom")
    obs.obs_property_list_add_string(format_p, get_ui_string("default"), "default")
    obs.obs_property_list_add_string(format_p, get_ui_string("short_date"), "short_date")
    obs.obs_property_list_add_string(format_p, get_ui_string("long_date"), "long_date")
    obs.obs_property_list_add_string(format_p, get_ui_string("24h_time"), "24h_time")
    obs.obs_property_list_add_string(format_p, get_ui_string("12h_time"), "12h_time")
    obs.obs_property_list_add_string(format_p, get_ui_string("datetime_short"), "datetime_short")
    obs.obs_property_list_add_string(format_p, get_ui_string("datetime_long"), "datetime_long")
    
    obs.obs_properties_add_text(props, "custom_format", get_ui_string("custom_format"), obs.OBS_TEXT_DEFAULT)
    
    local tz_p = obs.obs_properties_add_list(props, "timezone", get_ui_string("timezone"), obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_STRING)
    for _, tz in ipairs(timezone_presets) do
        obs.obs_property_list_add_string(tz_p, get_ui_string(tz.label_key), tz.key)
    end
    obs.obs_property_set_modified_callback(tz_p, timezone_callback)
    
    local tz_offset_prop = obs.obs_properties_add_float(props, "timezone_offset", get_ui_string("timezone_offset"), -12, 14, 0.5)
    obs.obs_property_set_visible(tz_offset_prop, script_settings.timezone == "custom")
    
    obs.obs_properties_add_bool(props, "show_timezone_label", get_ui_string("show_timezone_label"))
    
    local label_pos_prop = obs.obs_properties_add_list(props, "timezone_label_position", get_ui_string("timezone_label_position"), obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_STRING)
    obs.obs_property_list_add_string(label_pos_prop, get_ui_string("label_before"), "before")
    obs.obs_property_list_add_string(label_pos_prop, get_ui_string("label_after"), "after")
    obs.obs_property_list_add_string(label_pos_prop, get_ui_string("label_newline"), "newline")
    obs.obs_property_set_modified_callback(obs.obs_properties_get(props, "show_timezone_label"), show_tz_label_callback)
    obs.obs_property_set_visible(label_pos_prop, script_settings.show_timezone_label and script_settings.timezone ~= "local")
    
    obs.obs_properties_add_int(props, "update_interval", get_ui_string("update_interval"), 50, 5000, 50)
    
    obs.obs_properties_add_int(props, "font_size", get_ui_string("font_size"), 8, 200, 1)
    obs.obs_properties_add_color(props, "font_color", get_ui_string("font_color"))
    
    -- 添加字体下拉选择框
    local font_p = obs.obs_properties_add_list(props, "font_face", get_ui_string("font_face"), obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_STRING)
    obs.obs_property_list_add_string(font_p, "Arial", "Arial")
    obs.obs_property_list_add_string(font_p, "Helvetica", "Helvetica")
    obs.obs_property_list_add_string(font_p, "Times New Roman", "Times New Roman")
    obs.obs_property_list_add_string(font_p, "Georgia", "Georgia")
    obs.obs_property_list_add_string(font_p, "Verdana", "Verdana")
    obs.obs_property_list_add_string(font_p, "Courier New", "Courier New")
    obs.obs_property_list_add_string(font_p, "Consolas", "Consolas")
    obs.obs_property_list_add_string(font_p, "Impact", "Impact")
    obs.obs_property_list_add_string(font_p, "Comic Sans MS", "Comic Sans MS")
    obs.obs_property_list_add_string(font_p, "Microsoft YaHei", "Microsoft YaHei")
    obs.obs_property_list_add_string(font_p, "SimHei", "SimHei")
    obs.obs_property_list_add_string(font_p, "KaiTi", "KaiTi")
    obs.obs_property_list_add_string(font_p, "SimSun", "SimSun")
    obs.obs_property_list_add_string(font_p, "FangSong", "FangSong")
    obs.obs_property_list_add_string(font_p, get_ui_string("custom_font"), "custom")
    
    -- 设置字体选择回调
    obs.obs_property_set_modified_callback(font_p, font_face_callback)
    
    -- 添加自定义字体输入框
    local custom_font_prop = obs.obs_properties_add_text(props, "custom_font_face", get_ui_string("custom_font"), obs.OBS_TEXT_DEFAULT)
    -- 默认隐藏自定义字体输入框
    obs.obs_property_set_visible(custom_font_prop, script_settings.font_face == "custom")
    
    obs.obs_properties_add_bool(props, "show_seconds", get_ui_string("show_seconds"))
    obs.obs_properties_add_bool(props, "show_date", get_ui_string("show_date"))
    obs.obs_properties_add_bool(props, "show_time", get_ui_string("show_time"))
    
    obs.obs_properties_add_text(props, "date_separator", get_ui_string("date_separator"), obs.OBS_TEXT_DEFAULT)
    obs.obs_properties_add_text(props, "time_separator", get_ui_string("time_separator"), obs.OBS_TEXT_DEFAULT)
    
    obs.obs_properties_add_text(props, "prefix", get_ui_string("prefix"), obs.OBS_TEXT_DEFAULT)
    obs.obs_properties_add_text(props, "suffix", get_ui_string("suffix"), obs.OBS_TEXT_DEFAULT)
    
    obs.obs_properties_add_bool(props, "uppercase", get_ui_string("uppercase"))
    
    local align_p = obs.obs_properties_add_list(props, "alignment", get_ui_string("alignment"), obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_STRING)
    obs.obs_property_list_add_string(align_p, get_ui_string("left"), "left")
    obs.obs_property_list_add_string(align_p, get_ui_string("center"), "center")
    obs.obs_property_list_add_string(align_p, get_ui_string("right"), "right")
    
    return props
end

function script_update(settings)
    script_settings.ui_language = obs.obs_data_get_string(settings, "ui_language") or "zh"
    UI_LANG = script_settings.ui_language
    script_settings.text_source = obs.obs_data_get_string(settings, "text_source")
    script_settings.format_type = obs.obs_data_get_string(settings, "format_type")
    script_settings.custom_format = obs.obs_data_get_string(settings, "custom_format")
    script_settings.timezone = obs.obs_data_get_string(settings, "timezone")
    script_settings.timezone_offset = obs.obs_data_get_double(settings, "timezone_offset")
    script_settings.show_timezone_label = obs.obs_data_get_bool(settings, "show_timezone_label")
    script_settings.timezone_label_position = obs.obs_data_get_string(settings, "timezone_label_position")
    script_settings.update_interval = obs.obs_data_get_int(settings, "update_interval")
    script_settings.font_size = obs.obs_data_get_int(settings, "font_size")
    script_settings.font_color = obs.obs_data_get_int(settings, "font_color")
    
    -- 更新字体设置
    local selected_font = obs.obs_data_get_string(settings, "font_face")
    if selected_font == "custom" then
        script_settings.font_face = obs.obs_data_get_string(settings, "custom_font_face") or "Arial"
    else
        script_settings.font_face = selected_font
    end
    script_settings.custom_font_face = obs.obs_data_get_string(settings, "custom_font_face")
    
    script_settings.show_seconds = obs.obs_data_get_bool(settings, "show_seconds")
    script_settings.show_date = obs.obs_data_get_bool(settings, "show_date")
    script_settings.show_time = obs.obs_data_get_bool(settings, "show_time")
    script_settings.date_separator = obs.obs_data_get_string(settings, "date_separator")
    script_settings.time_separator = obs.obs_data_get_string(settings, "time_separator")
    script_settings.prefix = obs.obs_data_get_string(settings, "prefix")
    script_settings.suffix = obs.obs_data_get_string(settings, "suffix")
    script_settings.uppercase = obs.obs_data_get_bool(settings, "uppercase")
    script_settings.alignment = obs.obs_data_get_string(settings, "alignment")
    
    obs.timer_remove(update_clock)
    obs.timer_add(update_clock, script_settings.update_interval)
end

function script_defaults(settings)
    obs.obs_data_set_default_string(settings, "ui_language", "zh")
    obs.obs_data_set_default_string(settings, "text_source", "")
    obs.obs_data_set_default_string(settings, "format_type", "default")
    obs.obs_data_set_default_string(settings, "custom_format", "%Y-%m-%d %H:%M:%S")
    obs.obs_data_set_default_string(settings, "timezone", "local")
    obs.obs_data_set_default_double(settings, "timezone_offset", 8)
    obs.obs_data_set_default_bool(settings, "show_timezone_label", false)
    obs.obs_data_set_default_string(settings, "timezone_label_position", "after")
    obs.obs_data_set_default_int(settings, "update_interval", 100)
    obs.obs_data_set_default_int(settings, "font_size", 48)
    obs.obs_data_set_default_int(settings, "font_color", 0xFFFFFFFF)
    obs.obs_data_set_default_string(settings, "font_face", "Arial")
    obs.obs_data_set_default_string(settings, "custom_font_face", "")
    obs.obs_data_set_default_bool(settings, "show_seconds", true)
    obs.obs_data_set_default_bool(settings, "show_date", true)
    obs.obs_data_set_default_bool(settings, "show_time", true)
    obs.obs_data_set_default_string(settings, "date_separator", "-")
    obs.obs_data_set_default_string(settings, "time_separator", ":")
    obs.obs_data_set_default_string(settings, "prefix", "")
    obs.obs_data_set_default_string(settings, "suffix", "")
    obs.obs_data_set_default_bool(settings, "uppercase", false)
    obs.obs_data_set_default_string(settings, "alignment", "center")
end

function script_save(settings)
end

function script_load(settings)
    script_settings.ui_language = obs.obs_data_get_string(settings, "ui_language") or "zh"
    UI_LANG = script_settings.ui_language
end

function script_unload()
    obs.timer_remove(update_clock)
end

function format_time()
    local format_str
    
    if script_settings.format_type == "custom" then
        format_str = script_settings.custom_format
    else
        format_str = format_presets[script_settings.format_type] or format_presets["default"]
    end
    
    format_str = format_str:gsub("%%Y%-%%m%-%%d", "%%Y" .. script_settings.date_separator .. "%%m" .. script_settings.date_separator .. "%%d")
    format_str = format_str:gsub("%%m/%%d/%%Y", "%%m" .. script_settings.date_separator .. "%%d" .. script_settings.date_separator .. "%%Y")
    format_str = format_str:gsub("%%H:%%M:%%S", "%%H" .. script_settings.time_separator .. "%%M" .. script_settings.time_separator .. "%%S")
    format_str = format_str:gsub("%%I:%%M:%%S", "%%I" .. script_settings.time_separator .. "%%M" .. script_settings.time_separator .. "%%S")
    format_str = format_str:gsub("%%H:%%M", "%%H" .. script_settings.time_separator .. "%%M")
    format_str = format_str:gsub("%%I:%%M", "%%I" .. script_settings.time_separator .. "%%M")
    
    if not script_settings.show_seconds then
        format_str = format_str:gsub("%%S", ""):gsub(script_settings.time_separator .. "%s*$", ""):gsub("%s+$", "")
    end
    
    if not script_settings.show_date then
        format_str = format_str:gsub("%%[Yy]", ""):gsub("%%m", ""):gsub("%%d", ""):gsub("%%[Aa]", ""):gsub("%%[Bb]", ""):gsub("%%[xX]", ""):gsub("^%s+", ""):gsub("%s+$", "")
    end
    
    if not script_settings.show_time then
        format_str = format_str:gsub("%%[Hh]", ""):gsub("%%[Ii]", ""):gsub("%%M", ""):gsub("%%S", ""):gsub("%%[pP]", ""):gsub("%%[xX]", ""):gsub("^%s+", ""):gsub("%s+$", "")
    end
    
    local result
    local tz_offset = get_timezone_offset_hours()
    local utc_time = os.time(os.date("!*t", os.time()))
    local target_time = utc_time + math.floor(tz_offset * 3600)
    
    result = os.date(format_str, target_time)
    
    result = script_settings.prefix .. result .. script_settings.suffix
    
    if script_settings.show_timezone_label and script_settings.timezone ~= "local" then
        local tz_label = get_timezone_label()
        if tz_label ~= "" then
            if script_settings.timezone_label_position == "before" then
                result = tz_label .. " " .. result
            elseif script_settings.timezone_label_position == "newline" then
                result = result .. "\n" .. tz_label
            else
                result = result .. " " .. tz_label
            end
        end
    end
    
    if script_settings.uppercase then
        result = result:upper()
    end
    
    return result
end

function update_clock()
    if script_settings.text_source == "" then
        return
    end
    
    local source = obs.obs_get_source_by_name(script_settings.text_source)
    if source ~= nil then
        local text = format_time()
        
        local settings = obs.obs_data_create()
        obs.obs_data_set_string(settings, "text", text)
        
        local align_value
        if script_settings.alignment == "left" then
            align_value = 0
        elseif script_settings.alignment == "right" then
            align_value = 2
        else
            align_value = 1
        end
        obs.obs_data_set_int(settings, "align", align_value)
        
        obs.obs_source_update(source, settings)
        obs.obs_data_release(settings)
        
        obs.obs_source_release(source)
    end
end
