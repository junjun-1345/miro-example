import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/model/shape.dart';
import '../view_model/board_view_model.dart';

/// 図形を描画するウィジェット
/// ドラッグによる移動と削除をサポート
class ShapeWidget extends HookConsumerWidget {
  const ShapeWidget({
    super.key,
    required this.shapeId,
    this.isSelected = false,
    this.onSelect,
    this.onDeleted,
  });

  /// 図形のID
  final String shapeId;

  /// 選択されているかどうか
  final bool isSelected;

  /// 選択時のコールバック
  final VoidCallback? onSelect;

  /// 削除完了時のコールバック
  final VoidCallback? onDeleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = useFocusNode();

    // Riverpodの状態から図形を取得
    final boardState = ref.watch(boardNotifierProvider);
    final entry = boardState.entries[shapeId];

    // 図形が存在しないか削除済みの場合は何も表示しない
    if (entry == null || entry.deleted) {
      return const SizedBox.shrink();
    }

    final shape = entry.shape;
    final notifier = ref.read(boardNotifierProvider.notifier);

    void handleKeyEvent(KeyEvent event) {
      if (event is KeyDownEvent) {
        // Delete または Backspace キーで削除
        if (event.logicalKey == LogicalKeyboardKey.delete ||
            event.logicalKey == LogicalKeyboardKey.backspace) {
          notifier.deleteShape(shapeId);
          onDeleted?.call();
        }
      }
    }

    void handleDelete() {
      notifier.deleteShape(shapeId);
      onDeleted?.call();
    }

    return Positioned(
      left: shape.x,
      top: shape.y,
      child: KeyboardListener(
        focusNode: focusNode,
        onKeyEvent: handleKeyEvent,
        child: GestureDetector(
          onTap: () {
            // タップで選択してフォーカス
            onSelect?.call();
            focusNode.requestFocus();
          },
          onPanUpdate: (details) {
            // Notifier経由で移動（状態更新 → UI再描画）
            notifier.moveShape(shapeId, details.delta.dx, details.delta.dy);
          },
          onLongPress: () {
            // 長押しで削除確認ダイアログ
            _showDeleteDialog(context, handleDelete);
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 図形本体
              _buildShape(shape, isSelected),
              // 選択時に削除ボタンを表示
              if (isSelected)
                Positioned(
                  right: -20,
                  top: -20,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        // 親のGestureDetectorに伝播させない
                        handleDelete();
                      },
                      // 親のonPanUpdateに伝播させない
                      onPanDown: (_) {},
                      child: Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, VoidCallback onDelete) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('図形を削除'),
        content: const Text('この図形を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }

  Widget _buildShape(Shape shape, bool isSelected) {
    final color = Color(shape.color);

    switch (shape.type) {
      case ShapeType.rectangle:
        return Container(
          width: shape.width,
          height: shape.height,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.5),
            border: Border.all(
              color: isSelected ? Colors.blue : color,
              width: isSelected ? 3 : 2,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      case ShapeType.ellipse:
        return Container(
          width: shape.width,
          height: shape.height,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.5),
            border: Border.all(
              color: isSelected ? Colors.blue : color,
              width: isSelected ? 3 : 2,
            ),
            shape: BoxShape.circle,
          ),
        );
      case ShapeType.triangle:
        return CustomPaint(
          size: Size(shape.width, shape.height),
          painter: TrianglePainter(
            color: color,
            isSelected: isSelected,
          ),
        );
    }
  }
}

/// 三角形を描画するCustomPainter
class TrianglePainter extends CustomPainter {
  TrianglePainter({
    required this.color,
    required this.isSelected,
  });

  final Color color;
  final bool isSelected;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    // 塗りつぶし
    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // 枠線
    final strokePaint = Paint()
      ..color = isSelected ? Colors.blue : color
      ..style = PaintingStyle.stroke
      ..strokeWidth = isSelected ? 3 : 2;
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant TrianglePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.isSelected != isSelected;
  }
}
