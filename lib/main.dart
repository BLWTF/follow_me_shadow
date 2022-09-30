import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Follow Me',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Follow Me'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});
  final String title;
  final GlobalKey buttonKey = GlobalKey();
  final GlobalKey containerKey = GlobalKey();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Offset mousePosition = const Offset(0, 0);
  bool showShadow = false;
  Size shadowSize = const Size(10, 10);
  String? selected;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          showShadow = true;
        });
      },
      onHover: (event) {
        setState(() {
          if (selected == 'button1') {
            RenderBox box = widget.buttonKey.currentContext!.findRenderObject()
                as RenderBox;
            Offset buttonOffset = box.localToGlobal(Offset.zero);
            shadowSize = box.size;
            mousePosition = Offset(
              buttonOffset.dx + (shadowSize.width / 2),
              buttonOffset.dy + (shadowSize.height / 2),
            );
          } else if (selected == 'container1') {
            RenderBox box = widget.containerKey.currentContext!
                .findRenderObject() as RenderBox;
            Offset containerOffset = box.localToGlobal(Offset.zero);
            shadowSize = box.size;
            mousePosition = Offset(
              containerOffset.dx + (shadowSize.width / 2),
              containerOffset.dy + (shadowSize.height / 2),
            );
          } else {
            mousePosition = event.position;
            shadowSize = const Size(10, 10);
          }
        });
      },
      child: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Move the mouse!',
                    ),
                    MouseRegion(
                      onHover: (event) {
                        setState(() {
                          selected = 'container1';
                        });
                      },
                      onExit: (event) {
                        setState(() {
                          selected = null;
                        });
                      },
                      child: Container(
                        key: widget.containerKey,
                        width: 100,
                        height: 100,
                        color: Colors.blue,
                      ),
                    )
                  ],
                ),
              ),
              floatingActionButton: MouseRegion(
                onHover: (event) {
                  setState(() {
                    selected = 'button1';
                  });
                },
                onExit: (event) {
                  setState(() {
                    selected = null;
                  });
                },
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: FloatingActionButton(
                    key: widget.buttonKey,
                    onPressed: null,
                    child: const Icon(Icons.push_pin),
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            top: mousePosition.dy - (shadowSize.height / 2),
            left: mousePosition.dx - (shadowSize.width / 2),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: Opacity(
              opacity: showShadow == true ? 1 : 0,
              child: IgnorePointer(
                ignoring: true,
                child: AnimatedContainer(
                  height: shadowSize.height,
                  width: shadowSize.width,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
