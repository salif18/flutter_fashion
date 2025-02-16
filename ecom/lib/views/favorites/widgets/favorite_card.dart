import 'package:ecom/models/produits_model.dart';
import 'package:ecom/providers/favorite_provider.dart';
import 'package:ecom/utils/app_color.dart';
import 'package:ecom/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FavoriteCard extends StatelessWidget {
  final ProductModel item;
  final constraints;
  const FavoriteCard(
      {super.key, required this.item, required this.constraints});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal:
              constraints.maxWidth * AppSizes.converValueToadapter(context, 1),
          vertical:
              constraints.maxWidth * AppSizes.converValueToadapter(context, 2)),
      child: Container(
          width: constraints.maxWidth,
          height: constraints.maxWidth *
              AppSizes.converValueToadapter(context, 100),
          padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth *
                  AppSizes.converValueToadapter(context, 8),
              vertical: constraints.maxWidth *
                  AppSizes.converValueToadapter(context, 8)),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(constraints.maxWidth *
                  AppSizes.converValueToadapter(context, 8)),
              border: const Border(
                  bottom:
                      BorderSide(color: Color.fromARGB(255, 219, 219, 219)))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 16)),
                      image: DecorationImage(
                        image: item.image != null && item.image!.isNotEmpty
                            ? NetworkImage(item.image!) as ImageProvider
                            : const AssetImage("assets/images/default.jpg"),
                        fit: BoxFit.contain,
                      )),
                ),
              ),
              SizedBox(
                width: constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 10),
              ),
              Expanded(
                  flex: 3,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: constraints
                                    .maxWidth, // Ajustez selon vos besoins
                                child: Text(
                                  item.name ?? "",
                                  style: GoogleFonts.roboto(
                                    fontSize: constraints.maxWidth *
                                        AppSizes.converValueToadapter(
                                            context, 14),
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
                                      fontSize: constraints.maxWidth *
                                          AppSizes.converValueToadapter(
                                              context, 14),
                                      color: const Color(0xFF1D1A30)))
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          child: IconButton(
                              onPressed: () {
                                Provider.of<FavoriteProvider>(context,
                                        listen: false)
                                    .removeToFavorite(item);
                              },
                              icon: Icon(Icons.favorite_rounded,
                                  color: Colors.red,
                                  size: constraints.maxWidth *
                                      AppSizes.converValueToadapter(
                                          context, 24))),
                        ),
                      )
                    ],
                  ))
            ],
          )),
    );
  }
}
