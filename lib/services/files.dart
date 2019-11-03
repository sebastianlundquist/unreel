import 'dart:io';

import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class Files {
  static Future<File> getLocalFile(String filename) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File f = new File('$dir/$filename');
    return f;
  }

  static void deleteImage(String imageUrl) async {
    final dir =
        Directory((await getApplicationDocumentsDirectory()).path + imageUrl);
    dir.deleteSync(recursive: true);
  }

  static Future<String> saveImageToFile(
      String imageUrl, bool isBackdrop) async {
    var fullUrl = 'https://image.tmdb.org/t/p';
    if (isBackdrop)
      fullUrl += '/w780' + imageUrl;
    else
      fullUrl += '/w300' + imageUrl;
    var response = await get(fullUrl);
    String documentsDirectory = (await getApplicationDocumentsDirectory()).path;
    File file = new File(documentsDirectory + imageUrl);
    file.writeAsBytesSync(response.bodyBytes);
    return file.path;
  }
}
