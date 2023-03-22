import 'dart:ui';
import 'package:flutter/material.dart';

class Node {
  late List<Node> adj;
  late Color color;

  Node() {
    adj = [];
    color = Colors.green;
  }
}
