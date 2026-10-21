# 进度报告5（第7周·Flutter工程结构与Widget体系）

> 仓库地址：https://github.com/smfals/mapping5　|　项目：`counter_deep`　|　日期：2026-10-21

## 一、任务理解

> 用自己的话说明本次作业要完成什么、验收标准是什么。

本次课堂作业（第5课，第7周实践）要求完成 Flutter 框架入门案例 counter_deep，核心目标是：在 flutter create 生成的默认计数器模板基础上，完成三步改造——① 增加步长选择器（每点 +1/+2/+5 可选）并把主题色从默认紫色改为 teal 种子色；② 为 State 的每个生命周期钩子加 debugPrint 日志；③ 在 assets 放入一张自定义图片并在界面中显示。

验收标准：计数器改造功能正确；生命周期日志齐全并能口头解释 setState 链路；资源图片正常显示；Git 提交规范；附 Widget 树手绘图、运行截图、AI 使用记录。

## 二、环境与工具

> 本次使用的开发环境、运行目标（Web/模拟器/真机）与AI工具版本。

- **操作系统**：Windows 11 25H2 (Build 26200.9168)

- **Flutter SDK**：Channel stable 3.47.5 (Dart 3.13.4)

- **运行目标**：Chrome debug / Windows debug / Web release

- **IDE**：Trae CN (基于 VS Code)

- **AI 工具**：TraeCode / Trae AI Agent

- **Git**：mapping5 独立仓库，4 次提交（含 README 更新）

## 三、过程记录

> 按时间线记录主要操作步骤（安装、创建、修改、运行）。

flutter create counter_deep —org com.mapp 在 d:\mapping5 下生成项目骨架，通读默认 main.dart，手绘完整 Widget 树（存 docs/widget_tree.md + 桌面独立文件夹 widget_sketches/）→ git commit "docs: widget tree diagram" (75f725d)

步骤二改造：修改 main.dart，添加 _step 状态变量 + ChoiceChip 选择器（+1/+2/+5），theme 改为 ColorScheme.fromSeed(seedColor: Colors.teal, useMaterial3: true)，build 中用 Theme.of(context).colorScheme.primary 驱动文字颜色→ git commit "feat: step control & teal theme" (50f7a28)

步骤三改造：添加 initState / didChangeDependencies / didUpdateWidget / deactivate / dispose 五个生命周期钩子的 debugPrint；生成 512×512 的 logo.png 放入 assets/images/；pubspec.yaml 声明 assets 段；body 中加 Image.asset 展示→ git commit "feat: lifecycle logs & asset image" (03740ae)

flutter pub get → flutter analyze (仅 2 条 info 级别提示) → flutter run -d windows 验证运行 + 查看控制台生命周期日志 → flutter build web --release → Chrome headless 截图

## 四、关键代码

> 粘贴1至3段关键代码并逐行解释（注明是否AI生成、如何验证）。

### 4.1 setState 链路（_CounterPageState.build 片段）

```dart
void _incrementCounter() {
  setState(() {
    _counter += _step;       // ① setState 回调里改数据
    debugPrint('$_tag setState → _counter=$_counter');
  });
}
// → Flutter 框架标记 State 为 dirty
// → 调度下一帧调用 build()
// → Widget 树重建，Text('$_counter') 显示新值
```

### 4.2 主题定制（MyApp.build）

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.teal,     // ② teal 种子色
    brightness: Brightness.light,
  ),
  useMaterial3: true,           // Material 3 设计规范
),
// 页面内通过 Theme.of(context).colorScheme.primary 取主题色
```

### 4.3 生命周期日志（initState + build）

```dart
@override
void initState() {
  super.initState();
  debugPrint('$_tag initState — 一次性初始化');  // ③ 首次挂载
}
```

```dart
@override
Widget build(BuildContext context) {
  debugPrint('$_tag build — 重建界面');           // 每次 setState 都触发
  // ...
}
```

验证方式：flutter run -d windows → 观察控制台输出

## 五、检查点结果

> 计数器改造功能正确；能口头解释setState链路。附证据说明。

```text
[CounterPage] initState — 一次性初始化, _counter=0, _step=1
[CounterPage] didChangeDependencies — 依赖变化（主题继承等）
[CounterPage] build — 重建界面, _counter=0, _step=1
```

热重载（r）只重新跑 build；热重启（R）则从 initState 重新开始。

teal 种子色 → 全应用 AppBar 背景、主题色文字、ChoiceChip/FAB 同步变 teal；useMaterial3: true 启用圆角 Material You 风格。

assets/images/logo.png 已放入（16KB，512×512），pubspec.yaml 声明 flutter: assets: [assets/images/]，界面中 Image.asset 正常加载。

点 FAB → onPressed 触发 → setState(callback) 标记 State 为 dirty → Flutter 在下一帧调用 build() → 新的 _counter 值被 Text 渲染出来。setState 必须在 State 内部调用，回调里只放"改数据"逻辑。

## 六、问题与调试

> 遇到的问题、定位过程、解决方案（至少1条真实记录）。

1. 问题一：assets 声明后热重载不生效

现象：第一次运行时 Image.asset 报 "Unable to load asset"。
定位：检查 pubspec.yaml → assets 段缩进正确；检查文件路径大小写。
解决：资源修改必须完整重启（热重启 R 或重新 flutter run），热重载只走 build 不会重新加载资源索引。重启后 logo.png 正常显示。

2. 问题二：flutter analyze 报 unnecessary_underscores

现象：errorBuilder: (_, __, ___) → info 级别提示。
定位：多下划线占位符在 Dart 3 中合并为单个 _。
解决：改为 errorBuilder: (_, _, _) → analyze 通过，仅剩 0 条问题

## 七、AI使用记录

> TraeCode使用清单（用途、指令摘要、输出、本人验证方式）。

| 用途 | 指令摘要 | AI 输出 | 本人验证方式 |
| --- | --- | --- | --- |
| 步骤一：生成项目骨架 | flutter create counter_deep | 生成 131 个文件的标准 Flutter 模板 | 手动通读 lib/main.dart，对比 docs.wiki 确认结构正确 |
| 步骤二：步长选择 + 主题 | 修改 main.dart：增加 _step + ChoiceChip + teal seedColor | 完整的 StatefulWidget 改造方案 | git diff 查看差异 → 手动 flutter run 验证颜色和步长切换 |
| 步骤三：生命周期日志 | 添加 6 个生命周期钩子 debugPrint | initState/didChangeDependencies/didUpdateWidget/deactivate/dispose/build 全链路日志 | flutter run 后对照控制台输出，按 r 和 R 各一次观察钩子行为差异 |

## 八、证据截图

> 运行截图、flutter doctor 或控制台输出、Git 提交记录（每图配一句话说明）。截图文件保存在桌面、未随仓库提交：`01_counter_deep_initial.png`、`02_counter_deep_desktop.png`、`03_counter_deep_run_window.png`、`04_console_lifecycle_log.png`、`05_flutter_doctor.png`、`06_git_log.png`。

图1：Web 窄屏（400×800）运行效果——AppBar 为 teal 主题色，logo 资源图片正常显示，计数器 0，步长选择器 +1/+2/+5 与 FAB 均可见。

图2：Web 桌面尺寸（1200×700）运行效果——布局居中不变形，Material 3 圆角风格与 teal 配色全应用统一。

图3：Windows 桌面端实际运行——连续点击 FAB 两次后计数为 2，步长已切换为 +2，FAB 文案同步变为「＋ 2」，证明步长状态驱动界面重建。

图4：flutter run -d windows 控制台输出——initState → didChangeDependencies → build 的启动顺序，以及每次点击后「setState → build」的成对日志，step changed 印证步长切换同样触发重建。

图5：flutter doctor 结果——Flutter 3.47.5、Windows 11 25H2、Android SDK、Chrome、Visual Studio 均已就绪，输出「No issues found!」。

图6：git log --oneline --decorate 与 git remote -v——四次提交对应「文档→步长与主题→生命周期与资源→README」，且分支已与 origin/main 同步至 https://github.com/smfals/mapping5.git。

## 九、自评

> 对照本次作业要求逐项自查完成情况。

| 任务 | 完成情况 | 备注 |
| --- | --- | --- |
| 案例复现 counter_deep | 完整 | 三步骤改造全部完成 |
| Widget 树手绘图 | 完成 | docs/widget_tree.md + 桌面独立文件夹 HTML 草图 |
| 生命周期日志 | 完成 | 6 个钩子全部加 debugPrint，r/R 行为已对照 |
| 主题定制 | 完成 | teal 种子色 + useMaterial3 + Theme.of(context) 取用 |
| 资源替换 | 完成 | assets/images/logo.png + pubspec 声明 + 界面显示 |

## 十、一句话收获与下一步计划

> 本课一句话收获；遗留问题与下次课的预习要点。

收获：Flutter 的"声明式 UI = f(state)"模型——你不操作界面，你改状态，界面跟着变——一切皆 Widget 的思想让嵌套结构变得清晰可控。

遗留问题：const 构造对 rebuild 次数的影响还没做量化实验（独立研究任务 1）；InheritedWidget 只知其然不知其所以然。

下次预习：第 7 课导航与路由，提前看 Navigator.of(context) 用法。
