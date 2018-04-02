import 'package:flutter/material.dart';
import 'package:inkino/data/models/event.dart';
import 'package:inkino/data/models/show.dart';
import 'package:inkino/ui/event_details/actor_scroller.dart';
import 'package:inkino/ui/event_details/event_header.dart';
import 'package:inkino/ui/event_details/showtime_information.dart';
import 'package:inkino/ui/event_details/storyline_widget.dart';
import 'package:inkino/ui/events/event_poster.dart';

class EventDetailsPage extends StatelessWidget {
  EventDetailsPage(
    this.event, {
    this.show,
  });

  final Event event;
  final Show show;

  Widget _buildHeader(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Container(
          height: 175.0,
          margin: const EdgeInsets.only(bottom: 118.0),
        ),
        new Positioned(
          left: 16.0,
          right: 16.0,
          bottom: 0.0,
          child: _buildEventPortraitAndInfo(),
        ),
      ],
    );
  }

  Widget _buildEventPortraitAndInfo() {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildPortraitPhoto(),
        new Expanded(
          child: new Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              top: 48.0,
            ),
            child: _buildEventInfo(),
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitPhoto() {
    return new Hero(
      tag: event.id,
      child: new EventPoster(
        url: event.images.portraitMedium,
        size: new Size(100.0, 150.0),
        useShadow: true,
      ),
    );
  }

  Widget _buildEventInfo() {
    var content = <Widget>[]..addAll(_buildTitleAndLengthInMinutes());

    if (event.directors.isNotEmpty) {
      content.add(new Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: _buildDirectorInfo(),
      ));
    }

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: content,
    );
  }

  List<Widget> _buildTitleAndLengthInMinutes() {
    return <Widget>[
      new Text(
        event.title,
        style: new TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
      new Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: new Text(
          '${event.lengthInMinutes}min | ${event.genres.split(', ').take(4).join(', ')}',
          style: new TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ];
  }

  Widget _buildDirectorInfo() {
    return new Row(
      children: <Widget>[
        new Text(
          'Director:',
          style: new TextStyle(
            fontSize: 12.0,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: new Text(
            event.directors.first,
            style: new TextStyle(
              fontSize: 12.0,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var content = <Widget>[
      _buildHeader(context),
    ];

    if (show != null) {
      content.add(new Padding(
        padding: const EdgeInsets.only(
          top: 24.0,
          bottom: 8.0,
          left: 16.0,
          right: 16.0,
        ),
        child: new ShowtimeInformation(show),
      ));
    }

    if (event.hasSynopsis) {
      content.add(new Padding(
        padding: new EdgeInsets.only(top: show == null ? 12.0 : 0.0),
        child: new StorylineWidget(event),
      ));
    }

    if (event.actors.isNotEmpty) {
      content.add(new ActorScroller(event));
    }

    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new EventHeader(event),
          new Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 4.0,
            child: new Material(
              type: MaterialType.circle,
              color: Colors.transparent,
              child: new BackButton(color: Colors.white.withOpacity(0.9)),
            ),
          ),
          new SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: new Column(children: content),
          ),
        ],
      ),
    );
  }
}
