import 'dart:convert';
import 'dart:io';

import 'evaluator.dart';
import 'lexer.dart';
import 'parser.dart';

void main(List<String> args) {
  while (true) {
    try {
      stdout.write('calc> ');
      var text = stdin.readLineSync(encoding: Encoding.getByName('utf-8'));
      var lexer = Lexer(text);
      var parser = Parser(lexer);
      var interpreter = Evaluator(parser);
      var result = interpreter.evaluate();
      print(result.toString());
    } on FormatException catch (ex) {
      print(ex.message);
      break;
    } on Exception {
      print('An error has occurred');
      break;
    }
  }
}
