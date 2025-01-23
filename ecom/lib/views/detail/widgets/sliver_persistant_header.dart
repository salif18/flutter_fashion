import 'package:flutter/material.dart';

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String mainImage;
  final double maxHeight;
  final double minHeight;
  MySliverPersistentHeaderDelegate(
      {required this.maxHeight,
      required this.minHeight,
      required this.mainImage});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      children: [
        Image.network(
          mainImage,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          height: maxHeight,
        ),
        Positioned(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: 25,
                right: 25,
              ),
              padding: const EdgeInsets.all(10),
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
            width: MediaQuery.of(context).size.width,
            height: minHeight,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: 60,
              height: 5,
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
