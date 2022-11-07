import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../api/api_services.dart';
import '../models/search_response.dart';
import '../utils/static.dart';

class SearchController extends GetxController {
  SearchResponse _listResto = SearchResponse();
  SearchResponse get listResto => _listResto;
  String _message = '';
  String get message => _message;
  ResultState _state = ResultState.loading;
  ResultState get stateData => _state;
  changeState(ResultState state) {
    _state = state;
    update();
  }

  Future searchResto(query) async {
    try {
      final data = {'q': query};
      final dataResto = await ApiService().searchRestaurant(data);
      if (dataResto.restaurants!.isEmpty) {
        changeState(ResultState.noData);
        return _message = 'Empty Data';
      } else {
        changeState(ResultState.hasData);
        return _listResto = dataResto;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.sendTimeout) {
        changeState(ResultState.error);
        return _message = 'Request Time Out';
      } else {
        changeState(ResultState.error);
        return _message = 'Periksa internet anda..';
      }
    } catch (e) {
      changeState(ResultState.error);
      return _message = 'other error -> $e';
    }
  }
}
