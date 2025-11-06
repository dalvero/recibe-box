import 'package:flutter/material.dart';
import 'package:recipe_box/themes/my_themes.dart';
import 'package:recipe_box/widgets/my_app_bar.dart';
import 'package:recipe_box/widgets/my_bottom_bar.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  int _selectedIndex = 1; // POSISI DEFAULT TOMBOL TENGAH (FAVORITE)

  final List<Widget> _pages = [
    const Center(child: Text('Kategori Resep')),
    const Center(child: Text('Favorit')),
    const Center(child: Text('Tambah Resep')),    
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Buat resep makananmu sendiri',        
        subtitle: 'di rumahmu sendiri!',        
        backgroundColor: MyThemes.greyColor,
        height: 120,                        
        titleStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: MyThemes.greyText,          
        ),
        subtitleStyle: TextStyle(
          fontSize: 16,
          color: MyThemes.primaryColor,
        ),
      ),
      body: const Center(
        child: Text('Welcome to Recipe Box!'),
      ),
      bottomNavigationBar: MyBottomBar(
        selectedIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
