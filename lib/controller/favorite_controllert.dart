import 'package:get/get.dart';

import '../db/favorite_database.dart';
import '../models/detail_response.dart';
import '../models/favorite_model.dart';

class FavoriteController extends GetxController {
  List<FavRestoModel>? _fav;
  List<FavRestoModel> get fav => _fav ?? [];
  final List<String> _favId = [];
  List<String> get favId => _favId;

  String _id = 'kosong';
  String get id => _id;
  FavoriteController() {
    getAllFavData();
  }

  setId(String data) {
    _id = data;
    update();
  }

  getAllFavData() async {
    final data = await FavDatabase.instance.readAllFavorite();
    _favId.clear();
    if (data != null) {
      _fav = data;
      for (int i = 0; i < data.length; i++) {
        _favId.add(data[i].idResto!);
      }
      update();
    } else {
      _fav = [];
      update();
    }
  }

  addModel(Restaurant data) async {
    _favId.add(data.id!);
    final newData = FavRestoModel(
        idResto: data.id,
        restoName: data.name,
        city: data.city,
        rating: data.rating.toString(),
        urlPic: data.pictureId);
    await FavDatabase.instance.create(newData);
    await getAllFavData();
  }

  removeModel(String data) async {
    _favId.remove(data);
    await FavDatabase.instance.delete(data);
    await getAllFavData();
  }
}
