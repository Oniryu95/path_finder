import 'package:flutter/material.dart';
import 'node.dart';

class Algo {
  static bool isFound = false;

  static Future<void> depthFirst(
      Node start, Function changeUI, double speedAnimation) async {
    if (start.color == Colors.blue) {
      isFound = true;
      start.color = Colors.yellow;
    } else {
      if (!isFound) {
        await Future.delayed(Duration(milliseconds: (100 ~/ speedAnimation)));
        changeUI(start, Colors.black12);

        for (Node node in start.adj) {
          if (node.color != Colors.black12) {
            await depthFirst(node, changeUI, speedAnimation);
          }
        }
      }
    }
  }
}
