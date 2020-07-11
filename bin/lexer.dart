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
