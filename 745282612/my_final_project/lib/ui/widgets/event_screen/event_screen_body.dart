import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_final_project/entities/event.dart';
import 'package:my_final_project/ui/widgets/event_screen/cubit/event_cubit.dart';
import 'package:my_final_project/ui/widgets/event_screen/event_screen_bottom_message.dart';
import 'package:my_final_project/ui/widgets/event_screen/event_screen_instruction.dart';
import 'package:my_final_project/ui/widgets/event_screen/event_screen_list_message.dart';
import 'package:my_final_project/ui/widgets/settings_screen/cubit/settings_cubit.dart';

class EventScreenBody extends StatefulWidget {
  final String title;
  final bool isFavorite;
  final bool isSelected;
  final List<Event> listEvent;
  final bool isSearch;
  final int chatId;

  const EventScreenBody({
    super.key,
    required this.isFavorite,
    required this.isSelected,
    required this.listEvent,
    required this.title,
    required this.isSearch,
    required this.chatId,
  });

  @override
  State<EventScreenBody> createState() => _EventScreenBodyState();
}

class _EventScreenBodyState extends State<EventScreenBody> {
  late final TextEditingController controller;
  bool _isCamera = true;

  @override
  void initState() {
    controller = TextEditingController();
    controller.addListener(_onInputText);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(_onInputText);
    controller.dispose();
    super.dispose();
  }

  void _onInputText() {
    setState(
      () {
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
        controller.text.isEmpty ? _isCamera = true : _isCamera = false;
        context.read<EventCubit>().changeWrite();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: context.read<SettingCubit>().state.backgroundImage != ''
          ? BoxDecoration(
              image: DecorationImage(
                image: Image.file(File(context.read<SettingCubit>().state.backgroundImage)).image,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.3), BlendMode.dstATop),
              ),
            )
          : null,
      child: Stack(
        children: [
          widget.listEvent.isEmpty
              ? Instruction(title: widget.title)
              : EventScreenListMessage(
                  chatId: widget.chatId,
                  title: widget.title,
                  isSearch: widget.isSearch,
                  isSelected: widget.isSelected,
                  listMessageFavorite: widget.isFavorite
                      ? widget.listEvent.where((element) => element.isFavorit).toList()
                      : widget.listEvent,
                ),
          widget.isSearch
              ? const SizedBox()
              : EventScreenBottomMessage(
                  chatId: widget.chatId,
                  isCamera: _isCamera,
                  controller: controller,
                ),
        ],
      ),
    );
  }
}
