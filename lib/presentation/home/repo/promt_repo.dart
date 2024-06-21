import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';

class PromptRepo {
  static Future<Uint8List?> generateImage(String prompt) async {
    try {
      final dio = Dio();
      const String url =
          'https://api.vyro.ai/v1/imagine/api/generations'; //Imagine api dont change this

      final Map<String, dynamic> headers = {
        'Authorization':
            'Bearer vk-KiB9PSH8C94bqMFeG1DQbSV332dAh5OGX4rMX8Vj429ypY' //Imagine api key change when your imagine free credit is finished
      };

      final Map<String, dynamic> payload = {
        'prompt': prompt,
        'style_id': '33',
        'aspect_ratio': '1:1',
        'high_res_results': '1'
      };
      FormData formData = FormData.fromMap(payload);
      dio.options =
          BaseOptions(headers: headers, responseType: ResponseType.bytes);
      final response = await dio.post(url, data: formData);

      if (response.statusCode == 200) {
        final bytes = response.data;
        Uint8List uint8list = Uint8List.fromList(bytes);

        return uint8list;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
