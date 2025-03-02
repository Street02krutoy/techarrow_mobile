import 'package:image/image.dart';

class CollageCreator {
  int rows = 2;
  int cols = 2;
  int resultWidth = 1080;
  int resultHeight = 1920;
  //Color gridColor = const Color(0xFF000000);
  List<Image> images;

  CollageCreator(this.images, {int row = 2, int col = 2}) {
      rows = row;
      cols = col;
    }

    Image createCollage() {
    while (images.length < rows * cols){
      images.add(Image(540, 960));
      print('added empty image');
    }

    // Определим размеры ячейки
    int cellWidth = images.first.width;
    int cellHeight = images.first.height;

    // Создадим итоговое изображение
    int totalWidth = cellWidth * cols;
    int totalHeight = cellHeight * rows;
    Image collage = Image(totalWidth, totalHeight);

    // Разместим изображения в коллаже
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        int index = i * cols + j;
        Image image = images[index];
        copyInto(collage, image, dstX: j * cellWidth, dstY: i * cellHeight);
      }
    }

    return collage;
  }
}
