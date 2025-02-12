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
      body: LayoutBuilder(
         builder: (context,constraints){
          return CustomScrollView(slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            toolbarHeight: constraints.maxWidth * AppSizes.converValueToadapter(context, 50),
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                "Favoris",
                style: GoogleFonts.roboto(
                    fontSize:
                        constraints.maxWidth * AppSizes.converValueToadapter(context, 20),
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * AppSizes.converValueToadapter(context, 16)),
                      child:Text("Mes listes", 
                      style: GoogleFonts.roboto(
                                      fontSize:
                    constraints.maxWidth * AppSizes.converValueToadapter(context, 16),
                                      fontWeight: FontWeight.w600),)
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 20),),),
          Consumer<FavoriteProvider>(
            builder: (context, favoriteProvider, child) {
              List<ProductModel> myFavorites = favoriteProvider.getFavorites;
              return myFavorites.isNotEmpty
                  ? SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * AppSizes.converValueToadapter(context, 16)),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context , index){
                          return  GestureDetector(
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
                                  FavoriteCard(item: myFavorites[index], constraints: constraints),
                            );
                          
                        },
                        childCount: myFavorites.length,
                      ),
                     
                    ),
                  )
                  : SliverToBoxAdapter(child:FavoriteEmpty(constraints:constraints));
            },
          ),
        ]);
         }
      ),
    );
  }
}
