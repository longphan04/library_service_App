import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../pages/messages/message_page.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool showBackButton;

  const SearchAppBar({this.showBackButton = false, super.key});

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _SearchAppBarState extends State<SearchAppBar> with RouteAware {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    // Listen to focus changes
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();

    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    // Update state when focus changes
    if (!_focusNode.hasFocus) {
      setState(() {});
    }
  }

  /// Unfocus the search field and dismiss keyboard
  void _unfocusSearchField() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }

  void _onSearchSubmitted(String value) {
    _unfocusSearchField();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Unfocus when tapping outside the search field
      onTap: _unfocusSearchField,
      behavior: HitTestBehavior.translucent,
      child: AppBar(
        backgroundColor: widget.showBackButton
            ? AppColors.background
            : Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.icon),
                onPressed: () {
                  _unfocusSearchField();
                  Navigator.of(context).pop();
                },
              )
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset('images/logo.svg'),
              ),
        title: _buildSearchField(context),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, size: 30),
            color: AppColors.icon,
            onPressed: () {
              _unfocusSearchField();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MessagePage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.navBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        autofocus: false,
        textInputAction: TextInputAction.search,
        textAlignVertical: TextAlignVertical.center,
        onChanged: (value) {
          setState(() {});
        },
        onSubmitted: _onSearchSubmitted,
        onTapOutside: (_) => _unfocusSearchField(),
        decoration: InputDecoration(
          hintText: 'Search Books...',
          hintStyle: TextStyle(color: AppColors.subText, fontSize: 14),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 0,
          ),
          suffixIcon: const Icon(Icons.search, color: AppColors.subText),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
        ),
      ),
    );
  }
}
