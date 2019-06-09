import 'dart:io';

import 'package:path_provider/path_provider.dart';


class StorageUtility {
  static Future<File> getLocalFile(String filePath, {String extension: FileExtension.TXT}) async {
    final path = (await getApplicationDocumentsDirectory()).path;
    return File('$path/$filePath.$extension');
  }
}

class FileExtension {
  static const TXT = "txt";
}