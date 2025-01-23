import 'dart:async' show Future, StreamController;
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:ecom/models/produits_model.dart';
import 'package:ecom/services/products_api.dart';
import 'package:ecom/utils/app_color.dart';
import 'package:ecom/utils/app_size.dart';
import 'package:ecom/views/detail/single.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyCarouselWidget extends StatefulWidget {
  const MyCarouselWidget({super.key});

  @override
  State<MyCarouselWidget> createState() => _MyCarouselState();
}

class _MyCarouselState extends State<MyCarouselWidget> {
  final StreamController<List<ProductModel>> _articlesData = StreamController();
  List<ProductModel?> others = [];
  ServicesAPiProducts api = ServicesAPiProducts();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  @override
  void dispose() {
    _articlesData.close();
    super.dispose();
  }

  // fonction fetch data articles depuis server
  Future<void> _getProducts() async {
    try {
      final res = await api.getPromo();
      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        if (body["specialOffre"] != null && body["specialOffre"] is Map) {
          // Convertissez l'objet en un ProductModel unique
          final product = ProductModel.fromJson(body["specialOffre"]);
          others.add(product);
          // Ajoutez ce produit dans une liste pour respecter le flux de type List<ProductModel>
          _articlesData.add([product]);
        } else {
          throw Exception("Failed to load products ");
        }
      }
    } catch (e) {
      _articlesData.addError("");
    }
  }

  int getLength(data) {
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              StreamBuilder<List<ProductModel>>(
                  stream: _articlesData.stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("err",
                          style: GoogleFonts.roboto(fontSize: 20));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text(
                        "No data available",
                        style: GoogleFonts.roboto(fontSize: 20),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 5),
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors.banerBtnNavigatorBackground,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                          child: Text(
                                        "Spécial offre",
                                        style: GoogleFonts.roboto(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                AppSizes.fontMedium,
                                            color: Colors.white),
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                      Flexible(
                                          child: Text(
                                        "-${snapshot.data![0].discountPercentage!.floor()}% de réduction",
                                        style: GoogleFonts.roboto(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                AppSizes.fontMedium,
                                            color: Colors.white),
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      )),
                                      const SizedBox(height: 5),
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
                                              minimumSize: const Size(100, 40)),
                                          child: Text(
                                            "Acheter".toUpperCase(),
                                            style: GoogleFonts.roboto(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    AppSizes.fontSmall,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white70),
                                          ))
                                    ],
                                  ),
                                  Container(
                                    width: 110,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color:
                                          AppColors.banerBtnNavigatorBackground,
                                      image: DecorationImage(
                                          image: NetworkImage(item.images!),
                                          fit: BoxFit.contain),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                            height: 240,
                            enlargeCenterPage: true,
                            aspectRatio: 16 / 9,
                            autoPlay: true,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            viewportFraction: 0.8,
                            onPageChanged: (index, reason) {
                              setState(() {
                                currentIndex = index;
                              });
                            }),
                      );
                    }
                  }),
              const SizedBox(height: 20),
              DotsIndicator(
                dotsCount: 4  ,
                position: currentIndex.toInt(),
                decorator: DotsDecorator(
                    size: const Size(12.0, 12.0),
                    activeSize: const Size(40.0, 12.0),
                    color: Colors.grey[400]!,
                    activeColor: AppColors.colorBtnSecondary,
                    // const Color.fromARGB(255, 5, 191, 100),
                    spacing: const EdgeInsets.all(3.0),
                    activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
              ),
            ],
          ),
        ),
      );
    });
  }
}
