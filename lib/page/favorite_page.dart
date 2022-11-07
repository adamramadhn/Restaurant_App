import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/detail_controller.dart';
import '../controller/favorite_controllert.dart';
import '../models/favorite_model.dart';
import '../utils/static.dart';
import 'detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Restaurant'),
      ),
      body: GetBuilder<FavoriteController>(
        init: FavoriteController(),
        builder: (data) {
          if (data.fav.isNotEmpty) {
            final listData = data.fav;
            return ListView.builder(
              itemCount: data.fav.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    await Get.put(FavoriteController())
                        .setId(listData[index].idResto!);
                    Get.to(() => const DetailPage());
                    await Get.put(DetailController())
                        .searchResto(listData[index].idResto);
                  },
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    leading: _picResto(data, index),
                    title: Text(
                      data.fav[index].restoName ?? '...',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: _favoriteButton(listData, index),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _locationResto(data, index),
                        const SizedBox(
                          height: 2,
                        ),
                        _ratingResto(data, index),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('Empty'),
            );
          }
        },
      ),
    );
  }

  SizedBox _picResto(FavoriteController data, int index) {
    return SizedBox(
                    height: 100,
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        '$urlPictId${data.fav[index].urlPic}',
                        fit: BoxFit.cover,
                        width: 100,
                        errorBuilder: (context, error, stackTrace) =>
                            const Text(
                          'Unable to load..',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        loadingBuilder: (context, child, loadingProgress) =>
                            child,
                      ),
                    ),
                  );
  }

  Row _ratingResto(FavoriteController data, int index) {
    return Row(
                        children: [
                          const Flexible(
                            child: Icon(
                              Icons.star,
                              size: 20,
                              color: Colors.yellow,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              '${data.fav[index].rating ?? 0.0}',
                            ),
                          ),
                        ],
                      );
  }

  Row _locationResto(FavoriteController data, int index) {
    return Row(
                        children: [
                          const Flexible(
                            child: Icon(
                              Icons.location_pin,
                              size: 20,
                              color: Colors.green,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              data.fav[index].city ?? 'something wrong..',
                            ),
                          ),
                        ],
                      );
  }

  GetBuilder<FavoriteController> _favoriteButton(List<FavRestoModel> listData, int index) {
    return GetBuilder<FavoriteController>(
                    init: FavoriteController(),
                    builder: (data) {
                      return IconButton(
                        onPressed: () {
                          data.removeModel(listData[index].idResto!);
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: data.fav.contains(listData[index])
                              ? Colors.red
                              : Colors.grey,
                        ),
                      );
                    },
                  );
  }
}
