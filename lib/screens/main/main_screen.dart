import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:techarrow_mobile/screens/comics/comics_screen.dart';
import 'package:techarrow_mobile/screens/main/ui/create_dialog.dart';
import 'package:techarrow_mobile/storage/models/comics.dart';
import 'package:techarrow_mobile/storage/storage.dart';
import 'package:techarrow_mobile/widgets/comics_card_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _scrollController = ScrollController();

  late List<ComicsInfo> _data;

  @override
  void initState() {
    super.initState();
    _data = ApplicationStorage().getAllComics();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height -
            kToolbarHeight -
            (25 * (size.aspectRatio < 1 ? 6 : 0.1))) /
        2;
    final double itemWidth = size.width / (size.aspectRatio < 1 ? 2 : 4);


    return Scaffold(
        appBar: AppBar(
          title: const Text("Мои комиксы"),
        ),
        body: _data.isEmpty
            ? Center(
                child: Column(
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
                      "Комиксов не найдено",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CreateDialog().build(context,
                                    onCreate: () {
                                  _data = ApplicationStorage().getAllComics();
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
                ),
              )
            : SingleChildScrollView(
                controller: _scrollController,
                child: GridView.count(
                  childAspectRatio: size.aspectRatio < 1
                      ? (itemWidth / itemHeight)
                      : (itemHeight / itemWidth),
                  shrinkWrap: true,
                  crossAxisCount: size.aspectRatio < 1 ? 2 : 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  padding: const EdgeInsets.all(3),
                  physics: const NeverScrollableScrollPhysics(),
                  children: _data
                      .map((comics) => InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return ComicsScreen(
                                  title: comics.title,
                                );
                              }));
                            },
                            child: ComicsCardWidget(
                                image: ApplicationStorage().getPreview(
                                    comics.title, itemWidth, itemHeight),
                                title: Text(
                                  comics.title,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                )),
                          ))
                      .toList(),
                )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CreateDialog().build(context, onCreate: () {
                    _data = ApplicationStorage().getAllComics();
                  });
                });
          },
          child: const Icon(Icons.add),
        ));
  }
}

// Row(
//   children: [
//     Expanded(
//         child: InkWell(
//       onTap: () {},
//       child: const CustomCardWidget(
//           child: Column(
//         children: [
//           Icon(
//             Icons.add,
//             size: 50,
//           ),
//           Text(
//             "Добавить комикс",
//             style: TextStyle(fontSize: 30),
//           )
//         ],
//       )),
//     )),
//   ],
// ),
