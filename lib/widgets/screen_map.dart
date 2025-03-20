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
        "With one click on a rectangle you decide the start, with a double the destination and with a prolonged one you position a wall.";
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
          (i) => List.generate(widget.mapSize.toInt(), (j) => Node(i, j)));

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
      int newI = i + offset.i;
      int newJ = j + offset.j;

      if (newJ >= 0 &&
          newJ < widget.mapSize &&
          newI < widget.mapSize &&
          newI >= 0 &&
          widget.maps[i][j].color != Colors.black &&
          widget.maps[newI][newJ].color != Colors.black) {
        widget.maps[i][j].adj.add(widget.maps[newI][newJ]);
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

      switch (type) {
        case "normal":
          {
            await algo(widget.start!, changeUI, widget.speedAnimation);
            break;
          }
        case "dijkstra":
          {
            await algo(
                widget.start!, changeUI, widget.speedAnimation, widget.maps);
            setState(() {
              widget.text =
                  "The shortest path from source to object is ${widget.goal!.distanceFromSrc == 999 ? "infinite" : widget.goal!.distanceFromSrc} rectangles long";
              widget.showText = true;
            });
            break;
          }
        case "aStar":
          {
            await algo(widget.start!, widget.goal!, changeUI,
                widget.speedAnimation, widget.maps);
            break;
          }
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
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Colors.indigo,
        title: const Text(
          "Path Finder",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (!widget.isWorking) {
                createMaps();
              }
            },
            icon: const Icon(Icons.refresh),
            tooltip: "Reset Map",
          )
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.grid_4x4, color: Colors.indigo),
                      const SizedBox(width: 8),
                      const Text(
                        "Map size:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Slider(
                          value: widget.mapSize,
                          max: 30,
                          min: 10,
                          activeColor: Colors.indigo,
                          inactiveColor: Colors.indigo.withValues(alpha: 0.3),
                          label: widget.mapSize.round().toString(),
                          divisions: 20,
                          onChanged: (double value) {
                            setState(() {
                              if (!widget.isWorking) {
                                widget.mapSize = value.round() as double;
                                createMaps();
                              }
                            });
                          },
                        ),
                      ),
                      Text(
                        "${widget.mapSize.round()}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.speed, color: Colors.indigo),
                      const SizedBox(width: 8),
                      const Text(
                        "Animation speed:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Slider(
                          value: widget.speedAnimation,
                          max: 15,
                          min: 2,
                          activeColor: Colors.indigo,
                          inactiveColor: Colors.indigo.withValues(alpha: 0.3),
                          label: widget.speedAnimation.round().toString(),
                          divisions: 13,
                          onChanged: (double value) {
                            setState(() {
                              widget.speedAnimation = value.round() as double;
                            });
                          },
                        ),
                      ),
                      Text(
                        "${widget.speedAnimation.round()}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.indigo.withValues(alpha: 0.3), width: 2),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.mapSize.toInt(),
                    (i) => Expanded(
                      child: Row(
                        children: List.generate(
                          widget.mapSize.toInt(),
                          (j) => Expanded(
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
                              onLongPress: () {
                                if (!widget.isWorking && !widget.isOver) {
                                  setState(() {
                                    if (widget.maps[i][j].color != Colors.red &&
                                        widget.maps[i][j].color !=
                                            Colors.blue) {
                                      if (widget.maps[i][j].color ==
                                          Colors.black) {
                                        widget.maps[i][j].color =
                                            Colors.white70;
                                      } else {
                                        widget.maps[i][j].color = Colors.black;
                                      }

                                      for (int x = 0; x < widget.mapSize; x++) {
                                        for (int y = 0;
                                            y < widget.mapSize;
                                            y++) {
                                          widget.maps[x][y].adj.clear();
                                        }
                                      }
                                      getAllAdj();
                                    }
                                  });
                                }
                              },
                              child: AnimatedContainer(
                                margin: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: widget.maps[i][j].color,
                                  border: Border.all(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                duration: const Duration(milliseconds: 750),
                                curve: Curves.bounceOut,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          widget.showText
              ? Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: Colors.indigo.withValues(alpha: 0.3)),
                  ),
                  child: Center(
                    child: Text(
                      widget.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              : const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAlgorithmButton(
                  "Deep First",
                  Icons.line_style,
                  Colors.deepPurple,
                  () => runAlgo(Algo.depthFirst),
                ),
                _buildAlgorithmButton(
                  "Breath First",
                  Icons.grid_3x3,
                  Colors.blue,
                  () => runAlgo(Algo.breathFirst),
                ),
                _buildAlgorithmButton(
                  "Dijkstra",
                  Icons.directions,
                  Colors.teal,
                  () async => await runAlgo(Algo.dijkstra, "dijkstra"),
                ),
                _buildAlgorithmButton(
                  "A*",
                  Icons.star_outline,
                  Colors.amber.shade800,
                  () async => await runAlgo(Algo.aStar, "aStar"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlgorithmButton(
      String text, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          elevation: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: color.withValues(alpha: 0.5)),
            ),
            child: Column(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(height: 4),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
