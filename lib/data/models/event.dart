import 'package:inkino/data/models/actor.dart';
import 'package:inkino/utils/event_name_cleaner.dart';
import 'package:meta/meta.dart';
import 'package:xml/xml.dart' as xml;
import 'package:inkino/utils/xml_utils.dart';

enum EventListType {
  nowInTheaters,
  comingSoon,
}

class Event {
  Event({
    this.id,
    this.title,
    this.cleanedUpTitle,
    this.originalTitle,
    this.cleanedUpOriginalTitle,
    this.genres,
    this.directors,
    this.actors,
    this.lengthInMinutes,
    this.shortSynopsis,
    this.synopsis,
    this.images,
    this.youtubeTrailers,
  });

  final String id;
  final String title;
  final String cleanedUpTitle;
  final String originalTitle;
  final String cleanedUpOriginalTitle;
  final String genres;
  final List<String> directors;
  final List<Actor> actors;
  final String lengthInMinutes;
  final String shortSynopsis;
  final String synopsis;
  final EventImageData images;
  final List<String> youtubeTrailers;

  bool get hasSynopsis => shortSynopsis.isNotEmpty && synopsis.isNotEmpty;

  static List<Event> parseAll(String xmlString) {
    var events = <Event>[];
    var document = xml.parse(xmlString);

    document.findAllElements('Event').forEach((node) {
      var title = tagContents(node, 'Title');
      var originalTitle = tagContents(node, 'OriginalTitle');

      events.add(new Event(
        id: tagContents(node, 'ID'),
        title: title,
        cleanedUpTitle: EventNameCleaner.cleanup(title),
        originalTitle: originalTitle,
        cleanedUpOriginalTitle: EventNameCleaner.cleanup(originalTitle),
        genres: tagContents(node, 'Genres'),
        directors: _parseDirectors(node.findAllElements('Director')),
        actors: _parseActors(node.findAllElements('Actor')),
        lengthInMinutes: tagContents(node, 'LengthInMinutes'),
        shortSynopsis: tagContents(node, 'ShortSynopsis'),
        synopsis: tagContents(node, 'Synopsis'),
        images: EventImageData.parseAll(node.findElements('Images')),
        youtubeTrailers: _parseTrailers(node.findAllElements('EventVideo')),
      ));
    });

    return events;
  }

  static List<String> _parseDirectors(Iterable<xml.XmlElement> nodes) {
    var directors = <String>[];

    nodes.forEach((node) {
      var first = tagContents(node, 'FirstName');
      var last = tagContents(node, 'LastName');
      directors.add('$first $last');
    });

    return directors;
  }

  static List<Actor> _parseActors(Iterable<xml.XmlElement> nodes) {
    var actors = <Actor>[];

    nodes.forEach((node) {
      var first = tagContents(node, 'FirstName');
      var last = tagContents(node, 'LastName');
      actors.add(new Actor(name: '$first $last'));
    });

    return actors;
  }

  static List<String> _parseTrailers(Iterable<xml.XmlElement> nodes) {
    var trailers = <String>[];

    nodes.forEach((node) {
      trailers.add(
        'https://youtube.com/watch?v=' + tagContents(node, 'Location'),
      );
    });

    return trailers;
  }
}

class EventImageData {
  EventImageData({
    @required this.portraitSmall,
    @required this.portraitMedium,
    @required this.portraitLarge,
    @required this.landscapeSmall,
    @required this.landscapeBig,
  });

  final String portraitSmall;
  final String portraitMedium;
  final String portraitLarge;
  final String landscapeSmall;
  final String landscapeBig;

  String get anyAvailableImage =>
      portraitSmall ??
      portraitMedium ??
      portraitLarge ??
      landscapeSmall ??
      landscapeBig;

  EventImageData.empty()
      : portraitSmall = null,
        portraitMedium = null,
        portraitLarge = null,
        landscapeSmall = null,
        landscapeBig = null;

  static EventImageData parseAll(Iterable<xml.XmlElement> roots) {
    if (roots == null || roots.isEmpty) {
      return new EventImageData.empty();
    }

    var root = roots.first;

    return new EventImageData(
      portraitSmall: tagContentsOrNull(root, 'EventSmallImagePortrait'),
      portraitMedium: tagContentsOrNull(root, 'EventMediumImagePortrait'),
      portraitLarge: tagContentsOrNull(root, 'EventLargeImagePortrait'),
      landscapeSmall: tagContentsOrNull(root, 'EventSmallImageLandscape'),
      landscapeBig: tagContentsOrNull(root, 'EventLargeImageLandscape'),
    );
  }
}
