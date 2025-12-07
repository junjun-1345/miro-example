import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/model/shape.dart';
import '../view_model/board_view_model.dart';
import '../widget/shape_widget.dart';
import '../widget/toolbar.dart';

/// キャンバスページ
/// 図形の描画と操作を行うメインビュー
class CanvasPage extends HookConsumerWidget {
  const CanvasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 現在選択中のツール
    final selectedTool = useState<ShapeType?>(null);

    // CRDT状態を監視
    final boardState = ref.watch(boardNotifierProvider);
    final boardNotifier = ref.read(boardNotifierProvider.notifier);

    // 接続状態を監視
    final connectionAsync = ref.watch(connectionStateProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Miro Clone'),
        actions: [
          // 接続状態インジケーター
          connectionAsync.when(
            data: (connected) => Icon(
              connected ? Icons.cloud_done : Icons.cloud_off,
              color: connected ? Colors.green : Colors.red,
            ),
            loading: () => const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (_, __) => const Icon(Icons.cloud_off, color: Colors.red),
          ),
          const SizedBox(width: 8),
          // クライアント数表示
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Text('${boardState.clientCount} users'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ツールバー
          Toolbar(
            selectedTool: selectedTool.value,
            onToolSelected: (tool) {
              selectedTool.value = tool;
            },
          ),
          // キャンバス
          Expanded(
            child: GestureDetector(
              onTapUp: (details) {
                // ツールが選択されている場合、図形を追加
                if (selectedTool.value != null) {
                  boardNotifier.addShape(
                    selectedTool.value!,
                    details.localPosition.dx,
                    details.localPosition.dy,
                  );
                }
              },
              child: Container(
                color: Colors.grey[200],
                child: Stack(
                  children: [
                    // グリッド背景
                    CustomPaint(
                      painter: GridPainter(),
                      size: Size.infinite,
                    ),
                    // 図形を描画
                    ...boardState.activeShapes.map(
                      (shape) => ShapeWidget(
                        shape: shape,
                        onMove: (dx, dy) {
                          boardNotifier.moveShape(shape.id, dx, dy);
                        },
                        onDelete: () {
                          boardNotifier.deleteShape(shape.id);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// グリッド背景を描画するPainter
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1;

    const gridSize = 20.0;

    // 縦線
    for (var x = 0.0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // 横線
    for (var y = 0.0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
