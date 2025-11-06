import 'package:flutter/material.dart';
import 'package:recipe_box/themes/my_themes.dart';
import 'package:recipe_box/widgets/my_app_bar.dart';
import 'package:recipe_box/widgets/my_search_bar.dart';

class ScreenFavorite extends StatefulWidget {
  const ScreenFavorite({super.key});

  @override
  State<ScreenFavorite> createState() => _ScreenFavoriteState();
}

class _ScreenFavoriteState extends State<ScreenFavorite> {
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

              // LIST RESEP FAVORIT
              Center(
                child: Text("Kamu belum punya resep favorit!"),
              )
            ],
          ),
        )
      ),
    );
  }
}
