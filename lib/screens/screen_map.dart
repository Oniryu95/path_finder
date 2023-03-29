import 'package:flutter/material.dart';
import 'package:path_finder/utilities/node.dart';
import 'package:path_finder/widgets//map.dart';

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
      body: MatrixMap(
        isWorking: widget.isWorking,
        maps: widget.maps,
        goal: widget.goal,
        mapSize: widget.mapSize,
        start: widget.start,
        speedAnimation: widget.speedAnimation,
      ),
    );
  }
}
