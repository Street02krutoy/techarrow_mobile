import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:techarrow_mobile/screens/comics/ui/delete_confirmation_dialog.dart';
import 'package:techarrow_mobile/screens/draw/draw_screen.dart';
import 'package:techarrow_mobile/screens/main/main_screen.dart';
import 'package:techarrow_mobile/storage/storage.dart';

class ComicsScreen extends StatefulWidget {
  const ComicsScreen({super.key, required this.title});
  final String title;

  @override
  State<ComicsScreen> createState() => _ComicsScreenState();
}

class _ComicsScreenState extends State<ComicsScreen> {
  final DateFormat formatter = DateFormat('yyyy.MM.dd');

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height;
    final double itemWidth = size.width * 1.3518;

    List<Widget> list = List.generate(
      100,
      (index) => Image.asset(
        index.isOdd ? "assets/preview.png" : "assets/preview2.png",
        width: size.width,
        height: size.height,
        fit: BoxFit.fill,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Title ${widget.title}"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CarouselSlider(
            items: list,
            options: CarouselOptions(
                aspectRatio: (itemWidth / itemHeight),
                viewportFraction: 1,
                enableInfiniteScroll: false),
          ),
        ],
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
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return DrawScreen(
                        path: widget.title,
                      );
                    }));
                    try {
                      //ApplicationStorage().createComicsPage(widget.title, 1, 2);
                      print(ApplicationStorage().getAllComics());
                    } catch (e) {
                      print(e);
                      Fluttertoast.showToast(msg: "error $e");
                    }
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
                          return DeleteConfirmationDialog().build(
                              context, widget.title,
                              onDelete: () => {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (context) {
                                      return const MainScreen();
                                    }), (route) => false)
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
