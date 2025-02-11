import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:techarrow_mobile/screens/util/pick_image.dart';
import 'package:techarrow_mobile/screens/util/storage.dart';

class CreateComicsScreen extends StatefulWidget {
  const CreateComicsScreen({super.key});

  @override
  State<CreateComicsScreen> createState() => _CreateComicsScreenState();
}

class _CreateComicsScreenState extends State<CreateComicsScreen> {
  final TextEditingController _controller = TextEditingController();
  Uint8List? bytesImage;
  final Storage _storage = Storage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Создать комикс"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Введите название комикса"),
            TextField(
              controller: _controller,
              textAlign: TextAlign.center,
            ),
            bytesImage != null ? Image.memory(bytesImage!) : Spacer(),
            OutlinedButton(
                onPressed: () {
                  pick().then((value) {
                    setState(() {
                      bytesImage = value;
                    });
                  });
                },
                child: const Text("Выберите обложку комикса")),
            OutlinedButton(
              onPressed: () async {
                String title = _controller.text;
                if (title.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Название не может быть пустым!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else if (bytesImage == null) {
                  Fluttertoast.showToast(
                      msg: "Выберите обложку для комикса!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  _storage.createComics(title, bytesImage!)
                    ..then((value) {
                      Navigator.of(context).pop();
                    })
                    ..onError((e, _) {
                      Fluttertoast.showToast(
                          msg: e.toString(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    });
                }
              },
              child: const Text("Создать!"),
            ),
          ],
        ),
      ),
    );
  }
}
