import 'package:flutter/material.dart';
import '../widgets/cat.dart';
import 'dart:math';

class Home extends StatefulWidget {
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  // TickerProviderStateMixin is required for vsync
  late Animation<double> catAnimation;
  late AnimationController catController;
  late Animation<double> boxAnimation;
  late AnimationController boxController;

  initState() {
    super.initState();
    catController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    catAnimation = Tween(
      begin: -20.0,
      end: -80.0,
    ).animate(CurvedAnimation(
      parent: catController,
      curve: Curves.easeIn,
    ));

    boxController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    boxAnimation = Tween(
      begin: 0.6 * pi,
      end: 0.65 * pi,
    ).animate(CurvedAnimation(
      parent: boxController,
      curve: Curves.easeInOut,
    ));

    boxAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        boxController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        boxController.forward();
      }
    });
    boxController.forward();
  }

  onTap() {
    if (catAnimation.status == AnimationStatus.completed ||
        catAnimation.status == AnimationStatus.forward) {
      catController.reverse();
      boxController.forward();
    } else if (catAnimation.status == AnimationStatus.dismissed ||
        catAnimation.status == AnimationStatus.reverse) {
      catController.forward();
      boxController.stop();
    }
  }

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation'),
      ),
      body: GestureDetector(
        child: Center(
          child: Stack(
            children: [
              buildCatAnimation(),
              buildBox(),
              buildLeftFlap(),
              buildRightFlap(),
            ],
            clipBehavior: Clip.none, // overflow: visible
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned(
          child:
              child!, // exclamation mark is used to make sure the child is not optional
          top: catAnimation.value,
          right: 0.0,
          left: 0.0,
        );
      },
      child: Cat(),
    );
  }

  Widget buildBox() {
    return Container(
      height: 200.0,
      width: 200.0,
      color: Colors.brown,
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
      left: 3.0,
      child: AnimatedBuilder(
          animation: boxAnimation,
          child: Container(
            height: 10.0,
            width: 125.0,
            color: Colors.brown,
          ),
          builder: (context, child) {
            return Transform.rotate(
              child: child,
              alignment: Alignment.topLeft,
              angle: boxAnimation.value,
            );
          }),
    );
  }

  Widget buildRightFlap() {
    return Positioned(
      right: 3.0,
      child: AnimatedBuilder(
          animation: boxAnimation,
          child: Container(
            height: 10.0,
            width: 125.0,
            color: Colors.brown,
          ),
          builder: (context, child) {
            return Transform.rotate(
              child: child,
              alignment: Alignment.topRight,
              angle: -boxAnimation.value + (pi * 0.05),
            );
          }),
    );
  }
}
