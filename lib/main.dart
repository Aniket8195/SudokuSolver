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
  bool isCorrect() {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        int? currentNumber = sudokuBoard[row][col];

        // Check if the current cell is empty or contains an invalid number
        if (currentNumber == null || currentNumber < 1 || currentNumber > 9) {
          return false; // If any cell is empty or contains an invalid number, the Sudoku is incorrect
        }

        // Check the current row for duplicates
        for (int checkCol = col + 1; checkCol < 9; checkCol++) {
          if (sudokuBoard[row][checkCol] == currentNumber) {
            return false; // Duplicate number found in the same row
          }
        }

        // Check the current column for duplicates
        for (int checkRow = row + 1; checkRow < 9; checkRow++) {
          if (sudokuBoard[checkRow][col] == currentNumber) {
            return false; // Duplicate number found in the same column
          }
        }

        // Check the current 3x3 subgrid for duplicates
        int subgridStartRow = (row ~/ 3) * 3;
        int subgridStartCol = (col ~/ 3) * 3;
        for (int checkRow = subgridStartRow; checkRow < subgridStartRow + 3; checkRow++) {
          for (int checkCol = subgridStartCol; checkCol < subgridStartCol + 3; checkCol++) {
            if (checkRow != row && checkCol != col && sudokuBoard[checkRow][checkCol] == currentNumber) {
              return false; // Duplicate number found in the same 3x3 subgrid
            }
          }
        }
      }
    }

    return true; // If all checks pass, the Sudoku board is correct
  }

  bool solveSudoku() {

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
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 5.0,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    int row = index ~/ 9;
                    int col = index % 9;
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: sudokuBoard[row][col] == null ? Colors.white : Colors.grey[300],
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
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
                              } else {
                                setState(() {
                                  sudokuBoard[row][col] = null;
                                });
                              }
                            } catch (e) {
                              setState(() {
                                sudokuBoard[row][col] = null;
                              });
                            }
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
                        if(isCorrect()){
                            solveSudoku();
                        }else{
                          Fluttertoast.showToast(
                              msg: "Error",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
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
