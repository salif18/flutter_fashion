
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:ecom/components/generatedStarProduct.dart';
import 'package:ecom/models/marques_model.dart';
import 'package:ecom/models/produits_model.dart';
import 'package:ecom/providers/cart_provider.dart';
import 'package:ecom/services/marque_api.dart';
import 'package:ecom/services/products_api.dart';
import 'package:ecom/utils/app_color.dart';
import 'package:ecom/utils/app_size.dart';
import 'package:ecom/views/cart/cart.dart';
import 'package:ecom/views/detail/single.dart';
import 'package:ecom/views/store/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class StoresView extends StatefulWidget {
  final String? categoSelected;
  const StoresView({super.key, required this.categoSelected});

  @override
  State<StoresView> createState() => _StoresViewState();
}

class _StoresViewState extends State<StoresView> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey<ScaffoldState>();
  ServicesAPiProducts api = ServicesAPiProducts();
  ServicesAPiMarques apiMarques = ServicesAPiMarques();

  List<ProductModel> _products = [];
  List<MarquesModel> _marques = [];
  String _categoryLocal = '';
  String _subCategoryFilter = '';
  String _marqueFilter = '';
  Map<String, dynamic> _filters = {
    'selectedCategories': [],
    'maxPrice': 100000,
    'searchQuery': '',
    'selectedRating': ''
  };

  @override
  void initState() {
    super.initState();
    setState(() {
      _categoryLocal = widget.categoSelected!;
    });
    _fetchProducts();
    _fetchMarques();
  }

// recuperation du produit
  Future<void> _fetchProducts() async {
    try {
      final response = await api.getAllProducts();
      if (response.statusCode == 200) {
        final body = response.data;
        setState(() {
          _products = (body["produits"] as List)
              .map((json) => ProductModel.fromJson(json))
              .toList();
        });
      }
     }on DioException {
      api.showSnackBarErrorPersonalized(
          context, "Problème de connexion : Vérifiez votre Internet.");
      print("Erreur de connexion : Impossible d'accéder au serveur.");
    } on TimeoutException {
      api.showSnackBarErrorPersonalized(
          context, "Le serveur ne répond pas. Veuillez réessayer plus tard.");
      print("Erreur : Temps d'attente dépassé.");
    }catch(e){
     api.showSnackBarErrorPersonalized(context, "$e");
    }
  }

  // recupertions des marques
  Future<void> _fetchMarques() async {
    try {
      final response = await apiMarques.getAllMarques();
      final body = response.data;
      if (response.statusCode == 200) {
        setState(() {
          _marques = (body["marques"] as List)
              .map((json) => MarquesModel.fromJson(json))
              .toList();
        });
      }
    }  on DioException {
      api.showSnackBarErrorPersonalized(
          context, "Problème de connexion : Vérifiez votre Internet.");
      print("Erreur de connexion : Impossible d'accéder au serveur.");
    } on TimeoutException {
      api.showSnackBarErrorPersonalized(
          context, "Le serveur ne répond pas. Veuillez réessayer plus tard.");
      print("Erreur : Temps d'attente dépassé.");
    }catch(e){
     api.showSnackBarErrorPersonalized(context, "$e");
    }
   
  }

// filtration selon les resultats de filtre
  List<ProductModel> get _filteredProducts {
    return _products.where((product) {
      final matchesCategory = (_filters['selectedCategories'].isEmpty ||
              _filters['selectedCategories'].contains(product.category)) &&
          (_categoryLocal.isEmpty || product.category == _categoryLocal);
      final matchesPrice =
          // ignore: unnecessary_null_comparison
          product.price != null && product.price <= _filters['maxPrice'];
      final matchesSearch = (product.name ?? '')
              .toLowerCase()
              .contains(_filters['searchQuery'].toLowerCase()) ||
          (product.category ?? '')
              .toLowerCase()
              .contains(_filters['searchQuery'].toLowerCase()) ||
          (product.subCategory ?? '')
              .toLowerCase()
              .contains(_filters['searchQuery'].toLowerCase());

      final matchesRatings = _filters['selectedRating'] == '' ||
          product.rating! >= _filters['selectedRating'];
      final matchesMarques =
          product.brand != null && product.brand!.contains(_marqueFilter);
      final matchesSubCategory = product.subCategory != null &&
          product.subCategory!.contains(_subCategoryFilter);

      return matchesCategory &&
          matchesPrice &&
          matchesSearch &&
          matchesMarques &&
          matchesRatings &&
          matchesSubCategory;
    }).toList();
  }

// reinitialiser
  void _resetFilters() {
    setState(() {
      _subCategoryFilter = '';
      _marqueFilter = '';
      _categoryLocal = '';
      _filters = {
        'selectedCategories': [],
        'maxPrice': 100000,
        'searchQuery': '',
        'selectedRating': ''
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // const Color.fromARGB(239, 245, 245, 245),
      backgroundColor: AppColors.backgroundPrincal,
      key: _drawerKey,
      drawer: _buildFilterMenuDrawer(context),
      body: LayoutBuilder(
        builder: (context, constraints){
          return  CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.backgroundPrincal,
              automaticallyImplyLeading: false,
              toolbarHeight: constraints.maxWidth * AppSizes.converValueToadapter(context, 50),
              pinned: true,
              floating: true,
              // stretchTriggerOffset: 120.5,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text( widget.categoSelected == "" ?  "Boutique" : widget.categoSelected!,
                  style: GoogleFonts.roboto(
                    fontSize:
                       constraints.maxWidth * AppSizes.converValueToadapter(context, 20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              leading: 
                IconButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange),
                      
                  onPressed: () {
                    _drawerKey.currentState!.openDrawer();
                  },
                  icon: Icon(
                    Mdi.tuneVariant,
                    color: Colors.white,
                    size: constraints.maxWidth * AppSizes.converValueToadapter(context, 24),
                  ),
                  // label: Text(
                  //   "",
                  //   style: GoogleFonts.roboto(
                  //       color: Colors.white,
                  //       fontSize: MediaQuery.of(context).size.width *
                  //           AppSizes.fontSmall),
                  // ),
                ),
               
              
            ),
            SliverToBoxAdapter(
              child: _buildProductList(context,constraints),
            ),
          ],
        );
        }
       
      ),
      floatingActionButton: LayoutBuilder(
        builder: (context,constraints){
        return Container(
          width: constraints.maxWidth * AppSizes.converValueToadapter(context, 50),
          height: constraints.maxWidth * AppSizes.converValueToadapter(context, 50),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.2), // Couleur de l'ombre
              spreadRadius: 2, // Élargissement de l'ombre
              blurRadius: 5, // Flou de l'ombre
              offset: const Offset(3, 3), // Déplacement horizontal et vertical
            ),
          ], color: Colors.orange, borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context, 20),)),
          child: Consumer<CartProvider>(
            builder: (context, provider, child) {
              return Stack(
                children: [
                  IconButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CartView())),
                    icon: Icon(Icons.shopping_cart_outlined,
                        color: Colors.white,
                        size:constraints.maxWidth * AppSizes.converValueToadapter(context, 30),
                            ),
                  ),
                  if (provider.cart.isNotEmpty)
                    Positioned(
                      left: constraints.maxWidth * AppSizes.converValueToadapter(context, 25),
                      bottom: constraints.maxWidth * AppSizes.converValueToadapter(context, 30),
                      child: Badge.count(
                        count: provider.nombreArticles,
                        largeSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 35) / 2,
                        backgroundColor: Colors.black,
                        textStyle: GoogleFonts.roboto(
                          fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        );
        }
      ),
    );
  }

  Widget _buildFilterMenuDrawer(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context , constraints){
        return  Drawer(
        child: Container(
          color: AppColors.backgroundPrincal,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          _drawerKey.currentState!.closeDrawer();
                        },
                        icon: Icon(Icons.close,
                            size: constraints.maxWidth * AppSizes.converValueToadapter(context, 15),)
                                )
                  ],
                ),
              ),
              Text(
                'Rechercher'.toUpperCase(),
                style: GoogleFonts.roboto(
                    fontSize:
                        constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor),
              ),
              SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 16),),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _filters['searchQuery'] = value;
                  });
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: AppColors.productBackground,
                  hintText: 'Que voulez-vous ?',
                  hintStyle: GoogleFonts.roboto(
                      fontSize:
                         constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                      color: AppColors.textColor),
                ),
              ),
              SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 16)),
              Text(
                'Filtrer par prix'.toUpperCase(),
                style: GoogleFonts.roboto(
                    fontSize:
                        constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor),
              ),
              Slider(
                value: _filters['maxPrice'].toDouble(),
                min: 0,
                max: 100000,
                divisions: 100,
                label: '${_filters['maxPrice']} FCFA',
                thumbColor: Colors.black,
                activeColor: Colors.deepOrange,
                onChanged: (value) {
                  setState(() {
                    _filters['maxPrice'] = value.toInt();
                  });
                },
              ),
              SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 16),),
              Text(
                'Filtrer par individus'.toUpperCase(),
                style: GoogleFonts.roboto(
                    fontSize:
                       constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor),
              ),
              SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 16),),
              Wrap(
                spacing: 8,
                children: ['Hommes', 'Femmes', "Enfants"].map((type) {
                  return FilterChip(
                    label: Text(type,
                        style: GoogleFonts.roboto(
                          color: _subCategoryFilter == type ? Colors.white : null,
                        )),
                    selected: _subCategoryFilter == type,
                    selectedColor: _subCategoryFilter == type
                        ? AppColors.colorBtnPrimary
                        : null,
                    onSelected: (selected) {
                      setState(() {
                        _subCategoryFilter = selected ? type : '';
                        _drawerKey.currentState!.closeDrawer();
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 15),),
              const Divider(),
              SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 15),),
              Text(
                'Filtrer par Catégories'.toUpperCase(),
                style: GoogleFonts.roboto(
                    fontSize:
                        constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor),
              ),
               SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 16),),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: constraints.maxWidth * AppSizes.converValueToadapter(context, 8),
                children: [
                  'Accessoires',
                  'Vêtements',
                  "Chaussures",
                  'Sacs',
                ].map((category) {
                  return FilterChip(
                    label: Text(category,
                        style: GoogleFonts.roboto(
                          color: _categoryLocal == category ? Colors.white : null,
                        )),
                    selected: _categoryLocal == category,
                    selectedColor: _categoryLocal == category
                        ? AppColors.colorBtnPrimary
                        : null,
                    onSelected: (selected) {
                      setState(() {
                        _categoryLocal = selected ? category : '';
                        _drawerKey.currentState!.closeDrawer();
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 15),),
              const Divider(),
              SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 15),),
              Text(
                'Filtrer par Marques'.toUpperCase(),
                style: GoogleFonts.roboto(
                    fontSize:
                       constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor),
              ),
             SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 15),),
              Wrap(
                spacing: constraints.maxWidth * AppSizes.converValueToadapter(context, 8),
                children: _marques.map((marque) {
                  return FilterChip(
                    label: Text(marque.name,
                        style: GoogleFonts.roboto(
                          color:
                              _marqueFilter == marque.name ? Colors.white : null,
                        )),
                    selected: _marqueFilter == marque.name,
                    selectedColor: _marqueFilter == marque.name
                        ? AppColors.colorBtnPrimary
                        : null,
                    onSelected: (selected) {
                      setState(() {
                        _marqueFilter = selected ? marque.name : '';
                        _drawerKey.currentState!.closeDrawer();
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 15),),
              const Divider(),
              SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 15),),
              Text(
                'Produits les mieux notés'.toUpperCase(),
                style: GoogleFonts.roboto(
                    fontSize:
                        constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor),
              ),
              SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 15),),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [100, 80, 60, 40, 20].map((note) {
                  // Calcul du nombre d'étoiles en fonction de la note (20 = 1 étoile)
                  final starCount = (note / 20).round();
      
                  return FilterChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        starCount,
                        (index) => Icon(
                          Icons.star,
                          size: constraints.maxWidth * AppSizes.converValueToadapter(context, 20), // Taille de l'étoile
                          color: Colors.amber, // Couleur de l'étoile
                        ),
                      ),
                    ),
                    selected: _filters['selectedRating'] == note,
                    onSelected: (selected) {
                      setState(() {
                        _filters['selectedRating'] = selected ? note : 0;
                        _drawerKey.currentState!.closeDrawer();
                      });
                    },
                  );
                }).toList(),
              ),
             SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 15),),
              const Divider(),
               SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 15),),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.banerBtnNavigatorBackground),
                onPressed: _resetFilters,
                child: Text(
                  'Réinitialiser les filtres',
                  style: GoogleFonts.roboto(
                      fontSize:
                          constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 20),),
            ],
          ),
        ),
      );
      },
      
    );
  }

  Widget _buildProductList(BuildContext context,constraints) {
    final filteredProducts = _filteredProducts;
    bool isLoading = filteredProducts.isEmpty;
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 0),
      child: isLoading
          ? _buildShimmerLoading(context, constraints, itemCount: 5)
          : GridView.builder(
  physics: const NeverScrollableScrollPhysics(), // Désactive le défilement interne
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2, // Nombre de colonnes
    crossAxisSpacing: 2, // Espacement horizontal entre les cartes
    mainAxisSpacing: 2, // Espacement vertical entre les cartes
    childAspectRatio: 0.72, // Ratio largeur/hauteur pour les cartes
  ),
  shrinkWrap: true, // Adapte la hauteur du GridView à son contenu
  itemCount: filteredProducts.length,
  itemBuilder: (BuildContext context, int index) {
    ProductModel product = filteredProducts[index];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleProduct(product: product),
          ),
        );
      },
      child: ProductCard(product: product, constraints: constraints,),
    );
  },
)

    );
  }
  
 Widget _buildShimmerLoading(BuildContext context, constraints, {int itemCount = 10}) {
  return SizedBox(
    height: constraints.maxHeight,
    child: GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
      ),
      itemCount: itemCount,
      itemBuilder: (_, __) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            constraints.maxWidth * AppSizes.converValueToadapter(context, 10),
          ),
          color: Colors.white, // Fond général du conteneur
        ),
        margin: EdgeInsets.all(
          constraints.maxWidth * AppSizes.converValueToadapter(context, 4),
        ),
        padding: EdgeInsets.all(
          constraints.maxWidth * AppSizes.converValueToadapter(context, 8),
        ),
        width: constraints.maxWidth / 2.14,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Image principale du produit (Shimmer appliqué uniquement ici)
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: constraints.maxWidth,
                height: constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 125),
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.circular(
                    constraints.maxWidth * AppSizes.converValueToadapter(context, 10),
                  ),
                ),
              ),
            ),
            SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 5)),

            // 🔹 Liste des couleurs disponibles (Shimmer sur chaque couleur)
            SizedBox(
              height: constraints.maxWidth * AppSizes.converValueToadapter(context, 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      margin: EdgeInsets.only(
                        right: constraints.maxWidth * AppSizes.converValueToadapter(context, 8),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[350],
                        shape: BoxShape.rectangle,
                      ),
                      width: constraints.maxWidth * AppSizes.converValueToadapter(context, 20),
                      height: constraints.maxWidth * AppSizes.converValueToadapter(context, 20),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 5)),

            // 🔹 Nom du produit (Shimmer appliqué sur le texte)
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: constraints.maxWidth * 0.5,
                height: 16,
                color: Colors.grey[350],
              ),
            ),
            SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 3)),

            // 🔹 Prix (Shimmer appliqué)
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: constraints.maxWidth * 0.3,
                height: 14,
                color: Colors.grey[350],
              ),
            ),
            SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 3)),

            // 🔹 Évaluation (rating) en Shimmer
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: constraints.maxWidth * 0.4,
                height: 14,
                color: Colors.grey[350],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


}
