import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:techarrow_mobile/data/comics.dart';

class Storage {
  Future<String> get _localPath async {
    final Directory directory = await getApplicationDocumentsDirectory();
    print(directory.path); 

    return directory.path;
  }

  Future<File> _localFile(String path) async {
    return File('${await _localPath}/$path');
  }

  Future<Image> getPreviewImage(
      String title, double width, double height) async {
    try {
      final File file = await _localFile("$title/preview.png");

      // Read the file
      return Image.file(
        file,
        width: width,
        height: height,
      );
    } catch (e) {
      // If encountering an error, return 0
      return Image.asset(
        "assets/preview2.png",
        width: width,
        height: height,
      );
    }
  }

  Future<File?> createComics(String title, Uint8List image) async {
    try {
      final File file = await _localFile("$title/preview.png");
      if (!(await file.exists())) {
        await file.create(recursive: true);
      }
      await file.writeAsBytes(image);
      return file;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Comics>> getAllComicses() async {
    List<Comics> comicses = [];
    final Directory directory = await getApplicationDocumentsDirectory();
    await for (var entity in directory.list()) {
      var list = entity.path.split("/");
      comicses.add(Comics(list.last));
    }
    return comicses;
  }
}
