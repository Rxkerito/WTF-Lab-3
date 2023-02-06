part of '../view/chat_overview_page.dart';

class ChatList extends StatelessWidget {
  const ChatList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChatOverviewScope(
      child: BlocBuilder<ChatOverviewCubit, ChatOverviewState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.chats.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Insets.small,
                  horizontal: Insets.large,
                ),
                child: ChatItem(
                  chat: state.chats[index],
                  onTap: () {
                    context.go(
                      Navigation.chatPagePath.withArgs(
                        {':chatId': '${state.chats[index].id}'},
                      ),
                    );
                  },
                  onLongPress: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => _BottomChatActionSheet(
                        chat: state.chats[index],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
