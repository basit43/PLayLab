import 'package:flutter/material.dart';
import '../../../constants/my_strings.dart';
import '../../../core/utils/my_color.dart';
import '../../components/app_bar/custom_appbar.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.secondaryColor,
      appBar: const CustomAppBar(
        title: MyStrings.products,
        isShowBackBtn: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 120,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              margin: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: MyColor.cardBg,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 120,
                        width: 110,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius
                              .circular(8.0), topLeft: Radius.circular(8.0),),
                          color: Colors.black,
                          image: DecorationImage(image: AssetImage("assets/images/onboarding_bg.jpg"), fit: BoxFit.cover)
                        ),
                      ),
                      const SizedBox(width: 20.0,),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Books",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 15.0,),
                          Text(
                            "test",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 15.0,),
                          Text(
                            "\$/500",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 19.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, right: 10.0),
                        child: Row(
                          children: [
                            Container(
                              height: 23,
                              width: 23,
                              decoration: BoxDecoration(
                                color: MyColor.closeRedColor,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: const Icon(Icons.remove, color: MyColor.t1, size: 20,),
                            ),
                            const SizedBox(width: 10.0,),
                            const Text(
                              "1",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 10.0,),
                            Container(
                              height: 23,
                              width: 23,
                              decoration: BoxDecoration(
                                color: MyColor.greenSuccessColor,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: const Icon(Icons.add, color: MyColor.t1, size: 20,),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, right: 10.0),
                        child: MaterialButton(
                          onPressed: (){},
                          color: MyColor.secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: const Text(
                            "ADD TO CART",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
