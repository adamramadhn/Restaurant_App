import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/api_services.dart';
import '../controller/detail_controller.dart';
import '../controller/favorite_controllert.dart';
import '../controller/home_controller.dart';
import '../controller/search_controller.dart';
import '../models/list_restaurant_response.dart';
import '../utils/notification_helper.dart';
import '../utils/static.dart';
import 'detail_page.dart';
import 'favorite_page.dart';
import 'setting_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationHelper notificationHelper = NotificationHelper();
  @override
  void initState() {
    super.initState();
    notificationHelper.configureSelectNotificationSubject(
        context, DetailPage.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  // @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'The Resto',
          style: TextStyle(color: Colors.black, fontSize: 28),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: MySearch(),
              );
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () async {
              await Get.put(FavoriteController()).getAllFavData();
              Get.to(
                () => const FavoritePage(),
              );
            },
            icon: const Icon(Icons.favorite),
          ),
          IconButton(
            onPressed: () {
              Get.to(
                () => const SettingsPage(),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: GetBuilder<HomeController>(
        init: HomeController(apiService: ApiService()),
        builder: (home) {
          if (home.stateData == ResultState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (home.stateData == ResultState.hasData) {
            final listData = home.listResto;
            return ListView.builder(
              itemCount: listData.count,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    await Get.put(FavoriteController())
                        .setId(listData.restaurants![index].id!);
                    Get.to(() => const DetailPage());
                    await Get.put(DetailController())
                        .searchResto(listData.restaurants![index].id!);
                  },
                  child: _listResto(listData, index, home),
                );
              },
            );
          } else if (home.stateData == ResultState.noData) {
            return Center(
              child: Material(
                child: Text(home.message),
              ),
            );
          } else if (home.stateData == ResultState.error) {
            return Center(
              child: Column(
                children: [
                  Text(home.message),
                  ElevatedButton(
                    onPressed: () {
                      home.getList();
                    },
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Material(
                child: Text(''),
              ),
            );
          }
        },
      ),
    );
  }

  ListTile _listResto(
      ListRestaurantResponse listData, int index, HomeController home) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      leading: _pictureResto(listData, index),
      title: Text(
        listData.restaurants?[index].name ?? '...',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: GetBuilder<FavoriteController>(
        init: FavoriteController(),
        builder: (data) {
          return _favoriteButton(data, listData, index, home);
        },
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _locationResto(listData, index),
          const SizedBox(
            height: 2,
          ),
          _ratingResto(listData, index),
        ],
      ),
    );
  }

  Row _ratingResto(ListRestaurantResponse listData, int index) {
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
            '${listData.restaurants?[index].rating ?? 0.0}',
          ),
        ),
      ],
    );
  }

  Row _locationResto(ListRestaurantResponse listData, int index) {
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
          child: FittedBox(
            child: Text(
              listData.restaurants?[index].city ?? 'something wrong..',
            ),
          ),
        ),
      ],
    );
  }

  SizedBox _pictureResto(ListRestaurantResponse listData, int index) {
    return SizedBox(
      height: 100,
      width: 100,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          '$urlPictId${listData.restaurants?[index].pictureId}',
          fit: BoxFit.cover,
          width: 100,
          errorBuilder: (context, error, stackTrace) => Text(
            error.toString(),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          loadingBuilder: (context, child, loadingProgress) => child,
        ),
      ),
    );
  }

  IconButton _favoriteButton(FavoriteController data,
      ListRestaurantResponse listData, int index, HomeController home) {
    return IconButton(
      onPressed: () {
        if (data.favId.contains(listData.restaurants![index].id!)) {
          data.removeModel(listData.restaurants![index].id!);
        } else {
          data.addModel(listData.restaurants![index]);
        }
      },
      icon: Icon(
        Icons.favorite,
        color: data.favId.contains(home.listResto.restaurants![index].id)
            ? Colors.red
            : Colors.grey,
      ),
    );
  }
}

class MySearch extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(
            Icons.clear,
            color: Colors.grey,
          ),
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
        ),
      ];
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        },
      );
  @override
  Widget buildResults(BuildContext context) => GetBuilder<SearchController>(
        init: SearchController(),
        builder: (data) {
          data.searchResto(query);
          final listData = data.listResto;
          if (data.stateData == ResultState.error) {
            return Center(
              child: Text(data.message),
            );
          } else if (data.stateData == ResultState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.stateData == ResultState.noData) {
            return Center(
              child: Text(data.message),
            );
          } else if (data.stateData == ResultState.hasData) {
            return ListView.builder(
              itemCount: listData.founded,
              itemBuilder: (context, index) {
                final suggestion = listData.restaurants?[index];
                return ListTile(
                  title: Text(suggestion?.name ?? ''),
                  onTap: () async {
                    await Get.put(DetailController())
                        .searchResto(suggestion!.id!);
                    await Get.put(FavoriteController()).setId(suggestion.id!);
                    Get.to(() => const DetailPage());
                  },
                );
              },
            );
          } else {
            return Center(
              child: Text(data.message),
            );
          }
        },
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    return GetBuilder<SearchController>(
      init: SearchController(),
      builder: (data) {
        data.searchResto(query);
        final listData = data.listResto;
        if (data.stateData == ResultState.error) {
          return Center(
            child: Text(data.message),
          );
        } else if (data.stateData == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (data.stateData == ResultState.noData) {
          return Center(
            child: Text(data.message),
          );
        } else if (data.stateData == ResultState.hasData) {
          return ListView.builder(
            itemCount: listData.founded,
            itemBuilder: (context, index) {
              final suggestion = listData.restaurants?[index];
              return ListTile(
                title: Text(suggestion?.name ?? ''),
                onTap: () async {
                  await Get.put(FavoriteController()).setId(suggestion!.id!);
                  Get.to(() => const DetailPage());
                  await Get.put(DetailController()).searchResto(suggestion.id!);
                },
              );
            },
          );
        } else {
          return Center(
            child: Text(data.message),
          );
        }
      },
    );
  }
}
