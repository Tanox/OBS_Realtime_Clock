# 更新日志

## [v1.1.2] - 2026-08-13

### 文档更新
- 完善 README.md：新增配置项说明表、格式配置示例、常见问题与贡献指南
- 完善 README_EN.md：修正残留中文，补充配置项说明、示例、FAQ 与贡献指南
- 完善 openspec/project.md：新增架构说明、兼容性、测试验证与版本管理章节
- 同步所有文档版本号至 v1.1.2

## [v1.1.1] - 2026-05-24

### 改进
- 优化语言设置的初始化逻辑，将 UI_LANG 初始化从 script_properties 移至 script_load 函数
- 添加 .gitignore 中的 Lua 构建产物忽略规则
- 包含编译产物、库文件、可执行文件等多种文件类型的忽略规则

### 文档更新
- 同步更新所有文档的版本号至 v1.1.1

## [v1.1.0] - 2026-05-24

### 新功能
- 优化字体选择功能，添加常用字体下拉菜单
- 包含 14 种常用字体预设（Arial、Helvetica、Times New Roman、Georgia、Verdana、Courier New、Consolas、Impact、Comic Sans MS、Microsoft YaHei、SimHei、KaiTi、SimSun、FangSong）
- 支持自定义字体输入功能
- 添加动态界面：选择自定义字体时显示输入框，选择预设字体时隐藏输入框
- 完善多语言支持（中文/英文界面）

### 改进
- 优化用户体验，避免手动输入常用字体名称
- 版本号更新至 1.1.0

## [v1.0.1] - 2026-05-23

### 改进
- 重构项目文档结构，将默认文档从英文改为中文
- 新增独立的英文文档 [README_EN.md](file:///workspace/README_EN.md)
- 新增 [openspec/project.md](file:///workspace/openspec/project.md) 项目规范文档
- 更新 [README.md](file:///workspace/README.md) 为中文默认文档
- 完善文件结构说明和项目目录组织

## [v1.0.0] - 初始版本

### 新增
- 实现核心的 OBS 实时日期时间显示功能
- 支持关联 OBS 场景中的任意文本源
- 提供 7 种预定义的日期/时间格式预设
- 支持使用标准日期/时间格式符创建自定义格式
- 时区支持：本地时区或 UTC
- 灵活的更新间隔配置（50ms 到 5000ms）
- 视觉自定义：字体大小、颜色和字体
- 显示/隐藏元素：秒、日期、时间
- 自定义分隔符：日期和时间分隔符
- 前缀/后缀：在时钟前后添加自定义文本
- 大写选项：全大写显示
- 对齐方式：左对齐、居中、右对齐
- 中文界面配置选项
- [README.md](file:///workspace/README.md) 中文默认文档
- [README_EN.md](file:///workspace/README_EN.md) 英文文档
- LICENSE 许可证文件
- .gitignore 和 .gitattributes 配置文件
