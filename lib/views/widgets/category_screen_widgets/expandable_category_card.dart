import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Sankalit/views/widgets/category_screen_widgets/category_card.dart';

class ExpandableCategoryCard extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> subCategories;
  const ExpandableCategoryCard({
    super.key,
    required this.title,
    required this.subCategories,
  });

  @override
  State<ExpandableCategoryCard> createState() => _ExpandableCategoryCardState();
}

class _ExpandableCategoryCardState extends State<ExpandableCategoryCard> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CategoryCard(
          tileTitle: widget.title,
          didHaveSubCategory: widget.subCategories.length > 1,
          subCategoryIsOpen: _isExpanded,
          isSelected: _isExpanded,
          onTap: () {
            if (widget.subCategories.length > 1) {
              setState(() => _isExpanded = !_isExpanded);
            } else {
              // Navigate directly if only one subcategory
              final item = widget.subCategories.first;
              print("Tapped on ${item['name']} (id: ${item['id']})");
            }
          },
        ),
        if (_isExpanded)
          Padding(
            padding: EdgeInsets.only(left: 10.w, top: 5.h),
            child: Column(
              children: widget.subCategories.map((item) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: CategoryCard(
                    tileTitle: item['name'],
                    isSelected: _isExpanded,
                    onTap: () {
                      print("Tapped on ${item['name']} (id: ${item['id']})");
                    },
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
