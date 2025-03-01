import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:techarrow_mobile/screens/comics/ui/create_page_dialog.dart';
import 'package:techarrow_mobile/screens/comics/ui/delete_confirmation_dialog.dart';
import 'package:techarrow_mobile/screens/draw/draw_screen.dart';
import 'package:techarrow_mobile/screens/main/main_screen.dart';
import 'package:techarrow_mobile/screens/tiles/tiles_screen.dart';
import 'package:techarrow_mobile/storage/models/page_layout.dart';
import 'package:techarrow_mobile/storage/storage.dart';

class ComicsScreen extends StatefulWidget {
  const ComicsScreen({super.key, required this.title});
  final String title;

  @override
  State<ComicsScreen> createState() => _ComicsScreenState();
}

class _ComicsScreenState extends State<ComicsScreen> {
  final DateFormat formatter = DateFormat('yyyy.MM.dd');
  late List<PageLayout> comicsPages;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  void fetch() {
    try {
      comicsPages = ApplicationStorage().getComicsPages(widget.title);
    } catch (e) {
      print(e);
      comicsPages = [];
    }
  }

  int _page = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height;
    final double itemWidth = size.width * 1.3518;
    final CarouselSliderController _carouselController =
        CarouselSliderController();

    final List<Widget> previews = [];

    for (final (index, _) in comicsPages.indexed) {
      previews.add(Image.file(ApplicationStorage()
          .getLocalFileSync("/${widget.title}/$index/preview.png")));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Title ${widget.title}"),
        centerTitle: true,
      ),
      body: Center(
        child: comicsPages.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(
                    flex: 4,
                  ),
                  Icon(
                    Symbols.error,
                    size: 100,
                  ),
                  Text(
                    "Здесь нет страниц",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return CreatePageDialog()
                                  .build(context, widget.title, onCreate: () {
                                fetch();
                              });
                            });
                      },
                      child: Text(
                        "Создать",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      )),
                  Spacer(
                    flex: 5,
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CarouselSlider(
                    carouselController: _carouselController,
                    items: previews,
                    options: CarouselOptions(
                        onPageChanged: (index, reason) {
                          print(index);
                          setState(() {
                            _page = index;
                          });
                        },
                        initialPage: _page,
                        aspectRatio: (itemWidth / itemHeight),
                        viewportFraction: 1,
                        enableInfiniteScroll: false),
                  ),
                ],
              ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      // floatingActionButton:
      //     FloatingActionButton(child: const Icon(Icons.add), onPressed: () {}),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).focusColor,
              radius: 30,
              child: IconButton(
                  onPressed: comicsPages.isEmpty
                      ? null
                      : () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return TilesScreen(
                              title: widget.title,
                              page: _page,
                            );
                          }));
                          // try {
                          //   //ApplicationStorage().createComicsPage(widget.title, 1, 2);
                          //   print(ApplicationStorage().getAllComics());
                          // } catch (e) {
                          //   print(e);
                          //   Fluttertoast.showToast(msg: "error $e");
                          // }
                        },
                  icon: const Icon(Icons.edit, size: 30)),
            ),
            CircleAvatar(
              backgroundColor: Theme.of(context).focusColor,
              radius: 30,
              child: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return CreatePageDialog().build(context, widget.title,
                              onCreate: () {
                            fetch();
                          });
                        });
                  },
                  icon: const Icon(Icons.add, size: 30)),
            ),
            CircleAvatar(
              backgroundColor: Theme.of(context).focusColor,
              radius: 30,
              child: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return DeleteConfirmationDialog().build(
                              context, widget.title,
                              onDelete: () => {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MainScreen()),
                                        (route) => false)
                                  });
                        });
                  },
                  icon: const Icon(Icons.delete, size: 30)),
            ),
          ],
        ),
      ),
    );
  }
}
