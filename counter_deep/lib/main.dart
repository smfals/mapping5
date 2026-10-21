import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter Deep',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;
  int _step = 1;

  static const String _tag = '[CounterPage]';

  // ===== 步骤三：生命周期钩子日志 =====
  @override
  void initState() {
    super.initState();
    debugPrint('$_tag initState — 一次性初始化, _counter=$_counter, _step=$_step');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('$_tag didChangeDependencies — 依赖变化（主题继承等）');
  }

  @override
  void didUpdateWidget(covariant CounterPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint('$_tag didUpdateWidget — 父组件重建传入新配置');
  }

  @override
  void deactivate() {
    super.deactivate();
    debugPrint('$_tag deactivate — State 从树中暂时移除');
  }

  @override
  void dispose() {
    debugPrint('$_tag dispose — 销毁清理');
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter += _step;
      debugPrint('$_tag setState → _counter=$_counter');
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter -= _step;
      debugPrint('$_tag setState → _counter=$_counter');
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('$_tag build — 重建界面, _counter=$_counter, _step=$_step');
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Counter Deep — counter_deep'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ===== 步骤三：资源图片 =====
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 120,
                    height: 120,
                    color: primary.withValues(alpha: 0.2),
                    child: Icon(Icons.image, size: 48, color: primary),
                  ),
                ),
              ),
            ),
            const Text('You have pushed the button this many times:'),
            const SizedBox(height: 8),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('步长：', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                for (final s in [1, 2, 5]) ...[
                  ChoiceChip(
                    label: Text('+$s'),
                    selected: _step == s,
                    onSelected: (_) {
                      setState(() {
                        _step = s;
                        debugPrint('$_tag step changed → $_step');
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _decrementCounter,
              icon: const Icon(Icons.remove),
              label: Text('－ $_step'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _incrementCounter,
        icon: const Icon(Icons.add),
        label: Text('＋ $_step'),
      ),
    );
  }
}
