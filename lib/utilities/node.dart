import 'dart:ui';
import 'package:flutter/material.dart';

class Node {
  late List<Node> adj;
  late Color color;
  List index = [];
  double distance = 1;
  double distanceFromSrc = 999;

  Node(int i, int j) {
    index.add(i);
    index.add(j);
    adj = [];
    color = Colors.white70;
  }
}
