import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ComicCell extends CustomPainter {

  final int maxReturnElements = 5;
  late ui.Picture image;
  
  bool repaint = false;
  Color curColor = Colors.blue;
  double strokeWidth = 5.0;

  List<List<Offset>> points = [[]];
  List<Color> colors = [Colors.blue];
  List<double> widths = [5.0];

  ui.PictureRecorder recorder = ui.PictureRecorder();
  Canvas? curCanvas;

  List<List<Offset>> returnedPoints = [];
  List<Color> returnedColors = [];
  List<double> returnedWidths = [];
  ui.Image? baseImage;

  void addPoint(Offset point) { // добавить точку
    points.last.add(point);
    repaint = true;
  }

  void addList() { // добавить рисунки
    colors.add(colors.last);
    points.add([]);
    widths.add(strokeWidth);
    returnedColors.clear();
    returnedPoints.clear();
    returnedWidths.clear();
    repaint = true;
  }

  void initReturned(){ // удалить лишние элементы
    if (returnedPoints.length > maxReturnElements){
      returnedPoints.removeAt(0);
    }
    if (returnedColors.length > maxReturnElements){
      returnedColors.removeAt(0);
    }
    if (returnedWidths.length > maxReturnElements){
      returnedWidths.removeAt(0);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Создаем PictureRecorder и Canvas для записи
    recorder = ui.PictureRecorder();
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

    if (baseImage != null){
      curCanvas!.drawImage(baseImage!, Offset.zero, paint);
    }
    else{
      curCanvas!.drawRect(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: size.width,
          height: size.height,
        ),
        paint,
      );
    }

    for (int i = 0; i < points.length; i++) {
      paint.color = colors[i];
      paint.strokeWidth = widths[i];
      for (int j = 0; j < points[i].length - 1; j++) {
        curCanvas!.drawLine(points[i][j], points[i][j + 1], paint);
      }
    }

    // Отрисовка на основной Canvas
    image = recorder.endRecording();
    canvas.drawPicture(image);
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

  void setBaseImage(ui.Image img){
    baseImage = img;
  }

  void undoLast() { // откатывет последнее действие
    if (points.length > 1) {
      returnedPoints.add(points.removeAt(points.length - 2));
      returnedWidths.add(widths.removeAt(widths.length - 2));
      returnedColors.add(colors.removeAt(colors.length - 2));
    }
  }

  void redoLast(){ // возвращает последнее действие
    if (returnedPoints.isNotEmpty) {
      colors.insert(colors.length - 1, returnedColors.removeLast());
      widths.insert(widths.length - 1, returnedWidths.removeLast());
      points.insert(points.length - 1, returnedPoints.removeLast());
    }
  }

  ui.Picture canvasToImage({width = 540, height = 960}) { // я не могу сказать что оно работает, но должно
    return image;
  }

  bool isUndo(){
    return points.length > 1;
  }

  bool isRedo(){
    return returnedPoints.isNotEmpty;
  }
}