import 'package:flutter/material.dart';

class OverlaySearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final Function(String)? onChanged;
  final Color? backgroundColor;
  final IconData? prefixIcon;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final TextStyle? hintStyle;
  final Color? prefixIconColor;
  final List<Widget> suggestions;
  final double overlayMaxHeight;
  final Decoration? overlayDecoration;
  final EdgeInsetsGeometry? overlayPadding;
  final Alignment overlayAlignment;

  const OverlaySearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.backgroundColor,
    this.prefixIcon,
    this.padding = const EdgeInsets.all(8.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.hintStyle,
    this.prefixIconColor,
    this.suggestions = const [],
    this.overlayMaxHeight = 200.0,
    this.overlayDecoration,
    this.overlayPadding,
    this.overlayAlignment = Alignment.topLeft,
  });

  @override
  State<OverlaySearchBar> createState() => _OverlaySearchBarState();
}

class _OverlaySearchBarState extends State<OverlaySearchBar> {
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _searchBarKey = GlobalKey();
  bool _isOverlayVisible = false;
  double _searchBarHeight = 0.0;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isOverlayVisible = _focusNode.hasFocus;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSearchBarHeight();
    });
  }

  void _updateSearchBarHeight() {
    final RenderBox? renderBox =
        _searchBarKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _searchBarHeight = renderBox.size.height;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  double _calculateOverlayHeight() {
    const itemHeight = 48.0;
    double desiredHeight = widget.suggestions.length * itemHeight;
    return desiredHeight.clamp(0.0, widget.overlayMaxHeight);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        clipBehavior: Clip.none,
        alignment: widget.overlayAlignment,
        children: [
          Container(
            key: _searchBarKey,
            padding: widget.padding,
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? Colors.white,
              borderRadius: widget.borderRadius,
            ),
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: widget.hintStyle,
                prefixIcon: widget.prefixIcon != null
                    ? Icon(widget.prefixIcon, color: widget.prefixIconColor)
                    : null,
                border: InputBorder.none,
              ),
              onChanged: (value) {
                widget.onChanged?.call(value);
                setState(() {
                  _isOverlayVisible = value.isNotEmpty || _focusNode.hasFocus;
                });
              },
            ),
          ),
          if (_isOverlayVisible && widget.suggestions.isNotEmpty)
            Positioned(
              top: _searchBarHeight,
              width: constraints.maxWidth,
              child: Material(
                elevation: 0.0,
                child: Container(
                  padding: widget.overlayPadding,
                  decoration: widget.overlayDecoration ??
                      const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                  height: _calculateOverlayHeight(),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: widget.suggestions.length,
                    itemBuilder: (context, index) {
                      return widget.suggestions[index];
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
