import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Captures the widget behind a [RepaintBoundary] and writes a PNG file.
class CardRenderer {
  const CardRenderer();

  Future<Uint8List?> capturePng(
    RenderRepaintBoundary boundary, {
    double pixelRatio = 3.0,
  }) async {
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  /// Writes PNG bytes to the app's documents directory under `save_cards/`.
  /// Returns the absolute path the user can find later (and, in a future
  /// share-plus integration, share).
  Future<String> writePng(Uint8List bytes) async {
    final outDir = await _ensureDir();
    final filename = 'card_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File(p.join(outDir.path, filename));
    await file.writeAsBytes(bytes);
    return file.path;
  }

  /// Removes every previously-saved card. Called by the data reset flow so
  /// "Xóa toàn bộ dữ liệu" doesn't leave derived day-lương PNGs on disk.
  Future<void> deleteAllSavedCards() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final outDir = Directory(p.join(docsDir.path, 'save_cards'));
    if (await outDir.exists()) {
      await outDir.delete(recursive: true);
    }
  }

  Future<Directory> _ensureDir() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final outDir = Directory(p.join(docsDir.path, 'save_cards'));
    if (!await outDir.exists()) {
      await outDir.create(recursive: true);
    }
    return outDir;
  }
}
