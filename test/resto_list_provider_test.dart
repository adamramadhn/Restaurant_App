// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:restaurant_app_api/api/api_services.dart';
import 'package:restaurant_app_api/controller/home_controller.dart';
import 'package:restaurant_app_api/models/list_restaurant_response.dart';

import 'resto_list_provider_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('Testing API List Resto', () {
    test('List Resto Check', () async {
      final client = MockClient();

      when(client.get(Uri.parse('https://restaurant-api.dicoding.dev/list')))
          .thenAnswer((_) async => http.Response(
              '{"error": false,"message": "success","count": 20,"restaurants": []}',
              200));

      expect(
          await Get.put(HomeController(apiService: ApiService()))
              .getListHttp(client),
          isA<ListRestaurantResponse>());
    });
  });
}
