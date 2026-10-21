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
      // ===== 步骤二：teal 种子色主题 =====
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
  // ===== 步骤二：步长变量 =====
  int _step = 1;

  void _incrementCounter() {
    setState(() {
      _counter += _step; // 每次加 _step
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter -= _step;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 使用 Theme.of(context) 取主题色（主题定制验证点）
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
            const Text('You have pushed the button this many times:'),
            const SizedBox(height: 8),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: primary, // 主题色驱动
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            // ===== 步骤二：步长选择 =====
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('步长：', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                for (final s in [1, 2, 5]) ...[
                  ChoiceChip(
                    label: Text('+$s'),
                    selected: _step == s,
                    onSelected: (_) => setState(() => _step = s),
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
