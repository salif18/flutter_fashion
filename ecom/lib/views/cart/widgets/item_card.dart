import 'package:ecom/providers/cart_provider.dart';
import 'package:ecom/utils/app_color.dart';
import 'package:ecom/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyCard extends StatefulWidget {
  final CartItem item;
  const MyCard({super.key, required this.item});

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  Color? parsedColor(String color) {
    try {
      return color.startsWith("#")
          ? Color(int.parse("0xFF${color.substring(1)}"))
          : Colors.primaries.firstWhere(
              (c) => c.toString().toLowerCase().contains(color.toLowerCase()),
              orElse: () => Colors.grey, // Couleur par défaut si non trouvée
            );
    } catch (e) {
      return Colors.grey; // Couleur par défaut en cas d'erreur
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.symmetric(vertical:1,horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.productBackground,
            borderRadius: BorderRadius.circular(10)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 80,
                width: 80,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: NetworkImage(widget.item.img),
                        fit: BoxFit.contain)),
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.5, // Ajustez selon vos besoins
                        child: Text(
                          widget.item.name,
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
                      Row(
                        children: [
                          Text("Couleur",
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: const Color(0xff121212))),
                          const SizedBox(width: 5),
                          Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: parsedColor(widget.item.selectedColor),
                              shape: BoxShape
                                  .circle, // Forme ronde pour le conteneur
                            ),
                            width: 20,
                            height: 20,
                          ),
                        ],
                      ),
                      if(widget.item.selectedSize.isNotEmpty)
                      Row(
                        children: [
                          Text("Size",
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: const Color(0xff121212))),
                          const SizedBox(width: 5),
                          Text(widget.item.selectedSize,
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: const Color(0xff121212))),
                        ],
                      ),
                      Text("${widget.item.price.toString()} Fcfa",
                          style: GoogleFonts.roboto(
                              fontSize: 14, color: const Color(0xff121212)))
                    ],
                  ),
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                        color: AppColors.banerBtnNavigatorBackground,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.banerBtnNavigatorBackground,
                        )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          alignment: Alignment.center,
                          child: TextButton(
                              onPressed: () {
                                Provider.of<CartProvider>(context,
                                        listen: false)
                                    .incrementQuantity(
                                        widget.item.id,
                                        widget.item.selectedSize,
                                        widget.item.selectedColor);
                              },
                              child: Text("+",
                                  style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))),
                        ),
                        Container(
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(widget.item.qty.toString(),
                              style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                        if (widget.item.qty > 1)
                          Container(
                            alignment: Alignment.center,
                            width: 50,
                            child: TextButton(
                                onPressed: () {
                                  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .decrementQuantity(
                                          widget.item.id,
                                          widget.item.selectedSize,
                                          widget.item.selectedColor);
                                },
                                child: Text("-",
                                    style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))),
                          )
                      ],
                    ),
                  )
                ],
              ))
            ],
          )),
    );
  }
}
