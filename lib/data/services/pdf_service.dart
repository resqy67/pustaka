import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

Future<String> downloadPdf(String bookUuid, String url) async {
  var dio = Dio();
  var dir = await getApplicationDocumentsDirectory();
  String filePath = '${dir.path}/book_$bookUuid.pdf';

  // Check if the file already exists
  if (await File(filePath).exists()) {
    print('File already exists');
    return filePath;
  }

  await dio.download(url, filePath);
  return filePath;
}
