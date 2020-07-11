import 'lexer.dart';
import 'parser.dart';

class Interpreter extends NodeVisitor {
  const Interpreter(this.parser);

  final Parser parser;

  @override
  int visitBinOp(BinOp node) {
    if (node.op.type == PLUS) {
      return node.esq.accept(this) + node.dir.accept(this);
    } else if (node.op.type == MINUS) {
      return node.esq.accept(this) - node.dir.accept(this);
    } else if (node.op.type == MUL) {
      return node.esq.accept(this) * node.dir.accept(this);
    } else if (node.op.type == DIV) {
      return node.esq.accept(this) ~/ node.dir.accept(this);
    }
    return 0;
  }

  @override
  int visitNum(Num node) => node.value;

  int interpret() {
    var tree = parser.parse();
    return tree.accept(this);
  }
}
