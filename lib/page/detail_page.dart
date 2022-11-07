import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app_api/common/styles.dart';

import '../controller/detail_controller.dart';
import '../controller/favorite_controllert.dart';
import '../controller/review_controller.dart';
import '../utils/static.dart';
import 'package:restaurant_app_api/models/detail_response.dart';

class DetailPage extends StatelessWidget {
  static const routeName = '/detail';

  const DetailPage({super.key});
  @override
  Widget build(BuildContext context) {
    final id = Get.put(FavoriteController()).id;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Restaurant',
          style: TextStyle(color: Colors.black),
        ),
        actions: [_favButton(id)],
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: GetBuilder<DetailController>(
        init: DetailController(),
        builder: (data) {
          if (data.stateData == ResultState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.stateData == ResultState.hasData) {
            final dataResto = data.dataResto;
            return SingleChildScrollView(
              child: Column(
                children: [
                  _pictureResto(dataResto),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _headLine(dataResto, data, id),
                        const SizedBox(
                          height: 10,
                        ),
                        _restoLocation(dataResto),
                        const SizedBox(
                          height: 5,
                        ),
                        _restoRating(dataResto),
                        const SizedBox(
                          height: 10,
                        ),
                        _descriptionResto(dataResto),
                        const SizedBox(
                          height: 10,
                        ),
                        _foods(dataResto),
                        const SizedBox(
                          height: 10,
                        ),
                        _drinks(dataResto),
                        const SizedBox(
                          height: 10,
                        ),
                        _reviews(dataResto),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (data.stateData == ResultState.noData) {
            return Center(
              child: Material(
                child: Text(data.message),
              ),
            );
          } else if (data.stateData == ResultState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(data.message),
                  ElevatedButton(
                    onPressed: () {
                      data.searchResto(id);
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

  Row _headLine(DetailResponse dataResto, DetailController data, String id) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 5,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              dataResto.restaurant?.name ?? 'something wrong',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                late TextEditingController txtName;
                late TextEditingController txtReview;
                final formLogin = GlobalKey<FormState>();
                txtName = TextEditingController();
                txtReview = TextEditingController();
                reviewBottomSheet(
                    formLogin, txtName, txtReview, dataResto, data, id);
              },
              child: Row(
                children: const [
                  Icon(
                    Icons.add,
                    color: Colors.green,
                  ),
                  Text(
                    'Add Review',
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  FittedBox _favButton(String id) {
    return FittedBox(
      child: GetBuilder<FavoriteController>(
        init: FavoriteController(),
        builder: (data) {
          final resto = Get.put(DetailController()).dataResto;
          return IconButton(
            onPressed: () {
              if (data.favId.contains(id)) {
                data.removeModel(id);
              } else {
                data.addModel(resto.restaurant!);
              }
            },
            icon: Icon(
              Icons.favorite,
              color: data.favId.contains(id) ? Colors.red : Colors.grey,
            ),
          );
        },
      ),
    );
  }

  ClipRRect _pictureResto(DetailResponse dataResto) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      child: Image.network(
        '$urlPictLargeId${dataResto.restaurant?.pictureId}',
        errorBuilder: (context, error, stackTrace) => const Text(
          "Periksa jaringan anda..",
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        loadingBuilder: (context, child, loadingProgress) => child,
      ),
    );
  }

  Column _reviews(DetailResponse dataResto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Reviews",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          height: Get.height * 0.15,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dataResto.restaurant?.customerReviews?.length ?? 0,
            itemBuilder: (context, index) {
              final data = dataResto.restaurant?.customerReviews?[index];
              return Container(
                width: Get.width * 0.8,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _reviewsList(data!.name, data.review, data.date),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Column _drinks(DetailResponse dataResto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Drinks",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        drinkList(dataResto),
      ],
    );
  }

  Column _foods(DetailResponse dataResto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Foods",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        foodList(dataResto),
      ],
    );
  }

  Column _descriptionResto(DetailResponse dataResto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        Text(
          dataResto.restaurant?.description ?? 'Something wrong',
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Row _restoRating(DetailResponse dataResto) {
    return Row(
      children: [
        const Icon(
          Icons.star,
          size: 20,
          color: Colors.yellow,
        ),
        Text(
          dataResto.restaurant?.rating?.toString() ?? '..',
        ),
      ],
    );
  }

  Row _restoLocation(DetailResponse dataResto) {
    return Row(
      children: [
        const Icon(
          Icons.location_pin,
          size: 20,
          color: Colors.green,
        ),
        Text(
          dataResto.restaurant?.city ?? 'something wrong..',
        ),
      ],
    );
  }

  reviewBottomSheet(
      GlobalKey<FormState> formLogin,
      TextEditingController txtName,
      TextEditingController txtReview,
      DetailResponse dataResto,
      DetailController data,
      String id) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          height: Get.height * 0.4,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formLogin,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Review Restaurant',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'this field must be filled!';
                        }
                        return null;
                      },
                      controller: txtName,
                      decoration: const InputDecoration(
                        hintText: 'Input your name..',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'this field must be filled!';
                        }
                        return null;
                      },
                      controller: txtReview,
                      decoration: const InputDecoration(
                        hintText: 'Your review..',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      width: Get.width * 0.5,
                      child: ElevatedButton(
                        style: buttonPrimary,
                        onPressed: () async {
                          final revC = Get.put(ReviewController());
                          final isValidForm =
                              formLogin.currentState!.validate();
                          if (isValidForm) {
                            revC
                                .revResto(dataResto.restaurant?.id ?? '',
                                    txtName.text, txtReview.text)
                                .then(
                              (value) async {
                                Get.back();
                                await data.searchResto(id);

                                Get.snackbar(
                                    'Yeay!', 'Berhasil mereview restoran!',
                                    colorText: Colors.white,
                                    duration: const Duration(seconds: 3),
                                    backgroundColor: Colors.green);
                              },
                              onError: (e) {
                                Get.back();
                                Get.snackbar('Oops!', 'Terjadi Kesalahan!\n$e',
                                    colorText: Colors.black,
                                    duration: const Duration(seconds: 3),
                                    backgroundColor: Colors.grey);
                              },
                            );
                          } else {
                            Get.snackbar(
                                'Oops!', 'Lengkapi form terlebih dahulu!',
                                colorText: Colors.white,
                                duration: const Duration(seconds: 3),
                                backgroundColor: Colors.red);
                          }
                        },
                        child: const Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      width: Get.width * 0.5,
                      child: ElevatedButton(
                        style: buttonPrimary,
                        onPressed: () {
                          txtName.dispose();
                          txtReview.dispose();
                          Get.back();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox foodList(DetailResponse dataResto) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dataResto.restaurant?.menus?.foods?.length ?? 0,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Text(
                dataResto.restaurant?.menus?.foods?[index].name ??
                    'something wrong',
                maxLines: 2,
                overflow: TextOverflow.clip,
              ),
            ),
          );
        },
      ),
    );
  }

  SizedBox drinkList(DetailResponse dataResto) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dataResto.restaurant?.menus?.drinks?.length ?? 0,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Text(
                dataResto.restaurant?.menus?.drinks?[index].name ??
                    'something wrong',
                maxLines: 2,
                overflow: TextOverflow.clip,
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _reviewsList(String? nama, String? review, String? date) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 1,
        child: FittedBox(
          child: Text(
            nama ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            maxLines: 2,
            overflow: TextOverflow.clip,
          ),
        ),
      ),
      Expanded(
        flex: 1,
        child: Text(
          date ?? '',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
          maxLines: 2,
          overflow: TextOverflow.clip,
        ),
      ),
      Expanded(
        flex: 2,
        child: Text(
          review ?? '',
          maxLines: 2,
          overflow: TextOverflow.clip,
        ),
      )
    ],
  );
}
