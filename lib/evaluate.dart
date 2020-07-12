import 'src/evaluator.dart';
import 'src/lexer.dart';
import 'src/parser.dart';

extension EvaluatorExt on String {
  double evaluate(String expression) => evaluate(expression);
}

double evaluate(String expression) {
  return Evaluator(Parser(Lexer(expression))).evaluate();
}
