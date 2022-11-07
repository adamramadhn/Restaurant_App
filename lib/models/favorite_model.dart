const String tableFav = 'fav';

class FavoriteFields {
  static final List<String> values = [idDB, idResto, restoName, city, rating];
  static const String idDB = '_id';
  static const String idResto = 'idResto';
  static const String restoName = 'restoName';
  static const String city = 'city';
  static const String rating = 'rating';
  static const String url = 'urlPic';
}

class FavRestoModel {
  final int? idDB;
  final String? idResto;
  final String? restoName;
  final String? city;
  final String? rating;
  final String? urlPic;

  const FavRestoModel({
    this.idDB,
    this.idResto,
    this.urlPic,
    this.restoName,
    this.city,
    this.rating,
  });

  FavRestoModel copy({
    int? idDb,
    String? idR,
    String? title,
    String? description,
    String? createdTime,
    String? url,
  }) =>
      FavRestoModel(
          idDB: idDb ?? idDB,
          idResto: idR ?? idResto,
          restoName: title ?? restoName,
          city: description ?? city,
          rating: createdTime ?? rating,
          urlPic: url ?? urlPic);

  Map<String, Object?> toJson() => {
        FavoriteFields.idResto: idResto,
        FavoriteFields.idDB: idDB,
        FavoriteFields.restoName: restoName,
        FavoriteFields.city: city,
        FavoriteFields.rating: rating,
        FavoriteFields.url: urlPic,
      };

  static FavRestoModel fromJson(Map<String, Object?> json) => FavRestoModel(
      idDB: json[FavoriteFields.idDB] as int?,
      idResto: json[FavoriteFields.idResto] as String?,
      restoName: json[FavoriteFields.restoName] as String?,
      city: json[FavoriteFields.city] as String?,
      rating: json[FavoriteFields.rating] as String?,
      urlPic: json[FavoriteFields.url] as String?);
}
