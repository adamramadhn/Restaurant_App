import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../api/api_services.dart';
import '../models/list_restaurant_response.dart';
import '../utils/static.dart';

import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  final ApiService apiService;
  ListRestaurantResponse _listResto = ListRestaurantResponse();
  ListRestaurantResponse get listResto => _listResto;
  String _message = '';
  String get message => _message;
  late ResultState _state;
  ResultState get stateData => _state;

  HomeController({required this.apiService}) {
    getList();
  }

  getList() async {
    try {
      _state = ResultState.loading;
      update();
      final dataResto = await ApiService().listRestaurant();
      if (dataResto.restaurants!.isEmpty) {
        _state = ResultState.noData;
        _message = 'Empty Data';
        update();
      } else {
        _state = ResultState.hasData;
        _listResto = dataResto;
        update();
      }
    } on DioError {
      _state = ResultState.error;
      update();
      _message = 'Periksa Internet Anda..';
    }
  }

  Future<ListRestaurantResponse> getListHttp(http.Client client) async {
    final response =
        await client.get(Uri.parse('https://restaurant-api.dicoding.dev/list'));

    if (response.statusCode == 200) {
      return ListRestaurantResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load resto');
    }
  }
}
