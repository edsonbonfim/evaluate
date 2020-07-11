import 'dart:convert';
import 'dart:io';

enum TokenType { INTEGER, PLUS, MINUS, MUL, DIV, LPAREN, RPAREN, EOF }

const INTEGER = TokenType.INTEGER;
const PLUS = TokenType.PLUS;
const MINUS = TokenType.MINUS;
const MUL = TokenType.MUL;
const DIV = TokenType.DIV;
const LPAREN = TokenType.LPAREN;
const RPAREN = TokenType.RPAREN;
const EOF = TokenType.EOF;

class Token {
  const Token(this.type, this.value);

  final TokenType type;

  /// Token value: non-negative integer value, '+', '-', or null
  final dynamic value;

  /// String representation of the class instance
  /// Example: Token(INTEGER, 3)
  ///          Token(PLUS, '+')
  ///          Token(MUL, '*')
  @override
  String toString() {
    return 'Token($type, ${value.toString()})';
  }
}

class Lexer {
  Lexer(this.text) : assert(text != null && text.isNotEmpty) {
    currentChar = text[pos];
  }

  /// Client string input, e.g. "3 + 5", "12 - 5 + 3", etc
  final String text;

  /// [pos] is an index into [text]
  int pos = 0;

  String currentChar;

  void error() => throw FormatException('Invalid character');

  /// Advance the [pos] pointer and set the [currentChar] variable
  void advance() {
    pos++;

    if (pos > text.length - 1) {
      // Indicates end of input
      currentChar = null;
    } else {
      currentChar = text[pos];
    }
  }

  void skipWhiteSpace() {
    while (currentChar != null && currentChar == ' ') {
      advance();
    }
  }

  /// Return a (multidigit) integer consumed from the input
  int integer() {
    var result = '';

    while (currentChar != null && int.tryParse(currentChar) != null) {
      result += currentChar;
      advance();
    }

    return int.parse(result);
  }

  /// Lexical analyser (alson knows as scanner or tokenizer)
  /// This method is responsible for breaking a sentence apart into tokens.
  /// One token at time.
  Token getNextToken() {
    while (currentChar != null) {
      if (currentChar == ' ') {
        skipWhiteSpace();
        continue;
      }

      if (int.tryParse(currentChar) != null) {
        return Token(TokenType.INTEGER, integer());
      }

      if (currentChar == '+') {
        advance();
        return Token(TokenType.PLUS, '+');
      }

      if (currentChar == '-') {
        advance();
        return Token(TokenType.MINUS, '-');
      }

      if (currentChar == '*') {
        advance();
        return Token(TokenType.MUL, '*');
      }

      if (currentChar == '/') {
        advance();
        return Token(TokenType.DIV, '/');
      }

      if (currentChar == '(') {
        advance();
        return Token(TokenType.LPAREN, '(');
      }

      if (currentChar == ')') {
        advance();
        return Token(TokenType.RPAREN, ')');
      }

      error();
    }

    return Token(TokenType.EOF, null);
  }
}

class Interpreter {
  Interpreter(this.lexer) : assert(lexer != null) {
    // Set current token to the first token taken from the input
    currentToken = lexer.getNextToken();
  }

  final Lexer lexer;

  /// Current token instance
  Token currentToken;

  void error() => throw FormatException('Invalid syntax');

  /// Compare the current token type with the passed token type and if they match
  /// then "eat" the current token and assign the next token to the [currentToken],
  /// otherwise raise an exception.
  void eat(TokenType tokenType) {
    if (currentToken.type == tokenType) {
      currentToken = lexer.getNextToken();
    } else {
      error();
    }
  }

  /// [factor] : [INTEGER] | [LPAREN] [expr] [RPAREN]
  int factor() {
    var token = currentToken;

    if (token.type == INTEGER) {
      eat(INTEGER);
      return token.value;
    }

    eat(LPAREN);
    var result = expr();
    eat(RPAREN);
    return result;
  }

  /// [term] : [factor] (([MUL] | [DIV]) [factor])*
  int term() {
    var result = factor();

    while (currentToken.type == MUL || currentToken.type == DIV) {
      var token = currentToken;

      if (token.type == MUL) {
        eat(MUL);
        result *= factor();
      } else if (token.type == DIV) {
        eat(DIV);
        result ~/= factor();
      }
    }

    return result;
  }

  /// [expr] : [term] (([PLUS] | [MINUS]) [term])*
  int expr() {
    var result = term();

    while (currentToken.type == PLUS || currentToken.type == MINUS) {
      var token = currentToken;

      if (token.type == PLUS) {
        eat(PLUS);
        result += term();
      } else if (token.type == MINUS) {
        eat(MINUS);
        result -= term();
      }
    }

    return result;
  }
}

void main(List<String> args) {
  while (true) {
    try {
      stdout.write('calc> ');
      var text = stdin.readLineSync(encoding: Encoding.getByName('utf-8'));
      var lexer = Lexer(text);
      var interpreter = Interpreter(lexer);
      var result = interpreter.expr();
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
