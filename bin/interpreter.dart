import 'lexer.dart';
import 'parser.dart';

class Interpreter extends NodeVisitor {
  const Interpreter(this.parser);

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
      return node.esq.visit(this) + node.dir.visit(this);
    }

    if (node.op.type == MINUS) {
      return node.esq.visit(this) - node.dir.visit(this);
    }

    if (node.op.type == MUL) {
      return node.esq.visit(this) * node.dir.visit(this);
    }

    if (node.op.type == DIV) {
      return node.esq.visit(this) / node.dir.visit(this);
    }
  }

  @override
  double visitNum(Num node) => node.value;

  double interpret() => parser.parse().visit(this);
}
