# **喵点 (Meow Dot)**

**项目目标：** 开发一款名为“喵点”的 macOS 平台集成工具集，提供截图、置顶、计时器、桌面时钟等常用功能，旨在提升用户日常工作和学习效率，并具备良好的可扩展性。

## **✨ 主要功能 (Features)**

* **截图与标注 (Screenshot & Annotation)**  
  * 区域截图、窗口截图、全屏截图  
  * 截图后编辑：绘制矩形框、箭头  
  * 文字识别 (OCR)：提取截图文字并复制  
  * 截图翻译：识别并翻译截图内文字  
  * 输出：复制、保存、置顶  
* **置顶显示 (Pin to Top)**  
  * 图片置顶：支持截图、剪贴板、本地文件，可调大小/透明度  
  * 文字置顶：支持普通文本和 Markdown，可编辑、渲染切换、调整大小/透明度  
* **计时与时钟 (Timer & Clock)**  
  * 倒计时器：按分钟/小时快速设置、自定义时间、标签、系统通知提醒  
  * 桌面时钟：可置顶、可调整大小  
* **系统级功能**  
  * 全局快捷键自定义  
  * 应用内更新检查  
  * 菜单栏图标快速访问  
  * 偏好设置（快捷键、功能配置、开机启动等）

## **🛠️ 技术栈 (Tech Stack)**

* **框架 (Framework):** Flutter (for macOS Desktop)  
* **架构 (Architecture):** 领域驱动设计 (DDD)  
* **状态管理 (State Management):** Bloc / Cubit  
* **依赖注入 (Dependency Injection):** GetIt \+ Injectable  
* **核心插件 (Key Plugins):**  
  * window\_manager: 窗口管理  
  * system\_tray: 系统托盘菜单  
  * hotkey\_manager: 全局快捷键  
  * desktop\_screenshot / screen\_capturer: 截图  
  * google\_mlkit\_text\_recognition / Platform Channels: OCR  
  * http / dio: 网络请求 (翻译, 更新)  
  * flutter\_markdown: Markdown 渲染  
  * shared\_preferences: 本地配置存储  
  * flutter\_local\_notifications: 本地通知  
  * package\_info\_plus: 应用信息  
  * url\_launcher: 打开链接  
  * (可能需要 Platform Channels 进行原生交互)

## **📂 项目结构 (Folder Structure)**

喵点/  
├── lib/  
│   ├── main.dart                 \# 应用入口与 DI 初始化  
│   ├── app/                      \# 应用层 (Application Layer) \- Use Cases/Blocs  
│   ├── domain/                   \# 领域层 (Domain Layer) \- 核心业务逻辑与模型  
│   ├── infrastructure/           \# 基础设施层 (Infrastructure Layer) \- 数据、平台交互实现  
│   ├── presentation/             \# 表示层 (Presentation Layer) \- UI  
│   │   ├── pages/                \# 主要页面/屏幕 (设置页, 关于页)  
│   │   ├── windows/              \# 独立窗口/悬浮窗 (截图编辑, 置顶, 时钟, 计时器列表)  
│   │   ├── widgets/              \# 可复用的小部件  
│   │   ├── themes/               \# 应用主题 (AppTheme.dart)  
│   │   └── utils/                \# UI 相关工具类  
│   └── core/                     \# 核心工具/通用代码  
├── macos/                      \# macOS 平台特定代码 (原生插件或配置, Info.plist 权限)  
├── assets/                     \# 静态资源 (图片, 字体, Logo)  
├── test/                       \# 各层单元测试、集成测试、Widget 测试  
├── pubspec.yaml                \# 项目配置文件  
└── README.md                   \# 项目说明

## **🚀 开始使用 (Getting Started)**

*(此处可添加构建和运行项目的具体步骤)*

1. **克隆仓库:**  
   git clone \[your-repository-url\]  
   cd meow\_point

2. **获取依赖:**  
   flutter pub get

3. **运行代码生成 (如果使用 injectable):**  
   flutter pub run build\_runner build \--delete-conflicting-outputs

4. **运行应用:**  
   flutter run \-d macos

5. **构建应用:**  
   flutter build macos

macOS 权限:  
首次运行时，macOS 可能会提示需要屏幕录制权限（用于截图）。请在“系统偏好设置” \-\> “安全性与隐私” \-\> “隐私” \-\> “屏幕录制”中允许本应用。如果使用了网络功能（翻译、更新），可能还需要网络访问权限。

## **🤝 贡献指南 (Contributing)**

*(此处可添加贡献流程、代码规范等说明，例如：)*

欢迎参与贡献！请遵循以下步骤：

1. Fork 本仓库  
2. 创建您的 Feature 分支 (git checkout \-b feature/AmazingFeature)  
3. 提交您的更改 (git commit \-m 'Add some AmazingFeature')  
4. 将更改推送到分支 (git push origin feature/AmazingFeature)  
5. 发起 Pull Request

请确保您的代码符合项目代码风格，并通过所有测试。

## **📄 开源许可 (License)**

*(此处添加您的项目所使用的开源许可证信息，例如 MIT, Apache 2.0 等)*

本项目采用 [MIT](https://choosealicense.com/licenses/mit/) 许可证。

*这个 README.md 提供了项目概览、功能介绍、技术选型、项目结构和基本的使用/贡献说明。您可以根据实际情况进行修改和补充。*