import 'package:ecom/utils/app_size.dart';
import 'package:flutter/material.dart';

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String mainImage;
  final double maxHeight;
  final double minHeight;
  final constraints;
  MySliverPersistentHeaderDelegate(
      {required this.maxHeight,
      required this.minHeight,
      required this.mainImage,
      required this.constraints
      });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      children: [
        Image.network(
         mainImage , // Laisse une chaîne vide si l'URL est null
  fit: BoxFit.contain,
  errorBuilder: (context, error, stackTrace) {
    return Image.asset("assets/images/default.jpg", fit: BoxFit.contain);
  },
          width: constraints.maxWidth,
          height: maxHeight,
        ),
        Positioned(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: constraints.maxWidth * AppSizes.converValueToadapter(context, 25),
                right:  constraints.maxWidth * AppSizes.converValueToadapter(context, 25),
              ),
              padding: EdgeInsets.all( constraints.maxWidth * AppSizes.converValueToadapter(context, 10)),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: const Color(0xFF1D1A30).withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          top: maxHeight - minHeight - shrinkOffset,
          child: Container(
            alignment: Alignment.center,
            width:  constraints.maxWidth,
            height: minHeight,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular( constraints.maxWidth * AppSizes.converValueToadapter(context, 30)),
                topRight: Radius.circular( constraints.maxWidth * AppSizes.converValueToadapter(context, 30)),
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width:  constraints.maxWidth * AppSizes.converValueToadapter(context, 60),
              height:  constraints.maxWidth * AppSizes.converValueToadapter(context, 5),
              color: const Color(0xFF1D1A30),
            ),
          ),
        )
      ],
    );
  }

  @override
  double get maxExtent => maxHeight > minHeight ? maxHeight : minHeight;

  @override
  double get minExtent => minHeight;

  // @override
  // bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
  //   return maxHeight != oldDelegate.maxExtent || minHeight != oldDelegate.minExtent ;
  // }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate is MySliverPersistentHeaderDelegate &&
        (mainImage != oldDelegate.mainImage ||
            maxHeight != oldDelegate.maxHeight ||
            minHeight != oldDelegate.minHeight);
  }
}
