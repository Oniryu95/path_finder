import 'package:flutter/material.dart';
import 'package:path_finder/utilities/algorithms.dart';
import 'package:path_finder/utilities/node.dart';

class ScreenMap extends StatefulWidget {
  ScreenMap({Key? key}) : super(key: key);

  double mapSize = 10;
  List<List<Node>> maps = [];
  Node? start;
  Node? goal;
  bool isWorking = false;
  double speedAnimation = 2;

  @override
  ScreenMapState createState() => ScreenMapState();
}

class ScreenMapState extends State<ScreenMap> {
  @override
  void initState() {
    createMaps();
    super.initState();
  }

  void changeUI(Node node, Color color) {
    setState(() {
      node.color = color;
    });
  }

  void createMaps() {
    setState(() {
      widget.maps = List.generate(widget.mapSize.toInt(),
          (index) => List.generate(widget.mapSize.toInt(), (index) => Node()));
    });
    getAllAdj();
    widget.start = widget.goal = null;
  }

  void getAllAdj() {
    for (int i = 0; i < widget.mapSize; i++) {
      for (int j = 0; j < widget.mapSize; j++) {
        getSingleAdj(i, j);
      }
    }
  }

  void getSingleAdj(int i, int j) {
    if (j - 1 >= 0) {
      widget.maps[i][j].adj.add(widget.maps[i][j - 1]);
    }

    if (j + 1 < widget.mapSize) {
      widget.maps[i][j].adj.add(widget.maps[i][j + 1]);
    }

    if (i - 1 >= 0) {
      widget.maps[i][j].adj.add(widget.maps[i - 1][j]);
    }

    if (i + 1 < widget.mapSize) {
      widget.maps[i][j].adj.add(widget.maps[i + 1][j]);
    }

    if (i + 1 < widget.mapSize && j + 1 < widget.mapSize) {
      widget.maps[i][j].adj.add(widget.maps[i + 1][j + 1]);
    }

    if (i - 1 >= 0 && j - 1 >= 0) {
      widget.maps[i][j].adj.add(widget.maps[i - 1][j - 1]);
    }

    if (i - 1 >= 0 && j + 1 < widget.mapSize) {
      widget.maps[i][j].adj.add(widget.maps[i - 1][j + 1]);
    }

    if (i + 1 < widget.mapSize && j - 1 >= 0) {
      widget.maps[i][j].adj.add(widget.maps[i + 1][j - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Path Finder"), actions: [
        Row(
          children: [
            const Text("Map size:"),
            Slider(
                value: widget.mapSize,
                max: 40,
                min: 10,
                activeColor: Colors.yellow,
                inactiveColor: Colors.brown,
                onChanged: (double value) {
                  setState(() {
                    if (!widget.isWorking) {
                      widget.mapSize = value.round() as double;
                      createMaps();
                    }
                  });
                }),
          ],
        ),
        Row(
          children: [
            const Text("Animation speed:"),
            Slider(
                value: widget.speedAnimation,
                max: 10,
                min: 2,
                activeColor: Colors.yellow,
                inactiveColor: Colors.brown,
                onChanged: (double value) {
                  setState(() {
                    widget.speedAnimation = value.round() as double;
                  });
                }),
          ],
        ),
        IconButton(
            onPressed: () {
              if (!widget.isWorking) {
                createMaps();
              }
            },
            icon: const Icon(Icons.clear))
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
                                            widget.maps[i][j].color =
                                                Colors.red;
                                            return;
                                          }

                                          if (widget.start !=
                                              widget.maps[i][j]) {
                                            widget.start!.color =
                                                Colors.white70;
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
                                      duration:
                                          const Duration(milliseconds: 750),
                                      curve: Curves.bounceOut,
                                    ),
                                  ))),
                        ))),
              )),
          Flexible(
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
                            await Algo.depthFirst(
                                widget.start!, changeUI, widget.speedAnimation);
                            widget.start!.color = Colors.red;
                            widget.isWorking = false;
                            Algo.isFound = false;
                          }
                        },
                        child: const Text("Deep first"))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
