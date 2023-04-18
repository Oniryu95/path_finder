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

  static Future<void> dijkstra(Node start, Function changeUI,
      double speedAnimation, List<List<Node>> map) async {
    late Node minNode;
    late double newDistance;
    start.distanceFromSrc = 0;

    for (Node node in start.adj) {
      node.distanceFromSrc = node.distance;
    }

    for (int i = 0; i < map.length * map.length; i++) {
      minNode = findMinNode(map);

      if (minNode.color == Colors.blue) {
        changeUI(minNode, Colors.yellow);

        break;
      } else {
        changeUI(minNode, Colors.black12);

        for (Node node in minNode.adj) {
          newDistance = minNode.distanceFromSrc + node.distance;

          if (newDistance < node.distanceFromSrc) {
            node.distanceFromSrc = newDistance;
          }
        }

        await Future.delayed(Duration(milliseconds: (100 ~/ speedAnimation)));
      }
    }
  }

  static Future<void> aStar(Node start, Node goal, Function changeUI,
      double speedAnimation, List<List<Node>> map) async {
    late Node minNode;
    late double newDistance;
    start.distanceFromSrc = 0;

    for (Node node in start.adj) {
      node.distanceFromSrc = node.distance + heuristic(node, goal);
    }

    for (int i = 0; i < map.length * map.length; i++) {
      minNode = findMinNode(map);

      if (minNode.color == Colors.blue) {
        changeUI(minNode, Colors.yellow);

        break;
      } else {
        changeUI(minNode, Colors.black12);

        for (Node node in minNode.adj) {
          newDistance = minNode.distanceFromSrc + node.distance;

          if (newDistance < node.distanceFromSrc) {
            node.distanceFromSrc = newDistance;
          }
        }

        await Future.delayed(Duration(milliseconds: (100 ~/ speedAnimation)));
      }
    }
  }

  static Node findMinNode(List<List<Node>> map) {
    Node minNode = Node(0, 0);

    for (List<Node> nodeList in map) {
      for (Node node in nodeList) {
        if (node.distanceFromSrc != double.maxFinite &&
            minNode.distanceFromSrc > node.distanceFromSrc &&
            (node.color == Colors.white70 || node.color == Colors.blue)) {
          minNode = node;
        }
      }
    }

    return minNode;
  }

  static int heuristic(Node node, Node goal) {

    int distance = 0;
    List nIndex = [node.index[0],node.index[1]];
    List gIndex = [goal.index[0],goal.index[1]];

    if (nIndex[0] == gIndex[0] && nIndex[1] == gIndex[0]) {
      return distance;
    }
    else{

      if(nIndex[0] == gIndex[0]){

        while(nIndex[1] != gIndex[1]){

          nIndex[1] < gIndex[1] ? nIndex = nIndex[1]++ : nIndex[1]--;
          distance++;
        }
      }
      return distance;
    }
  }
}
