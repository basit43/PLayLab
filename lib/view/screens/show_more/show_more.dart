import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/helper/string_format_helper.dart';
import '../../../core/route/route.dart';
import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';
import '../../../data/model/new_categorymodel/new_categorymodel_class.dart';
import '../movie_details/widget/rating_and_watch_widget/RatingAndWatchWidget.dart';

class ShowMoreScreen extends StatefulWidget {
  final List? moreItems;
  final String categoryName;

  const ShowMoreScreen({
    Key? key,
    required this.moreItems,
    required this.categoryName,
  }) : super(key: key);

  @override
  State<ShowMoreScreen> createState() => _ShowMoreScreenState();
}

class _ShowMoreScreenState extends State<ShowMoreScreen> {
  int itemsPerPage = 5; // Number of items per page
  int currentPage = 1; // Current page number, starting from 1

  @override
  Widget build(BuildContext context) {
    String landScapePath = 'assets/images/item/portrait/';
    String baseUrl = 'https://playnow.sadgurushririteshwarji.com/';

    // Calculate the start and end index for the current page
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    List<Items>? currentPageItems = (widget.moreItems as List<Items>?)
        ?.sublist(startIndex, endIndex.clamp(0, widget.moreItems!.length));

    return Scaffold(
      backgroundColor: MyColor.secondaryColor,
      appBar: AppBar(
        backgroundColor: MyColor.secondaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.categoryName,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: currentPageItems?.length ?? 0,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 16, top: 8),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteHelper.movieDetailsScreen,
                          arguments: [currentPageItems![index].id, -1]);
                    },
                    child: CachedNetworkImage(
                      imageUrl:
                          '$baseUrl$landScapePath${currentPageItems![index].image!.portrait.toString()}',
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                      width: 120,
                      height: 140,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentPageItems![index].title.toString(),
                          softWrap: true,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 4),
                        RatingAndWatchWidget(
                          textColor: MyColor.primaryText2,
                          iconSpace: 4,
                          rating: CustomValueConverter
                              .twoDecimalPlaceFixedWithoutRounding(
                            currentPageItems[index].ratings ?? '0',
                          ),
                          watch: CustomValueConverter
                              .twoDecimalPlaceFixedWithoutRounding(
                            currentPageItems[index].view.toString() ?? '0',
                            precision: 0,
                          ),
                          iconSize: 14,
                          textSize: Dimensions.fontExtraSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: MyColor.secondaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: currentPage > 1
                  ? () {
                      setState(() {
                        currentPage--;
                      });
                    }
                  : null,
            ),
            Text(
              'Page $currentPage',
              style: const TextStyle(color: Colors.white),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              color: Colors.white,
              onPressed:
                  currentPage < (widget.moreItems!.length / itemsPerPage).ceil()
                      ? () {
                          setState(() {
                            currentPage++;
                          });
                        }
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}
