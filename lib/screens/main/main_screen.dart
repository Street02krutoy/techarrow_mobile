import 'package:flutter/material.dart';
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

  late Future<List<ComicsInfo>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApplicationStorage().getAllComics();
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
        body: Center(
          child: FutureBuilder(
            future: _future,
            builder: (BuildContext context,
                AsyncSnapshot<List<ComicsInfo>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SingleChildScrollView(
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
                    children: snapshot.data!
                        .map((comics) => InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return ComicsScreen(
                                    id: comics.title,
                                  );
                                }));
                              },
                              child: ComicsCardWidget(
                                  image: Image.asset(
                                    "assets/preview.png",
                                    height: itemHeight,
                                    width: itemWidth,
                                  ),
                                  title: Text(
                                    comics.title,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20.0),
                                  )),
                            ))
                        .toList(),
                  ));
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CreateDialog().build(context, onCreate: () {
                    _future = ApplicationStorage().getAllComics();
                    ;
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
