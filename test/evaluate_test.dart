import 'package:evaluate/evaluate.dart';
import 'package:test/test.dart';

void main() {
  test('just a number', () {
    expect(evaluate('3'), equals(3));
  });

  test('+', () {
    expect(evaluate('3+4'), equals(3 + 4));
    expect(evaluate('3 + 5'), equals(3 + 5));
    expect(evaluate('3 +9'), equals(3 + 9));
    expect(evaluate('27+ 3'), equals(27 + 3));
  });

  test('-', () {
    expect(evaluate('7-4'), equals(7 - 4));
    expect(evaluate('27 - 7'), equals(27 - 7));
  });

  test('+ and -', () {
    expect(evaluate('7 - 3 + 2 - 1'), equals(7 - 3 + 2 - 1));
    expect(
      evaluate('10 + 1 + 2 - 3 + 4 + 6 - 15'),
      equals(10 + 1 + 2 - 3 + 4 + 6 - 15),
    );
  });

  test('*', () {
    expect(evaluate('3 * 7'), equals(3 * 7));
    expect(evaluate('51 * 4 * .2'), equals(51 * 4 * .2));
    expect(evaluate('51 * 4 * 0.2'), equals(51 * 4 * 0.2));
  });

  test('/', () {
    expect(evaluate('3 / 7'), equals(3 / 7));
    expect(evaluate('51 / 4 / .2'), equals(51 / 4 / .2));
    expect(evaluate('51 / 4 / 0.2'), equals(51 / 4 / 0.2));
  });

  test('* and /', () {
    expect(evaluate('7 * 4 / 2'), equals(7 * 4 / 2));
    expect(evaluate('7 * 4 / 2 * 3'), equals(7 * 4 / 2 * 3));
    expect(evaluate('10 * 4  * 2 * 3 / 8'), equals(10 * 4 * 2 * 3 / 8));
  });

  test('unary operators', () {
    expect(evaluate('-3'), equals(-3));
    expect(evaluate('+3'), equals(3));
    expect(evaluate('5 - - - + - 3'), equals(8));
    expect(evaluate('5 - - - + - (3 + 4) - +2'), equals(10));
  });

  test('^', () {
    expect(evaluate('2^3^2'), equals(512));
    expect(evaluate('2^(3^2)'), equals(512));
    expect(evaluate('(2^3)^2'), equals(64));
  });

  test('mix', () {
    expect(evaluate('14 + 2 * 3 - 6 / 2'), equals(14 + 2 * 3 - 6 / 2));
    expect(
      evaluate('7 + 3 * (10 / (12 / (3 + 1) - 1))'),
      equals(7 + 3 * (10 / (12 / (3 + 1) - 1))),
    );
    expect(
      evaluate('7 + 3 * (10 / (12 / (3 + 1) - 1)) / (2 + 3) - 5 - 3 + (8)'),
      equals(7 + 3 * (10 / (12 / (3 + 1) - 1)) / (2 + 3) - 5 - 3 + (8)),
    );
    expect(evaluate('7 + (((3 + 2)))'), equals(7 + (((3 + 2)))));
    expect(evaluate('3/(10^3)*7'), equals(0.021));
    expect(evaluate('3/10^3*7'), equals(0.021));
    expect(evaluate('3/10^(2+1)*7'), equals(0.021));
    expect(evaluate('3/(13-3)^(2+1)*7'), equals(0.021));
  });
}
