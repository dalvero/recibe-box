import 'package:flutter/material.dart';
import 'package:recipe_box/screens/screen_review_resep.dart';
import 'package:recipe_box/themes/my_themes.dart';
import 'package:recipe_box/models/resep_model.dart';

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
      backgroundColor: MyThemes.greyColor,
      appBar: AppBar(
        title: const Text("Masukkan Resep"),
        backgroundColor: MyThemes.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul
              const Text("Judul Resep", style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(hintText: "Contoh: Kari Ayam"),
                validator: (v) => v!.isEmpty ? "Judul wajib diisi" : null,
              ),
              const SizedBox(height: 12),

              // Jenis Masakan
              const Text("Jenis Masakan", style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                value: _kategoriDipilih,
                decoration: const InputDecoration(),
                hint: const Text("Pilih jenis masakan"),
                items: _kategoriList.map((e) {
                  return DropdownMenuItem(value: e, child: Text(e));
                }).toList(),
                onChanged: (value) => setState(() => _kategoriDipilih = value),
                validator: (v) => v == null ? "Pilih kategori" : null,
              ),
              const SizedBox(height: 12),

              // Porsi & Waktu Masak
              const Text("Porsi & Waktu Masak", style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _waktuController,
                decoration: const InputDecoration(hintText: "Contoh: 30 - 45 Menit"),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _porsiController,
                decoration: const InputDecoration(hintText: "Contoh: 1 Porsi"),
              ),
              const SizedBox(height: 16),

              // Bahan-bahan
              const Text("Bahan-bahan", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._buildDynamicFields(_bahanControllers, "Tambah Bahan"),
              const SizedBox(height: 16),

              // Langkah-langkah
              const Text("Langkah-langkah", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._buildDynamicFields(_langkahControllers, "Tambah Langkah-langkah"),
              const SizedBox(height: 24),

              // Tombol Review
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
    List<Widget> widgets = [];
    for (int i = 0; i < controllers.length; i++) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: TextFormField(
            controller: controllers[i],
            decoration: InputDecoration(
              prefixText: "${i + 1}. ",
              hintText: i == 0 ? "Contoh: Ayam 1kg" : null,
            ),
            validator: (v) => v!.isEmpty ? "Isi data ini" : null,
          ),
        ),
      );
    }
    widgets.add(
      Center(
        child: TextButton.icon(
          onPressed: () {
            setState(() => controllers.add(TextEditingController()));
          },
          icon: const Icon(Icons.add, color: Colors.orange),
          label: Text(
            label,
            style: const TextStyle(color: Colors.orange),
          ),
        ),
      ),
    );
    return widgets;
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
