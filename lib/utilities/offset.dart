class Utilities {
  List<PairInteger> offsets = [];

  Utilities() {
    offsets.add(PairInteger(0, -1));
    offsets.add(PairInteger(0, 1));
    offsets.add(PairInteger(-1, 0));
    offsets.add(PairInteger(1, 0));
    offsets.add(PairInteger(1, 1));
    offsets.add(PairInteger(-1, -1));
    offsets.add(PairInteger(-1, 1));
    offsets.add(PairInteger(1, -1));
  }
}

class PairInteger {
  int i;
  int j;

  PairInteger(this.i, this.j);
}
