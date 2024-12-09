import 'dart:convert';

import 'package:flutter_getx/models/mulan.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MulanController extends GetxController {
  var mulans = <Mulan>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    findMulan();
  }

  void findMulan() async {
    isLoading(true);
    var res = await http.get(Uri.parse('http://localhost/template/tampil.php'));
    var data = json.decode(res.body) as List;
    mulans.value = data.map((e) => Mulan.fromJson(e)).toList();
    isLoading(false);
  }

  void addMulan(Mulan mulan) async {
    try {
      isLoading(true);
      await http.post(
        Uri.parse('http://localhost/template/tambah.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(mulan.toJson())
      ); 
      Get.snackbar('Success', 'Berhasil menambahkan Data');
      findMulan();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  void updateMulan(Mulan mulan) async {
    try {
      isLoading(true);
      await http.put(
        Uri.parse('http://localhost/template/edit.php'),
        body: json.encode({
          'id': mulan.id,
          'nama': mulan.nama,
          'story': mulan.story,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      Get.snackbar('Success', 'Berhasil mengubah Data');
      findMulan();
    } catch (e) {
      Get.snackbar('Error', '$e');
    } finally {
      isLoading(false);
    }
  }

  void deleteMulan(String id) async {
    try {
      isLoading(true);
      await http.delete(Uri.parse('http://localhost/template/hapus.php?id=$id'));
      Get.snackbar('Success', 'Berhasil menghapus Data');
      findMulan();
    } catch (e) {
      Get.snackbar('Error', '$e');
    } finally {
      isLoading(false);
    }
  }
}