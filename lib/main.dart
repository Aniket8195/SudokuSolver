import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku Solver',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<int?>> sudokuBoard = List.generate(9, (i) => List<int?>.filled(9, null));
  bool isCorrect(int row, int col) {
    int? currentNumber = sudokuBoard[row][col];

    if (currentNumber == null) {
      return true; // An empty cell is always considered correct
    }
    if (currentNumber > 9|| currentNumber<1) {
      return false;
    }

    // Check the same row for duplicates
    for (int i = 0; i < 9; i++) {
      if (i != col && sudokuBoard[row][i] == currentNumber) {
        return false;
      }
    }

    // Check the same column for duplicates
    for (int i = 0; i < 9; i++) {
      if (i != row && sudokuBoard[i][col] == currentNumber) {
        return false;
      }
    }

    // Check the same 3x3 subgrid for duplicates
    int subgridRow = (row ~/ 3) * 3;
    int subgridCol = (col ~/ 3) * 3;
    for (int i = subgridRow; i < subgridRow + 3; i++) {
      for (int j = subgridCol; j < subgridCol + 3; j++) {
        if (i != row && j != col && sudokuBoard[i][j] == currentNumber) {
          return false; // Duplicate in the same 3x3 subgrid
        }
      }
    }

    return true; // No duplicates found
  }


  solveSudoku() {
    if (_solveSudoku(0, 0)) {
      // Sudoku is solved, update the UI with the solved puzzle.
      setState(() {});
    } else {
      // If no solution exists, display an error message.
      Fluttertoast.showToast(
        msg: "No solution exists for this Sudoku.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  bool _solveSudoku(int row, int col) {
    // Base case: If we have filled all the cells, the Sudoku is solved.
    if (row == 9) {
      return true;
    }

    // Move to the next cell.
    int nextRow = (col == 8) ? row + 1 : row;
    int nextCol = (col + 1) % 9;

    // Skip cells that are already filled.
    if (sudokuBoard[row][col] != null) {
      return _solveSudoku(nextRow, nextCol);
    }

    // Try filling the current cell with numbers from 1 to 9.
    for (int num = 1; num <= 9; num++) {
      if (_isSafe(row, col, num)) {
        // If it's safe to place the number, update the board.
        sudokuBoard[row][col] = num;

        // Recursively try to solve the remaining Sudoku.
        if (_solveSudoku(nextRow, nextCol)) {
          return true;
        }

        // If the current placement doesn't lead to a solution, backtrack.
        sudokuBoard[row][col] = null;
      }
    }

    // If no number can be placed here, return false to backtrack further.
    return false;
  }

  bool _isSafe(int row, int col, int num) {
    // Check if 'num' is not present in the current row, current column, and current 3x3 subgrid.
    for (int i = 0; i < 9; i++) {
      if (sudokuBoard[row][i] == num || sudokuBoard[i][col] == num) {
        return false;
      }
    }

    int subgridRow = (row ~/ 3) * 3;
    int subgridCol = (col ~/ 3) * 3;
    for (int i = subgridRow; i < subgridRow + 3; i++) {
      for (int j = subgridCol; j < subgridCol + 3; j++) {
        if (sudokuBoard[i][j] == num) {
          return false;
        }
      }
    }

    return true;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 10.0),
                const Text(
                  'Enter Sudoku Numbers',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 9,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    int row = index ~/ 9;
                    int col = index % 9;

                    bool isValid = isCorrect(row, col);
                    int? cellValue = sudokuBoard[row][col];
                    String displayText = cellValue != null ? '$cellValue' : '';
                    Color? cellColor=sudokuBoard[row][col] == null ? Colors.white : Colors.grey[300];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: cellColor,
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: isValid ? Colors.black : Colors.red,
                        ),
                        controller: TextEditingController(text: displayText),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            setState(() {
                              sudokuBoard[row][col] = null;
                            });
                          } else {
                            try {
                              int number = int.parse(value);
                              if (number >= 1 && number <= 9) {
                                setState(() {
                                  sudokuBoard[row][col] = number;
                                });
                              }
                            }

                            catch (e) {
                              setState(() {
                                sudokuBoard[row][col] = null;
                              });
                            }
                          }
                          bool isValid = isCorrect(row, col);
                          if (!isValid) {

                            Fluttertoast.showToast(
                              msg: "Error: Enter a number between 1 and 9.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                      ),
                    );
                  },
                  itemCount: 81,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                        solveSudoku();
                  },
                  child: const Text('Solve Sudoku'),
                ),
              ],
            ),
          ),
        ),
      ),


    );
  }
}
