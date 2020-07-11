import 'lexer.dart';
import 'parser.dart';

class Interpreter extends NodeVisitor {
  const Interpreter(this.parser);

  final Parser parser;

  int interpret() {
    var tree = parser.parse();
    return tree.accept(this);
  }

  @override
  int visitUnaryOp(UnaryOp node) {
    if (node.op.type == PLUS) {
      return node.expr.accept(this);
    }

    if (node.op.type == MINUS) {
      return -node.expr.accept(this);
    }
  }

  @override
  int visitBinOp(BinOp node) {
    if (node.op.type == PLUS) {
      return node.esq.accept(this) + node.dir.accept(this);
    }

    if (node.op.type == MINUS) {
      return node.esq.accept(this) - node.dir.accept(this);
    }

    if (node.op.type == MUL) {
      return node.esq.accept(this) * node.dir.accept(this);
    }

    if (node.op.type == DIV) {
      return node.esq.accept(this) ~/ node.dir.accept(this);
    }
  }

  @override
  int visitNum(Num node) => node.value;
}
