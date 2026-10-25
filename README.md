# 🧩 Sudoku Solver

A modern, elegant, and efficient Sudoku Solver application built with **Flutter**. This app allows users to input Sudoku puzzles and solve them instantly using a powerful backtracking algorithm.

![Sudoku Solver Preview](https://via.placeholder.com/800x400?text=Sudoku+Solver+App+Preview) <!-- Replace with an actual screenshot once uploaded -->

## ✨ Features

- **🚀 Instant Solving**: Uses a recursive backtracking algorithm to find the solution to any valid Sudoku puzzle.
- **🎨 Modern UI/UX**: A clean, responsive design with support for both **Light and Dark modes**.
- **🛠 Interactive Grid**: Easily input numbers, select cells, and manage your puzzle.
- **✅ Validation**: Checks for duplicate numbers in rows, columns, and 3x3 grids before attempting to solve.
- **📋 Sample Puzzles**: Includes a "Load Sample" feature to quickly test the solver.
- **📱 Multi-platform**: Built with Flutter, making it ready for Android, iOS, Web, and Desktop.
- **🖋 Typography**: Integrated with `google_fonts` (Poppins) for a professional look and feel.

## 🛠 Technical Architecture

### Algorithm
The core of the application is the `SudokuSolverLogic` class, which implements the **Backtracking Algorithm**. 
1. **Search**: It finds an empty cell (represented by `0`).
2. **Trial**: It attempts to place numbers from 1 to 9.
3. **Validation**: For every number placed, it verifies if the move is valid according to Sudoku rules.
4. **Recursion**: If valid, it moves to the next empty cell.
5. **Backtrack**: If no number works in a cell, it resets the cell and goes back to the previous step to try a different number.

### Tech Stack
- **Framework**: [Flutter](https://flutter.dev/)
- **Language**: [Dart](https://dart.dev/)
- **Fonts**: [Google Fonts](https://pub.dev/packages/google_fonts)
- **Design**: Material 3

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed on your machine.
- A code editor (VS Code or Android Studio).

### Installation
1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/sudoku_solver.git
   cd sudoku_solver
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

## 📖 How to Use
1. **Enter Puzzle**: Tap on any cell in the 9x9 grid and select a number from the number pad.
2. **Clear/Edit**: Use the "Delete" button to remove a number or "Clear Board" to start over.
3. **Solve**: Press the **SOLVE** button. The app will validate your input and display the completed puzzle.
4. **Sample**: Use "Load Sample Puzzle" to see the solver in action immediately.

## 📂 Project Structure
```text
lib/
├── main.dart                 # Entry point and Theme configuration
├── models/
│   └── sudoku_solver_logic.dart # Core backtracking algorithm
├── screens/
│   └── home_screen.dart      # Main UI logic and state management
└── widgets/
    ├── number_pad.dart       # Input number pad
    └── sudoku_grid.dart      # Custom 9x9 grid widget
```

## 🤝 Contributing
Contributions are welcome! Feel free to open an issue or submit a pull request to improve the algorithm, UI, or add new features.

## 📄 License
This project is open-source. Please check the `LICENSE` file for more details.
