class CalculatorBrain {
  String _expression = "";

  void reset() {
    _expression = "";
  }

  void addToExpression(String input) {
    _expression += input;
  }

  String calculate() {
    try {
      final result = _evaluateSimpleExpression(_expression);
      _expression = result.toString();
      return _expression;
    } catch (e) {
        reset();
        return "Error";
      }
  }

  double _evaluateSimpleExpression(String expression) {
    final regex = RegExp(r'(\d+\.?\d*)([\+\-\*\/\^])(\d+\.?\d*)');
    final match = regex.firstMatch(expression);

    if (match == null) {
      throw Exception("Invalid expression");
    }

    double operand1 = double.parse(match.group(1)!);
    String operator = match.group(2)!;
    double operand2 = double.parse(match.group(3)!);

    switch (operator) {
      case "+":
        return operand1 + operand2;
      case "-":
        return operand1 - operand2;
      case "*":
        return operand1 * operand2;
      case "/":
        return operand2 != 0 ? operand1 / operand2 : throw Exception("Division by zero");
      case "^":
        return _power(operand1, operand2);
      default:
        throw Exception("Error");
    }
  }

  double _power(double base, double exponent) {
    double result = 1;
      for (int i = 0; i < exponent.abs(); i++) {
        result *= base;
      }
      return exponent < 0 ? 1 / result : result;
  }
}