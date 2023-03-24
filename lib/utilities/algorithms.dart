import 'dart:io';

import 'package:flutter/material.dart';
import 'node.dart';

class Algo {
  static bool isFound = false;

  static void depthFirst(Node start, Node object) async {
    if (start.color == Colors.black12 || isFound) {
      return;
    }
    if (identical(start, object)) {
      isFound = true;
      start.color = Colors.yellow;
    } else {
      start.color = Colors.black12;
      Future.delayed(const Duration(milliseconds: 200));
      for (Node node in start.adj) {
        if (node.color == Colors.white70 || node.color == Colors.red) {
          depthFirst(node, object);
        }
      }
    }
  }
}
