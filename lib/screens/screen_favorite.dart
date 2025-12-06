// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recipe_box/models/form_resep_dto.dart';
import 'package:recipe_box/models/resep_model.dart';
import 'package:recipe_box/repository/kategori_repository.dart';
import 'package:recipe_box/repository/resep_bahan_repository.dart';
import 'package:recipe_box/repository/resep_langkah_repository.dart';
import 'package:recipe_box/repository/resep_repository.dart';
import 'package:recipe_box/screens/screen_detail_resep.dart';
import 'package:recipe_box/themes/my_themes.dart';
import 'package:recipe_box/widgets/my_app_bar.dart';
import 'package:recipe_box/widgets/my_search_bar.dart';

class ScreenFavorite extends StatefulWidget {
  const ScreenFavorite({super.key});

  @override
  State<ScreenFavorite> createState() => _ScreenFavoriteState();
}

class _ScreenFavoriteState extends State<ScreenFavorite> {
  final _resepRepo = ResepRepository();
  final _kategoriRepo = KategoriRepository();
  final _resepBahanRepo = ResepBahanRepository();
  final _resepLangkahRepo = ResepLangkahRepository();
  String searchQuery = "";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      appBar: MyAppBar(
        title: 'Buat resep makananmu',        
        subtitle: 'di rumahmu sendiri!',        
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
          fontWeight: FontWeight.normal,
          color: MyThemes.backgroundColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [

            /// SEARCH BAR
            MySearchBar(
              hintText: "Search any recipe",
              backgroundColor: MyThemes.greyColor,
              borderRadius: 25,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),

            const SizedBox(height: 15),

            /// LIST RESEP DARI REPOSITORY (lebih aman)
            Expanded(
              child: FutureBuilder<List<Resep>>(
                future: _resepRepo.getAllResep(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final resepList = snapshot.data!;

                  // filter hanya resep favorit
                  final favoriteResepList = resepList.where((r) => r.isFavorite == true).toList();

                  // filter juga search query
                  final filtered = favoriteResepList.where((r) {
                    final judul = r.judul.toLowerCase();
                    final kategori = r.kategoriId.toString().toLowerCase();
                    return judul.contains(searchQuery) || kategori.contains(searchQuery);
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text("Belum ada resep favorit. Tambahkan yuk!"),
                    );
                  }

                  
                  final futures = filtered.map((r) async {
                    final nama = await _kategoriRepo.getNamaById(r.kategoriId);
                    return {'resep': r, 'kategoriNama': nama};
                  }).toList();

                  return FutureBuilder<List<Map<String, dynamic>>>(
                    future: Future.wait(futures),
                    builder: (context, snapshot2) {
                      if (!snapshot2.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final data = snapshot2.data!;

                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final resep = data[index]['resep'] as Resep;
                          final kategoriNama = data[index]['kategoriNama'] as String;

                          return _buildResepCard(
                            resepId: resep.id!,
                            judul: resep.judul,
                            kategori: kategoriNama,
                            imagePath: resep.imagePath,
                            isFavorite: resep.isFavorite,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),          
    );
  }

  /// CARD DESAIN RESEP
  Widget _buildResepCard({
    required int resepId,
    required String judul,
    required String kategori,
    required String? imagePath,
    required bool isFavorite,
  }) {
    return GestureDetector(
      onTap: () async {
        // AMBIL RESEP BERDASARKAN RESEP ID
        final resep = await _resepRepo.getResepById(resepId);
        if (resep == null) return;
        // AMBIL NAMA KATEGORI
        final kategoriNama = await _kategoriRepo.getNamaById(resep.kategoriId);        

        // MENGAMBIL LIST BAHAN DAN LANGKAH
        final bahanList = await _resepBahanRepo.getBahanByResep(resepId);
        final langkahList = await _resepLangkahRepo.getLangkahByResep(resepId);

        // KARENA FORM RESEP DTO MENGGUNAKAN LIST BAHAN STRING & LANGKAH STRING
        final bahanStrings = bahanList.map((b) => b.bahan).toList();
        final langkahStrings = langkahList.map((l) => l.langkah).toList();

        // SIAPKAN DTO RESEP UNTUK DITAMPILKAN DI SCREEN DETAIL RESEP
        final dtoResep = FormResepDTO(
          id: resep.id,
          judul: judul, 
          kategoriId: resep.kategoriId, 
          kategoriNama: kategoriNama, 
          porsi: resep.porsi, 
          waktuMasak: resep.waktuMasak, 
          bahan: bahanStrings, 
          langkah: langkahStrings,
          imagePath: resep.imagePath,
        );

        // NAVIGASI KE SCREEN DETAIL RESEP        
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ScreenDetailResep(resep: dtoResep)),
        ).then((_) => setState(() {}));

      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// FOTO RESEP
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: imagePath == null || imagePath.isEmpty
                  ? Container(
                      height: 160,
                      color: Colors.grey.shade300,
                      child: const Center(child: Icon(Icons.image, size: 40)),
                    )
                  : Image.file(
                      File(imagePath),
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// TITLE & KATEGORI
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          judul,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          kategori,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// FAVORITE BUTTON                  
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                      size: 28,
                    ),
                    onPressed: () async {
                      // toggle favorite di DB
                      await _resepRepo.toggleFavorite(resepId, !isFavorite);

                      // update UI card sendiri
                      setState(() {
                        isFavorite = !isFavorite;                        
                      });

                      // debug snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFavorite ? "Ditandai favorit ❤️" : "Dihapus dari favorit 💔",
                          ),
                          duration: const Duration(seconds: 1),
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
    );
  }
}