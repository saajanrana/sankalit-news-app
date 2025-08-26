import 'package:flutter/material.dart';

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
    return Container(
      height: 40,
      // margin: const EdgeInsets.symmetric(vertical: 10),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
