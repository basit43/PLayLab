import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/utils/my_color.dart';
import '../live_tv_grid_item/live_tv_grid_item.dart';

class AllLiveTvShimmer extends StatelessWidget {
  const AllLiveTvShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        itemCount: 40,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 4,
            childAspectRatio: 1),
        itemBuilder: (context, index){
          return  Shimmer.fromColors(
            baseColor: MyColor.textFieldColor,
            highlightColor: MyColor.textColor,
            child: LiveTvGridItem(
                liveTvName: '',
                imageUrl: '',
                press: () {

                }),
          );}
    );
  }
}