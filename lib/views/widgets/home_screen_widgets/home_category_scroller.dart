import 'package:Sankalit/core/app_text_style.dart';
import 'package:Sankalit/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HorizontalCategoryTabs extends StatefulWidget {
  final List<String> categories;
  final Function(int) onTabSelected;
  final int initialIndex;

  const HorizontalCategoryTabs({
    Key? key,
    required this.categories,
    required this.onTabSelected,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  _HorizontalCategoryTabsState createState() => _HorizontalCategoryTabsState();
}

class _HorizontalCategoryTabsState extends State<HorizontalCategoryTabs> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categories.isEmpty) {
      return _buildShimmerTabs();
    }

    // ✅ Otherwise, show actual category tabs
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onTabSelected(index);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.red : Colors.black,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  widget.categories[index],
                  style: AppTextStyles.heading3Hindi.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkTextPrimary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  Widget _buildShimmerTabs() {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6, // number of shimmer placeholders
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: 80,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
