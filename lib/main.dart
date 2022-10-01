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
  final Map<String, GlobalKey> selectables = {
    'button1': GlobalKey(),
    'container1': GlobalKey(),
  };

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Offset mousePosition = const Offset(0, 0);
  bool showShadow = false;
  Size shadowSize = const Size(15, 15);
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
          if (selected != null) {
            RenderBox box = widget.selectables[selected]!.currentContext!
                .findRenderObject() as RenderBox;
            Offset offset = box.localToGlobal(Offset.zero);
            shadowSize = box.size;
            // mousePosition = Offset(
            //   offset.dx + (shadowSize.width / 2),
            //   offset.dy + (shadowSize.height / 2),
            // );
            mousePosition = event.position;
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
                    _Selectable(
                        key: widget.selectables['container1'],
                        tag: 'container1',
                        child: Container(
                          width: 150,
                          height: 100,
                          color: Colors.blue,
                        ),
                        onHover: () {
                          setState(() {
                            selected = 'container1';
                          });
                        },
                        onExit: () {
                          setState(() {
                            selected = null;
                          });
                        }),
                  ],
                ),
              ),
              floatingActionButton: _Selectable(
                key: widget.selectables['button1'],
                tag: 'button1',
                onHover: () {
                  setState(() {
                    selected = 'button1';
                  });
                },
                onExit: () {
                  setState(() {
                    selected = null;
                  });
                },
                child: const SizedBox(
                  width: 60,
                  height: 60,
                  child: FloatingActionButton(
                    onPressed: null,
                    child: Icon(Icons.push_pin),
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            top: mousePosition.dy - (shadowSize.height / 2),
            left: mousePosition.dx - (shadowSize.width / 2),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: Opacity(
              opacity: showShadow == true ? 1 : 0,
              child: IgnorePointer(
                ignoring: true,
                child: AnimatedContainer(
                  height: shadowSize.height,
                  width: shadowSize.width,
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.fastLinearToSlowEaseIn,
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

class _Selectable extends StatelessWidget {
  final String tag;
  final Widget child;
  final Function() onHover;
  final Function() onExit;

  const _Selectable({
    super.key,
    required this.tag,
    required this.child,
    required this.onHover,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) => onHover(),
      onExit: (event) => onExit(),
      child: child,
    );
  }
}
