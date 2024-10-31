import 'package:flutter/material.dart';
import 'calculator_logic.dart';
void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String displayExpression = "0";
  final CalculatorBrain brain = CalculatorBrain();

  bool isResultDisplayed = false;
  String? pressedButton;

  void buttonPressed(String buttonText) {
    
    if (isResultDisplayed) {
      if (!isOperator(buttonText) && !(buttonText == "C")) {
        return;
      }
      isResultDisplayed = false;
    }
    if (displayExpression == "0") {
      brain.addToExpression(displayExpression);
    }
    if (buttonText == "C") {
      brain.reset();
      setState(() {
        displayExpression = "0";
      });
    } else if (buttonText == "=") {
        String result = brain.calculate();
        setState(() {
          displayExpression = result;
        });
        isResultDisplayed = true;
      } else {
          if (isOperator(buttonText)) {
            for (int i = 0; i < displayExpression.length; i++) {
              if (isOperator(displayExpression[i])) {
                return;
              }
            }
          }
          if (buttonText == ".") {
            if (currentNumberHasDecimal()) {
              return;
            }
          }
          if (displayExpression == "0" && buttonText != "C" && !isOperator(buttonText)) {
            displayExpression = "";
          }

          brain.addToExpression(buttonText);
          setState(() {
            displayExpression += buttonText;
          });
        }
  }

  bool isOperator(String text) {
    return text == "+" || text == "-" || text == "*" || text == "/" || text == "^" || text == "=";
  }

  bool currentNumberHasDecimal() {
    for (int i = displayExpression.length - 1; i >= 0; i--) {
      if (isOperator(displayExpression[i])) {
        break;
      }
      if (displayExpression[i] == ".") {
        return true;
      }
    }
    return false;
  }

  Widget buildButton(String buttonText) {
    Color buttonColor;
    Color textColor;
    Color pressedColor;

    if (buttonText == "C") {
      buttonColor = Colors.grey;
      pressedColor = Colors.black54;
      textColor = Colors.white;
    } else if (isOperator(buttonText)) {
      buttonColor = Colors.orange;
      pressedColor = Colors.deepOrange;
      textColor = Colors.white;
    } else {
      buttonColor = Colors.white;
      pressedColor = Colors.black12;
      textColor = Colors.black;
    }

   if (pressedButton == buttonText) {
      buttonColor = pressedColor;
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTapDown: (_) {
            setState(() {
              pressedButton = buttonText;
            });
          },
          onTapUp: (_) {
            setState(() {
              pressedButton = null;
            });
            buttonPressed(buttonText);
          },
          onTapCancel: () {
            setState(() {
              pressedButton = null;
            });
          },
          child: Container(
            height: 70.0,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.black12),
            ),
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
            child: Text(
              displayExpression,
              style: const TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
            ),
          ),
          const Expanded(
            child: Divider(),
          ),
          Column(
            children: [
              Row(
                children: [
                  buildButton("C"),
                  buildButton("+"),
                ],
              ),
              Row(
                children: [
                  buildButton("7"),
                  buildButton("8"),
                  buildButton("9"),
                  buildButton("/"),
                ],
              ),
              Row(
                children: [
                  buildButton("4"),
                  buildButton("5"),
                  buildButton("6"),
                  buildButton("*"),
                ],
              ),
              Row(
                children: [
                  buildButton("1"),
                  buildButton("2"),
                  buildButton("3"),
                  buildButton("-"),
                ],
              ),
              Row(
                children: [
                  buildButton("0"),
                  buildButton("."),
                  buildButton("^"),
                  buildButton("="),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}