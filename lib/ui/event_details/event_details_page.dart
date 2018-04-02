import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:inkino/data/models/event.dart';
import 'package:inkino/data/models/show.dart';
import 'package:inkino/ui/event_details/actor_scroller.dart';
import 'package:inkino/ui/event_details/event_header.dart';
import 'package:inkino/ui/event_details/showtime_information.dart';
import 'package:inkino/ui/event_details/storyline_widget.dart';
import 'package:inkino/ui/events/event_poster.dart';

class EventDetailsPage extends StatefulWidget {
  EventDetailsPage(
    this.event, {
    this.show,
  });

  final Event event;
  final Show show;

  @override
  _EventDetailsPageState createState() => new _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  ScrollController _scrollController;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();

    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
      tag: widget.event.id,
      child: new EventPoster(
        url: widget.event.images.portraitMedium,
        size: new Size(100.0, 150.0),
        useShadow: true,
      ),
    );
  }

  Widget _buildEventInfo() {
    var content = <Widget>[]..addAll(_buildTitleAndLengthInMinutes());

    if (widget.event.directors.isNotEmpty) {
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
        widget.event.title,
        style: new TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
      new Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: new Text(
          '${widget.event.lengthInMinutes}min | ${widget.event.genres.split(', ').take(4).join(', ')}',
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
            widget.event.directors.first,
            style: new TextStyle(
              fontSize: 12.0,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShowtimeInformation() {
    if (widget.show != null) {
      return new Padding(
        padding: const EdgeInsets.only(
          top: 24.0,
          bottom: 8.0,
          left: 16.0,
          right: 16.0,
        ),
        child: new ShowtimeInformation(widget.show),
      );
    }

    return null;
  }

  Widget _buildSynopsis() {
    if (widget.event.hasSynopsis) {
      return new Padding(
        padding: new EdgeInsets.only(top: widget.show == null ? 12.0 : 0.0),
        child: new StorylineWidget(widget.event),
      );
    }

    return null;
  }

  Widget _buildActorScroller() =>
      widget.event.actors.isNotEmpty ? new ActorScroller(widget.event) : null;

  void _addIfNonNull(Widget child, List<Widget> children) {
    if (child != null) {
      children.add(child);
    }
  }

  List<Widget> _buildEventBackdrop() {
    var unconstrainedBackdropHeight = 175.0 + (-_scrollOffset);
    var backdropHeight = max(kToolbarHeight, unconstrainedBackdropHeight);
    var backdropBlur = max(0.0, min(13.0, -_scrollOffset / 10));
    var overlayOpacity = max(
        0.0, min(1.0, 1.5 - (unconstrainedBackdropHeight / kToolbarHeight)));

    return <Widget>[
      new EventHeader(
        widget.event,
        backdropHeight,
        backdropBlur,
      ),
      new Container(
        height: backdropHeight,
        decoration: new BoxDecoration(
          color: Colors.white.withOpacity(overlayOpacity),
        ),
      ),
    ];
  }

  Widget _buildStatusbarBackground() {
    var statusbarMaxHeight = MediaQuery.of(context).padding.vertical;
    var statusbarHeight = max(0.0, min(statusbarMaxHeight, _scrollOffset - 175.0 + statusbarMaxHeight + 56.0));
    var statusbarColor = Theme.of(context).primaryColor;

    return new Container(
      height: statusbarHeight,
      color: statusbarColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    var content = <Widget>[
      _buildHeader(context),
    ];

    _addIfNonNull(_buildShowtimeInformation(), content);
    _addIfNonNull(_buildSynopsis(), content);
    _addIfNonNull(_buildActorScroller(), content);

    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Stack(
        children: <Widget>[]
          ..addAll(_buildEventBackdrop())
          ..addAll(
            <Widget>[
              new CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  new SliverList(
                    delegate: new SliverChildListDelegate(content),
                  ),
                ],
              ),
              new Positioned(
                top: MediaQuery.of(context).padding.top,
                left: 4.0,
                child: new Material(
                  type: MaterialType.circle,
                  color: Colors.transparent,
                  child: new BackButton(color: Colors.white.withOpacity(0.9)),
                ),
              ),
            ],
          )
          ..add(_buildStatusbarBackground()),
      ),
    );
  }
}
