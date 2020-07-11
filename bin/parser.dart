import 'lexer.dart';

abstract class NodeVisitor {
  const NodeVisitor();

  double visitUnaryOp(UnaryOp node);
  double visitBinOp(BinOp node);
  double visitNum(Num node);
}

abstract class AST {
  const AST();

  Token get token;

  double visit(NodeVisitor visitor);
}

class UnaryOp extends AST {
  UnaryOp(this.op, this.expr);

  final Token op;
  final AST expr;

  @override
  double visit(NodeVisitor visitor) => visitor.visitUnaryOp(this);

  @override
  Token get token => op;
}

class BinOp extends AST {
  const BinOp(this.esq, this.op, this.dir)
      : assert(esq != null && op != null && dir != null);

  final AST esq, dir;
  final Token op;

  @override
  Token get token => op;

  @override
  double visit(NodeVisitor visitor) => visitor.visitBinOp(this);
}

class Num extends AST {
  const Num(this.token) : assert(token != null);

  @override
  final Token token;

  double get value => token.value;

  @override
  double visit(NodeVisitor visitor) => visitor.visitNum(this);
}

class Parser {
  Parser(this.lexer) : assert(lexer != null) {
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

  /// [factor] : ([PLUS] | [MINUS]) [factor] | [NUMBER] | [LPAREN] [expr] [RPAREN]
  AST factor() {
    var token = currentToken;

    if (token.type == PLUS) {
      eat(PLUS);
      return UnaryOp(token, factor());
    }

    if (token.type == MINUS) {
      eat(MINUS);
      return UnaryOp(token, factor());
    }

    if (token.type == NUMBER) {
      eat(NUMBER);
      return Num(token);
    }

    if (token.type == LPAREN) {
      eat(LPAREN);
      var node = expr();
      eat(RPAREN);
      return node;
    }
  }

  /// [term] : [factor] (([MUL] | [DIV]) [factor])*
  AST term() {
    var node = factor();

    while (currentToken.type == MUL || currentToken.type == DIV) {
      var token = currentToken;

      if (token.type == MUL) {
        eat(MUL);
      } else if (token.type == DIV) {
        eat(DIV);
      }

      node = BinOp(node, token, factor());
    }

    return node;
  }

  /// [expr] : [term] (([PLUS] | [MINUS]) [term])*
  AST expr() {
    var node = term();

    while (currentToken.type == PLUS || currentToken.type == MINUS) {
      var token = currentToken;

      if (token.type == PLUS) {
        eat(PLUS);
      } else if (token.type == MINUS) {
        eat(MINUS);
      }

      node = BinOp(node, token, term());
    }

    return node;
  }

  AST parse() => expr();
}
