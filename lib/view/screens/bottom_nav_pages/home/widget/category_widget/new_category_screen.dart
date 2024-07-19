import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:play_lab/core/utils/my_color.dart';
import 'package:play_lab/view/screens/show_more/show_more.dart';
import '../../../../../../core/helper/string_format_helper.dart';
import '../../../../../../core/route/route.dart';
import '../../../../../../core/utils/dimensions.dart';
import '../../../../../../data/controller/newcategory_controller/new_category_controller_screen.dart';
import '../../../../../../data/model/new_categorymodel/new_categorymodel_class.dart';
import '../../../../movie_details/widget/rating_and_watch_widget/RatingAndWatchWidget.dart'; // Import the package

class CategoryScreen extends StatelessWidget {
  final NewCategoryController categoryController =
      Get.put(NewCategoryController());

  @override
  Widget build(BuildContext context) {
    String landScapePath = 'assets/images/item/portrait/';
    String baseUrl = 'https://playnow.sadgurushririteshwarji.com/';
    return Scaffold(
      backgroundColor: MyColor.secondaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(() {
            if (categoryController.categories.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: categoryController.categories.map((category) {
                  print('name of category ${category.name}');
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                category.name.toString(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ShowMoreScreen(
                                                  moreItems: category.items,
                                                  categoryName: category.name!,
                                                )));
                                  },
                                  child: const Text(
                                    'Show More',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ]),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      SizedBox(
                        height: 190,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: category.items?.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (index >= 4) {
                              return const SizedBox.shrink();
                            }
                            Items item = category.items![index];
                            print(
                                "Chinto $baseUrl$landScapePath${item.image!.portrait.toString()}");
                            return Container(
                              width: 120,
                              height: 150,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(
                                          RouteHelper.movieDetailsScreen,
                                          arguments: [
                                            item.id,
                                            // index,
                                            -1
                                          ]);
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          '$baseUrl$landScapePath${item.image!.portrait.toString()}',
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      fit: BoxFit.cover,
                                      width: 120,
                                      height: 140,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(item.title.toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis),
                                  SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: RatingAndWatchWidget(
                                        textColor: MyColor.primaryText2,
                                        iconSpace: 4,
                                        rating: CustomValueConverter
                                            .twoDecimalPlaceFixedWithoutRounding(
                                                item.ratings ?? '0'),
                                        watch: CustomValueConverter
                                            .twoDecimalPlaceFixedWithoutRounding(
                                                item.view.toString() ?? '0',
                                                precision: 0),
                                        iconSize: 14,
                                        textSize: Dimensions.fontExtraSmall,
                                      ))
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }).toList(),
              );
            }
          }),
        ),
      ),
    );
  }
}
