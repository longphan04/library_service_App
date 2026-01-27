import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../bloc/message/ai_chat_bloc.dart';
import 'ai_chat_page.dart';
import 'notification_page.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<AIChatPageState> _aiChatKey = GlobalKey<AIChatPageState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
      setState(() {});
    });
    // Reset AI chat state when entering the page
    getIt<AIChatBloc>().add(const ResetAIChat());
  }

  Future<void> _clearChatHistory() async {
    // Use bloc to clear history
    getIt<AIChatBloc>().add(const ClearAIChatHistory());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AIChatBloc>(),
      child: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            await _clearChatHistory();
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.navBackground,
            elevation: 0,
            title: Text(
              'Hộp thư',
              style: TextStyle(
                color: AppColors.titleText,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    const NotificationPage(),
                    AIChatPage(key: _aiChatKey),
                  ],
                ),
              ),
              Positioned(
                top: 12,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.sectionBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            _tabController.animateTo(0);
                          },
                          child: Text(
                            'Thông báo',
                            style: TextStyle(
                              color: _tabController.index == 0
                                  ? AppColors.buttonSecondaryText
                                  : AppColors.subText,
                              fontSize: 14,
                              fontWeight: _tabController.index == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            _tabController.animateTo(1);
                          },
                          child: Text(
                            'Chat AI',
                            style: TextStyle(
                              color: _tabController.index == 1
                                  ? AppColors.buttonSecondaryText
                                  : AppColors.subText,
                              fontSize: 14,
                              fontWeight: _tabController.index == 1
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
