import 'dart:io';
import 'dart:math' as math;

import 'lexer.dart';

abstract class Node {
  const Node();

  final Node left = null;
  final Node right = null;

  final Token token = null;

  double visit(NodeVisitor visitor);
}

void printNode(Node root) {
  var maxLevel = _maxLevel(root);
  _printNodeInternal([root], 1, maxLevel);
}

void _printNodeInternal(List<Node> nodes, int level, int maxLevel) {
  if (nodes.isEmpty || _isAllElementsNull(nodes)) return;

  var floor = maxLevel - level;
  var endgeLines = math.pow(2, math.max(floor - 1, 0)).toInt();
  var firstSpaces = math.pow(2, floor).toInt() - 1;
  var betweenSpaces = math.pow(2, floor + 1).toInt() - 1;

  _printWhitespaces(firstSpaces);

  var newNodes = <Node>[];

  for (var node in nodes) {
    if (node != null) {
      stdout.write(node.token.value.toString());
      newNodes.add(node.left);
      newNodes.add(node.right);
    } else {
      newNodes.add(null);
      newNodes.add(null);
      stdout.write(' ');
    }
    _printWhitespaces(betweenSpaces);
  }

  stdout.writeln('');

  for (var i = 1; i <= endgeLines; i++) {
    for (var j = 0; j < nodes.length; j++) {
      _printWhitespaces(firstSpaces - i);

      if (nodes[j] == null) {
        _printWhitespaces(endgeLines + endgeLines + i + 1);
        continue;
      }

      if (nodes[j].left != null) {
        stdout.write('/');
      } else {
        _printWhitespaces(2);
      }

      _printWhitespaces(i + i - 1);

      if (nodes[j].right != null) {
        stdout.write('\\');
      } else {
        _printWhitespaces(2);
      }

      _printWhitespaces(endgeLines + endgeLines - i);
    }

    stdout.writeln('');
  }

  _printNodeInternal(newNodes, level + 1, maxLevel);
}

void _printWhitespaces(int count) {
  for (var i = 0; i < count; i++) {
    stdout.write(' ');
  }
}

int _maxLevel(Node node) {
  return node == null
      ? 0
      : math.max(_maxLevel(node.left), _maxLevel(node.right)) + 1;
}

bool _isAllElementsNull<T>(List<T> list) {
  for (Object object in list) {
    if (object != null) return false;
  }
  return true;
}

abstract class NodeVisitor {
  const NodeVisitor();

  double visitUnaryOp(UnaryOp node);
  double visitBinOp(BinOp node);
  double visitNum(Num node);
}

class UnaryOp extends Node {
  UnaryOp(this.op, this.expr);

  final Token op;
  final Node expr;

  @override
  double visit(NodeVisitor visitor) => visitor.visitUnaryOp(this);

  @override
  Token get token => op;
}

class BinOp<T> extends Node {
  const BinOp(this.left, this.op, this.right)
      : assert(left != null && op != null && right != null);

  @override
  final Node left, right;

  final Token op;

  @override
  Token get token => op;

  @override
  double visit(NodeVisitor visitor) => visitor.visitBinOp(this);
}

class Num extends Node {
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

  /// [factor] : ([PLUS] | [MINUS]) [factor] | [NUMBER] | [LPAREN] ([expr]) [RPAREN]
  Node factor() {
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

  /// [exponent] : [factor] ([EXPONENT] [term])*
  Node exponent() {
    var node = factor();

    while (currentToken.type == EXPONENT) {
      var token = currentToken;
      eat(EXPONENT);
      node = BinOp(node, token, expr());
    }

    return node;
  }

  /// [term] : [exponent] (([MUL] | [DIV]) [exponent])*
  Node term() {
    var node = exponent();

    while (currentToken.type == MUL || currentToken.type == DIV) {
      var token = currentToken;

      if (token.type == MUL) {
        eat(MUL);
      } else if (token.type == DIV) {
        eat(DIV);
      }

      node = BinOp(node, token, exponent());
    }

    return node;
  }

  /// [expr] : [term] (([PLUS] | [MINUS]) [term])*
  Node expr() {
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

  Node parse() => expr();
}
