import 'dart:io';

import 'package:flutter/material.dart';
import 'package:techarrow_mobile/screens/comics/comics_screen.dart';
import 'package:techarrow_mobile/screens/util/storage.dart';
import 'package:techarrow_mobile/widgets/comics_card_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _scrollController = ScrollController();

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
        body: Center(
          child: SingleChildScrollView(
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
                children: List.generate(
                    100,
                    (index) => InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return ComicsScreen(
                                id: index.toString(),
                              );
                            }));
                          },
                          onLongPress: () {
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Title ${index + 1}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                              ],
                                            ),
                                            Divider(),
                                            InkWell(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )),
                                            Divider(),
                                          ],
                                        ),
                                      ),
                                    ));
                          },
                          child: ComicsCardWidget(
                              image: Image.asset(
                                index.isOdd
                                    ? "assets/preview.png"
                                    : "assets/preview2.png",
                                height: itemHeight,
                                width: itemWidth,
                              ),
                              title: Text(
                                "Title ${index + 1}",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                              )),
                        )),
              )),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
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
