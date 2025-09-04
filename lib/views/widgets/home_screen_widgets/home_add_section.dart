import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart'; // ✅ Add this package

class AddsDynamicImageList extends StatelessWidget {
  final List<dynamic> imageUrls;

  const AddsDynamicImageList({
    Key? key,
    required this.imageUrls,
  }) : super(key: key);

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("dataAdds::::$imageUrls");

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final ad = imageUrls[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: () {
                if (ad['url'] != null && ad['url'].toString().isNotEmpty) {
                  _launchURL(ad['url']);
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  ad['image'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        childCount: imageUrls.length,
      ),
    );
  }
}
