class SudokuSolverLogic {
  /// Solves the Sudoku puzzle using Backtracking Algorithm
  /// Returns true if solved, false if no solution exists
  static bool solveSudoku(List<List<int>> board) {
    // Find the next empty cell
    List<int>? emptyCell = _findEmptyCell(board);

    // If no empty cell found, puzzle is solved
    if (emptyCell == null) {
      return true;
    }

    int row = emptyCell[0];
    int col = emptyCell[1];

    // Try numbers 1 to 9
    for (int num = 1; num <= 9; num++) {
      if (_isValid(board, row, col, num)) {
        // Place the number
        board[row][col] = num;

        // Recursively try to solve the rest
        if (solveSudoku(board)) {
          return true;
        }

        // If placing num didn't lead to a solution, backtrack
        board[row][col] = 0;
      }
    }

    // No number worked, trigger backtracking
    return false;
  }

  /// Find the next empty cell (cell with value 0)
  static List<int>? _findEmptyCell(List<List<int>> board) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (board[row][col] == 0) {
          return [row, col];
        }
      }
    }
    return null; // No empty cell found
  }

  /// Check if placing a number is valid
  static bool _isValid(List<List<int>> board, int row, int col, int num) {
    // Check row
    for (int c = 0; c < 9; c++) {
      if (board[row][c] == num) {
        return false;
      }
    }

    // Check column
    for (int r = 0; r < 9; r++) {
      if (board[r][col] == num) {
        return false;
      }
    }

    // Check 3x3 box
    int boxRowStart = (row ~/ 3) * 3;
    int boxColStart = (col ~/ 3) * 3;

    for (int r = boxRowStart; r < boxRowStart + 3; r++) {
      for (int c = boxColStart; c < boxColStart + 3; c++) {
        if (board[r][c] == num) {
          return false;
        }
      }
    }

    return true;
  }

  /// Validate the initial board (check for duplicates in given puzzle)
  static bool isValidBoard(List<List<int>> board) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (board[row][col] != 0) {
          int num = board[row][col];
          board[row][col] = 0; // Temporarily remove
          if (!_isValid(board, row, col, num)) {
            board[row][col] = num; // Restore
            return false;
          }
          board[row][col] = num; // Restore
        }
      }
    }
    return true;
  }

  /// Create a deep copy of the board
  static List<List<int>> copyBoard(List<List<int>> board) {
    return board.map((row) => List<int>.from(row)).toList();
  }
}