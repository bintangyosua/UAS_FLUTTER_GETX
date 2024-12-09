import 'package:get/get.dart';

class DataController extends GetxController {
  var items = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

  void fetchItems() {
    items.value = ['Item 1', 'Item 2', 'Item 3'];
  }
}
