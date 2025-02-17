import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:techarrow_mobile/storage/models/comics.dart';

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
    if (await dir.exists()) {
      throw Exception("Comics alerady exists");
    }
    await dir.create();
    final File info = await getLocalFile("/$title/info.json");
    await info.writeAsString(json.encode(ComicsInfo(
            title: title, createdAt: DateTime.now(), updatedAt: DateTime.now())
        .toJson()));
  }

  Future<void> deleteComics(String title) async {
    throw "Not implemented.";
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
}
