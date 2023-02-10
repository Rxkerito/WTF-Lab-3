import 'dart:io';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/data/repository/chat_repository.dart';
import '../../../../../common/features/settings/settings.dart';
import '../../../../../common/models/ui/message.dart';
import '../../../../../common/utils/insets.dart';
import '../../../../../common/utils/radius.dart';
import '../../../../../common/utils/text_styles.dart';
import '../../../../../common/widget/regex_text_highlight.dart';
import 'message_tags.dart';

part 'message_images.dart';

part 'message_text.dart';

part 'message_chat_name.dart';

typedef SelectedMessageCallback = void Function(
  Message message,
  bool isSelected,
);

class MessageItem extends StatelessWidget {
  const MessageItem({
    super.key,
    required this.message,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
    this.isChatNameShown = false,
  });

  final Message message;
  final SelectedMessageCallback? onTap;
  final SelectedMessageCallback? onLongPress;
  final bool isSelected;
  final bool isChatNameShown;

  double get _widthScaleFactor => isSelected ? 0.75 : 0.8;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment:
              context.read<SettingsCubit>().state.messageAlignment ==
                      MessageAlignment.right
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: [
            LimitedBox(
              maxWidth: MediaQuery.of(context).size.width * _widthScaleFactor,
              child: Card(
                color: isSelected
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.onPrimary,
                margin: const EdgeInsets.symmetric(
                  vertical: Insets.extraSmall,
                  horizontal: Insets.large,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    Radius.medium,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    if (onTap != null) {
                      onTap!(
                        message,
                        isSelected,
                      );
                    }
                  },
                  onLongPress: () {
                    if (onLongPress != null) {
                      onLongPress!(
                        message,
                        isSelected,
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(
                    Radius.medium,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(
                      Insets.extraSmall,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (isChatNameShown)
                          _MessageChatName(
                            chatName: context
                                .read<ChatRepository>()
                                .chats
                                .value
                                .firstWhere(
                                  (chat) => chat.id == message.parentId,
                                )
                                .name,
                          ),
                        if (message.images.isNotEmpty)
                          _MessageImages(
                            message: message,
                          ),
                        if (message.text.isNotEmpty)
                          _MessageText(
                            text: message.text,
                          ),
                        if (message.tags.isNotEmpty)
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 250,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(
                                Insets.small,
                              ),
                              child: MessageTags(
                                tags: message.tags,
                              ),
                            ),
                          ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (message.isFavorite)
                              Icon(
                                Icons.bookmark,
                                color: Colors.yellow[600],
                                size: 18,
                              ),
                            _MessageTime(
                              time: message.time,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
