import 'dart:io';

import 'package:dio/dio.dart';
import 'package:restaurant_app_api/models/review_response.dart';

import '../models/detail_response.dart';
import '../models/list_restaurant_response.dart';
import '../models/search_response.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  static const String _searchUrl = 'search';
  static const String _listUrl = 'list';
  static const String _detailUrl = 'detail/';
  static const String _reviewlUrl = 'review';
  Dio dioApi() {
    BaseOptions options = BaseOptions(
      baseUrl: _baseUrl,
      headers: {
        // "x-api-key": ApiUrl.apiKey,
        HttpHeaders.contentTypeHeader: "application/json",
      },
      responseType: ResponseType.json,
    );
    final dio = Dio(options);
    return dio;
  }

  Future<ListRestaurantResponse> listRestaurant() async {
    final dio = dioApi();
    final response = await dio.get(_listUrl);
    if (response.statusCode == 200) {
      return ListRestaurantResponse.fromJson(
        response.data,
      );
    } else {
      throw Exception('Failed to load List Restaurant');
    }
  }

  Future<SearchResponse> searchRestaurant(Map<String, dynamic> query) async {
    final dio = dioApi();
    final response = await dio.get(_searchUrl, queryParameters: query);
    if (response.statusCode == 200) {
      return SearchResponse.fromJson(
        response.data,
      );
    } else {
      throw Exception('Failed to search List Restaurant');
    }
  }

  Future<DetailResponse> detailRestaurant(query) async {
    final dio = dioApi();
    final response = await dio.get('$_detailUrl$query');
    if (response.statusCode == 200) {
      return DetailResponse.fromJson(
        response.data,
      );
    } else {
      throw Exception('Failed to get detail Restaurant');
    }
  }

  Future<ReviewResponse> reviewRestaurant(query) async {
    final dio = dioApi();
    final response = await dio.post(_reviewlUrl, data: query);
    if (response.statusCode == 201) {
      return ReviewResponse.fromJson(
        response.data,
      );
    } else {
      throw Exception('Failed to Review Restaurant');
    }
  }
}
