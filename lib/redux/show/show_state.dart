import 'package:inkino/data/models/show.dart';
import 'package:inkino/data/models/loading_status.dart';
import 'package:meta/meta.dart';

@immutable
class ShowState {
  ShowState({
    @required this.loadingStatus,
    @required this.dates,
    @required this.selectedDate,
    @required this.shows,
  });

  final LoadingStatus loadingStatus;
  final List<DateTime> dates;
  final DateTime selectedDate;
  final List<Show> shows;

  factory ShowState.initial() {
    var now = new DateTime.now();
    var dates = new List.generate(
      7,
      (index) => now.add(new Duration(days: index)),
    );

    return new ShowState(
      loadingStatus: LoadingStatus.loading,
      dates: dates,
      selectedDate: dates.first,
      shows: <Show>[],
    );
  }

  ShowState copyWith({
    LoadingStatus loadingStatus,
    List<DateTime> availableDates,
    DateTime selectedDate,
    List<Show> shows,
  }) {
    return new ShowState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      dates: availableDates ?? this.dates,
      selectedDate: selectedDate ?? this.selectedDate,
      shows: shows ?? this.shows,
    );
  }
}
