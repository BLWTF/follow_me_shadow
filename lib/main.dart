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
  final Widget mouseShadow = Container(
    height: 10,
    width: 10,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.black,
    ),
  );

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Offset? mousePosition;
  bool showShadow = false;
  // late OverlayEntry entry;
  // late AnimationController controller;

  @override
  void initState() {
    super.initState();
    // controller = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 1000),
    // );
  }

  Future<void> followMouse(Offset newMousePosition) async {
    // final animation = controller.drive(
    //   Tween<Offset>(
    //     begin: mousePosition ?? const Offset(0, 0),
    //     end: newMousePosition,
    //   ),
    // );
    setState(() {
      showShadow = false;
      // entry = OverlayEntry(
      //   builder: (context) {
      //     return AnimatedBuilder(
      //       animation: animation,
      //       builder: (context, child) => Positioned(
      //         top: animation.value.dy,
      //         left: animation.value.dx,
      //         child: widget.mouseShadow,
      //       ),
      //     );
      //   },
      // );
    });
    // controller.forward(from: 0);
    setState(() {
      // showShadow = true;
      mousePosition = newMousePosition;
    });
    setState(() {
      showShadow = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {},
      onHover: (event) async {
        await Future.delayed(const Duration(milliseconds: 150));
        await followMouse(event.localPosition);
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    'Move the mouse!',
                  ),
                ],
              ),
            ),
          ),
          if (showShadow)
            Positioned(
              top: mousePosition?.dy,
              left: mousePosition?.dx,
              child: widget.mouseShadow,
            ),
        ],
      ),
    );
  }
}
