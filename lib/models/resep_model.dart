class Resep {
  final String judul;
  final String kategori;
  final int porsi;
  final String waktuMasak;
  final List<String> bahan;
  final List<String> langkah;
  String? imagePath;

  Resep({
    required this.judul,
    required this.kategori,
    required this.porsi,
    required this.waktuMasak,
    required this.bahan,
    required this.langkah,
    this.imagePath,
  });
}
