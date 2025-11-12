// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:recipe_box/screens/screen_review_resep.dart';
import 'package:recipe_box/themes/my_themes.dart';
import 'package:recipe_box/models/resep_model.dart';
import 'package:recipe_box/widgets/my_app_bar.dart';
import 'package:recipe_box/widgets/my_dropdown.dart';
import 'package:recipe_box/widgets/my_textfield.dart';
import 'package:recipe_box/widgets/my_dynamic_fields.dart';

class ScreenFormTambahResep extends StatefulWidget {
  const ScreenFormTambahResep({super.key});

  @override
  State<ScreenFormTambahResep> createState() => _ScreenFormTambahResepState();
}

class _ScreenFormTambahResepState extends State<ScreenFormTambahResep> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _porsiController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();

  String? _kategoriDipilih;
  final List<String> _kategoriList = [
    "Menu Utama",
    "Hidangan Pembuka",
    "Cemilan",
    "Minuman",
    "Penutup",
  ];

  List<TextEditingController> _bahanControllers = [TextEditingController()];
  List<TextEditingController> _langkahControllers = [TextEditingController()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyThemes.backgroundColor,
      appBar: MyAppBar(
        title: 'Ayo Buat Resep',        
        subtitle: 'Makananmu!',        
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

        // BACK BUTTON
        actionWidget: IconButton(
          icon: Icon(Icons.arrow_back, color: MyThemes.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // JUDUL RESEP
              const Text("Judul Resep", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              MyTextfield(
                hintText: "Contoh: Kari Ayam",
                controller: _judulController,
              ),
              const SizedBox(height: 8),

              // JENIS MASAKAN
              const Text("Jenis Masakan", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              MyDropdown(
                value: _kategoriDipilih,
                items: _kategoriList,
                onChanged: (value) => setState(() => _kategoriDipilih = value),
                hintText: "Pilih jenis",                                
              ),
              const SizedBox(height: 12),

              // PORSI & WAKTU MASAK
              const Text("Porsi & Waktu Masak", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8,),
              MyTextfield(
                hintText: "Contoh: 30 Menit",
                controller: _waktuController,                
              ),
              const SizedBox(height: 8),
               MyTextfield(
                hintText: "Contoh: 1 Porsi",
                controller: _porsiController,
              ),
              const SizedBox(height: 16),

              // BAHAN-BAHAN
              const Text("Bahan-bahan", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._buildDynamicFields(_bahanControllers, "Tambah Bahan"),
              const SizedBox(height: 16),

              // LANGKAH-LANGKAH
              const Text("Langkah-langkah", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._buildDynamicFields(_langkahControllers, "Tambah Langkah-langkah"),
              const SizedBox(height: 24),

              // TOMBOL REVIEW
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
                  onPressed: _onReviewPressed,
                  child: const Text(
                    "Review Resep",
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold,
                      color: MyThemes.textColor,
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

  List<Widget> _buildDynamicFields(
    List<TextEditingController> controllers,
    String label,
  ) {
    return [
      for (int i = 0; i < controllers.length; i++)
        MyDynamicField(
          index: i,
          controller: controllers[i],
          hintText: i == 0 ? "Contoh: Ayam 1kg" : null,
        ),
      const SizedBox(height: 8),
      Center(
        child: TextButton.icon(
          onPressed: () => setState(() => controllers.add(TextEditingController())),
          icon: const Icon(Icons.add, color: Colors.orange),
          label: Text(
            label,
            style: const TextStyle(color: Colors.orange),
          ),
        ),
      ),
    ];
  }


  void _onReviewPressed() {
    if (_formKey.currentState!.validate()) {
      final resep = Resep(
        judul: _judulController.text,
        kategori: _kategoriDipilih!,
        porsi: int.tryParse(_porsiController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1,
        waktuMasak: _waktuController.text,
        bahan: _bahanControllers.map((e) => e.text).toList(),
        langkah: _langkahControllers.map((e) => e.text).toList(),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ScreenReviewResep(resep: resep)),
      );
    }
  }
}
