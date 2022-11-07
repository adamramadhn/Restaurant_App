import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../api/api_services.dart';
import '../models/review_response.dart';
import '../utils/static.dart';

class ReviewController extends GetxController {
  ReviewResponse _reviewResto = ReviewResponse();
  ReviewResponse get reviewResto => _reviewResto;
  String _message = '';
  String get message => _message;
  late ResultState _state;
  ResultState get stateData => _state;
  static ReviewController get to => Get.find();
  Future revResto(String idResto, String nama, String review) async {
    try {
      final Map<String, dynamic> query = {
        "id": idResto,
        "name": nama,
        "review": review
      };

      _state = ResultState.loading;
      update();
      final newData = await ApiService().reviewRestaurant(query);
      if (newData.error == true) {
        _state = ResultState.noData;
        update();
        return _message = 'Unable to review';
      } else {
        _state = ResultState.hasData;
        update();
        return _reviewResto = newData;
      }
    } on DioError {
      _state = ResultState.error;
      update();
      return _message = 'Periksa Internet Anda..';
    }
  }
}
