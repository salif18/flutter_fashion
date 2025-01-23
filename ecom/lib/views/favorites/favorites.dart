import 'package:ecom/models/produits_model.dart';
import 'package:ecom/providers/favorite_provider.dart';
import 'package:ecom/utils/app_size.dart';
import 'package:ecom/views/detail/single.dart';
import 'package:ecom/views/favorites/widgets/favorite_card.dart';
import 'package:ecom/views/favorites/widgets/favorite_empty.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 80,
          pinned: true,
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text(
              "Favoris",
              style: GoogleFonts.roboto(
                  fontSize:
                      MediaQuery.of(context).size.width * AppSizes.fontMedium,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Consumer<FavoriteProvider>(
            builder: (context, favoriteProvider, child) {
              List<ProductModel> myFavorites = favoriteProvider.getFavorites;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child:Text("Mes listes", 
                        style: GoogleFonts.roboto(
                  fontSize:
                      MediaQuery.of(context).size.width * AppSizes.fontMedium,
                  fontWeight: FontWeight.w600),)
                      ),
                      Container(
                        child: myFavorites.isNotEmpty
                            ? ListView.builder(
                                itemCount: myFavorites.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SingleProduct(
                                            product: myFavorites[index],
                                          ),
                                        ),
                                      );
                                    },
                                    child:
                                        FavoriteCard(item: myFavorites[index]),
                                  );
                                },
                              )
                            : const FavoriteEmpty(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
