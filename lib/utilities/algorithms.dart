import 'package:flutter/material.dart';
import 'node.dart';

class Algo {
  static bool isFound = false;

  static Future<void> depthFirst(Node start, Function changeUI) async {
    if (start.color == Colors.black12 || isFound) {
      return;
    }

    if (start.color == Colors.blue) {
      isFound = true;
      start.color = Colors.yellow;
      print("SONO DENTRO!");
    } else {
      if (start.color != Colors.red) {
        await Future.delayed(const Duration(milliseconds: 300));

        changeUI(start);
      }

      for (Node node in start.adj) {
        if (node.color != Colors.black12) {
          depthFirst(node, changeUI);
        }
      }
    }
  }
}
