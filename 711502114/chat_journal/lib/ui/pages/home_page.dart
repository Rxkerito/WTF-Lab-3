import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../cubit/home/home_cubit.dart';
import '../../cubit/home/home_state.dart';
import '../../cubit/theme/theme_cubit.dart';
import '../../models/chat.dart';
import '../../utils/utils.dart';
import '../widgets/home_page/archive_row.dart';
import '../widgets/home_page/chat_card.dart';
import '../widgets/home_page/popup_bottom_menu.dart';
import '../widgets/home_page/questionnaire_bot_row.dart';
import 'add_chat_page.dart';
import 'event_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(local?.homePage ?? ''),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              icon: const Icon(Icons.invert_colors),
              onPressed: () {
                BlocProvider.of<ThemeCubit>(context).switchTheme();
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(child: Text('${DateTime.now()}')),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(local?.settings ?? ''),
              onTap: () {
                closePage(context);
                openNewPage(context, const AddChatPage(isCategoryMode: true));
              },
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            const QuestionnaireBot(),
            const SizedBox(height: 5),
            _createMessagesList(local),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNewPage(context, const AddChatPage()),
        tooltip: local?.add,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _createMessagesList(AppLocalizations? local) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      final cubit = context.read<HomeCubit>();
      final archived = state.chats.where((c) => c.isArchive);
      final archivedFlag = archived.isNotEmpty ? 1 : 0;
      final info = '${archived.length} ${local?.countArchived ?? ''}';
      final chats = state.chats.where((c) => !c.isArchive).toList();
      return Expanded(
        child: ListView.builder(
          itemCount: chats.length + archivedFlag,
          itemBuilder: (context, index) {
            if (index < chats.length) {
              return InkWell(
                onTap: () => openNewPage(
                  context,
                  MessengerPage(chat: chats[index]),
                ),
                onLongPress: () => _showMenu(cubit, chats[index]),
                child: ChatCard(chat: chats[index]),
              );
            } else {
              return Column(
                children: [
                  const SizedBox(height: 30),
                  ArchiveRow(archivedInfo: info),
                ],
              );
            }
          },
        ),
      );
    });
  }

  void _showMenu(HomeCubit cubit, Chat chat) {
    showModalBottomSheet(
      context: context,
      builder: (_) => PopupBottomMenu(cubit: cubit, chat: chat),
    );
  }
}
