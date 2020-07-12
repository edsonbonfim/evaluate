enum TokenType {
  NUMBER,
  PLUS,
  MINUS,
  MUL,
  DIV,
  LPAREN,
  RPAREN,
  DOT,
  EOF,
  EXPONENT
}

const NUMBER = TokenType.NUMBER;
const PLUS = TokenType.PLUS;
const MINUS = TokenType.MINUS;
const MUL = TokenType.MUL;
const DIV = TokenType.DIV;
const LPAREN = TokenType.LPAREN;
const RPAREN = TokenType.RPAREN;
const DOT = TokenType.DOT;
const EOF = TokenType.EOF;
const EXPONENT = TokenType.EXPONENT;

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

  String peek([int n = 1]) {
    assert(n >= 1);

    var pos = this.pos + n;

    if (pos > text.length - 1) {
      return null;
    } else {
      return text[pos] != ' ' ? text[pos] : peek(n + 1);
    }
  }

  void skipWhiteSpace() {
    while (currentChar != null && currentChar == ' ') {
      advance();
    }
  }

  /// Return a (multidigit) number consumed from the input
  double number([String start = '']) {
    var result = start;

    while (currentChar != null &&
        (int.tryParse(currentChar) != null || currentChar == '.')) {
      result += currentChar;
      advance();
    }

    return double.parse(result);
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
        return Token(NUMBER, number());
      }

      if (currentChar == '.') {
        advance();
        return Token(NUMBER, number('.'));
      }

      if (currentChar == '+') {
        advance();
        return Token(PLUS, '+');
      }

      if (currentChar == '-') {
        advance();
        return Token(MINUS, '-');
      }

      if (currentChar == '*') {
        advance();
        return Token(MUL, '*');
      }

      if (currentChar == '/') {
        advance();
        return Token(DIV, '/');
      }

      if (currentChar == '^') {
        advance();
        return Token(EXPONENT, '^');
      }

      if (currentChar == '(') {
        advance();
        return Token(LPAREN, '(');
      }

      if (currentChar == ')') {
        advance();
        return Token(RPAREN, ')');
      }

      error();
    }

    return Token(EOF, null);
  }
}
