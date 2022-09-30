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
  Offset mousePosition = const Offset(0, 0);
  bool showShadow = false;

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
          mousePosition = event.position;
        });
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
          AnimatedPositioned(
            top: mousePosition.dy - 5,
            left: mousePosition.dx - 5,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: Opacity(
              opacity: showShadow == true ? 1 : 0,
              child: widget.mouseShadow,
            ),
          ),
        ],
      ),
    );
  }
}
