import 'package:ecom/providers/cart_provider.dart';
import 'package:ecom/utils/app_color.dart';
import 'package:ecom/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyCard extends StatefulWidget {
  final CartItem item;
  final constraints;
  const MyCard({super.key, required this.item, required this.constraints});

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
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Container(
          width: widget.constraints.maxWidth,
          height: widget.constraints.maxWidth *
              AppSizes.converValueToadapter(context, 125),
          padding: EdgeInsets.symmetric(
              horizontal: widget.constraints.maxWidth *
                  AppSizes.converValueToadapter(context, 10)),
          margin: EdgeInsets.symmetric(
              vertical: widget.constraints.maxWidth *
                  AppSizes.converValueToadapter(context, 1)),
          decoration: BoxDecoration(
              color: AppColors.productBackground,
              borderRadius: BorderRadius.circular(widget.constraints.maxWidth *
                  AppSizes.converValueToadapter(context, 5))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  // margin: EdgeInsets.only(right: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 5)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          widget.constraints.maxWidth *
                              AppSizes.converValueToadapter(context, 5)),
                      image: DecorationImage(
                        image: widget.item.img != null &&
                                widget.item.img.isNotEmpty
                            ? NetworkImage(widget.item.img) as ImageProvider
                            : const AssetImage("assets/images/default.jpg"),
                        fit: BoxFit.contain,
                      )),
                ),
              ),
              SizedBox(
                width: widget.constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 10),
              ),
              Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              // Ajustez selon vos besoins
                              child: Text(
                                widget.item.name,
                                style: GoogleFonts.roboto(
                                  fontSize: widget.constraints.maxWidth *
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
                            Row(
                              children: [
                                Text("Couleur",
                                    style: GoogleFonts.roboto(
                                        fontSize: widget.constraints.maxWidth *
                                            AppSizes.converValueToadapter(
                                                context, 14),
                                        color: const Color(0xff121212))),
                                SizedBox(
                                    width: widget.constraints.maxWidth *
                                        AppSizes.converValueToadapter(
                                            context, 5)),
                                Container(
                                  margin: EdgeInsets.all(
                                      widget.constraints.maxWidth *
                                          AppSizes.converValueToadapter(
                                              context, 5)),
                                  decoration: BoxDecoration(
                                    color:
                                        parsedColor(widget.item.selectedColor),
                                    shape: BoxShape
                                        .circle, // Forme ronde pour le conteneur
                                  ),
                                  width: widget.constraints.maxWidth *
                                      AppSizes.converValueToadapter(
                                          context, 10),
                                  height: widget.constraints.maxWidth *
                                      AppSizes.converValueToadapter(
                                          context, 10),
                                ),
                              ],
                            ),
                            if (widget.item.selectedSize.isNotEmpty)
                              Row(
                                children: [
                                  Text("Size",
                                      style: GoogleFonts.roboto(
                                          fontSize:
                                              widget.constraints.maxWidth *
                                                  AppSizes.converValueToadapter(
                                                      context, 14),
                                          color: const Color(0xff121212))),
                                  SizedBox(
                                      width: widget.constraints.maxWidth *
                                          AppSizes.converValueToadapter(
                                              context, 5)),
                                  Text(widget.item.selectedSize,
                                      style: GoogleFonts.roboto(
                                          fontSize:
                                              widget.constraints.maxWidth *
                                                  AppSizes.converValueToadapter(
                                                      context, 14),
                                          color: const Color(0xff121212))),
                                ],
                              ),
                            Text("${widget.item.price.toString()} Fcfa",
                                style: GoogleFonts.roboto(
                                    fontSize: widget.constraints.maxWidth *
                                        AppSizes.converValueToadapter(
                                            context, 14),
                                    color: const Color(0xff121212)))
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: widget.constraints.maxHeight,
                          decoration: BoxDecoration(
                              color: AppColors.banerBtnNavigatorBackground,
                              borderRadius: BorderRadius.circular(widget
                                      .constraints.maxWidth *
                                  AppSizes.converValueToadapter(context, 10)),
                              border: Border.all(
                                color: AppColors.banerBtnNavigatorBackground,
                              )),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: widget.constraints.maxWidth,
                                height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,50),
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
                                            fontSize: widget
                                                    .constraints.maxWidth *
                                                AppSizes.converValueToadapter(
                                                    context, 12),
                                            fontWeight: FontWeight.bold))),
                              ),
                              Container(
                                width: widget.constraints.maxWidth,
                                alignment: Alignment.center,
                                child: Text(widget.item.qty.toString(),
                                    style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: widget.constraints.maxWidth *
                                            AppSizes.converValueToadapter(
                                                context, 12),
                                        fontWeight: FontWeight.bold)),
                              ),
                              if (widget.item.qty > 1)
                                Container(
                                  alignment: Alignment.center,
                                  width: widget.constraints.maxWidth,
                                    height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,50),
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
                                              fontSize: widget
                                                      .constraints.maxWidth *
                                                  AppSizes.converValueToadapter(
                                                      context, 12),
                                              fontWeight: FontWeight.bold))),
                                )
                            ],
                          ),
                        ),
                      )
                    ],
                  ))
            ],
          )),
    );
  }
}
