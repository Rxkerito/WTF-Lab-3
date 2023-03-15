import 'dart:async';

import '../../domain/models/event.dart';
import '../../domain/repository/event_repository_api.dart';
import '../converter/converter_db.dart';
import '../entities/event_db.dart';
import '../provider/api_firebase_provider.dart';

class EventRepository extends EventRepositoryApi {
  final ApiDataProvider _provider;

  EventRepository({required ApiDataProvider provider}) : _provider = provider;

  @override
  Future<void> addEvent(Event event) async {
    final eventDB = ConverterDB.event2Entity(event);
    await _provider.addEvent(eventDB);
  }

  @override
  Future<void> changeEvent(Event event) async {
    final eventDB = ConverterDB.event2Entity(event);
    await _provider.updateEvent(eventDB);
  }

  @override
  Future<void> deleteEvent(Event event) async {
    final eventDB = ConverterDB.event2Entity(event);
    await _provider.deleteEvent(eventDB);
  }

  @override
  Future<List<Event>> getEvents(String chatId) async {
    final eventsDB = await _provider.events;
    final chatEventsDB = eventsDB.where((e) => e.chatId == chatId).toList();
    chatEventsDB.sort((a, b) => a.creationTime.compareTo(b.creationTime));
    return List<Event>.generate(chatEventsDB.length, (index) {
      return ConverterDB.entity2Event(chatEventsDB[index]);
    });
  }

  @override
  Stream<List<Event>> get eventStream =>
      _provider.eventsStream.map<List<Event>>(_transformToListEvent);

  List<Event> _transformToListEvent(List<EventDB> dbEvents) {
    final result = <Event>[];
    for (final dbEvent in dbEvents) {
      result.add(ConverterDB.entity2Event(dbEvent));
    }
    return result;
  }

  @override
  Future<List<Event>> getAllEvents() async {
    var dbEvents = await _provider.events;
    final events = List<Event>.generate(
      dbEvents.length,
      (i) => ConverterDB.entity2Event(dbEvents[i]),
    );
    return events;
  }
}
