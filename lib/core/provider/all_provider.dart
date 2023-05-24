import 'package:get/get.dart';

class AllProvider extends GetConnect {
  static String urlBase = "https://plantrip.theaterify.id/public/";
  static String tokenAPI = 'bf939db2c3060b988389d1aecbe18aefb7ee6ff4';

  Future<Response?>? pushResponse(final String path, final String encoded) =>
      post(
        urlBase + path,
        encoded,
        contentType: 'application/json; charset=UTF-8',
        headers: {
          'X-Authentication': tokenAPI,
          'Content-type': 'application/json',
        },
      ).timeout(const Duration(seconds: 210));
}
