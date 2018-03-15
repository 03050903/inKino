import 'package:inkino/data/event.dart';
import 'package:inkino/data/show.dart';
import 'package:inkino/redux/app/app_state.dart';
import 'package:inkino/data/theater.dart';

Theater currentTheaterSelector(AppState state) =>
    state.theaterState.currentTheater;

List<Theater> theatersSelector(AppState state) => state.theaterState.theaters;

List<Show> showsForTheaterSelector(AppState state, Theater theater) {
  var shows = <Show>[];
  var allShows = state.showState.allShowsById;
  var showIdsForTheater =
      theater != null ? state.showState.showIdsByTheaterId[theater.id] : [];

  showIdsForTheater?.forEach((id) {
    var show = allShows[id];

    if (show != null) {
      shows.add(show);
    }
  });

  if (isSearching(state)) {
    var query = new RegExp(state.searchQuery, caseSensitive: false);
    shows.removeWhere((show) => !query.hasMatch(show.title));
  }

  return shows;
}

bool isSearching(AppState state) {
  return state.searchQuery != null && state.searchQuery.isNotEmpty;
}

Event eventByShowSelector(AppState state, Show show) {
  return state.eventState.nowInTheatersEvents
      .where((event) => event.id == show.eventId)
      .first;
}
