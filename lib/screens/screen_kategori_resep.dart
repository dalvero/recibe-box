import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recipe_box/models/kategori_model.dart';
import 'package:recipe_box/repository/kategori_repository.dart';
import 'package:recipe_box/screens/screen_form_tambah_kategori.dart';
import 'package:recipe_box/themes/my_themes.dart';
import 'package:recipe_box/widgets/my_app_bar.dart';
import 'package:recipe_box/widgets/my_floating_act_button.dart';
import 'package:recipe_box/widgets/my_search_bar.dart';

class ScreenKategoriResep extends StatefulWidget {
  const ScreenKategoriResep({super.key});

  @override
  State<ScreenKategoriResep> createState() => _ScreenKategoriResepState();
}

class _ScreenKategoriResepState extends State<ScreenKategoriResep> {
  final TextEditingController _searchController = TextEditingController();
  List<KategoriResep> kategoriList = [];
  List<KategoriResep> kategoriFiltered = [];


  @override
  void initState() {
    super.initState();
    _loadKategori();
    _searchController.addListener(_runFilter);
  }

  Future<void> _loadKategori() async {
    final data = await KategoriRepository().getAllKategori();
    setState(() {
      kategoriList = data;
      kategoriFiltered = data;
    });
  }

  void _runFilter() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      kategoriFiltered = kategoriList.where((kategori) {
        return kategori.namaKategori.toLowerCase().contains(query);
      }).toList();
    });
  }


  Future<void> _hapusKategori(int? id) async {
    if (id == null) {      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menghapus: id kategori tidak ditemukan.")),
      );
      return;
    }

    await KategoriRepository().deleteKategori(id);
    await _loadKategori();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Kategori Resep',
        subtitle: 'siapkan kategori makananmu!',
        backgroundColor: MyThemes.primaryColor,
        height: 140,
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
        titleStyle: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          color: MyThemes.textColor,
        ),
        subtitleStyle: TextStyle(
          fontSize: 20,
          color: MyThemes.backgroundColor,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // SEARCHBAR AKTIF
            MySearchBar(
              controller: _searchController,
              hintText: "Cari kategori…",
              backgroundColor: MyThemes.greyColor,
              borderRadius: 25,
            ),
            const SizedBox(height: 20),

            // LIST KATEGORI
            Expanded(
              child: kategoriFiltered.isEmpty
                  ? const Center(
                      child: Text("Kategori tidak ditemukan…"),
                    )
                  : ListView.builder(
                      itemCount: kategoriFiltered.length,
                      itemBuilder: (context, index) {
                        final kategori = kategoriFiltered[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 3,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              // === ON TAP pindah ke halaman resep per kategori ===
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Placeholder(),
                                  ),
                                );
                              },

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // FOTO
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                    child: kategori.fotoPath != null
                                        ? Image.file(
                                            File(kategori.fotoPath!),
                                            height: 170,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            height: 170,
                                            width: double.infinity,
                                            color: Colors.grey.shade300,
                                            child: const Icon(
                                              Icons.image_not_supported,
                                              size: 50,
                                              color: Colors.grey,
                                            ),
                                          ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // NAMA KATEGORI
                                        Text(
                                          kategori.namaKategori,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        // === TOMBOL HAPUS ===
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 26,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                title: const Text("Hapus Kategori"),
                                                content: const Text(
                                                    "Yakin ingin menghapus kategori ini?"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(context),
                                                      child: const Text("Batal")),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        _hapusKategori(kategori.id);
                                                      },
                                                      child: const Text(
                                                        "Hapus",
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      )),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: MyFloatingActButton(
          icon: Icons.add,
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const ScreenFormTambahKategori(),
            ).then((_) => _loadKategori());
          },
        ),
      ),
    );
  }
}
