import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: DraggableCard(
        child: AnimatedContainer(
          duration: Duration(microseconds: 300),
          curve: Curves.fastLinearToSlowEaseIn,
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color: Color(0xff8639FB),
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: Color(0xff8639FB).withOpacity(0.7),
                blurRadius: 30,
              )
            ]
          ),
          child: Center(
            child: Text(
              "Chair",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 25,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DraggableCard extends StatefulWidget {
  Widget? child;

  DraggableCard({this.child});

  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  var dragAlignment = Alignment.center;

  Animation<Alignment>? _animation;

  final _spring =
      const SpringDescription(mass: 10, stiffness: 1000, damping: 0.9);

  double _normalizeVelocity(Offset velocity, Size size) {
    final normalizeVelocity = Offset(
      velocity.dx / size.width,
      velocity.dy / size.height,
    );
    return -normalizeVelocity.distance;
  }

  void _runAnimation(Offset velocity, Size size) {
    _animation = _controller!
        .drive(AlignmentTween(begin: dragAlignment, end: Alignment.center));

    final simulation =
        SpringSimulation(_spring, 0, 0.0, _normalizeVelocity(velocity, size));
    _controller!.animateWith(simulation);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController.unbounded(vsync: this)
      ..addListener(() => setState(() => dragAlignment = _animation!.value));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onPanStart: (details) => _controller!.stop(canceled: true),
      onPanUpdate: (details) => setState(
        () => dragAlignment += Alignment(details.delta.dx / (size.width / 2),
            details.delta.dy / (size.height / 2)),
        /**/
      ),
      onPanEnd: (details) => _runAnimation(details.velocity.pixelsPerSecond, size),
      child: Align(
        alignment: dragAlignment,
        child: Card(
          child: widget.child,
        ),
      ),
    );
  }
}
