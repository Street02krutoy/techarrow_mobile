import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:techarrow_mobile/screens/draw/draw_screen.dart';

class ComicsScreen extends StatefulWidget {
  const ComicsScreen({super.key, required this.id});
  final String id;

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
        title: Text("Title ${widget.id}"),
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
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.edit),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return DrawScreen();
            }));
          }),
    );
  }
}
