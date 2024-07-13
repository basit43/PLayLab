
import 'dart:convert';
import 'package:get/get.dart';
import 'package:play_lab/data/model/wishlist_model/add_in_wishlist_response_model.dart';
import 'package:play_lab/data/model/wishlist_model/wish_list_response_model.dart';
import 'package:play_lab/data/repo/wish_list_repo/wish_list_repo.dart';
import 'package:play_lab/view/components/show_custom_snackbar.dart';
import '../../../core/utils/url_container.dart';
import '../../../shared_preference_class.dart';
import '../../model/global/response_model/response_model.dart';
import 'package:http/http.dart' as http;

// class WishListController extends GetxController {
//
//   WishListRepo repo;
//   WishListController({required this.repo});
//
//
//   String? nextPageUrl;
//   bool isLoading=true;
//   List<Data>wishlist=[];
//   String portraitImagePath='';
//
//
//
//   int page = 0;
//
// // Modify fetchInitialWishlist and fetchNewWishlist to handle errors
// //   void fetchInitialWishlist() async {
// //     try {
// //       print("WishList");
// //       updateStatus(true);
// //       page = 1; //page+1;
// //       ResponseModel model = await repo.getWishList(page);
// //       print("WishResponse ${model.statusCode}");
// //
// //       if (model.statusCode == 200) {
// //         WishlistResponseModel responseModel =
// //         WishlistResponseModel.fromJson(jsonDecode(model.responseJson));
// //         List<Data>? tempWishList = responseModel.data?.wishlists?.data;
// //         print("tempWishList ${tempWishList!.length}");
// //         portraitImagePath = 'assets/images/item/portrait/';
// //         nextPageUrl = responseModel.data?.wishlists?.nextPageUrl;
// //
// //         if (tempWishList != null && tempWishList.isNotEmpty) {
// //           if (page == 1) wishlist.clear();
// //           wishlist.addAll(tempWishList);
// //         }
// //       } else {
// //         // Handle error response here
// //         // For example, show a snackbar with an error message
// //         // You can also set a flag to indicate an error state and handle it in the UI
// //         // showErrorSnackBar('Failed to fetch wishlist. Please try again.');
// //       }
// //     } catch (e) {
// //       print("Error fetching wishlist: $e");
// //       // Handle exception here
// //       // For example, show a snackbar with an error message
// //       // showErrorSnackBar('An unexpected error occurred. Please try again later.');
// //     } finally {
// //       updateStatus(false);
// //     }
// //   }
//
//
//   void fetchInitialWishlist() async {
//     try {
//       print("WishList");
//       updateStatus(true);
//       page = 1; //page+1;
//       ResponseModel model = await repo.getWishList(page);
//       print("WishResponse ${model.statusCode}");
//
//       if (model.statusCode == 200) {
//         print("responseJson ${model.responseJson}");
//         WishlistResponseModel responseModel = WishlistResponseModel.fromJson(model.responseJson);
//         List<Data>? tempWishList = responseModel.data?.wishlists?.data;
//
//         print("codebase $tempWishList");
//
//         if (tempWishList != null && tempWishList.isNotEmpty) {
//           portraitImagePath = 'assets/images/item/portrait/';
//           nextPageUrl = responseModel.data?.wishlists?.nextPageUrl;
//           wishlist.addAll(tempWishList);
//         } else {
//           // Handle case where no wishlist items are returned
//         }
//       } else {
//         // Handle error response here
//       }
//     } catch (e) {
//       print("Error fetching wishlist: $e");
//       // Handle exception here
//       // For example, show a snackbar with an error message
//       // showErrorSnackBar('An unexpected error occurred. Please try again later.');
//     } finally {
//       updateStatus(false);
//     }
//   }
//
//
//   void fetchNewWishlist() async {
//     try {
//       page = page + 1;
//       ResponseModel model = await repo.getWishList(page);
//
//       if (model.statusCode == 200) {
//         WishlistResponseModel responseModel = WishlistResponseModel.fromJson(jsonDecode(model.responseJson));
//         List<Data>? tempWishList = responseModel.data?.wishlists?.data;
//
//         if (tempWishList != null && tempWishList.isNotEmpty) {
//           portraitImagePath = 'assets/images/item/portrait/';
//           nextPageUrl = responseModel.data?.wishlists?.nextPageUrl;
//           wishlist.addAll(tempWishList);
//         } else {
//           // Handle case where no new wishlist items are returned
//         }
//         update();
//       } else {
//         // Handle error response here
//         // showErrorSnackBar('Failed to fetch new wishlist items. Please try again.');
//       }
//     } catch (e) {
//       print("Error fetching new wishlist: $e");
//       // Handle exception here
//       // showErrorSnackBar('An unexpected error occurred. Please try again later.');
//     }
//   }
//
//
//
//   // void fetchNewWishlist() async {
//   //   try {
//   //     page = page + 1;
//   //     ResponseModel model = await repo.getWishList(page);
//   //
//   //     if (model.statusCode == 200) {
//   //       WishlistResponseModel responseModel =
//   //       WishlistResponseModel.fromJson(jsonDecode(model.responseJson));
//   //       List<Data>? tempWishList = responseModel.data?.wishlists?.data;
//   //       portraitImagePath = 'assets/images/item/portrait/';
//   //       nextPageUrl = responseModel.data?.wishlists?.nextPageUrl;
//   //
//   //       if (tempWishList != null && tempWishList.isNotEmpty) {
//   //         wishlist.addAll(tempWishList);
//   //       }
//   //       update();
//   //     } else {
//   //       // Handle error response here
//   //       // showErrorSnackBar('Failed to fetch new wishlist items. Please try again.');
//   //     }
//   //   } catch (e) {
//   //     print("Error fetching new wishlist: $e");
//   //     // Handle exception here
//   //     // showErrorSnackBar('An unexpected error occurred. Please try again later.');
//   //   }
//   // }
//
//
//
//
//   updateStatus(bool status) {
//     isLoading = status;
//     update();
//   }
//
//   bool hasNext() {
//     return nextPageUrl != null ? true : false;
//   }
//
//   void clearAllData(){
//     page=0;
//     isLoading=true;
//     nextPageUrl=null;
//     wishlist.clear();
//   }
//
//   bool removeLoading=false;
//   int selectedIndex=-1;
//   void removeFromWishlist(int index)async{
//     removeLoading=true;
//     selectedIndex=index;
//     update();
//      ResponseModel model=await repo.removeFromWishlist(int.tryParse(wishlist[index].itemId??'0')??0,int.tryParse(wishlist[index].episodeId??'0')??0);
//
//      if(model.statusCode==200){
//        AddInWishlistResponseModel responseModel=AddInWishlistResponseModel.fromJson(jsonDecode(model.responseJson));
//        if(responseModel.status=='success'){
//          wishlist.removeAt(index);
//          CustomSnackbar.showCustomSnackbar(errorList: [], msg: [responseModel.message?.success??'Successfully removed'], isError: false);
//          removeLoading=false;
//          update();
//        }else{
//          CustomSnackbar.showCustomSnackbar(errorList: [responseModel.message?.error??'Something went wrong'], msg: [], isError: true);
//          removeLoading=false;
//          update();
//        }
//      }
//      else{
//        CustomSnackbar.showCustomSnackbar(errorList: [model.message], msg: [], isError: true);
//        removeLoading=false;
//        update();
//      }
//
//   }
//
// }

class WishListController extends GetxController {
  WishListRepo repo;
  WishListController({required this.repo});

  String? nextPageUrl;
  bool isLoading = true;
  List<Data> wishlist = [];
  String portraitImagePath = '';
  int page = 0;
  bool removeLoading = false; // Add this property
  int selectedIndex = -1;

  Future<void> fetchInitialWishlist() async {
    try {
      String? accessToken = MySharedPrefClass.preferences?.getString('token');
      String url = '${UrlContainer.baseUrl}${UrlContainer.wishlistEndPoint}?page=$page';

      updateStatus(true);
      page = 1;

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("Response Body: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if(jsonResponse.isNotEmpty && jsonResponse['status'] == 'success'){
          WishlistResponseModel responseModel = WishlistResponseModel.fromJson(jsonResponse);
          portraitImagePath = 'assets/images/item/portrait/';
          List<Data>? tempWishList = responseModel.data?.wishlists?.data;

          print("TempWishList $tempWishList");

          if (tempWishList != null && tempWishList.isNotEmpty) {
            wishlist.addAll(tempWishList); // Add the parsed wishlist items to the existing list
          } else {
            // Handle case where no wishlist items are returned
          }
        } else {
          // If the response is empty or status is not 'success', handle accordingly
        }
      } else {
        // Handle error response here
      }
    } catch (e) {
      // Handle any errors occurred during the HTTP request
      print("Error fetching profile data: $e");
    } finally {
      updateStatus(false);
    }
  }


  void fetchNewWishlist() async {
    try {
      page++;
      ResponseModel model = await repo.getWishList(page);

      if (model.statusCode == 200) {
        WishlistResponseModel responseModel =
        WishlistResponseModel.fromJson(model.responseJson);
        List<Data>? tempWishList = responseModel.data?.wishlists?.data;

        if (tempWishList != null && tempWishList.isNotEmpty) {
          portraitImagePath = 'assets/images/item/portrait/';
          nextPageUrl = responseModel.data?.wishlists?.nextPageUrl;
          wishlist.addAll(tempWishList);
        } else {
          // Handle case where no new wishlist items are returned
        }
        update();
      } else {
        // Handle error response here
      }
    } catch (e) {
      print("Error fetching new wishlist: $e");
      // Handle exception here
    }
  }

  void removeFromWishlist(int index) async {
    try {
      ResponseModel model = await repo.removeFromWishlist(
        int.tryParse(wishlist[index].itemId ?? '0') ?? 0,
        int.tryParse(wishlist[index].episodeId ?? '0') ?? 0,
      );

      if (model.statusCode == 200) {
        AddInWishlistResponseModel responseModel =
        AddInWishlistResponseModel.fromJson(jsonDecode(model.responseJson));
        if (responseModel.status == 'success') {
          wishlist.removeAt(index);
          CustomSnackbar.showCustomSnackbar(
            errorList: [],
            msg: [responseModel.message?.success ?? 'Successfully removed'],
            isError: false,
          );
          update();
        } else {
          CustomSnackbar.showCustomSnackbar(
            errorList: [responseModel.message?.error ?? 'Something went wrong'],
            msg: [],
            isError: true,
          );
          update();
        }
      } else {
        CustomSnackbar.showCustomSnackbar(
          errorList: [model.message],
          msg: [],
          isError: true,
        );
        update();
      }
    } catch (e) {
      print("Error removing from wishlist: $e");
      CustomSnackbar.showCustomSnackbar(
        errorList: ['An unexpected error occurred. Please try again later.'],
        msg: [],
        isError: true,
      );
    }
  }

  updateStatus(bool status) {
    isLoading = status;
    update();
  }

  bool hasNext() {
    return nextPageUrl != null;
  }

  void clearAllData() {
    page = 0;
    isLoading = true;
    nextPageUrl = null;
    wishlist.clear();
  }
}

