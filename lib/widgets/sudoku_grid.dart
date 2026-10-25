import 'package:flutter/material.dart';

class SudokuGrid extends StatelessWidget {
  final List<List<int>> board;
  final List<List<bool>> originalCells;
  final int? selectedRow;
  final int? selectedCol;
  final bool isSolved;
  final Function(int row, int col) onCellTap;

  const SudokuGrid({
    super.key,
    required this.board,
    required this.originalCells,
    required this.selectedRow,
    required this.selectedCol,
    required this.isSolved,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF3949AB) : const Color(0xFF1A237E),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.indigo).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(2),
      child: AspectRatio(
        aspectRatio: 1,
        child: Column(
          children: List.generate(9, (row) {
            return Expanded(
              child: Row(
                children: List.generate(9, (col) {
                  return Expanded(
                    child: _SudokuCell(
                      value: board[row][col],
                      row: row,
                      col: col,
                      isSelected: selectedRow == row && selectedCol == col,
                      isHighlighted: selectedRow == row ||
                          selectedCol == col ||
                          (_sameBox(row, col)),
                      isOriginal: originalCells[row][col],
                      isSolved: isSolved,
                      isDark: isDark,
                      onTap: () => onCellTap(row, col),
                    ),
                  );
                }),
              ),
            );
          }),
        ),
      ),
    );
  }

  bool _sameBox(int row, int col) {
    if (selectedRow == null || selectedCol == null) return false;
    return (row ~/ 3 == selectedRow! ~/ 3) && (col ~/ 3 == selectedCol! ~/ 3);
  }
}

class _SudokuCell extends StatelessWidget {
  final int value;
  final int row;
  final int col;
  final bool isSelected;
  final bool isHighlighted;
  final bool isOriginal;
  final bool isSolved;
  final bool isDark;
  final VoidCallback onTap;

  const _SudokuCell({
    required this.value,
    required this.row,
    required this.col,
    required this.isSelected,
    required this.isHighlighted,
    required this.isOriginal,
    required this.isSolved,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine cell background color
    Color bgColor;
    if (isSelected) {
      bgColor = isDark
          ? const Color(0xFF3949AB).withOpacity(0.6)
          : const Color(0xFFBBDEFB);
    } else if (isHighlighted) {
      bgColor = isDark
          ? const Color(0xFF1A237E).withOpacity(0.2)
          : const Color(0xFFE8EAF6);
    } else {
      bgColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    }

    // Determine text color
    Color textColor;
    if (isOriginal) {
      textColor = isDark ? Colors.white : const Color(0xFF1A237E);
    } else if (isSolved && value != 0) {
      textColor = isDark
          ? const Color(0xFF66BB6A)
          : const Color(0xFF2E7D32);
    } else {
      textColor = isDark ? const Color(0xFF90CAF9) : const Color(0xFF42A5F5);
    }

    // Border logic for 3x3 box separation
    BorderSide thinBorder = BorderSide(
      color: isDark
          ? Colors.white.withOpacity(0.1)
          : Colors.grey.withOpacity(0.3),
      width: 0.5,
    );
    BorderSide thickBorder = BorderSide(
      color: isDark ? const Color(0xFF3949AB) : const Color(0xFF1A237E),
      width: 1.5,
    );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border(
            top: row % 3 == 0 ? thickBorder : thinBorder,
            left: col % 3 == 0 ? thickBorder : thinBorder,
            bottom: row == 8 ? thickBorder : thinBorder,
            right: col == 8 ? thickBorder : thinBorder,
          ),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              value == 0 ? '' : value.toString(),
              key: ValueKey<int>(value),
              style: TextStyle(
                fontSize: 20,
                fontWeight: isOriginal ? FontWeight.w800 : FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}