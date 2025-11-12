import 'package:flutter/material.dart';
import 'package:recipe_box/screens/screen_form_tambah.dart';
import 'package:recipe_box/themes/my_themes.dart';
import 'package:recipe_box/widgets/my_app_bar.dart';
import 'package:recipe_box/widgets/my_floating_act_button.dart';
import 'package:recipe_box/widgets/my_search_bar.dart';

class ScreenTambahResep extends StatefulWidget {
  const ScreenTambahResep({super.key});

  @override
  State<ScreenTambahResep> createState() => _ScreenTambahResepState();
}

class _ScreenTambahResepState extends State<ScreenTambahResep> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      appBar: MyAppBar(
        title: 'Ayo buat resep makanan',        
        subtitle: 'versi dirimu sendiri!',        
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
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SEARCH BAR
              SizedBox(height: 10),
              MySearchBar(hintText: "Search any recipe",
                backgroundColor: MyThemes.greyColor,
                borderRadius: 25,                
              ),            
              SizedBox(height: 10),

              // LIST RESEP YANG SUDAH ADA
              Center(
                child: Text("Kamu belum punya resep favorit!"),
              )              
            ],
          ),
        )
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40), // NAIK 40 PIXEL
        child: MyFloatingActButton(
          icon: Icons.add,
          // ARAHKAN KE FORM TAMBAH RESEP
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ScreenFormTambahResep(),
              ),                     
            );
          }
        ),      
      ),
    );
  }
}
