import 'dart:convert';
import 'dart:io';

enum TokenType { INTEGER, PLUS, MINUS, EOF }

class Token {
  const Token(this.type, this.value);

  /// Token type: INTEGER, PLUS, MINUS, EOF
  final TokenType type;

  /// Token value: non-negative integer value, '+', '-', or null
  final dynamic value;

  /// String representation of the class instance
  /// Example: Token(INTEGER, 3)
  ///          Token(PLUS, '+')
  @override
  String toString() {
    return 'Token($type, ${value.toString()})';
  }
}

class Interpreter {
  Interpreter(this.text) : assert(text != null) {
    currentChar = text[pos];
  }

  /// Client string input, e.g. "3 + 5", "12 - 5 + 3", etc
  final String text;

  /// [pos] is an index into [text]
  int pos = 0;

  /// Current token instance
  Token currentToken;

  String currentChar;

  void error() => throw FormatException('Invalid sintax');

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

      error();
    }

    return Token(TokenType.EOF, null);
  }

  /// Compare the current token type with the passed token type and if they match
  /// then "eat" the current token and assign the next token to the [currentToken],
  /// otherwise raise an exception.
  void eat(TokenType tokenType) {
    if (currentToken.type == tokenType) {
      currentToken = getNextToken();
    } else {
      error();
    }
  }

  /// Return an [TokenType.INTEGER] token value.
  int term() {
    var token = currentToken;
    eat(TokenType.INTEGER);
    return token.value;
  }

  /// Arithmetic expression parser/interpreter.
  int expr() {
    // Set current token to the first token taken from the input
    currentToken = getNextToken();

    var result = term();

    while (currentToken.type == TokenType.PLUS ||
        currentToken.type == TokenType.MINUS) {
      var token = currentToken;
      if (token.type == TokenType.PLUS) {
        eat(TokenType.PLUS);
        result = result + term();
      } else if (token.type == TokenType.MINUS) {
        eat(TokenType.MINUS);
        result = result - term();
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
      var interpreter = Interpreter(text);
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
