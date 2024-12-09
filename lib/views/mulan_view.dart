import 'package:flutter/material.dart';
import 'package:flutter_getx/controllers/mulan_controller.dart';
import 'package:flutter_getx/models/mulan.dart';
import 'package:get/get.dart';

class MulanView extends StatelessWidget {
  final MulanController mulanController = Get.put(MulanController());
  final namaController = TextEditingController();
  final storyController = TextEditingController();

  MulanView({super.key});

  void _showDialog({String? id, String? nama, String? story}) {
    namaController.text = nama ?? '';
    storyController.text = story ?? '';

    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: 'Nama Pahlawan'),
              ),
              TextField(
                controller: storyController,
                decoration: const InputDecoration(labelText: 'Story'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (id != null) {
                    mulanController.updateMulan(Mulan(id: id, nama: namaController.text, story: storyController.text));
                  } else {
                    mulanController.addMulan(Mulan(nama: namaController.text, story: storyController.text));
                  }
                  Get.back();
                },
                child: Text(id != null ? 'Update' : 'Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Get.toNamed('/profile');
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _showDialog(), child: const Icon(Icons.add)),
      body: Obx(() => mulanController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: mulanController.mulans.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(mulanController.mulans[index].nama),
                  subtitle: Text(mulanController.mulans[index].story),
                  trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showDialog(
                        id: mulanController.mulans[index].id,
                        nama: mulanController.mulans[index].nama,
                        story: mulanController.mulans[index].story,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        Get.dialog(
                          AlertDialog(
                            title: const Text('Konfirmasi'),
                            content: const Text('Yakin ingin menghapus data ini?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  mulanController.deleteMulan(mulanController.mulans[index].id!);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Hapus'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                );
              }),
      ),
    );
  }
}

