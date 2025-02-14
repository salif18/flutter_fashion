import 'dart:async';

import 'package:dio/dio.dart';
import 'package:ecom/models/produits_model.dart';
import 'package:ecom/services/products_api.dart';
import 'package:ecom/utils/app_color.dart';
import 'package:ecom/utils/app_size.dart';
import 'package:ecom/views/detail/single.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class PromoView extends StatefulWidget {
  const PromoView({super.key});

  @override
  State<PromoView> createState() => _PromoViewState();
}

class _PromoViewState extends State<PromoView> {
  ServicesAPiProducts api = ServicesAPiProducts();

  Stream<List<ProductModel>> fetchProductPromoData() async* {
  
    try {
        final res = await api.getAllPromo();
    final body = res.data;
      if (res.statusCode == 200) {
        // Vérifiez la structure ici
        yield (body["offres"] as List)
            .map((json) => ProductModel.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to load products ");
      }
    } on DioException {
      api.showSnackBarErrorPersonalized(
          context, "Problème de connexion : Vérifiez votre Internet.");
      print("Erreur de connexion : Impossible d'accéder au serveur.");
    } on TimeoutException {
      api.showSnackBarErrorPersonalized(
          context, "Le serveur ne répond pas. Veuillez réessayer plus tard.");
      print("Erreur : Temps d'attente dépassé.");
    }catch (e) {
      throw Exception("Erreur serveur  : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrincal,
      body: LayoutBuilder(builder: (context, constraints) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.backgroundPrincal,
              floating: true,
              pinned: true,
              toolbarHeight: constraints.maxWidth *
                  AppSizes.converValueToadapter(context, 50),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "Promotion",
                  style: GoogleFonts.roboto(
                      fontSize: constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 20),
                      fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 16),
                    vertical: constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Meilleures offres',
                      style: GoogleFonts.roboto(
                        fontSize: constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 16),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios_sharp,
                        size: constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            StreamBuilder<List<ProductModel>>(
              stream: fetchProductPromoData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverFillRemaining(
                    child: buildShimmerProductCard(context, constraints)
                  );
                } else if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        "Une erreur s'est produite lors du chargement",
                        style: GoogleFonts.roboto(
                          fontSize: constraints.maxWidth *
                              AppSizes.converValueToadapter(context, 14),
                        ),
                      ),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        "Aucune donnée disponible",
                        style: GoogleFonts.roboto(
                          fontSize: constraints.maxWidth *
                              AppSizes.converValueToadapter(context, 14),
                        ),
                      ),
                    ),
                  );
                } else {
                  final products = snapshot.data!;
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal:constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
                    sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 1,
                          childAspectRatio: 0.85,
                        ),
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          final product = products[index];
                          return GestureDetector(
                            onTap: () {
                              // Action on product tap
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SingleProduct(product: product)));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                // color: AppColors.productBackground,
                                borderRadius: BorderRadius.circular(constraints
                                        .maxWidth *
                                    AppSizes.converValueToadapter(context, 16)),
                              ),
                              // padding: EdgeInsets.all(constraints.maxWidth *
                              //     AppSizes.converValueToadapter(context, 8)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(children: [
                                    Container(
                                      width: constraints.maxWidth,
                                      height: constraints.maxWidth *
                                          AppSizes.converValueToadapter(
                                              context, 150),
                                               padding: EdgeInsets.all(
                          constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 5),
                            ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(
                                            constraints.maxWidth *
                                                AppSizes.converValueToadapter(
                                                    context, 16)),
                                        image: DecorationImage(
                                          image: product.image != null &&
                                                  product.image!.isNotEmpty
                                              ? NetworkImage(product.image!)
                                                  as ImageProvider
                                              : const AssetImage(
                                                  "assets/images/default.jpg"),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        child: Container(
                                      width: constraints.maxWidth *
                                          AppSizes.converValueToadapter(
                                              context, 40),
                                      height: constraints.maxWidth *
                                          AppSizes.converValueToadapter(
                                              context, 40),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              // ignore: deprecated_member_use
                                              color: Colors.black
                                                  // ignore: deprecated_member_use
                                                  .withOpacity(
                                                      0.2), // Couleur de l'ombre
                                              spreadRadius:
                                                  2, // Élargissement de l'ombre
                                              blurRadius: 5, // Flou de l'ombre
                                              offset: const Offset(3,
                                                  3), // Déplacement horizontal et vertical
                                            ),
                                          ],
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Text(
                                        "-${product.discountPercentage!.floor().toString()}%",
                                        style: GoogleFonts.roboto(
                                            fontSize: constraints.maxWidth *
                                                AppSizes.converValueToadapter(
                                                    context, 14),
                                            color: Colors.white),
                                      ),
                                    ))
                                  ]),
                                  SizedBox(
                                      height: constraints.maxWidth *
                                          AppSizes.converValueToadapter(
                                              context, 10)),
                                  Container(
                                     padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 5),
                            vertical: constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 2),),
                                    child: Text(
                                      product.name ?? "",
                                      style: GoogleFonts.roboto(
                                        fontSize: constraints.maxWidth *
                                            AppSizes.converValueToadapter(
                                                context, 12),
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textColor,
                                      ),
                                      // softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      // maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }, childCount: products.length)),
                  );
                }
              },
            )
          ],
        );
      }),
    );
  }

  Widget buildShimmerProductCard(BuildContext context, BoxConstraints constraints) {
  return SizedBox(
    height: constraints.maxHeight,
    child: GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
      ),
      itemCount: 10,
      itemBuilder: (_, __) => GestureDetector(
    onTap: () {},
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          constraints.maxWidth * AppSizes.converValueToadapter(context, 16),
        ),
        color: Colors.white, // Fond du conteneur
      ),
      padding: EdgeInsets.all(
        constraints.maxWidth * AppSizes.converValueToadapter(context, 8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // 🔹 Image du produit (Shimmer)
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: constraints.maxWidth,
                  height: constraints.maxWidth * AppSizes.converValueToadapter(context, 150),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      constraints.maxWidth * AppSizes.converValueToadapter(context, 16),
                    ),
                    color: Colors.grey[350], // Placeholder
                  ),
                ),
              ),

              // 🔹 Badge de réduction (Shimmer)
              Positioned(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: constraints.maxWidth * AppSizes.converValueToadapter(context, 40),
                    height: constraints.maxWidth * AppSizes.converValueToadapter(context, 40),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey[350],
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 10)),

          // 🔹 Nom du produit (Shimmer)
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: constraints.maxWidth * 0.6,
              height: 16,
              color: Colors.grey[350],
            ),
          ),
        ],
      ),
    ),
  )
    ),
  );
  }

}
