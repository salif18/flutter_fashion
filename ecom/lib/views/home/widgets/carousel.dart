import 'dart:async' show Future, StreamController, TimeoutException;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:ecom/models/produits_model.dart';
import 'package:ecom/services/products_api.dart';
import 'package:ecom/utils/app_color.dart';
import 'package:ecom/utils/app_size.dart';
import 'package:ecom/views/detail/single.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class MyCarouselWidget extends StatefulWidget {
  final constraints;
  const MyCarouselWidget({super.key, required this.constraints});

  @override
  State<MyCarouselWidget> createState() => _MyCarouselState();
}

class _MyCarouselState extends State<MyCarouselWidget> {
  List<ProductModel?> others = [];
  ServicesAPiProducts api = ServicesAPiProducts();
  int currentIndex = 0;

  // 1. Déclarez un StreamController
  late StreamController<List<ProductModel>> _articlesController;
  late Stream<List<ProductModel>> _articlesStream;

// 2. Initialisez le controller dans initState
  @override
  void initState() {
    super.initState();
    _articlesController = StreamController<
        List<ProductModel>>.broadcast(); // Broadcast pour plusieurs écouteurs
    _articlesStream = _articlesController.stream;
    _getProducts();
  }

// 3. Modifiez la méthode de récupération
  Future<void> _getProducts() async {
    try {
      final res = await api.getPromo();
      final body = res.data;

      if (res.statusCode == 200 && body["specialOffre"] != null) {
        // 4. Convertissez en List<ProductModel>
        final product = ProductModel.fromJson(body["specialOffre"]);
        _articlesController.add([product]); // Ajoutez à la stream
      } else {
        _articlesController.addError("Aucune offre spéciale trouvée");
      }
    }on DioException {
      api.showSnackBarErrorPersonalized(
          context, "Problème de connexion : Vérifiez votre Internet.");
    } on TimeoutException {
      api.showSnackBarErrorPersonalized(
          context, "Le serveur ne répond pas. Veuillez réessayer plus tard.");
    }  catch (e) {
      _articlesController.addError("Erreur: ${e.toString()}");
    }
  }

// 5. N'oubliez pas de fermer le controller
  @override
  void dispose() {
    _articlesController.close();
    super.dispose();
  }

  int getLength(data) {
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.constraints.maxWidth,
      height: widget.constraints.maxWidth *
          AppSizes.converValueToadapter(context, 250),
      padding: EdgeInsets.only(
          top: widget.constraints.maxWidth *
              AppSizes.converValueToadapter(context, 30)),
      child: Column(
        children: [
          StreamBuilder<List<ProductModel>>(
              stream: _articlesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return buildShimmerCarousel(widget.constraints, context);
                } else if (snapshot.hasError) {
                  return Text("Une erreur s'est produite", style: GoogleFonts.roboto(fontSize: 20));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text(
                    "No data available",
                    style: GoogleFonts.roboto(
                        fontSize: widget.constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 20)),
                  );
                } else {
                  getLength(snapshot.data!.length);

                  return CarouselSlider(
                    items: snapshot.data![0].othersColors.map((item) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SingleProduct(
                                      product: snapshot.data![0])));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: widget.constraints.maxWidth *
                                  AppSizes.converValueToadapter(context, 16),
                              vertical: widget.constraints.maxWidth *
                                  AppSizes.converValueToadapter(context, 8)),
                          // height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                widget.constraints.maxWidth *
                                    AppSizes.converValueToadapter(context, 20)),
                            color: AppColors.banerBtnNavigatorBackground,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                        child: Text(
                                      "Spécial offre",
                                      style: GoogleFonts.roboto(
                                          fontSize:
                                              widget.constraints.maxWidth *
                                                  AppSizes.converValueToadapter(
                                                      context, 14),
                                          color: Colors.white),
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                    Flexible(
                                        child: Text(
                                      "-${snapshot.data![0].discountPercentage!.floor()}% de réduction",
                                      style: GoogleFonts.roboto(
                                          fontSize:
                                              widget.constraints.maxWidth *
                                                  AppSizes.converValueToadapter(
                                                      context, 14),
                                          color: Colors.white),
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    )),
                                    SizedBox(
                                        height: widget.constraints.maxWidth *
                                            AppSizes.converValueToadapter(
                                                context, 5)),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SingleProduct(
                                                          product: snapshot
                                                              .data![0])));
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.colorBtnSecondary,
                                            minimumSize: Size(
                                                widget.constraints.maxWidth *
                                                    AppSizes
                                                        .converValueToadapter(
                                                            context, 100),
                                                widget.constraints.maxWidth *
                                                    AppSizes
                                                        .converValueToadapter(
                                                            context, 30))),
                                        child: Text(
                                          "Acheter".toUpperCase(),
                                          style: GoogleFonts.roboto(
                                              fontSize: widget
                                                      .constraints.maxWidth *
                                                  AppSizes.converValueToadapter(
                                                      context, 12),
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white70),
                                        ))
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  width: widget.constraints.maxWidth *
                                      AppSizes.converValueToadapter(context, 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        widget.constraints.maxWidth *
                                            AppSizes.converValueToadapter(
                                                context, 20)),
                                    color:
                                        AppColors.banerBtnNavigatorBackground,
                                    image: DecorationImage(
                                      image: item.images != null &&
                                              item.images!.isNotEmpty
                                          ? NetworkImage(item.images!)
                                              as ImageProvider
                                          : const AssetImage(
                                              "assets/images/default.jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                        height: widget.constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 170),
                        enlargeCenterPage: true,
                        aspectRatio: widget.constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 16) /
                            9,
                        autoPlay: true,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        viewportFraction: 0.95,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        }),
                  );
                }
              }),
          SizedBox(
              height: widget.constraints.maxWidth *
                  AppSizes.converValueToadapter(context, 20)),
          DotsIndicator(
            dotsCount: 4,
            position: currentIndex.toInt(),
            decorator: DotsDecorator(
                size: const Size(12.0, 12.0),
                activeSize: const Size(40.0, 12.0),
                color: Colors.grey[400]!,
                activeColor: AppColors.colorBtnSecondary,
                // const Color.fromARGB(255, 5, 191, 100),
                spacing: EdgeInsets.all(widget.constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 3)),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      widget.constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 5)),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      widget.constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 5)),
                )),
          ),
        ],
      ),
    );
  }
  Widget buildShimmerCarousel(BoxConstraints constraints, BuildContext context) {
  return CarouselSlider(
    items: List.generate(
      3, // Nombre de slides fictifs
      (index) => Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(
          horizontal: constraints.maxWidth *
              AppSizes.converValueToadapter(context, 16),
          vertical: constraints.maxWidth *
              AppSizes.converValueToadapter(context, 8),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            constraints.maxWidth * AppSizes.converValueToadapter(context, 20),
          ),
          color: Colors.grey[300], // Fond du container
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Shimmer pour le titre
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: constraints.maxWidth * 0.5,
                      height: 16,
                      color: Colors.grey[350],
                    ),
                  ),
                  SizedBox(height: 10),

                  // 🔹 Shimmer pour le texte de réduction
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: constraints.maxWidth * 0.7,
                      height: 20,
                      color: Colors.grey[350],
                    ),
                  ),
                  SizedBox(height: 10),

                  // 🔹 Shimmer pour le bouton
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: constraints.maxWidth * 0.4,
                      height: 40,
                      color: Colors.grey[350],
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Shimmer pour l'image produit
            Expanded(
              flex: 1,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: constraints.maxWidth * 0.3,
                  height: constraints.maxWidth * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      constraints.maxWidth * AppSizes.converValueToadapter(context, 20),
                    ),
                    color: Colors.grey[350],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    options: CarouselOptions(
      height: constraints.maxWidth * AppSizes.converValueToadapter(context, 180),
      enlargeCenterPage: true,
      autoPlay: false,
      viewportFraction: 0.8,
    ),
  );
}
}
