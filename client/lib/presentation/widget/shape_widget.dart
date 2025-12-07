import 'package:flutter/material.dart';

import '../../domain/model/shape.dart';

/// 図形を描画するウィジェット
/// ドラッグによる移動と削除をサポート
class ShapeWidget extends StatelessWidget {
  const ShapeWidget({
    super.key,
    required this.shape,
    required this.onMove,
    required this.onDelete,
  });

  /// 描画する図形
  final Shape shape;

  /// 移動時のコールバック（dx, dy）
  final void Function(double dx, double dy) onMove;

  /// 削除時のコールバック
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: shape.x,
      top: shape.y,
      child: GestureDetector(
        onPanUpdate: (details) {
          onMove(details.delta.dx, details.delta.dy);
        },
        onLongPress: () {
          // 長押しで削除確認ダイアログ
          showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Shape'),
              content: const Text('Are you sure you want to delete this shape?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onDelete();
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
          );
        },
        child: _buildShape(),
      ),
    );
  }

  Widget _buildShape() {
    final color = Color(shape.color);

    switch (shape.type) {
      case ShapeType.rectangle:
        return Container(
          width: shape.width,
          height: shape.height,
          decoration: BoxDecoration(
            color: color.withOpacity(0.5),
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      case ShapeType.ellipse:
        return Container(
          width: shape.width,
          height: shape.height,
          decoration: BoxDecoration(
            color: color.withOpacity(0.5),
            border: Border.all(color: color, width: 2),
            shape: BoxShape.circle,
          ),
        );
      case ShapeType.text:
        return Container(
          width: shape.width,
          height: shape.height,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              shape.text ?? 'Text',
              style: TextStyle(color: color),
            ),
          ),
        );
    }
  }
}
