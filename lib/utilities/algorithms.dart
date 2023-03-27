import 'dart:collection';

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

  static Future<void> breathFirst(
      Node start, Function changeUI, double speedAnimation) async {
    Queue<Node> border = Queue<Node>();

    border.add(start);

    while (border.isNotEmpty && !isFound) {
      Node first = border.removeFirst();

      if (first.color == Colors.blue) {
        isFound = true;
        changeUI(first, Colors.yellow);
        //non capisco perché io debba inserire questo, è implicito.
      } else if (first.color != Colors.black12) {
        changeUI(first, Colors.black12);
        await Future.delayed(Duration(milliseconds: (100 ~/ speedAnimation)));
      }

      for (Node node in first.adj) {
        if (node.color != Colors.black12) {
          border.add(node);
        }
      }
    }
  }
}
