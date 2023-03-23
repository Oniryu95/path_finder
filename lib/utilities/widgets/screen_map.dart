import 'package:flutter/material.dart';
import 'package:path_finder/utilities/node.dart';

class ScreenMap extends StatefulWidget {
  ScreenMap({Key? key}) : super(key: key);

  double mapSize = 10;
  List<List<Node>> maps = [];

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
              max: 50,
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
        body: Center(
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
                                  setState(() {
                                    widget.maps[i][j].color = Colors.blue;
                                  });
                                },
                                onTap: () {
                                  setState(() {
                                    widget.maps[i][j].color = Colors.red;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: widget.maps[i][j].color,
                                      border:
                                          Border.all(color: Colors.black12)),
                                ),
                              ))),
                    ))),
          ),
        ));
  }
}
