import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddsDynamicImageList extends StatelessWidget {
  final List<dynamic> imageUrls;

  const AddsDynamicImageList({
    Key? key,
    required this.imageUrls,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("dataAdds::::$imageUrls");

    // return SizedBox();
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final ad = imageUrls[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(ad['image']),
          );
        },
        childCount: imageUrls.length,
      ),
    );
    // child: Column(
    //   children: [
    //     for (int i = 0; i < imageUrls.length; i++) ...[
    //       ClipRRect(
    //         // borderRadius: BorderRadius.circular(12.r),
    //         child: Image.network(
    //           imageUrls[i],
    //           width: double.infinity,
    //           height: 50.h,
    //           fit: BoxFit.fill,
    //           errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
    //         ),
    //       ),
    //       if (i != imageUrls.length - 1) SizedBox(height: 10.h), // Space between images
    //     ],
    //   ],
    // ),
    //       ),
    // );
  }
}
