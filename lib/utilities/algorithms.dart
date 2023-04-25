import 'dart:collection';
import 'dart:core';
import 'package:flutter/material.dart';
import 'node.dart';

enum Case { minMin, greGre, minGre, greMin }

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

  static Future<void> dijkstra(
      Node start, Function changeUI, double speedAnimation) async {
    late Node minNode;
    late double newDistance;
    List<Node> exploredNodes = [];
    start.distanceFromSrc = 0;

    for (Node node in start.adj) {
      node.distanceFromSrc = node.distance;
      exploredNodes.add(node);
    }

    while (exploredNodes.isNotEmpty) {
      minNode = findMinNode(exploredNodes);

      if (minNode.color == Colors.blue) {
        changeUI(minNode, Colors.yellow);

        break;
      } else {
        changeUI(minNode, Colors.black12);

        for (Node node in minNode.adj) {
          newDistance = minNode.distanceFromSrc + node.distance;

          if (newDistance < node.distanceFromSrc) {
            node.distanceFromSrc = newDistance;
            if (!exploredNodes.contains(node)) {
              exploredNodes.add(node);
            }
          }
        }

        await Future.delayed(Duration(milliseconds: (100 ~/ speedAnimation)));
      }
    }
  }

  static Future<void> aStar(
      Node start, Node goal, Function changeUI, double speedAnimation) async {
    late Node minNode;
    late double newDistance;
    List<Node> exploredNodes = [];
    start.distanceFromSrc = 0;

    for (Node node in start.adj) {
      node.distanceFromSrc = node.distance + heuristic(node, goal);
      exploredNodes.add(node);
    }

    while (exploredNodes.isNotEmpty) {
      minNode = findMinNode(exploredNodes);

      if (minNode.color == Colors.blue) {
        changeUI(minNode, Colors.yellow);

        break;
      } else {
        changeUI(minNode, Colors.black12);

        for (Node node in minNode.adj) {
          newDistance = node.distance + heuristic(node, goal);

          if (newDistance < node.distanceFromSrc) {
            node.distanceFromSrc = newDistance;
            if (!exploredNodes.contains(node)) {
              exploredNodes.add(node);
            }
          }
        }

        await Future.delayed(
            Duration(milliseconds: (100 ~/ speedAnimation * 10)));
      }
    }
  }

  static Node findMinNode(List<Node> exploredNodes) {
    int index = 0;
    Node minNode = Node(0, 0);

    for (int i = 0; i < exploredNodes.length; i++) {
      if (exploredNodes[i].distanceFromSrc != double.maxFinite &&
          minNode.distanceFromSrc > exploredNodes[i].distanceFromSrc &&
          (exploredNodes[i].color == Colors.white70 ||
              exploredNodes[i].color == Colors.blue)) {
        minNode = exploredNodes[i];
        index = i;
      }
    }
    exploredNodes.removeAt(index);
    return minNode;
  }

  static int heuristic(Node node, Node goal) {
    int distance = 0;
    List nIndex = [node.index[0], node.index[1]];
    List gIndex = [goal.index[0], goal.index[1]];

    while (!(nIndex[0] == gIndex[0]) || !(nIndex[1] == gIndex[1])) {
      if (nIndex[0] == gIndex[0]) {
        while (nIndex[1] != gIndex[1]) {
          nIndex[1] < gIndex[1] ? nIndex[1]++ : nIndex[1]--;
          distance++;
        }
        break;
      } else if (nIndex[1] == gIndex[1]) {
        while (nIndex[0] != gIndex[0]) {
          nIndex[0] < gIndex[0] ? nIndex[0]++ : nIndex[0]--;
          distance++;
        }
        break;
      } else {
        Case currentCase = Algo.identifyCase(nIndex, gIndex);

        switch (currentCase) {
          case Case.greGre:
            {
              nIndex[0]--;
              nIndex[1]--;
              distance++;
              break;
            }
          case Case.minMin:
            {
              nIndex[0]++;
              nIndex[1]++;
              distance++;
              break;
            }
          case Case.greMin:
            {
              nIndex[0]--;
              nIndex[1]++;
              distance++;
              break;
            }
          case Case.minGre:
            {
              nIndex[0]++;
              nIndex[1]--;
              distance++;
              break;
            }
        }
      }
    }

    return distance;
  }

  static Case identifyCase(List nIndex, List gIndex) {
    if (nIndex[0] < gIndex[0] && nIndex[1] < gIndex[1]) {
      return Case.minMin;
    } else if (nIndex[0] > gIndex[0] && nIndex[1] > gIndex[1]) {
      return Case.greGre;
    } else if (nIndex[0] < gIndex[0] && nIndex[1] > gIndex[1]) {
      return Case.minGre;
    } else {
      return Case.greMin;
    }
  }
}
