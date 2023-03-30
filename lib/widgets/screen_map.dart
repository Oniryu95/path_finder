import 'package:flutter/material.dart';
import 'package:path_finder/utilities/algorithms.dart';
import 'package:path_finder/utilities/node.dart';
import 'package:path_finder/utilities/offset.dart';

class ScreenMap extends StatefulWidget {
  ScreenMap({Key? key}) : super(key: key);

  late double mapSize;
  late bool isWorking;
  late double speedAnimation;
  List<List<Node>> maps = [];
  Node? start;
  Node? goal;

  @override
  ScreenMapState createState() => ScreenMapState();
}

class ScreenMapState extends State<ScreenMap> {
  @override
  void initState() {
    widget.isWorking = false;
    widget.speedAnimation = 2;
    widget.mapSize = 10;
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
    Utilities utilities = Utilities();

    for (int i = 0; i < widget.mapSize; i++) {
      for (int j = 0; j < widget.mapSize; j++) {
        getSingleAdj(i, j, utilities);
      }
    }
  }

  void getSingleAdj(int i, int j, Utilities utilities) {
    for (PairInteger offset in utilities.offsets) {
      if (j + offset.j >= 0 &&
          j + offset.j < widget.mapSize &&
          i + offset.i < widget.mapSize &&
          i + offset.i >= 0) {
        widget.maps[i][j].adj.add(widget.maps[i + offset.i][j + offset.j]);
      }
    }
  }

  Future<void> runAlgo(Function algo) async {
    if (widget.start != null && widget.goal != null && !widget.isWorking) {
      setState(() {
        widget.isWorking = true;
      });

      await algo(widget.start!, changeUI, widget.speedAnimation);
      widget.start!.color = Colors.red;
      setState(() {
        widget.isWorking = false;
      });
      Algo.isFound = false;
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
                max: 30,
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
                max: 15,
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
            icon: const Icon(Icons.refresh))
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () {
                      runAlgo(Algo.depthFirst);
                    },
                    child: const Text("Deep first")),
                GestureDetector(
                    onTap: () {
                      runAlgo(Algo.breathFirst);
                    },
                    child: const Text("Breath first")),
              ],
            ),
          )
        ],
      ),
    );
  }
}
