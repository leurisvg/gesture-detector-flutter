import 'package:flutter/material.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double containerSize = 100.0;
  double horizontalDrag;
  double verticalDrag;
  double startHorizontalDrag = 0;
  double startVerticalDrag = 0;

  Color color = Colors.redAccent;
  double borderRadius = 0;
  bool animatedContainer = true;

  double appBar_statusBarHeight = 0;
  Size size;
  double statusBarHeight;
  Map<String, dynamic> borders;
  double angle = 0;

  String dropdownValue = 'Free';
  List<String> options = [
    'Free',
    'Free without limits',
    'Horizontal and Vertical',
    'Horizontal',
    'Vertical',
    'Scale',
    'Rotate'
  ];

  Map<String, dynamic> _bordersItem(DragUpdateDetails details) {
    double _leftBorderItem = 0;
    double _rightBorderItem = 0;
    double _topBorderItem = 0;
    double _bottomBorderItem = 0;

    _leftBorderItem = details.globalPosition.dx - startHorizontalDrag;
    _rightBorderItem = details.globalPosition.dx + (containerSize - startHorizontalDrag);
    _topBorderItem = details.globalPosition.dy - startVerticalDrag - appBar_statusBarHeight;
    _bottomBorderItem = details.globalPosition.dy - kBottomNavigationBarHeight + (containerSize - startVerticalDrag);

    return {
      'leftBorderItem': _leftBorderItem,
      'rightBorderItem': _rightBorderItem,
      'topBorderItem': _topBorderItem,
      'bottomBorderItem': _bottomBorderItem,
    };
  }

  _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      horizontalDrag = details.globalPosition.dx - startHorizontalDrag;
      borders = _bordersItem(details);

      if(borders['leftBorderItem'] <= 0) {
        horizontalDrag = 0;
      }

      if(borders['rightBorderItem'] >= size.width) {
        horizontalDrag = size.width - containerSize;
      }
    });
  }

  _onHorizontalDragStart(DragStartDetails details) {
    startHorizontalDrag = details.localPosition.dx;
  }

  _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      verticalDrag = details.globalPosition.dy - startVerticalDrag - appBar_statusBarHeight;
      borders = _bordersItem(details);

      if(borders['topBorderItem'] <= 0) {
        verticalDrag = 0;
      }

      if(borders['bottomBorderItem'] >= (size.height - kBottomNavigationBarHeight)) {
        verticalDrag = size.height - statusBarHeight - kBottomNavigationBarHeight - containerSize;
      }
    });
  }

  _onVerticalDragStart(DragStartDetails details) {
    startVerticalDrag = details.localPosition.dy;
  }

  _onPanUpdate(DragUpdateDetails details) {
    if (dropdownValue == 'Free') borders = _bordersItem(details);

    setState(() {
      horizontalDrag = details.globalPosition.dx - startHorizontalDrag;
      verticalDrag = details.globalPosition.dy - startVerticalDrag - appBar_statusBarHeight;

      if (dropdownValue == 'Free') {
        if(borders['leftBorderItem'] <= 0) {
          horizontalDrag = 0;
        }

        if(borders['rightBorderItem'] >= size.width) {
          horizontalDrag = size.width - containerSize;
        }

        if(borders['topBorderItem'] <= 0) {
          verticalDrag = 0;
        }

        if(borders['bottomBorderItem'] >= (size.height - kBottomNavigationBarHeight)) {
          verticalDrag = size.height - statusBarHeight - kBottomNavigationBarHeight - containerSize;
        }
      }
    });
  }

  _onPanStart(DragStartDetails details) {
    startHorizontalDrag = details.localPosition.dx;
    startVerticalDrag = details.localPosition.dy;
  }

  _onScaleUpdate(ScaleUpdateDetails details, bool scale) {
    if (scale == true) {
      setState(() {
        containerSize = details.scale * 150;

        if(containerSize <= 100) containerSize = 100;
        if(containerSize >= size.width ) containerSize = size.width;

        horizontalDrag = (size.width / 2) - (containerSize / 2);
        verticalDrag = (size.height  / 2 - statusBarHeight) - (containerSize / 2);
      });
    } else {
      setState(() {
        angle = details.rotation.abs() * (180 / math.pi);
        print(angle);
      });
    }
  }

  _onDoubleTap() {
    setState(() {
      containerSize += 50;

      if (containerSize >= size.width) containerSize = size.width;
    });
  }

  _onLongPress() {
    setState(() {
      containerSize -= 50;

      if (containerSize <= 100) containerSize = 100;
    });
  }

  _onTap() {
    final random = math.Random();

    setState(() {
      color = Color.fromRGBO(
        random.nextInt(255),
        random.nextInt(255),
        random.nextInt(255),
        1
      );

      borderRadius = random.nextInt(50).toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    statusBarHeight = MediaQuery.of(context).padding.top;
    appBar_statusBarHeight = kToolbarHeight + statusBarHeight;

    horizontalDrag ??= (size.width / 2) - (containerSize / 2);
    verticalDrag ??= (size.height  / 2 - statusBarHeight) - (containerSize / 2);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gesture Detector'),
        actions: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: DropdownButton<String>(
                value: dropdownValue,
                onChanged: (String value) {
                  setState(() {
                    dropdownValue = value;

                    if (dropdownValue == 'Scale' || dropdownValue == 'Rotate') {
                      animatedContainer = false;
                    } else {
                      animatedContainer = true;
                    }
                  });
                },
                isDense: true,
                underline: Container(height: 1, color: Colors.white),
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                items: options.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                } ).toList(),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: verticalDrag,
            left: horizontalDrag,
            child: GestureDetector(
              onHorizontalDragUpdate: dropdownValue == 'Horizontal' || dropdownValue == 'Horizontal and Vertical'
                ? _onHorizontalDragUpdate
                : null,
              onHorizontalDragStart: dropdownValue == 'Horizontal' || dropdownValue == 'Horizontal and Vertical'
                ? _onHorizontalDragStart
                : null,
              onVerticalDragUpdate: dropdownValue == 'Vertical' || dropdownValue == 'Horizontal and Vertical'
                ? _onVerticalDragUpdate
                : null,
              onVerticalDragStart: dropdownValue == 'Vertical' || dropdownValue == 'Horizontal and Vertical'
                ? _onVerticalDragStart
                : null,
              onPanUpdate: dropdownValue == 'Free' || dropdownValue == 'Free without limits' ? _onPanUpdate : null,
              onPanStart: dropdownValue == 'Free' || dropdownValue == 'Free without limits' ? _onPanStart : null,
              onScaleUpdate: dropdownValue == 'Scale'
                ? (details) => _onScaleUpdate(details, true)
                : dropdownValue == 'Rotate'
                  ? (details) => _onScaleUpdate(details, false)
                  : null,
              onDoubleTap: _onDoubleTap,
              onLongPress: _onLongPress,
              onTap: _onTap,
              child: Transform.rotate(
                angle: angle,
                child: AnimatedContainer(
                  duration: animatedContainer ? const Duration(milliseconds: 900) : const Duration(milliseconds: 0),
                  width: containerSize,
                  height: containerSize,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(color: Colors.blue, width: 2)
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
