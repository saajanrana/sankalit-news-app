
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddsDynamicImageList extends StatelessWidget {
  final List<String> imageUrls;

  const AddsDynamicImageList({
    Key? key,
    required this.imageUrls,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            for (int i = 0; i < imageUrls.length; i++) ...[
              ClipRRect(
                // borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  imageUrls[i],
                  width: double.infinity,
                  height: 50.h,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),
              if (i != imageUrls.length - 1)
                SizedBox(height: 10.h), // Space between images
            ],
          ],
        ),
      ),
    );
  }
}
