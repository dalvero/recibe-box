// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_box/models/resep_model.dart';
import 'package:recipe_box/themes/my_themes.dart';
import 'package:recipe_box/widgets/my_app_bar.dart';

class ScreenReviewResep extends StatefulWidget {
  final Resep resep;
  const ScreenReviewResep({super.key, required this.resep});

  @override
  State<ScreenReviewResep> createState() => _ScreenReviewResepState();
}

class _ScreenReviewResepState extends State<ScreenReviewResep> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
        widget.resep.imagePath = picked.path;
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      widget.resep.imagePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyThemes.greyColor,
      appBar: MyAppBar(
        title: 'Resep Makananmu',        
        backgroundColor: MyThemes.primaryColor,
        height: 100,                  
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),                
        titleStyle: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          color: MyThemes.textColor,             
        ),
        // BACK BUTTON
        actionWidget: IconButton(
          icon: Icon(Icons.arrow_back, color: MyThemes.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // GAMBAR / UPLOAD
              GestureDetector(
                onTap: _selectedImage == null ? _pickImage : _removeImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: MyThemes.greyColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    image: _selectedImage != null
                        ? DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _selectedImage == null
                      ? const Center(
                          child: Icon(Icons.add_a_photo,
                              size: 40, color: Colors.grey),
                        )
                      : const Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.delete,
                                color: Colors.white, size: 28),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // JUDUL RESEP
              Text(
                widget.resep.judul,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // KATEGORI
              Text(
                widget.resep.kategori,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 16),

              // BAHAN-BAHAN
              const Text(
                "Bahan-bahan",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...widget.resep.bahan.map(
                (bahan) => Row(
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
                        style: const TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // LANGKAH-LANGKAH
              const Text(
                "Langkah-langkah",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 8,),
              ...widget.resep.langkah.map(
                (langkah) => Row(
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
                        style: const TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // TOMBOL SAVE
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyThemes.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // NANTI DIHUBUNGKAN KE DATABASE (INSERT)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Resep disimpan!")),
                    );
                  },
                  child: const Text(
                    "Simpan Resep",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: MyThemes.textColor
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
