import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:techarrow_mobile/storage/models/comics.dart';
import 'package:techarrow_mobile/storage/models/page_layout.dart';

class ApplicationStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static late ByteData _previewImage;

  static String _localPathSync = "";
  static bool initialized = false;

  Future<File> getLocalFile(String path) async {
    return File('${await _localPath}/data/comics$path');
  }

  ByteData get previewImage => _previewImage;
  Uint8List get previewImageBytes => _previewImage.buffer
      .asUint8List(_previewImage.offsetInBytes, _previewImage.lengthInBytes);

  Future<Directory> getLocalDirectory(String path) async {
    return Directory('${await _localPath}/data/comics$path');
  }

  File getLocalFileSync(String path) {
    return File('$_localPathSync/data/comics$path');
  }

  Directory getLocalDirectorySync(String path) {
    return Directory('$_localPathSync/data/comics$path');
  }

  Future<void> initialize() async {
    Directory dir = Directory('${await _localPath}/data');
    _previewImage = await rootBundle.load("assets/empty.png");
    if (!(await dir.exists())) {
      dir.create();
    }
    dir = await getLocalDirectory("");
    if (!(await dir.exists())) {
      dir.create();
    }
    _localPathSync = await _localPath;
  }

  Future<void> createComics(String title) async {
    final Directory dir = getLocalDirectorySync("/$title");
    if (dir.existsSync()) {
      throw Exception("Comics alerady exists");
    }
    dir.createSync();
    final File info = getLocalFileSync("/$title/info.json");
    info.createSync();
    info.writeAsStringSync(json.encode(ComicsInfo(
            title: title, createdAt: DateTime.now(), updatedAt: DateTime.now())
        .toJson()));
  }

  void deleteComics(String title) {
    getLocalDirectorySync("/$title").deleteSync(recursive: true);
  }

  List<PageLayout> getComicsPages(String title) {
    String path = "/$title";
    final Directory dir = getLocalDirectorySync(path);

    List<PageLayout> pagesList = List.empty(growable: true);
    dir.listSync().forEach((val) {
      if (val is! Directory) return;
      File pagesInfo = File("${val.path}/layout.json");

      pagesList
          .add(PageLayout.fromJson(json.decode(pagesInfo.readAsStringSync())));
    });
    return pagesList;
  }

  void deleteComicsPage(String title, int index) {
    getLocalDirectorySync("/$title/$index").deleteSync(recursive: true);
  }

  void saveComicsPage(String title, int index, PageLayout layout) {
    String path = "/$title/$index";
    getLocalFileSync("$path/layout.json")
        .writeAsStringSync(json.encode(layout.toJson()));
  }

  void createComicsPage(String title, int height, int width) {
    String path = "/$title/${getComicsPages(title).length.toString()}";
    Directory dir = getLocalDirectorySync(path);
    dir.createSync();

    File info = getLocalFileSync("$path/layout.json");
    File preview = getLocalFileSync("$path/preview.png");

    preview.createSync();
    preview.writeAsBytesSync(_previewImage.buffer
        .asUint8List(_previewImage.offsetInBytes, _previewImage.lengthInBytes));
    info.createSync();

    info.writeAsStringSync(json.encode(PageLayout(
            images: List.generate(height * width, (index) {
              File file = getLocalFileSync("$path/$index.png");
              return file.path;
            }),
            height: height,
            width: width)
        .toJson()));
  }

  List<ComicsInfo> getAllComics() {
    final Directory dir = getLocalDirectorySync("/");

    List<ComicsInfo> comicsList = List.empty(growable: true);
    dir.listSync().forEach((val) {
      final File comicsInfo = File("${val.path}/info.json");

      comicsList
          .add(ComicsInfo.fromJson(json.decode(comicsInfo.readAsStringSync())));
    });
    return comicsList;
  }

  int getFilesCount(String path) {
    final Directory dir = getLocalDirectorySync(path);
    return dir.listSync().length;
  }

  List getPagesPreviews(String title) {
    return [];
  }

  Image getPreview(String title, double width, double height) {
    try {
      File file = getLocalFileSync("/$title/0/preview.png");
      if (!file.existsSync()) {
        return Image.asset("assets/empty.png", width: width, height: height);
      }
      return Image.file(file, width: width, height: height);
    } catch (e) {
      return Image.asset("assets/empty.png", width: width, height: height);
    }
  }
}
