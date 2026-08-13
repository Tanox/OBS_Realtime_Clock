# 项目规范

## 项目概述
OBS 实时日期时间脚本 - 一个功能强大的 OBS Studio Lua 脚本，用于在直播场景中显示实时日期和时间，提供丰富的自定义选项。脚本通过定时器周期性地更新指定文本源的内容，实现无需外部依赖的纯本地时钟显示。

## 项目类型
- 脚本类项目（OBS Lua 脚本）

## 技术栈
- Lua 5.x
- OBS Studio `obslua` API
- 目标运行环境：OBS Studio 28 及以上（Windows / macOS / Linux）

## 目录结构
```
obs_realtime_clock/
├── realtime_clock.lua    # 主脚本文件
├── README.md             # 中文文档（默认）
├── README_EN.md          # 英文文档
├── CHANGELOG.md          # 更新日志（中文）
├── CHANGELOG_EN.md       # 更新日志（英文）
├── LICENSE               # MIT 许可证
└── openspec/
    └── project.md        # 项目规范文档
```

## 核心功能
1. 多语言界面：中文 / 英文界面可切换
2. 文本源关联：与 OBS 场景中的 GDI+ 文本 / FreeType 2 文本源绑定
3. 多种格式预设：提供 7 种预定义的日期 / 时间格式
4. 自定义格式支持：使用标准日期 / 时间格式符（`os.date`）
5. 时区支持：本地时区或 UTC
6. 灵活的更新间隔：50ms 到 5000ms
7. 视觉自定义：字体大小、颜色和字体（14 种预设 + 自定义字体）
8. 显示 / 隐藏元素：秒、日期、时间
9. 自定义分隔符：日期和时间分隔符
10. 前缀 / 后缀：在时钟前后添加自定义文本
11. 大写选项：全大写显示
12. 对齐方式：左对齐、居中、右对齐

## 架构说明
- `script_load`：脚本加载时初始化界面语言，读取持久化设置。
- `script_update`：设置变更时同步到内部 `script_settings` 表，并重建刷新定时器。
- `script_properties`：声明脚本属性面板，含字体动态显隐回调。
- `format_time`：根据格式类型、分隔符、显隐开关拼装最终显示字符串。
- `update_clock`：定时器回调，写入目标文本源并应用对齐方式。
- `script_unload`：卸载时移除定时器，释放资源。

## 开发规范
### 代码风格
- 脚本使用 Lua 语言，遵循 OBS Lua API 约定
- 变量与函数命名清晰，关键逻辑带中文注释
- 文件头部标注路径与版本号（`-- path vX.Y.Z`）
- 对外导出函数遵循 OBS 脚本生命周期约定（`script_load` / `script_update` / `script_properties` / `script_description` / `script_unload` 等）

### 版本管理
- 版本号格式：`vMAJOR.MINOR.PATCH`（遵循 SemVer）
- 每次变更至少 bump 一次 patch 版本
- 文件头注释版本号仅更新被改动的文件
- 全局版本单一来源：`realtime_clock.lua` 头注释、`README.md` / `README_EN.md` 版本节、各 `CHANGELOG`

### 提交规范
- 遵循 Conventional Commits：`type: description`
- 类型：`feat` / `fix` / `docs` / `refactor` / `style` / `test` / `chore` / `perf`

## 兼容性
- OBS Studio 28+（提供稳定的 `obslua` API）
- 文本源依赖 `text_gdiplus`（Windows）或 `text_ft2_source`（跨平台）
- 字体渲染依赖宿主机已安装字体，未安装时回退到系统默认

## 测试验证
- 在 OBS 中加载脚本，确认属性面板正常渲染
- 切换文本源，确认时钟实时更新
- 切换语言，确认界面文案切换
- 修改格式 / 时区 / 字体 / 分隔符，确认输出符合预期
- 卸载脚本，确认无定时器残留（观察日志无持续写入）

## 文档
- `README.md` 为中文默认文档
- `README_EN.md` 为英文文档
- `CHANGELOG.md` / `CHANGELOG_EN.md` 记录版本变更

## 许可证
MIT License
