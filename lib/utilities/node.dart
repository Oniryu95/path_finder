import 'dart:ui';
import 'package:flutter/material.dart';

class Node {
  late List<Node> adj;
  late Color color;
  int distance = 1;

  Node() {
    adj = [];
    color = Colors.white70;
  }
}
