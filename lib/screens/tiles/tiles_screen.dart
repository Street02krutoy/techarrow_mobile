import 'dart:io';

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

  @override
  Widget build(BuildContext context) {
    List<PageLayout> layouts =
        ApplicationStorage().getComicsPages(widget.title);

    PageLayout layout = layouts[widget.page];
    List<Widget> tiles = List.generate(layout.height * layout.width, (index) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DrawScreen(
                path: "/${widget.title}/${widget.page}/$index.png",
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
