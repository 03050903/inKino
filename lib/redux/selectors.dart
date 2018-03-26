import 'package:inkino/data/event.dart';
import 'package:inkino/data/show.dart';
import 'package:inkino/redux/app/app_state.dart';
import 'package:inkino/data/theater.dart';

Theater currentTheaterSelector(AppState state) =>
    state.theaterState.currentTheater;

List<Theater> theatersSelector(AppState state) => state.theaterState.theaters;

bool isSearching(AppState state) {
  return state.searchQuery != null && state.searchQuery.isNotEmpty;
}

List<Event> eventsSelector(AppState state, EventListType type) {
  var events = type == EventListType.nowInTheaters
      ? state.eventState.nowInTheatersEvents
      : state.eventState.comingSoonEvents;

  if (state.searchQuery == null) {
    return events;
  }

  var searchQuery = new RegExp(state.searchQuery, caseSensitive: false);

  return events.where((event) {
    return event.title.contains(searchQuery) ||
        event.originalTitle.contains(searchQuery);
  }).toList();
}

Event eventForShowSelector(AppState state, Show show) {
  return state.eventState.nowInTheatersEvents
      .where((event) => event.id == show.eventId)
      .first;
}
