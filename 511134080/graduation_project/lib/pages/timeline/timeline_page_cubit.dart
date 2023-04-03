import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hashtagable/functions.dart';

import '../../models/chat.dart';
import '../../models/event.dart';
import '../../repositories/chat_repository.dart';
import '../../repositories/event_repository.dart';

part 'timeline_page_state.dart';

class TimelinePageCubit extends Cubit<TimelinePageState> {
  final EventRepository eventsRepository;
  final ChatRepository chatsRepository;
  late final StreamSubscription<List<Event>> eventsSubscription;
  late final StreamSubscription<List<Chat>> chatsSubscription;

  TimelinePageCubit({
    required this.eventsRepository,
    required this.chatsRepository,
  }) : super(TimelinePageState()) {
    initSubscriptions();
  }

  void initSubscriptions() {
    eventsSubscription = eventsRepository.eventsStream.listen(
      (events) {
        final tags = <String>{};
        for (final event in events) {
          if (hasHashTags(event.title)) {
            tags.addAll(extractHashTags(event.title));
          }
        }
        emit(
          state.copyWith(
            newEvents: events,
            newTags: tags,
          ),
        );
      },
    );
    chatsSubscription = chatsRepository.chatsStream.listen(
      (chats) {
        emit(
          state.copyWith(
            newChats: chats,
          ),
        );
      },
    );
  }

  Future<void> init() async {
    final events = await eventsRepository.receiveAllEvents();
    emit(
      state.copyWith(
        newEvents: events,
      ),
    );
  }

  void updateEvents(List<Event> events) => emit(
        state.copyWith(
          newEvents: events,
        ),
      );

  void toggleFavouriteMode() {
    emit(
      state.copyWith(
        showingFavourites: !state.isShowingFavourites,
      ),
    );
  }
}
