import 'package:flutter/material.dart';
import 'package:path_finder/utilities/node.dart';

class ScreenMap extends StatefulWidget {
  ScreenMap({Key? key}) : super(key: key);

  double mapSize = 10;
  List<List<Node>> maps = [];
  Node? start;
  Node? goal;
  bool isWorking = false;

  @override
  ScreenMapState createState() => ScreenMapState();
}

class ScreenMapState extends State<ScreenMap> {
  @override
  void initState() {
    createMaps();
    super.initState();
  }

  void createMaps() {
    setState(() {
      widget.maps = List.generate(widget.mapSize.toInt(),
          (index) => List.generate(widget.mapSize.toInt(), (index) => Node()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Path Finder"), actions: [
        Slider(
            value: widget.mapSize,
            max: 40,
            min: 10,
            activeColor: Colors.yellow,
            inactiveColor: Colors.brown,
            onChanged: (double value) {
              setState(() {
                widget.mapSize = value;
                createMaps();
              });
            })
      ]),
      body: Column(
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
                                            widget.maps[i][j].color =
                                                Colors.blue;
                                            return;
                                          }

                                          if (widget.goal !=
                                              widget.maps[i][j]) {
                                            widget.goal!.color = Colors.green;
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
                                            widget.maps[i][j].color =
                                                Colors.red;
                                            return;
                                          }

                                          if (widget.start !=
                                              widget.maps[i][j]) {
                                            widget.start!.color = Colors.green;
                                            widget.start = widget.maps[i][j];
                                          }
                                          widget.maps[i][j].color = Colors.red;
                                        });
                                      }
                                    },
                                    child: AnimatedContainer(
                                      decoration: BoxDecoration(
                                          color: widget.maps[i][j].color,
                                          border: Border.all(
                                              color: Colors.black12)),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  ))),
                        ))),
              )),
          Flexible(
            flex: 1,
            child: Row(
              children: const [
                Flexible(child: Text("Deep first")),
              ],
            ),
          )
        ],
      ),
    );
  }
}
