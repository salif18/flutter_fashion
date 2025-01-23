import 'package:ecom/models/produits_model.dart';
import 'package:ecom/providers/favorite_provider.dart';
import 'package:ecom/utils/app_color.dart';
import 'package:ecom/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FavoriteCard extends StatelessWidget {
  final ProductModel item;
  const FavoriteCard({super.key,required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 120,
          padding: const EdgeInsets.symmetric(vertical:20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: const Border(
                  bottom:
                      BorderSide(color: Color.fromARGB(255, 219, 219, 219)))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: NetworkImage(item.image!), fit: BoxFit.contain)),
                ),
              ),
              Expanded(
                  child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.5, // Ajustez selon vos besoins
                        child: Text(
                          item.name!,
                          style: GoogleFonts.roboto(
                            fontSize: MediaQuery.of(context).size.width *
                                AppSizes.fontSmall,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                        Text(item.price.toString(),
                            style: GoogleFonts.roboto(
                                fontSize:MediaQuery.of(context).size.width * AppSizes.fontSmall, color: const Color(0xFF1D1A30)))
                      ],
                    ),
                  ),
                  SizedBox(
                    child: IconButton(
                        onPressed: () {
                           Provider.of<FavoriteProvider>(context,listen:false).removeToFavorite(item);
                        },
                        icon:  Icon(Icons.favorite_rounded,color: Colors.red, size:MediaQuery.of(context).size.width * AppSizes.iconLarge)),
                  )
                ],
              ))
            ],
          )),
    );
  }
}