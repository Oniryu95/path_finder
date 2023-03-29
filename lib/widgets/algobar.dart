import 'package:flutter/material.dart';
import 'package:path_finder/utilities/algorithms.dart';
import 'package:path_finder/utilities/node.dart';

class Algobar extends StatefulWidget {
  Algobar(
      {Key? key,
      required this.isWorking,
      required this.start,
      required this.goal,
      required this.changeUI,
      required this.speedAnimation})
      : super(key: key);

  bool isWorking;
  Node? start;
  Node? goal;
  Function changeUI;
  double speedAnimation;

  @override
  AlgobarState createState() => AlgobarState();
}

class AlgobarState extends State<Algobar> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Row(
        children: [
          Flexible(
              child: GestureDetector(
                  onTap: () async {
                    if (widget.start != null &&
                        widget.goal != null &&
                        !widget.isWorking) {
                      widget.isWorking = true;
                      print(widget.isWorking);
                      await Algo.depthFirst(widget.start!, widget.changeUI,
                          widget.speedAnimation);
                      widget.start!.color = Colors.red;
                      widget.isWorking = false;
                      Algo.isFound = false;
                      print(widget.isWorking);
                    }
                  },
                  child: const Text("Deep first"))),
          GestureDetector(
              onTap: () async {
                if (widget.start != null &&
                    widget.goal != null &&
                    !widget.isWorking) {
                  print(widget.isWorking);
                  widget.isWorking = true;
                  await Algo.breathFirst(
                      widget.start!, widget.changeUI, widget.speedAnimation);
                  widget.start!.color = Colors.red;
                  widget.isWorking = false;
                  Algo.isFound = false;
                }
              },
              child: const Text("Breath first")),
        ],
      ),
    );
  }
}
