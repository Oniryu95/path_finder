import 'dart:ui';
import 'package:flutter/material.dart';

class Node {
  late List<Node> adj;
  late Color color;
  double distance = 1;
  double distanceFromSrc = double.maxFinite;

  Node() {
    adj = [];
    color = Colors.white70;
  }
}
