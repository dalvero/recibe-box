import 'dart:io';
import 'package:flutter/material.dart';
import 'package:recipe_box/models/form_resep_dto.dart';
import 'package:recipe_box/repository/resep_repository.dart';
import 'package:recipe_box/screens/screen_edit_resep.dart';
import 'package:recipe_box/themes/my_themes.dart';
import 'package:recipe_box/widgets/my_app_bar.dart';

class ScreenDetailResep extends StatefulWidget {
  final FormResepDTO resep;
  const ScreenDetailResep({super.key, required this.resep});

  @override
  State<ScreenDetailResep> createState() => _ScreenDetailResepState();
}

class _ScreenDetailResepState extends State<ScreenDetailResep> {
  final _resepRepo = ResepRepository();

  // FUNCTION UNTUK HAPUS RESEP
  Future <void> _deleteResep() async {
    await _resepRepo.deleteResep(widget.resep.id!);
    
    // NOTIFIKASI HAPUS BERHASIL
    if (mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Resep "${widget.resep.judul}" berhasil dihapus.'),
        )
      );
    }    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Resep Detail',        
        subtitle: 'Detail Resep ${widget.resep.judul}',
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
        actionWidget: IconButton(
          icon: Icon(Icons.arrow_back, color: MyThemes.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// GAMBAR RESEP
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: widget.resep.imagePath != null
                  ? Image.file(
                      File(widget.resep.imagePath!),
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Icon(Icons.image, size: 40),
                      ),
                    ),
            ),
            const SizedBox(height: 16),

            /// JUDUL + KATEGORI
            Text(
              widget.resep.judul,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.resep.kategoriNama,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),

            // WAKTU MASAK & PORSI
            Row(
              children: [
                Icon(Icons.schedule, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  widget.resep.waktuMasak,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.restaurant, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  "${widget.resep.porsi} porsi",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20,),

            /// BAHAN-BAHAN
            const Text(
              "Bahan-bahan",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...widget.resep.bahan.map((bahan) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6, right: 8),
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        bahan,
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 24),

            /// LANGKAH-LANGKAH
            const Text(
              "Langkah-langkah",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...widget.resep.langkah.map((langkah) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6, right: 8),
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        langkah,
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 32),

            /// TOMBOL EDIT & HAPUS
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // ARAHKAN KE SCREEN EDIT RESEP
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ScreenEditResep(resep: widget.resep),
                        ),
                      );
                    },
                    child: const Text(
                      "Edit",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // HAPUS RESEP
                      _deleteResep();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Hapus",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
