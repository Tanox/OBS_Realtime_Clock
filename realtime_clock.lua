-- realtime_clock.lua v1.0.0

local obs = obslua

local script_settings = {
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

local timer_id = nil

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
    return "实时日期时间显示脚本\n\n丰富的设置选项，支持自定义格式、时区、字体样式等"
end

function script_properties()
    local props = obs.obs_properties_create()
    
    local p = obs.obs_properties_add_list(props, "text_source", "文本源", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
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
    
    local format_p = obs.obs_properties_add_list(props, "format_type", "格式类型", obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_STRING)
    obs.obs_property_list_add_string(format_p, "自定义格式", "custom")
    obs.obs_property_list_add_string(format_p, "默认 (YYYY-MM-DD HH:MM:SS)", "default")
    obs.obs_property_list_add_string(format_p, "短日期 (MM/DD/YYYY)", "short_date")
    obs.obs_property_list_add_string(format_p, "长日期", "long_date")
    obs.obs_property_list_add_string(format_p, "24小时制时间", "24h_time")
    obs.obs_property_list_add_string(format_p, "12小时制时间", "12h_time")
    obs.obs_property_list_add_string(format_p, "日期时间 (短)", "datetime_short")
    obs.obs_property_list_add_string(format_p, "日期时间 (长)", "datetime_long")
    
    obs.obs_properties_add_text(props, "custom_format", "自定义格式", obs.OBS_TEXT_DEFAULT)
    
    local tz_p = obs.obs_properties_add_list(props, "timezone", "时区", obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_STRING)
    obs.obs_property_list_add_string(tz_p, "本地时区", "local")
    obs.obs_property_list_add_string(tz_p, "UTC", "utc")
    
    obs.obs_properties_add_int(props, "update_interval", "更新间隔 (毫秒)", 50, 5000, 50)
    
    obs.obs_properties_add_int(props, "font_size", "字体大小", 8, 200, 1)
    obs.obs_properties_add_color(props, "font_color", "字体颜色")
    obs.obs_properties_add_text(props, "font_face", "字体名称", obs.OBS_TEXT_DEFAULT)
    
    obs.obs_properties_add_bool(props, "show_seconds", "显示秒数")
    obs.obs_properties_add_bool(props, "show_date", "显示日期")
    obs.obs_properties_add_bool(props, "show_time", "显示时间")
    
    obs.obs_properties_add_text(props, "date_separator", "日期分隔符", obs.OBS_TEXT_DEFAULT)
    obs.obs_properties_add_text(props, "time_separator", "时间分隔符", obs.OBS_TEXT_DEFAULT)
    
    obs.obs_properties_add_text(props, "prefix", "前缀文本", obs.OBS_TEXT_DEFAULT)
    obs.obs_properties_add_text(props, "suffix", "后缀文本", obs.OBS_TEXT_DEFAULT)
    
    obs.obs_properties_add_bool(props, "uppercase", "大写显示")
    
    local align_p = obs.obs_properties_add_list(props, "alignment", "对齐方式", obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_STRING)
    obs.obs_property_list_add_string(align_p, "左对齐", "left")
    obs.obs_property_list_add_string(align_p, "居中", "center")
    obs.obs_property_list_add_string(align_p, "右对齐", "right")
    
    return props
end

function script_update(settings)
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
    
    if timer_id ~= nil then
        obs.timer_remove(update_clock)
    end
    
    timer_id = obs.timer_add(update_clock, script_settings.update_interval)
end

function script_defaults(settings)
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
    if timer_id ~= nil then
        obs.timer_remove(update_clock)
    end
end

function get_current_time()
    local now
    if script_settings.timezone == "utc" then
        now = os.time(os.date("!*t"))
    else
        now = os.time()
    end
    return now
end

function format_time(timestamp)
    local format_str
    
    if script_settings.format_type == "custom" then
        format_str = script_settings.custom_format
    else
        format_str = format_presets[script_settings.format_type] or format_presets["default"]
    end
    
    if not script_settings.show_seconds then
        format_str = format_str:gsub("%%S", ""):gsub(":%s*$", ""):gsub("%s+$", "")
    end
    
    if not script_settings.show_date then
        format_str = format_str:gsub("%%[YyMmDd]", ""):gsub("%%[Aa]", ""):gsub("%%[Bb]", ""):gsub("[^%%]*%%[xX]", ""):gsub("^%s+", ""):gsub("%s+$", "")
    end
    
    if not script_settings.show_time then
        format_str = format_str:gsub("%%[HhIiMmSs]", ""):gsub("%%[pP]", ""):gsub("[^%%]*%%[xX]", ""):gsub("^%s+", ""):gsub("%s+$", "")
    end
    
    if script_settings.date_separator ~= "-" then
        format_str = format_str:gsub("%%Y-%%m-%%d", "%%Y" .. script_settings.date_separator .. "%%m" .. script_settings.date_separator .. "%%d")
        format_str = format_str:gsub("%%m/%%d/%%Y", "%%m" .. script_settings.date_separator .. "%%d" .. script_settings.date_separator .. "%%Y")
    end
    
    if script_settings.time_separator ~= ":" then
        format_str = format_str:gsub("%%H:%%M:%%S", "%%H" .. script_settings.time_separator .. "%%M" .. script_settings.time_separator .. "%%S")
        format_str = format_str:gsub("%%I:%%M:%%S", "%%I" .. script_settings.time_separator .. "%%M" .. script_settings.time_separator .. "%%S")
    end
    
    local result = os.date(format_str, timestamp)
    
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
        local timestamp = get_current_time()
        local text = format_time(timestamp)
        
        local settings = obs.obs_data_create()
        obs.obs_data_set_string(settings, "text", text)
        obs.obs_source_update(source, settings)
        obs.obs_data_release(settings)
        
        obs.obs_source_release(source)
    end
end
