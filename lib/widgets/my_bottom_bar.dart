import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:recipe_box/themes/my_themes.dart';

class MyBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const MyBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      backgroundColor: MyThemes.primaryColor,
      style: TabStyle.react, // ANIMASI SMOOTH KETIKA DITEKAN
      color: Colors.white, // WARNA ICON DEFAULT
      activeColor: Colors.black, // WARNA ICON AKTIF
      items: const [
        TabItem(icon: Icons.category, title: 'Kategori'),
        TabItem(icon: Icons.favorite, title: 'Favorit'),
        TabItem(icon: Icons.add, title: 'Tambah'),        
      ],
      initialActiveIndex: selectedIndex,
      onTap: onTabSelected,
      height: 60,
      curveSize: 90,
      top: -20, // POSISI MENONJOL TOMBOL TENGAH
    );
  }
}
