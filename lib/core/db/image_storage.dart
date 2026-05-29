import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageStorage {
  const ImageStorage();

  Future<String> saveCrushImage(String cardId, XFile source) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final imageDir = Directory(p.join(documentsDir.path, 'crush_images'));
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }

    final targetPath = p.join(imageDir.path, '$cardId.jpg');
    final compressed = await FlutterImageCompress.compressAndGetFile(
      source.path,
      targetPath,
      quality: 70,
      minWidth: 1280,
      minHeight: 1280,
      format: CompressFormat.jpeg,
    );

    if (compressed == null) {
      await source.saveTo(targetPath);
    }

    return targetPath;
  }

  Future<void> deleteImage(String imagePath) async {
    final file = File(imagePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> deleteAllImages() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final imageDir = Directory(p.join(documentsDir.path, 'crush_images'));
    if (await imageDir.exists()) {
      await imageDir.delete(recursive: true);
    }
  }
}
