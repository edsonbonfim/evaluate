import 'lexer.dart';
import 'parser.dart';
import 'dart:math' as math;

class Evaluator extends NodeVisitor {
  const Evaluator(this.parser);

  final Parser parser;

  @override
  double visitUnaryOp(UnaryOp node) {
    if (node.op.type == PLUS) {
      return node.expr.visit(this);
    }

    if (node.op.type == MINUS) {
      return -node.expr.visit(this);
    }
  }

  @override
  double visitBinOp(BinOp node) {
    if (node.op.type == PLUS) {
      return node.left.visit(this) + node.right.visit(this);
    }

    if (node.op.type == MINUS) {
      return node.left.visit(this) - node.right.visit(this);
    }

    if (node.op.type == MUL) {
      return node.left.visit(this) * node.right.visit(this);
    }

    if (node.op.type == DIV) {
      return node.left.visit(this) / node.right.visit(this);
    }

    if (node.op.type == EXPONENT) {
      return math.pow(node.left.visit(this), node.right.visit(this));
    }
  }

  @override
  double visitNum(Num node) => node.value;

  double evaluate() {
    var tree = parser.parse();
    return tree.visit(this);
  }
}
