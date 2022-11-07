import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../api/api_services.dart';
import '../models/detail_response.dart';
import '../utils/static.dart';

class DetailController extends GetxController {
  DetailResponse _dataResto = DetailResponse();
  DetailResponse get dataResto => _dataResto;
  String _message = '';
  String get message => _message;
  ResultState _state = ResultState.loading;
  ResultState get stateData => _state;

  searchResto(query) async {
    try {
      _state = ResultState.loading;
      update();
      final newData = await ApiService().detailRestaurant(query);
      if (newData.error == true) {
        _state = ResultState.noData;
        _message = 'Restaurant not found';
        update();
      } else {
        _state = ResultState.hasData;
        _dataResto = newData;
        update();
      }
    } on DioError{
      _state = ResultState.error;
      _message = 'Periksa Internet Anda..';
      update();
    }
  }
}
