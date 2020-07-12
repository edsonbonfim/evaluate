import '../bin/interpreter.dart';
import '../bin/lexer.dart';
import '../bin/parser.dart';
import 'package:test/test.dart';

void main() {
  test('just a number', () {
    expect(interpret('3'), equals(3));
  });

  test('+', () {
    expect(interpret('3+4'), equals(3 + 4));
    expect(interpret('3 + 5'), equals(3 + 5));
    expect(interpret('3 +9'), equals(3 + 9));
    expect(interpret('27+ 3'), equals(27 + 3));
  });

  test('-', () {
    expect(interpret('7-4'), equals(7 - 4));
    expect(interpret('27 - 7'), equals(27 - 7));
  });

  test('+ and -', () {
    expect(interpret('7 - 3 + 2 - 1'), equals(7 - 3 + 2 - 1));
    expect(
      interpret('10 + 1 + 2 - 3 + 4 + 6 - 15'),
      equals(10 + 1 + 2 - 3 + 4 + 6 - 15),
    );
  });

  test('*', () {
    expect(interpret('3 * 7'), equals(3 * 7));
    expect(interpret('51 * 4 * .2'), equals(51 * 4 * .2));
    expect(interpret('51 * 4 * 0.2'), equals(51 * 4 * 0.2));
  });

  test('/', () {
    expect(interpret('3 / 7'), equals(3 / 7));
    expect(interpret('51 / 4 / .2'), equals(51 / 4 / .2));
    expect(interpret('51 / 4 / 0.2'), equals(51 / 4 / 0.2));
  });

  test('* and /', () {
    expect(interpret('7 * 4 / 2'), equals(7 * 4 / 2));
    expect(interpret('7 * 4 / 2 * 3'), equals(7 * 4 / 2 * 3));
    expect(interpret('10 * 4  * 2 * 3 / 8'), equals(10 * 4 * 2 * 3 / 8));
  });

  test('unary operators', () {
    expect(interpret('-3'), equals(-3));
    expect(interpret('+3'), equals(3));
    expect(interpret('5 - - - + - 3'), equals(8));
    expect(interpret('5 - - - + - (3 + 4) - +2'), equals(10));
  });

  test('^', () {
    expect(interpret('2^3^2'), equals(512));
    expect(interpret('2^(3^2)'), equals(512));
    expect(interpret('(2^3)^2'), equals(64));
  });

  test('mix', () {
    expect(interpret('14 + 2 * 3 - 6 / 2'), equals(14 + 2 * 3 - 6 / 2));
    expect(
      interpret('7 + 3 * (10 / (12 / (3 + 1) - 1))'),
      equals(7 + 3 * (10 / (12 / (3 + 1) - 1))),
    );
    expect(
      interpret('7 + 3 * (10 / (12 / (3 + 1) - 1)) / (2 + 3) - 5 - 3 + (8)'),
      equals(7 + 3 * (10 / (12 / (3 + 1) - 1)) / (2 + 3) - 5 - 3 + (8)),
    );
    expect(interpret('7 + (((3 + 2)))'), equals(7 + (((3 + 2)))));
    expect(interpret('3/(10^3)*7'), equals(0.021));
    expect(interpret('3/10^3*7'), equals(0.021));
    expect(interpret('3/10^(2+1)*7'), equals(0.021));
    expect(interpret('3/(13-3)^(2+1)*7'), equals(0.021));
  });
}

double interpret(String text) {
  return Interpreter(Parser(Lexer(text))).interpret();
}
