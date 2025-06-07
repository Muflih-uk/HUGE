import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String display = '0';
  String expression = '';
  double result = 0;
  String operation = '';
  double operand = 0;
  bool waitingForOperand = false;

  void onDigitPressed(String digit) {
    setState(() {
      if (waitingForOperand) {
        display = digit;
        waitingForOperand = false;
      } else {
        display = display == '0' ? digit : display + digit;
      }
    });
  }

  void onOperatorPressed(String operator) {
    setState(() {
      if (!waitingForOperand) {
        if (operation.isNotEmpty) {
          calculate();
        } else {
          result = double.parse(display);
        }
      }
      
      operation = operator;
      waitingForOperand = true;
      expression = display + ' ' + operator + ' ';
    });
  }

  void calculate() {
    double currentValue = double.parse(display);
    
    switch (operation) {
      case '+':
        result = result + currentValue;
        break;
      case '-':
        result = result - currentValue;
        break;
      case '×':
        result = result * currentValue;
        break;
      case '÷':
        if (currentValue != 0) {
          result = result / currentValue;
        } else {
          display = 'Error';
          return;
        }
        break;
      case '%':
        result = result % currentValue;
        break;
    }
    
    // Format the result to remove unnecessary decimals
    if (result == result.toInt()) {
      display = result.toInt().toString();
    } else {
      display = result.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '');
    }
  }

  void onEqualsPressed() {
    setState(() {
      if (operation.isNotEmpty && !waitingForOperand) {
        calculate();
        expression = '';
        operation = '';
        waitingForOperand = true;
      }
    });
  }

  void onClearPressed() {
    setState(() {
      display = '0';
      expression = '';
      result = 0;
      operation = '';
      operand = 0;
      waitingForOperand = false;
    });
  }

  void onBackspacePressed() {
    setState(() {
      if (display.length > 1) {
        display = display.substring(0, display.length - 1);
      } else {
        display = '0';
      }
    });
  }

  void onDecimalPressed() {
    setState(() {
      if (waitingForOperand) {
        display = '0.';
        waitingForOperand = false;
      } else if (!display.contains('.')) {
        display = display + '.';
      }
    });
  }

  Widget buildButton({
    required String text,
    required VoidCallback onPressed,
    Color backgroundColor = Colors.grey,
    Color textColor = Colors.white,
    Widget? child,
  }) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size(70, 70),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
        ),
      ),
      onPressed: onPressed,
      child: child ?? Text(
        text,
        style: TextStyle(fontSize: 28, color: textColor, fontWeight: FontWeight.w400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Display Area
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (expression.isNotEmpty)
                      Text(
                        expression,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.grey,
                        ),
                      ),
                    SizedBox(height: 10),
                    Text(
                      display,
                      style: TextStyle(
                        fontSize: 48,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
            
            
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildButton(
                          text: 'AC',
                          onPressed: onClearPressed,
                          backgroundColor: Colors.grey[600]!,
                        ),
                        buildButton(
                          text: '%',
                          onPressed: () => onOperatorPressed('%'),
                          backgroundColor: Colors.grey[600]!,
                        ),
                        buildButton(
                          text: '',
                          onPressed: onBackspacePressed,
                          backgroundColor: Colors.grey[600]!,
                          child: Icon(Icons.backspace_outlined, color: Colors.white, size: 24),
                        ),
                        buildButton(
                          text: '÷',
                          onPressed: () => onOperatorPressed('÷'),
                          backgroundColor: Colors.orange,
                        ),
                      ],
                    ),
                    
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildButton(
                          text: '7',
                          onPressed: () => onDigitPressed('7'),
                          backgroundColor: Colors.grey[800]!,
                        ),
                        buildButton(
                          text: '8',
                          onPressed: () => onDigitPressed('8'),
                          backgroundColor: Colors.grey[800]!,
                        ),
                        buildButton(
                          text: '9',
                          onPressed: () => onDigitPressed('9'),
                          backgroundColor: Colors.grey[800]!,
                        ),
                        buildButton(
                          text: '×',
                          onPressed: () => onOperatorPressed('×'),
                          backgroundColor: Colors.orange,
                        ),
                      ],
                    ),
                    
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildButton(
                          text: '4',
                          onPressed: () => onDigitPressed('4'),
                          backgroundColor: Colors.grey[800]!,
                        ),
                        buildButton(
                          text: '5',
                          onPressed: () => onDigitPressed('5'),
                          backgroundColor: Colors.grey[800]!,
                        ),
                        buildButton(
                          text: '6',
                          onPressed: () => onDigitPressed('6'),
                          backgroundColor: Colors.grey[800]!,
                        ),
                        buildButton(
                          text: '−',
                          onPressed: () => onOperatorPressed('-'),
                          backgroundColor: Colors.orange,
                        ),
                      ],
                    ),
                    
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildButton(
                          text: '1',
                          onPressed: () => onDigitPressed('1'),
                          backgroundColor: Colors.grey[800]!,
                        ),
                        buildButton(
                          text: '2',
                          onPressed: () => onDigitPressed('2'),
                          backgroundColor: Colors.grey[800]!,
                        ),
                        buildButton(
                          text: '3',
                          onPressed: () => onDigitPressed('3'),
                          backgroundColor: Colors.grey[800]!,
                        ),
                        buildButton(
                          text: '+',
                          onPressed: () => onOperatorPressed('+'),
                          backgroundColor: Colors.orange,
                        ),
                      ],
                    ),
                    
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildButton(
                          text: '00',
                          onPressed: () => onDigitPressed('00'),
                          backgroundColor: Colors.grey[800]!,
                        ),
                        buildButton(
                          text: '0',
                          onPressed: () => onDigitPressed('0'),
                          backgroundColor: Colors.grey[800]!,
                        ),
                        buildButton(
                          text: '.',
                          onPressed: onDecimalPressed,
                          backgroundColor: Colors.grey[800]!,
                        ),
                        buildButton(
                          text: '=',
                          onPressed: onEqualsPressed,
                          backgroundColor: Colors.orange,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
