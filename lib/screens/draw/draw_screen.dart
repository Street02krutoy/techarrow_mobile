import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
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

    List<Widget> tools = [
      IconButton(
        onPressed: () {
          setState(() {
            _painter.strokeWidth = 1;
            _painter.curColor = Colors.black;
            _painter.colors.last = Colors.black;
            _painter.widths.last = 1;
          });
        },
        icon: const Icon(Symbols.ink_pen),
      ),
      IconButton(
        onPressed: () {
          setState(() {
            _markerWidth = _markerWidth;
            _painter.strokeWidth = _markerWidth;
            _painter.colors.last = _currentColor;
            _painter.widths.last = _markerWidth;
          });
        },
        icon: const Icon(Symbols.stylus_pencil),
      ),
      IconButton(
        onPressed: () {
          setState(() {
            _painter.strokeWidth = _markerWidth;
            _painter.curColor = BACKROUND_COLOR;
            _painter.colors.last = BACKROUND_COLOR;
            _painter.widths.last = _markerWidth;
          });
        },
        icon: const Icon(Symbols.ink_eraser),
      ),
      IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ColorPickerDialog(
                key: const Key('color_picker_dialog'),
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
        icon: const Icon(Symbols.colors),
      ),
      IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return MarkerWidthDialog(
                key: const Key('marker_width_dialog'),
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
        icon: const Icon(Symbols.width),
      ),
      IconButton(
        onPressed: _painter.isUndo() ? () {
          setState(() {
            _painter.undoLast();
          });
        } : null,
        icon: const Icon(Symbols.undo),
      ),
      IconButton(
        onPressed: _painter.isRedo() ? () {
          setState(() {
            _painter.redoLast();
          });
        } : null,
        icon: const Icon(Symbols.redo),
      ),
      IconButton(
        onPressed: () {
          // Todo save image, canvasToImage
        },
        icon: const Icon(Symbols.save),
      )
    ];

    return Scaffold(
      appBar: width < height
          ? AppBar(
              title: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Горизонтальная прокрутка
                child: Row(children: tools),
              ),
            )
          : null,
      body: Row(
        children: [
          Expanded(
            child: Column(
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
                    height: height * (width > height ? 1 : 0.88),
                    width: width,
                    child: CustomPaint(
                      painter: _painter,
                      size: Size(width * (width < height ? 1 : 0.88),
                          height * (width > height ? 1 : 0.88)),
                      key: ValueKey(
                          _painter.points.last.length + _painter.points.length),
                    ),
                  ),
                ),
              ],
            ),
          ),
          width > height
              ? SingleChildScrollView(
                  scrollDirection: Axis.vertical, // Вертикальная прокрутка
                  child: Column(
                    children: tools,
                  ),
                )
              : const SizedBox.shrink(), // Убираем пустой текст
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
