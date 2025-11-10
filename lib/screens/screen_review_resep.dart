import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_box/models/resep_model.dart';
import 'package:recipe_box/themes/my_themes.dart';

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
      appBar: AppBar(
        title: const Text("Resep"),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {}, // nanti bisa tambah resep baru
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.black),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Resep dihapus (contoh aksi)")),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
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
                    // nanti dihubungkan ke database (insert)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Resep disimpan!")),
                    );
                  },
                  child: const Text(
                    "Simpan Resep",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
