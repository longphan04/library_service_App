import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/book/search_bloc.dart';
import '../bloc/message/notification_bloc.dart';
import '../pages/book/search_page.dart';
import '../pages/messages/message_page.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool showBackButton;

  const SearchAppBar({this.showBackButton = false, super.key});

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _SearchAppBarState extends State<SearchAppBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  final GlobalKey _searchFieldKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus && _controller.text.isNotEmpty) {
        _showOverlay();
      }
    });

    // Bắt đầu polling unread count qua NotificationBloc
    context.read<NotificationBloc>().add(const StartUnreadCountPolling());
  }

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    final renderBox =
        _searchFieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            child: TapRegion(
              groupId: "SearchGroup",
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state is SearchSuggestionsLoaded) {
                      if (state.suggestions.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Không tìm thấy kết quả gợi ý",
                            style: TextStyle(color: AppColors.subText),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: state.suggestions.length,
                        separatorBuilder: (_, __) => const Divider(
                          height: 1,
                          indent: 10,
                          endIndent: 10,
                          color: Color(0xFFEEEEEE),
                        ),
                        itemBuilder: (context, index) {
                          final suggestion = state.suggestions[index];
                          return InkWell(
                            onTap: () => _onSearchSubmitted(suggestion),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 12.0,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    size: 18,
                                    color: AppColors.subText,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      suggestion,
                                      style: const TextStyle(fontSize: 14),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    if (state is SearchFailure) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text("Lỗi: ${state.message}"),
                      );
                    }
                    if (state is SearchLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _unfocusSearchField() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
    _controller.clear();
    context.read<SearchBloc>().add(SearchQueryChanged(''));
    _removeOverlay();
  }

  void _onSearchSubmitted(String value) {
    _controller.text = value;
    _unfocusSearchField();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage.fromQuery(value.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
        BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            final unreadCount = state.unreadCount;
            return Stack(
              children: [
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
                if (unreadCount > 0)
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        unreadCount > 9 ? '9+' : unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        key: _searchFieldKey,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.navBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TapRegion(
          groupId: "SearchGroup",
          onTapOutside: (event) {
            _unfocusSearchField();
          },
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            autofocus: false,
            textInputAction: TextInputAction.search,
            textAlignVertical: TextAlignVertical.center,
            onChanged: (value) {
              context.read<SearchBloc>().add(SearchQueryChanged(value));
              if (value.isNotEmpty) {
                _showOverlay();
              } else {
                _removeOverlay();
              }
            },
            onSubmitted: _onSearchSubmitted,
            decoration: InputDecoration(
              hintText: 'Search Books...',
              hintStyle: TextStyle(color: AppColors.subText, fontSize: 14),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 0,
              ),
              suffixIcon: GestureDetector(
                onTap: () => _onSearchSubmitted(_controller.text),
                child: const Icon(Icons.search, color: AppColors.subText),
              ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
