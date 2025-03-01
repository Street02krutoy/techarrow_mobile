import 'dart:async';
import 'dart:io';

import "dart:ui" as ui;
import 'package:flutter/material.dart';
import 'package:techarrow_mobile/screens/draw/draw_screen.dart';
import 'package:techarrow_mobile/storage/models/page_layout.dart';
import 'package:techarrow_mobile/storage/storage.dart';

class TilesScreen extends StatefulWidget {
  const TilesScreen({super.key, required this.title, required this.page});
  final String title;
  final int page;
  @override
  State<TilesScreen> createState() => _TilesScreenState();
}

class _TilesScreenState extends State<TilesScreen> {
  Image _getImage(int index) {
    File imageFile = ApplicationStorage()
        .getLocalFileSync("/${widget.title}/${widget.page}/$index.png");
    if (!imageFile.existsSync()) {
      return Image.memory(ApplicationStorage().previewImageBytes);
    }
    return Image.file(imageFile);
  }

  bool isImage(int index) {
    File imageFile = ApplicationStorage()
        .getLocalFileSync("/${widget.title}/${widget.page}/$index.png");
    if (!imageFile.existsSync()) {
      return false;
    }
    return true;
  }

  Future<ui.Image> convert(Image image) {
    Completer<ui.Image> completer = Completer<ui.Image>();
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo info, bool _) {
          completer.complete(info.image);
        },
      ),
    );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    List<PageLayout> layouts =
        ApplicationStorage().getComicsPages(widget.title);

    PageLayout layout = layouts[widget.page];
    print(layout.toJson().toString());
    List<Widget> tiles = List.generate(layout.height * layout.width, (index) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FutureBuilder<ui.Image>(
                future: convert(_getImage(index)),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DrawScreen(
                      path: "/${widget.title}/${widget.page}/$index.png",
                      image: isImage(index) ? snapshot.data : null,
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          );
        },
        child: _getImage(index),
      );
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title}: ${widget.page + 1}"),
        centerTitle: true,
      ),
      body: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: layout.width),
        children: tiles,
      ),
    );
  }
}

// DrawScreen(
//                         title: widget.title,
//                         page: _page.toString(),
//                       );
