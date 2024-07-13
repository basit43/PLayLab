import 'package:flutter/material.dart';
import 'package:play_lab/core/utils/my_color.dart';
import 'package:shimmer/shimmer.dart';

class GridShimmer extends StatelessWidget {
  const GridShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        itemCount: 20,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 15,
            mainAxisSpacing: 12,
            crossAxisCount: 3,
            childAspectRatio: .55),
            itemBuilder: (context, index){

          return  Card(
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.zero,
              color: MyColor.colorBlack,
              shape: const RoundedRectangleBorder(
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                        child: Shimmer.fromColors(
                          highlightColor: MyColor.shimmerSplashColor,
                          baseColor: MyColor.shimmerBaseColor,
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: MyColor.textFieldColor,
                            ),
                          ),
                        )
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      width: 20,
                      color: MyColor.colorBlack,
                     ),
                    const Padding(padding:  EdgeInsets.only(left: 8),)
                  ]));}
    );
  }
}
