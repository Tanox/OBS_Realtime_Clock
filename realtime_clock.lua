-- realtime_clock.lua v1.0.1

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
        local_tz = "本地时区",
        utc = "UTC",
        update_interval = "更新间隔 (毫秒)",
        font_size = "字体大小",
        font_color = "字体颜色",
        font_face = "字体名称",
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
        custom = "自定义格式"
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
        local_tz = "Local Timezone",
        utc = "UTC",
        update_interval = "Update Interval (ms)",
        font_size = "Font Size",
        font_color = "Font Color",
        font_face = "Font Face",
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
        custom = "Custom Format"
    }
}

local function get_ui_string(key)
    local lang = UI_LANG
    if lang == "auto" then
        lang = "zh"
    end
    return UI_STRINGS[lang][key] or UI_STRINGS["zh"][key] or key
end

local script_settings = {
    ui_language = "zh",
    text_source = "",
    format_type = "custom",
    custom_format = "%Y-%m-%d %H:%M:%S",
    timezone = "local",
    update_interval = 100,
    font_size = 48,
    font_color = 0xFFFFFFFF,
    font_face = "Arial",
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
    return "实时日期时间显示脚本 / Realtime Clock Script\n\n丰富的设置选项，支持自定义格式、时区、字体样式等\nRich settings, custom format, timezone, font styles and more"
end

function script_properties()
    local props = obs.obs_properties_create()
    
    local lang_p = obs.obs_properties_add_list(props, "ui_language", "语言 / Language", obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_STRING)
    obs.obs_property_list_add_string(lang_p, "中文", "zh")
    obs.obs_property_list_add_string(lang_p, "English", "en")
    
    UI_LANG = obs.obs_data_get_string(obs.obs_properties_get_settings(props), "ui_language") or "zh"
    
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
    obs.obs_property_list_add_string(tz_p, get_ui_string("local_tz"), "local")
    obs.obs_property_list_add_string(tz_p, get_ui_string("utc"), "utc")
    
    obs.obs_properties_add_int(props, "update_interval", get_ui_string("update_interval"), 50, 5000, 50)
    
    obs.obs_properties_add_int(props, "font_size", get_ui_string("font_size"), 8, 200, 1)
    obs.obs_properties_add_color(props, "font_color", get_ui_string("font_color"))
    obs.obs_properties_add_text(props, "font_face", get_ui_string("font_face"), obs.OBS_TEXT_DEFAULT)
    
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
    script_settings.update_interval = obs.obs_data_get_int(settings, "update_interval")
    script_settings.font_size = obs.obs_data_get_int(settings, "font_size")
    script_settings.font_color = obs.obs_data_get_int(settings, "font_color")
    script_settings.font_face = obs.obs_data_get_string(settings, "font_face")
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
    obs.obs_data_set_default_int(settings, "update_interval", 100)
    obs.obs_data_set_default_int(settings, "font_size", 48)
    obs.obs_data_set_default_int(settings, "font_color", 0xFFFFFFFF)
    obs.obs_data_set_default_string(settings, "font_face", "Arial")
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
    if script_settings.timezone == "utc" then
        result = os.date("!" .. format_str, os.time())
    else
        result = os.date(format_str, os.time())
    end
    
    result = script_settings.prefix .. result .. script_settings.suffix
    
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
