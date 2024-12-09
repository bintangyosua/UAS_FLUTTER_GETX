import 'package:flutter/material.dart';
import 'package:flutter_getx/controllers/data_controller.dart';
import 'package:get/get.dart';

class DataView extends StatelessWidget {
  final DataController dataController = Get.put(DataController());

  DataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Item')),
      body: Obx(() => ListView.builder(
            itemCount: dataController.items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(dataController.items[index]),
              );
            },
          )),
    );
  }
}
