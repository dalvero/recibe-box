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
        title: 'Buat resep makananmu',        
        subtitle: 'di rumahmu sendiri!',        
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
