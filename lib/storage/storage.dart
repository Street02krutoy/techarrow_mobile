import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:techarrow_mobile/storage/models/comics.dart';
import 'package:techarrow_mobile/storage/models/page_layout.dart';

class ApplicationStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static String _localPathSync = "";
  static bool initialized = false;

  Future<File> getLocalFile(String path) async {
    return File('${await _localPath}/data/comics$path');
  }

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
    if (!(await dir.exists())) {
      dir.create();
    }
    dir = await getLocalDirectory("");
    if (!(await dir.exists())) {
      dir.create();
    }
    _localPathSync = await _localPath;
    print(dir.path);
    print(await getAllComics());
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

    info.createSync();

    info.writeAsStringSync(json.encode(
        PageLayout(images: [], height: height, width: height).toJson()));
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

  List getComicsImages(String title) {
    final Directory dir = getLocalDirectorySync("/$title/pictures");
    return dir.listSync();
  }
}
