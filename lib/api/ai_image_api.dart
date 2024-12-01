import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<String?> downloadImage(String imageUrl) async {
  // Fetching the image from the URL
  final response = await http.get(Uri.parse(imageUrl));

  if (response.statusCode == 200) {
    // Getting the directory to save the image
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/image.jpg';

    // Writing the content to a file named 'image.jpg'
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    // Logging completion message
    return filePath;
  } else {
    return null;
  }
}

String generateImageUrl({
  required String prompt,
  required int width,
  required int height,
  required int seed,
  String model = 'flux',
}) {
  return 'https://pollinations.ai/p/$prompt?width=$width&height=$height&seed=$seed&model=$model';
}
