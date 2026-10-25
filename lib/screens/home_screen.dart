import 'package:flutter/material.dart';
import '../models/sudoku_solver_logic.dart';
import '../widgets/sudoku_grid.dart';
import '../widgets/number_pad.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // 9x9 board initialized with 0s (0 means empty)
  List<List<int>> board = List.generate(9, (_) => List.filled(9, 0));

  // Track which cells were part of the original puzzle
  List<List<bool>> originalCells = List.generate(9, (_) => List.filled(9, false));

  // Currently selected cell
  int? selectedRow;
  int? selectedCol;

  // State flags
  bool isSolved = false;
  bool isSolving = false;

  // Animation controller
  late AnimationController _solveAnimController;
  late Animation<double> _solveAnimation;

  @override
  void initState() {
    super.initState();
    _solveAnimController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _solveAnimation = CurvedAnimation(
      parent: _solveAnimController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _solveAnimController.dispose();
    super.dispose();
  }

  void _onCellTap(int row, int col) {
    if (isSolved && originalCells[row][col]) return;
    setState(() {
      selectedRow = row;
      selectedCol = col;
    });
  }

  void _onNumberSelect(int number) {
    if (selectedRow == null || selectedCol == null) {
      _showSnackBar('Please select a cell first!', Colors.orange);
      return;
    }

    if (isSolved && originalCells[selectedRow!][selectedCol!]) return;

    setState(() {
      board[selectedRow!][selectedCol!] = number;
      if (!isSolved) {
        originalCells[selectedRow!][selectedCol!] = true;
      }
    });
  }

  void _onDelete() {
    if (selectedRow == null || selectedCol == null) {
      _showSnackBar('Please select a cell first!', Colors.orange);
      return;
    }

    if (isSolved && originalCells[selectedRow!][selectedCol!]) {
      _showSnackBar('Cannot delete original puzzle numbers!', Colors.red);
      return;
    }

    setState(() {
      board[selectedRow!][selectedCol!] = 0;
      if (!isSolved) {
        originalCells[selectedRow!][selectedCol!] = false;
      }
    });
  }

  void _solvePuzzle() {
    // Check if board is empty
    bool isEmpty = board.every((row) => row.every((cell) => cell == 0));
    if (isEmpty) {
      _showSnackBar('Please enter a Sudoku puzzle first!', Colors.orange);
      return;
    }

    // Validate the board
    if (!SudokuSolverLogic.isValidBoard(board)) {
      _showSnackBar('Invalid puzzle! Check for duplicate numbers.', Colors.red);
      return;
    }

    setState(() {
      isSolving = true;
    });

    // Create a copy to solve
    List<List<int>> boardCopy = SudokuSolverLogic.copyBoard(board);

    // Solve
    Future.delayed(const Duration(milliseconds: 300), () {
      bool solved = SudokuSolverLogic.solveSudoku(boardCopy);

      setState(() {
        isSolving = false;
        if (solved) {
          board = boardCopy;
          isSolved = true;
          _solveAnimController.forward();
          _showSnackBar('✅ Puzzle Solved Successfully!', Colors.green);
        } else {
          _showSnackBar('❌ No solution exists for this puzzle!', Colors.red);
        }
      });
    });
  }

  void _clearBoard() {
    setState(() {
      board = List.generate(9, (_) => List.filled(9, 0));
      originalCells = List.generate(9, (_) => List.filled(9, false));
      selectedRow = null;
      selectedCol = null;
      isSolved = false;
      _solveAnimController.reset();
    });
    _showSnackBar('Board cleared!', Colors.blue);
  }

  void _loadSamplePuzzle() {
    setState(() {
      board = [
        [5, 3, 0, 0, 7, 0, 0, 0, 0],
        [6, 0, 0, 1, 9, 5, 0, 0, 0],
        [0, 9, 8, 0, 0, 0, 0, 6, 0],
        [8, 0, 0, 0, 6, 0, 0, 0, 3],
        [4, 0, 0, 8, 0, 3, 0, 0, 1],
        [7, 0, 0, 0, 2, 0, 0, 0, 6],
        [0, 6, 0, 0, 0, 0, 2, 8, 0],
        [0, 0, 0, 4, 1, 9, 0, 0, 5],
        [0, 0, 0, 0, 8, 0, 0, 7, 9],
      ];

      originalCells = List.generate(9, (r) =>
          List.generate(9, (c) => board[r][c] != 0));

      selectedRow = null;
      selectedCol = null;
      isSolved = false;
      _solveAnimController.reset();
    });
    _showSnackBar('Sample puzzle loaded!', Colors.blue);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0D1117)
          : const Color(0xFFF5F7FF),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.grid_on_rounded, size: 28),
            SizedBox(width: 10),
            Text(
              'SUDOKU SOLVER',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'sample') _loadSamplePuzzle();
              if (value == 'clear') _clearBoard();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'sample',
                child: Row(
                  children: [
                    Icon(Icons.download_rounded),
                    SizedBox(width: 8),
                    Text('Load Sample'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.clear_all_rounded),
                    SizedBox(width: 8),
                    Text('Clear Board'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),

                      // Status indicator
                      if (isSolved)
                        FadeTransition(
                          opacity: _solveAnimation,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle, color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'SOLVED!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: 12),

                      // Sudoku Grid
                      SudokuGrid(
                        board: board,
                        originalCells: originalCells,
                        selectedRow: selectedRow,
                        selectedCol: selectedCol,
                        isSolved: isSolved,
                        onCellTap: _onCellTap,
                      ),

                      const SizedBox(height: 20),

                      // Number Pad
                      NumberPad(
                        onNumberSelected: _onNumberSelect,
                        onDelete: _onDelete,
                      ),

                      const SizedBox(height: 20),

                      // Action Buttons
                      Row(
                        children: [
                          // Solve Button
                          Expanded(
                            child: _ActionButton(
                              label: isSolving ? 'SOLVING...' : 'SOLVE',
                              icon: isSolving
                                  ? Icons.hourglass_top_rounded
                                  : Icons.auto_fix_high_rounded,
                              gradient: const [Color(0xFF1A237E), Color(0xFF3949AB)],
                              onPressed: isSolving ? null : _solvePuzzle,
                              isLoading: isSolving,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Clear Button
                          Expanded(
                            child: _ActionButton(
                              label: 'CLEAR',
                              icon: Icons.refresh_rounded,
                              gradient: const [Color(0xFFC62828), Color(0xFFEF5350)],
                              onPressed: _clearBoard,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Load Sample Button
                      SizedBox(
                        width: double.infinity,
                        child: _ActionButton(
                          label: 'LOAD SAMPLE PUZZLE',
                          icon: Icons.download_rounded,
                          gradient: const [Color(0xFF00695C), Color(0xFF26A69A)],
                          onPressed: _loadSamplePuzzle,
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback? onPressed;
  final bool isLoading;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                else
                  Icon(icon, color: Colors.white, size: 22),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}