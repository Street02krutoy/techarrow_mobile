import 'dart:ui';
import 'package:flutter/material.dart';

class ComicCell extends CustomPainter {
  List<List<Offset>> points = [[]];
  bool repaint = false;
  Color curColor = Colors.blue;
  double strokeWidth = 5.0;
  List<Color> colors = [Colors.blue];
  List<double> widths = [5.0];
  PictureRecorder recorder = PictureRecorder();
  Canvas? curCanvas;

  void addPoint(Offset point) {
    points.last.add(point);
    repaint = true;
  }

  void addList() {
    colors.add(curColor);
    points.add([]);
    widths.add(strokeWidth);
    repaint = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Создаем PictureRecorder и Canvas для записи
    recorder = PictureRecorder();
    curCanvas = Canvas(recorder);

    // Отрисовка на Canvas
    curCanvas!.clipRect(Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    ));
    curCanvas!.save();

    Paint paint = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    curCanvas!.drawRect(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: size.height,
      ),
      paint,
    );

    for (int i = 0; i < points.length; i++) {
      paint.color = colors[i];
      paint.strokeWidth = widths[i];
      for (int j = 0; j < points[i].length - 1; j++) {
        curCanvas!.drawLine(points[i][j], points[i][j + 1], paint);
      }
    }

    // Отрисовка на основной Canvas
    canvas.drawPicture(recorder.endRecording());
    curCanvas!.restore();
  }

  @override
  bool shouldRepaint(ComicCell oldDelegate) {
    if (repaint) {
      repaint = false;
      return true;
    }
    return (oldDelegate.points.last.length != points.last.length) ||
        (oldDelegate.points.length != points.length);
  }

  void returnLast() {
    if (points.length > 1) {
      points.removeAt(points.length - 2);
      widths.removeAt(widths.length - 2);
      colors.removeAt(colors.length - 2);
    }
  }

  Future<Image> canvasToImage({width = 200, height = 200}) async { // я не могу сказать что оно работает, но должно
    Picture picture = recorder.endRecording();
    Image image = (await picture.toImage(width, height)) as Image;
    return image;
  }
}