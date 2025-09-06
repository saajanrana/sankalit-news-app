import 'package:Sankalit/core/app_text_style.dart';
import 'package:Sankalit/core/theme.dart';
import 'package:Sankalit/viewmodels/category_viewmodel.dart';
import 'package:Sankalit/views/widgets/category_screen_widgets/expandable_category_card.dart';
import 'package:Sankalit/views/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
     
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider).categories;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.lightBackgroundColor,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              const CommonHeader(),
              SizedBox(height: 20.h),
              const Text("CATEGORY", style: AppTextStyles.bodyBold),
              SizedBox(height: 10.h),
              Expanded(
                child: categories.isNotEmpty
                    ? ListView(
                        padding: EdgeInsets.zero,
                        children: categories.entries.map((entry) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.h),
                            child: ExpandableCategoryCard(
                              title: entry.key,
                              subCategories: entry.value, // Same format as before
                            ),
                          );
                        }).toList(),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
