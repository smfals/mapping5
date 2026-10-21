# Counter Deep — Widget 树（手绘版）

> 对应 `flutter create` 生成模板 + counter_deep 三步改造后的完整层级。
> ✅ = StatelessWidget  ⚙️ = StatefulWidget

```
runApp(
 └── MaterialApp [✅ StatelessWidget]        ← 应用根节点
      ├── theme: ThemeData (seedColor: teal, useMaterial3: true)
      └── home: CounterPage [⚙️ StatefulWidget]   ← 首页
           └── _CounterPageState
                └── Scaffold [✅ StatelessWidget]
                     ├── appBar: AppBar [✅ StatelessWidget]
                     │    ├── backgroundColor: Theme.of(context).colorScheme.inversePrimary
                     │    └── title: Text('Counter Deep — counter_deep')
                     ├── body: Center [✅ StatelessWidget]
                     │    └── Column [✅ StatelessWidget]
                     │         ├── ClipRRect > Image.asset('assets/images/logo.png')  ← 资源图片
                     │         ├── Text('You have pushed the button...')
                     │         ├── Text('$_counter', headineMedium, teal primary)
                     │         ├── Row
                     │         │    └── ChoiceChip × 3  (+1 / +2 / +5)
                     │         └── ElevatedButton.icon('－ $_step')
                     └── floatingActionButton: FloatingActionButton.extended('＋ $_step')
```

## setState 链路说明

```
用户点 FAB / 减按钮
  → _incrementCounter / _decrementCounter
    → setState(() { _counter += _step; })   // 标记 State 为 dirty
      → Flutter 调度下一帧
        → 调用 _CounterPageState.build()     // 重建界面
          → Scaffold → Center → Column → Text('$_counter') 显示新值
```

## 生命周期钩子顺序

| 钩子 | 触发时机 | 备注 |
|------|---------|------|
| `initState` | State 首次创建挂载后 | 一次性，适合订阅 |
| `didChangeDependencies` | 依赖（如 InheritedWidget）变化 | 主题继承改变时触发 |
| `build` | 每次重建 | setState、父重建、依赖变化 |
| `didUpdateWidget` | 父组件重建传入新配置 | widget 引用变了 |
| `deactivate` | State 从树中暂时移除 | 可能之后又 insert |
| `dispose` | State 永久销毁 | 释放控制器/订阅 |

## 热重载 (r) vs 热重启 (R) 行为

- 按 **r**（hot reload）：保持 State → 只重新跑 `build()`
- 按 **R**（hot restart）：销毁旧 State → 从 `initState` 重新开始
