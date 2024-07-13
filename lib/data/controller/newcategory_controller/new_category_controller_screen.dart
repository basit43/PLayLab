import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:play_lab/data/model/new_categorymodel/new_categorymodel_class.dart';

class NewCategoryController extends GetxController {
  var categories = <Categories>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async {
    try {
      isLoading(true);
      List<Categories> fetchedCategories = await fetchCategoriesFromApi();
      categories.value = fetchedCategories;
    } catch (e) {
      // Handle errors
      print("Error fetching data: $e");
      // Show toast message
      Get.snackbar(
        "Error",
        "Failed to fetch data. Please try again later.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<List<Categories>> fetchCategoriesFromApi() async {
    final url = Uri.parse('https://playnow.sadgurushririteshwarji.com/api/categoryitemdata');
    print("NewCategory");
    try {
      final response = await http.get(url);
      print("Res $response");
      print("Res ${response.body}");
      if (response.statusCode == 200) {
        // Parse the response using the model classes
        final jsonResponse = json.decode(response.body);
        final newCategoryResponse = NewCategoryResponseModel.fromJson(jsonResponse);
        // Extract the categories list from the response
        final List<Categories>? categories = newCategoryResponse.data?.categories;
        // Return the categories list
        return categories ?? []; // Return an empty list if categories is null
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error is ${e.toString()}");
      throw Exception('Failed to load data');
    }
  }

}
