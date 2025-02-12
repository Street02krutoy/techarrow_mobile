import 'package:flutter/material.dart';
import 'package:techarrow_mobile/screens/draw/customPainter.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/material.dart';

Color BACKROUND_COLOR = Colors.white;
Color _currentColor = Colors.blue;
double _markerWidth = 5.0;

class DrawScreen extends StatefulWidget {
  const DrawScreen({super.key});

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  ComicCell _painter = ComicCell();
  

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _painter.addPoint(details.localPosition);
              });
            },
            onPanEnd: (details) {
              _painter.addList();
            },
            child: SizedBox(
              height: height * 0.9,
              width: width,
              child: CustomPaint(
                painter: _painter,
                size: Size(width, height * 0.9),
                key: ValueKey(_painter.points.last.length + _painter.points.length),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.1,
            width: width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ColorPickerDialog(
                            key: Key('color_picker_dialog'),
                            currentColor: _currentColor,
                            onColorChanged: (Color color) {
                              setState(() {
                                _currentColor = color;
                                _painter.curColor = color;
                                _painter.colors.last = color;
                              });
                            },
                          );
                        },
                      );
                    },
                    child: const Text('Выбрать цвет'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _painter.strokeWidth = 1;
                        _painter.curColor = Colors.black;
                        _painter.colors.last = Colors.black;
                        _painter.widths.last = 1;
                      });
                    },
                    child: const Text('Карандаш'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _markerWidth = _markerWidth;
                        _painter.strokeWidth = _markerWidth;
                        _painter.colors.last = _currentColor;
                        _painter.widths.last = _markerWidth;
                      });
                    },
                    child: const Text('Маркер'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _painter.strokeWidth = _markerWidth;
                        _painter.curColor = BACKROUND_COLOR;
                        _painter.colors.last = BACKROUND_COLOR;
                        _painter.widths.last = _markerWidth;
                      });
                    },
                    child: const Text('Ластик'),
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MarkerWidthDialog(
                            key: Key('marker_width_dialog'),
                            onMarkerWidthChanged: (double strokeWidth) {
                              setState(() {
                                _markerWidth = strokeWidth;
                                _painter.strokeWidth = strokeWidth;
                                _markerWidth = strokeWidth;
                                _painter.widths.last = strokeWidth;
                              });
                            },
                          );
                        },
                      );
                    },
                    child: const Text('Толщина'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _painter.returnLast();
                      });
                    },
                    child: const Text('Вернуться'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class ColorPickerDialog extends StatelessWidget {
  final Color currentColor;
  final ValueChanged<Color> onColorChanged;

  const ColorPickerDialog({
    required Key key,
    required this.currentColor,
    required this.onColorChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Выберите цвет'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: currentColor,
          onColorChanged: onColorChanged,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class MarkerWidthDialog extends StatefulWidget {
  final ValueChanged<double> onMarkerWidthChanged;

  const MarkerWidthDialog({
    required Key key,
    required this.onMarkerWidthChanged,
  }) : super(key: key);

  @override
  _MarkerWidthDialogState createState() => _MarkerWidthDialogState();
}

class _MarkerWidthDialogState extends State<MarkerWidthDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Выберите толщину маркера'),
      content: SingleChildScrollView(
        child: Slider(
          value: _markerWidth,
          min: 1.0,
          max: 10.0,
          divisions: 9,
          label: _markerWidth.toString(),
          onChanged: (double value) {
            setState(() {
              _markerWidth = value;
              widget.onMarkerWidthChanged(value);
            });
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
