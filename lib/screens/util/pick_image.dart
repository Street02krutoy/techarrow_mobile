import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

final ImagePicker _picker = ImagePicker();

Future<Uint8List?> pick() async {
  XFile? file = await _picker.pickImage(source: ImageSource.gallery);
  if (file == null) return null;

  Uint8List bytes = await file.readAsBytes();
  return bytes;
}
