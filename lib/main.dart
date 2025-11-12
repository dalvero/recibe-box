import 'package:flutter/material.dart';
import 'package:recipe_box/models/resep_model.dart';
import 'package:recipe_box/routing/routing.dart';
import 'package:recipe_box/screens/screen_review_resep.dart';
import 'package:recipe_box/themes/my_themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe Box',
      theme: MyThemes.lightTheme,
      // home: const Routing(),
      // UNTUK TESTING SCREEN REVIEW RESEP
      home : ScreenReviewResep(resep: Resep(
          judul: "asd", 
          kategori: "asd",           
          porsi: 1,          
          waktuMasak: "asd", 
          bahan: ["asd", "asd"],           
          langkah: ["asd"],                     
        ),
      ),
    );
  }
}