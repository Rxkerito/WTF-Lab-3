import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/chat.dart';
import '../chat_editor_page/chat_editor_page.dart';
import '../chat_page/chat_page.dart';
import 'home_cubit.dart';
import 'widgets/manage_panel_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const HomePageView(),
    );
  }
}

class HomePageView extends StatefulWidget {
  const HomePageView();

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  void _openManagePanel(BuildContext context, Chat chat) {
    final cubit = context.read<HomeCubit>();

    showModalBottomSheet(
      context: context,
      builder: (context) => ManagePanelDialog(
        chat: chat,
        onDeleteChat: () => cubit.deleteChat(chat.id),
        onSwitchChatPinning: () => cubit.switchChatPinning(chat.id),
        onEditChat: () => Navigator.of(context).push<void>(
          ChatEditorPage.route(
            homeCubit: cubit,
            sourceChat: chat,
          ),
        ),
      ),
    );
  }

  Widget _createChatCard(BuildContext context, Chat chat) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onLongPress: () => _openManagePanel(context, chat),
        onTap: () => Navigator.of(context).push<void>(
          ChatPage.route(
            homeCubit: context.read<HomeCubit>(),
            chatId: chat.id,
            chatName: chat.name,
          ),
        ),
        child: ListTile(
          leading: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.background,
                ),
                child: Icon(
                  IconData(chat.iconCode, fontFamily: 'MaterialIcons'),
                ),
              ),
              if (chat.isPinned)
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.push_pin,
                    size: 20,
                  ),
                ),
            ],
          ),
          title: Text(chat.name),
          subtitle: const Text('_generateSubtitle()'),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().updateChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => print('Open settings'),
        ),
        title: const Text('Cool Chat Journal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens_outlined),
            onPressed: () => print('Change color'),
          ),
        ],
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state.status.isInitial) {
            context.read<HomeCubit>().updateChats();
          }
        },
        builder:(context, state) {
          if (state.status.isSuccess) {
            final chats = state.chats;
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) =>
                _createChatCard(context, chats[index]),
            );
          } else if (state.status.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('Oops! Something wrong.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push<void>(
            ChatEditorPage.route(
              homeCubit: context.read<HomeCubit>(),
            ),
          );
        }
      ),
    );
  }
}