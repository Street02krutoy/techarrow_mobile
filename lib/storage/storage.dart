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

  Future<File> getLocalFile(String path) async {
    return File('${await _localPath}/data/comics$path');
  }

  Future<Directory> getLocalDirectory(String path) async {
    return Directory('${await _localPath}/data/comics$path');
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
  }

  Future<void> createComics(String title) async {
    final Directory dir = await getLocalDirectory("/$title");
    if (await dir.exists()) {
      throw Exception("Comics alerady exists");
    }
    await dir.create();
    final File info = await getLocalFile("/$title/info.json");
    await info.writeAsString(json.encode(ComicsInfo(
            title: title, createdAt: DateTime.now(), updatedAt: DateTime.now())
        .toJson()));
  }

  Future<List<ComicsInfo>> getAllComics() async {
    final Directory dir = await getLocalDirectory("/");

    List<ComicsInfo> comicsList = List.empty(growable: true);
    dir.list().forEach((val) async {
      final File comicsInfo = File("${val.path}/info.json");
      comicsList.add(
          ComicsInfo.fromJson(json.decode(await comicsInfo.readAsString())));
    });
    print(comicsList);
    return comicsList;
  }
}
