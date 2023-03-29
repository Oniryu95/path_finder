import 'package:flutter/material.dart';
import 'package:path_finder/utilities/node.dart';

import 'algobar.dart';

class MatrixMap extends StatefulWidget {
  MatrixMap(
      {Key? key,
      required this.isWorking,
      required this.maps,
      required this.goal,
      required this.mapSize,
      required this.start,
      required this.speedAnimation})
      : super(key: key);

  bool isWorking;
  List<List<Node>> maps;
  Node? goal;
  Node? start;
  double mapSize;
  double speedAnimation;
  @override
  MatrixMapState createState() => MatrixMapState();
}

class MatrixMapState extends State<MatrixMap> {
  void changeUI(Node node, Color color) {
    setState(() {
      node.color = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
            flex: 15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  widget.mapSize.toInt(),
                  (i) => Flexible(
                          child: Row(
                        children: List.generate(
                            widget.mapSize.toInt(),
                            (j) => Flexible(
                                    child: GestureDetector(
                                  onDoubleTap: () {
                                    if (!widget.isWorking) {
                                      setState(() {
                                        if (widget.goal == null) {
                                          widget.goal = widget.maps[i][j];
                                          widget.maps[i][j].color = Colors.blue;
                                          return;
                                        }

                                        if (widget.goal != widget.maps[i][j]) {
                                          widget.goal!.color = Colors.white70;
                                          widget.goal = widget.maps[i][j];
                                        }
                                        widget.maps[i][j].color = Colors.blue;
                                      });
                                    }
                                  },
                                  onTap: () {
                                    if (!widget.isWorking) {
                                      setState(() {
                                        if (widget.start == null) {
                                          widget.start = widget.maps[i][j];
                                          widget.maps[i][j].color = Colors.red;
                                          return;
                                        }

                                        if (widget.start != widget.maps[i][j]) {
                                          widget.start!.color = Colors.white70;
                                          widget.start = widget.maps[i][j];
                                        }
                                        widget.maps[i][j].color = Colors.red;
                                      });
                                    }
                                  },
                                  child: AnimatedContainer(
                                    decoration: BoxDecoration(
                                        color: widget.maps[i][j].color,
                                        border:
                                            Border.all(color: Colors.black12)),
                                    duration: const Duration(milliseconds: 750),
                                    curve: Curves.bounceOut,
                                  ),
                                ))),
                      ))),
            )),
        Algobar(
            isWorking: widget.isWorking,
            start: widget.start,
            goal: widget.goal,
            changeUI: changeUI,
            speedAnimation: widget.speedAnimation)
      ],
    );
  }
}
