import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../bloc/home/home_bloc.dart';
import '../../bloc/home/home_event.dart';
import 'home_page.dart';
import 'categories_page.dart';
import 'cart_page.dart';
import 'user_page.dart';
import '../../widgets/search_app_bar.dart';
import '../../widgets/bottom_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  // Expose route observer for MaterialApp
  static final RouteObserver<ModalRoute<void>> routeObserver =
      RouteObserver<ModalRoute<void>>();

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with RouteAware {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const CategoriesPage(),
    const CartPage(),
    const UserPage(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _currentIndex == 0) {
        context.read<HomeBloc>().add(const RefreshHomeDataEvent());
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      MainPage.routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    MainPage.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when we pop back to this page from another page
    if (_currentIndex == 0) {
      context.read<HomeBloc>().add(const RefreshHomeDataEvent());
    }
  }

  void _onTabTapped(int index) {
    FocusScope.of(context).unfocus();

    // Trigger refresh when switching to home tab (index 0)
    if (index == 0 && _currentIndex != 0) {
      // Switching to home from another tab
      Future.microtask(() {
        if (mounted) {
          context.read<HomeBloc>().add(const RefreshHomeDataEvent());
        }
      });
    }

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        final currentFocus = FocusScope.of(context);
        if (currentFocus.hasFocus) {
          currentFocus.unfocus();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: GestureDetector(
        // Unfocus when tapping outside
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: const SearchAppBar(showBackButton: false),
          body: IndexedStack(index: _currentIndex, children: _pages),
          bottomNavigationBar: BottomNavBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
          ),
        ),
      ),
    );
  }
}
