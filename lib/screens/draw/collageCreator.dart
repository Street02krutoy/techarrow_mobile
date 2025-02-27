import 'dart:ui';
import 'package:image/image.dart' as img;

class CollageCreator {
  int rowNumber = 2;
  int colNumber = 2;
  Color gridColor = const Color(0xFF000000);
  List<img.Image> images = [];

  CollageCreator(List<img.Image> images, {int row = 2, int col = 2}){
    this.images = images;
    this.rowNumber = row;
    this.colNumber = col;
  }

  img.Image createCollage({int resultWidth=1080, int resultHeight=1920}) {
    if (rowNumber < 1 || colNumber < 1) {
      throw Exception('Неверное количество рядов и колонок');
    }
    if (images.length != rowNumber * colNumber) {
      throw Exception('Неверное количество изображений');
    }

    // Определяем размеры каждого изображения
    int width = resultWidth ~/ colNumber;
    int height = resultHeight ~/ rowNumber;

    // Создаем изображение для коллажа
    img.Image collage = img.Image(resultWidth, resultHeight);

    // Отрисовываем изображения на коллаже
    for (int i = 0; i < rowNumber; i++) {
      for (int j = 0; j < colNumber; j++) {
        int index = i * colNumber + j;
        if (index < images.length) {
          img.Image resizedImage = img.copyResize(images[index], width: width, height: height);
          img.copyInto(collage, resizedImage, dstX: j * width, dstY: i * height);
        }
      }
    }

    for (int i = 0; i <= rowNumber; i++) {
      img.drawLine(collage, 0, i * height, resultWidth, i * height, gridColor.value);
    }
    for (int j = 0; j <= colNumber; j++) {
      img.drawLine(collage, j * width, 0, j * width, resultHeight, gridColor.value);
    }

    return collage;
  }
}

