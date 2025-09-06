import 'package:sankalit/core/app_text_style.dart';
import 'package:sankalit/core/theme.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;

    // Delay centering initial tab until after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCenter(selectedIndex);
    });
  }

  void _scrollToCenter(int index) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    // Find the widget by key
    final key = ValueKey(index);
    final contextBox = _keys[index].currentContext;
    if (contextBox == null) return;

    final RenderBox renderBox = contextBox.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    final screenWidth = MediaQuery.of(context).size.width;
    final targetScrollOffset = _scrollController.offset + position.dx - (screenWidth / 2) + (size.width / 2);

    _scrollController.animateTo(
      targetScrollOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  final List<GlobalKey> _keys = [];

  @override
  Widget build(BuildContext context) {
    if (_keys.length != widget.categories.length) {
      _keys.clear();
      _keys.addAll(List.generate(widget.categories.length, (_) => GlobalKey()));
    }

    return SizedBox(
      height: 45,
      child: ListView.builder(
        controller: _scrollController,
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
              _scrollToCenter(index); // 👈 center selected tab
            },
            child: Container(
              key: _keys[index], // 👈 attach key for measurement
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
