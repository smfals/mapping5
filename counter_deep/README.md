# counter_deep

Flutter 课堂作业五·第 7 周实践项目。在 `flutter create` 默认计数器模板基础上完成三步改造。

## 运行

```bash
cd counter_deep
flutter pub get
flutter run -d windows    # 或 -d chrome / -d macos
```

## 三次提交（对应实践指南步骤）

| 提交 | 说明 |
|------|------|
| `75f725d` | **docs: widget tree diagram** — flutter create + 手写 Widget 树文档 |
| `50f7a28` | **feat: step control & teal theme** — 步长选择器 (1/2/5) + teal 种子色主题 |
| `03740ae` | **feat: lifecycle logs & asset image** — 6 个生命周期钩子 debugPrint + 资源图片 |

## 改造要点

1. **主题定制**：`ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal), useMaterial3: true)`
2. **步长控制**：`ChoiceChip × 3` 选择 +1/+2/+5，`_step` 状态驱动
3. **生命周期日志**：`initState → didChangeDependencies → build → didUpdateWidget → deactivate → dispose`
4. **资源管理**：`pubspec.yaml` 声明 `assets: [assets/images/]`，`Image.asset` 读取

## 目录

```
counter_deep/
├── lib/main.dart          # 全部改造后的单文件
├── assets/images/logo.png # 资源图片
├── docs/widget_tree.md    # Widget 树手绘文档
└── pubspec.yaml           # 依赖 + 资源声明
```
