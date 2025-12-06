import 'package:flutter/material.dart';
import 'package:recipe_box/models/form_resep_dto.dart';
import 'package:recipe_box/models/kategori_model.dart';
import 'package:recipe_box/repository/kategori_repository.dart';
import 'package:recipe_box/screens/screen_review_resep.dart';
import 'package:recipe_box/themes/my_themes.dart';
import 'package:recipe_box/widgets/my_app_bar.dart';
import 'package:recipe_box/widgets/my_dropdown.dart';
import 'package:recipe_box/widgets/my_textfield.dart';
import 'package:recipe_box/widgets/my_dynamic_fields.dart';

class ScreenEditResep extends StatefulWidget {
  final FormResepDTO resep;
  const ScreenEditResep({super.key, required this.resep});

  @override
  State<ScreenEditResep> createState() => _ScreenEditResepState();
}

class _ScreenEditResepState extends State<ScreenEditResep> {
  final _formKey = GlobalKey<FormState>();
  final _kategoriRepo = KategoriRepository();

  // MENGAMBIL DATA RESEP YANG AKAN DIEDIT
  int? resepId;
  String? judulResep;
  String? jenisMasakan;
  String? porsi;
  String? waktuMasak;
  String? imagePath;

  // LIST UNTUK MENAMPUNG BAHAN DAN LANGKAH
  List<String> bahanList = [];
  List<String> langkahList = [];

  // CONTROLLER FORM FIELD
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _porsiController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();

  List<KategoriResep> _kategoriList = []; // SIMPAN LIST OBJEK KATEGORI
  KategoriResep? _kategoriDipilih; // SIMPAN OBJEK YANG DIPILIH

  final List<TextEditingController> _bahanControllers = [];
  final List<TextEditingController> _langkahControllers = [];

  @override
  void initState() {
    super.initState();
    _loadKategori();

    // INISIALISASI DATA RESEP YANG AKAN DIEDIT
    resepId = widget.resep.id;
    judulResep = widget.resep.judul;
    jenisMasakan = widget.resep.kategoriNama;
    porsi = widget.resep.porsi.toString();
    waktuMasak = widget.resep.waktuMasak;
    imagePath = widget.resep.imagePath;
    
    // MEMASUKAN BAHAN DAN LANGKAH KE LIST
    for(var bahan in widget.resep.bahan){
      bahanList.add(bahan);
      _bahanControllers.add(TextEditingController(text: bahan));
    }

    for(var langkah in widget.resep.langkah){
      langkahList.add(langkah);
      _langkahControllers.add(TextEditingController(text: langkah));
    }

    // SET DATA KE CONTROLLER
    _judulController.text = judulResep ?? "";
    _porsiController.text = porsi ?? "";
    _waktuController.text = waktuMasak ?? "";
    _kategoriDipilih = _kategoriList.firstWhere(
      (k) => k.namaKategori == jenisMasakan,
      orElse: () => KategoriResep(id: widget.resep.kategoriId, namaKategori: jenisMasakan ?? ""),
    );    
  }

  Future<void> _loadKategori() async {
    final data = await _kategoriRepo.getAllKategori();
    setState(() {
      _kategoriList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyThemes.backgroundColor,
      appBar: MyAppBar(
        title: 'Ayo Edit Resep',
        subtitle: 'Resep ${judulResep ?? ""}',
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Judul Resep", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),              
              MyTextfield(
                hintText: "Contoh: Kari Ayam",
                controller: _judulController,
              ),
              const SizedBox(height: 8),

              const Text("Jenis Masakan", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              MyDropdown(
                value: _kategoriDipilih?.namaKategori,
                items: _kategoriList.map((e) => e.namaKategori).toList(),
                onChanged: (value) {
                  setState(() {
                    _kategoriDipilih =
                        _kategoriList.firstWhere((k) => k.namaKategori == value);
                  });
                },
                hintText: "Pilih jenis",
              ),
              const SizedBox(height: 12),

              const Text("Porsi & Waktu Masak", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
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

              const Text("Bahan-bahan", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._buildDynamicFields(_bahanControllers, "Tambah Bahan"),
              const SizedBox(height: 16),

              const Text("Langkah-langkah", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._buildDynamicFields(_langkahControllers, "Tambah Langkah-langkah"),
              const SizedBox(height: 24),

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

  List<Widget> _buildDynamicFields(List<TextEditingController> controllers, String label) {
    // CEK APAKAH CONTROLLERS KOSONG
    if(controllers.isEmpty){
      controllers.add(TextEditingController(text: ""));
    }
    return [
      for (int i = 0; i < controllers.length; i++)
        MyDynamicField(
          index: i,
          controller: controllers[i],
          hintText: null,
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
    if (_kategoriDipilih == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih kategori dulu ya")),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final resepDTO = FormResepDTO(
        judul: _judulController.text,
        kategoriId: _kategoriDipilih!.id!,
        kategoriNama: _kategoriDipilih!.namaKategori,
        porsi: int.tryParse(_porsiController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1,
        waktuMasak: _waktuController.text,
        bahan: _bahanControllers.map((e) => e.text).toList(),
        langkah: _langkahControllers.map((e) => e.text).toList(),
        imagePath: imagePath,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ScreenReviewResep(
            resep: resepDTO,
            isEdit: true,            
            resepId: resepId,
          ),
        ),
      );
    }
  }
}