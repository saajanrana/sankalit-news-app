import 'package:flutter/material.dart';

class AutoScrollTextCarousel extends StatefulWidget {
  const AutoScrollTextCarousel({
    Key? key,
    required this.items,
    this.duration = const Duration(seconds: 2),
    this.textStyle,
  }) : super(key: key);

  final List<String> items;
  final Duration duration;
  final TextStyle? textStyle;

  @override
  State<AutoScrollTextCarousel> createState() => _AutoScrollTextCarouselState();
}

class _AutoScrollTextCarouselState extends State<AutoScrollTextCarousel>
    with AutomaticKeepAliveClientMixin {
  late final PageController _controller;
  int _currentPage = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _autoScroll());
  }

  void _autoScroll() async {
    while (mounted) {
      await Future.delayed(widget.duration);
      if (!mounted || !_controller.hasClients) return;
      _currentPage = (_currentPage + 1) % widget.items.length;
      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    @override
    // ignore: unused_element
    Widget build(BuildContext context) {
      super.build(context);
      return SizedBox(
        height: 50,
        child: PageView.builder(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            return Center(
              child: Text(
                widget.items[index],
                style:
                    widget.textStyle ?? Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      );
    }
  }
}
