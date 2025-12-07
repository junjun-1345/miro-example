import 'package:flutter/material.dart';

import '../../domain/model/shape.dart';

/// ツールバーウィジェット
/// 図形の種類を選択するためのUI
class Toolbar extends StatelessWidget {
  const Toolbar({
    super.key,
    required this.selectedTool,
    required this.onToolSelected,
  });

  /// 現在選択中のツール
  final ShapeType? selectedTool;

  /// ツール選択時のコールバック
  final void Function(ShapeType?) onToolSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          // 選択解除
          _ToolButton(
            icon: Icons.mouse,
            label: 'Select',
            isSelected: selectedTool == null,
            onPressed: () => onToolSelected(null),
          ),
          const SizedBox(width: 8),
          // 矩形
          _ToolButton(
            icon: Icons.rectangle_outlined,
            label: 'Rectangle',
            isSelected: selectedTool == ShapeType.rectangle,
            onPressed: () => onToolSelected(ShapeType.rectangle),
          ),
          const SizedBox(width: 8),
          // 楕円
          _ToolButton(
            icon: Icons.circle_outlined,
            label: 'Ellipse',
            isSelected: selectedTool == ShapeType.ellipse,
            onPressed: () => onToolSelected(ShapeType.ellipse),
          ),
          const SizedBox(width: 8),
          // 三角形
          _ToolButton(
            icon: Icons.change_history,
            label: 'Triangle',
            isSelected: selectedTool == ShapeType.triangle,
            onPressed: () => onToolSelected(ShapeType.triangle),
          ),
        ],
      ),
    );
  }
}

/// ツールボタンウィジェット
class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Material(
        color: isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
