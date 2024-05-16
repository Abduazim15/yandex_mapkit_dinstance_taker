import 'package:dio/dio.dart';

class DistanceService{
  Future<double> getDistance(double latitude, double longitude, String bearerToken) async {
    final url = 'https://quiz.4fun.uz/get_distance/';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken',
    };
    final data = {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
    };

    try {
      final dio = Dio();
      final response = await dio.post(
        url,
        options: Options(headers: headers),
        data: data,
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final message = responseData['message'] as double;
        return message;
      } else {
        print('Request failed with status code: ${response.statusCode}');
        return 0;
      }
    } catch (error) {
      print('Request error: $error');
      return 0;
    }
  }
}