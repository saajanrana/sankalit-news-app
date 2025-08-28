import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Sankalit/core/app_text_style.dart';
import 'package:Sankalit/core/theme.dart';
import 'package:Sankalit/views/widgets/category_screen_widgets/expandable_category_card.dart';
import 'package:Sankalit/views/widgets/common_header.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final Map<String, dynamic> data = {
    "गढ़वाल": [
      {"id": 2, "name": "चमोली"},
      {"id": 3, "name": "देहरादून"},
      {"id": 4, "name": "हरिद्वार"},
      {"id": 5, "name": "पौड़ी गढ़वाल"},
      {"id": 6, "name": "रूद्रप्रयाग"},
      {"id": 7, "name": "टिहरी गढ़वाल"},
      {"id": 8, "name": "उत्तरकाशी"}
    ],
    "कुमाऊं": [
      {"id": 9, "name": "अल्मोड़ा"},
      {"id": 10, "name": "बागेश्वर"},
      {"id": 11, "name": "चंपावत"},
      {"id": 12, "name": "नैनीताल"},
      {"id": 13, "name": "पिथौरागढ़"},
      {"id": 14, "name": "उधमसिंह नगर"}
    ],
    "उत्तराखण्ड": [
      {"id": 1, "name": "उत्तराखण्ड"}
    ],
    "देश": [
      {"id": 15, "name": "देश"}
    ],
    "विदेश": [
      {"id": 16, "name": "विदेश"}
    ],
    "राजनीति": [
      {"id": 17, "name": "राजनीति"}
    ],
    "पर्यटन": [
      {"id": 18, "name": "पर्यटन"}
    ],
    "खेल": [
      {"id": 19, "name": "खेल"}
    ],
    "मनोरंजन": [
      {"id": 20, "name": "मनोरंजन"}
    ],
    "उत्तर प्रदेश": [
      {"id": 21, "name": "उत्तर प्रदेश"}
    ],
    "ऋषिकेश": [
      {"id": 22, "name": "ऋषिकेश"}
    ],
    "अंतर्राष्ट्रीय": [
      {"id": 23, "name": "अंतर्राष्ट्रीय"}
    ],
    " धार्मिक": [
      {"id": 24, "name": " धार्मिक"}
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.lightBackgroundColor,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h),
              const CommonHeader(),
              SizedBox(height: 20.h),
              const Text("CATEGORY", style: AppTextStyles.bodyBold),
              SizedBox(height: 20.h),
              Expanded(
                  child: ListView(
                padding: EdgeInsets.symmetric(vertical: 0.h),
                children: data.entries.map((entry) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: ExpandableCategoryCard(title: entry.key, subCategories: entry.value),
                  );
                }).toList(),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
