import 'package:flutter/material.dart';
import 'package:path_finder/utilities/algorithms.dart';
import 'package:path_finder/utilities/node.dart';
import 'package:path_finder/utilities/offset.dart';

class ScreenMap extends StatefulWidget {
  ScreenMap({Key? key}) : super(key: key);

  late double mapSize;
  late bool isWorking, showText, firstTime, isOver;
  late double speedAnimation;
  late String text;
  List<List<Node>> maps = [];
  Node? start;
  Node? goal;

  @override
  ScreenMapState createState() => ScreenMapState();
}

class ScreenMapState extends State<ScreenMap> {
  @override
  void initState() {
    widget.isWorking = widget.isOver = false;
    widget.showText = widget.firstTime = true;
    widget.speedAnimation = 2;
    widget.mapSize = 10;
    widget.text =
        "To choose the starting point, click once on a rectangle, twice for the destination.";
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
          (i) => List.generate(widget.mapSize.toInt(), (j) => Node(i,j)));

      !widget.firstTime ? widget.showText = false : widget.firstTime = false;
    });
    getAllAdj();
    widget.isOver = false;
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

  Future<void> runAlgo(Function algo, [String type = "normal"]) async {
    if (widget.start != null &&
        widget.goal != null &&
        !widget.isWorking &&
        !widget.isOver) {
      setState(() {
        widget.isWorking = true;
      });

      switch(type){

        case "normal":{await algo(widget.start!, changeUI, widget.speedAnimation);break;}
        case "dijkstra":{await algo(widget.start!, changeUI, widget.speedAnimation, widget.maps);break;}
        case "aStar":{await algo(widget.start!,widget.goal!,changeUI,widget.speedAnimation,widget.maps);break;}
      }

      widget.start!.color = Colors.red;
      setState(() {
        widget.isWorking = false;
        widget.isOver = true;
      });
      Algo.isFound = false;
    }
  }

  Node setPoint(Node? point, Node node, Color color) {
    setState(() {
      if (point == null) {
        node.color = color;
        widget.showText = false;
        return;
      }

      if (point != node) {
        point!.color = Colors.white70;
      }
      node.color = color;
      widget.showText = false;
    });

    return node;
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
                                      if (!widget.isWorking && !widget.isOver) {
                                        setState(() {
                                          widget.goal = setPoint(widget.goal,
                                              widget.maps[i][j], Colors.blue);
                                        });
                                      }
                                    },
                                    onTap: () {
                                      if (!widget.isWorking && !widget.isOver) {
                                        setState(() {
                                          widget.start = setPoint(widget.start,
                                              widget.maps[i][j], Colors.red);
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
          widget.showText
              ? Flexible(
                  flex: 2,
                  child: Center(
                    child: Text(
                      widget.text,
                    ),
                  ))
              : Container(),
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
                GestureDetector(
                    onTap: () async {
                      await runAlgo(Algo.dijkstra, "dijkstra");
                      setState(() {
                        widget.text =
                            "The shortest path from source to object is ${widget.goal!.distanceFromSrc} rectangles long";
                        widget.showText = true;
                      });
                    },
                    child: const Text("Dijkstra")),
                GestureDetector(
                    onTap: () async {
                      await runAlgo(Algo.aStar, "aStar");
                    },
                    child: const Text("A*"))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
