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
            onChanged: (double value) {
              setState(() {
                widget.mapSize = value;
                createMaps();
              });
            })
      ]),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
            widget.mapSize.toInt(),
            (i) => Row(
                  children: List.generate(
                      widget.mapSize.toInt(),
                      (j) => GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.maps[i][j].color = Colors.red;
                              });
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: widget.maps[i][j].color,
                                  border: Border.all(color: Colors.black12)),
                            ),
                          )),
                )),
      ),
    );
  }
}
