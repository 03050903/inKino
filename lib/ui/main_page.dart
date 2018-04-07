import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:inkino/data/models/event.dart';
import 'package:inkino/data/models/theater.dart';
import 'package:inkino/redux/app/app_actions.dart';
import 'package:inkino/redux/app/app_state.dart';
import 'package:inkino/ui/events/events_page.dart';
import 'package:inkino/ui/showtimes/showtime_page_view_model.dart';
import 'package:inkino/ui/showtimes/showtimes_page.dart';
import 'package:inkino/ui/theater_list/theater_list.dart';
import 'package:inkino/ui/theater_list/theater_list_view_model.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  TabController _controller;
  TextEditingController _searchQuery;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 3, vsync: this);
    _searchQuery = new TextEditingController();
  }

  void _startSearch() {
    ModalRoute.of(context).addLocalHistoryEntry(new LocalHistoryEntry(
      onRemove: () {
        setState(() {
          _searchQuery.clear();
          _isSearching = false;

          _updateSearchQuery(null);
        });
      },
    ));

    setState(() {
      _isSearching = true;
    });
  }

  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment =
        Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    var subtitle = new StoreConnector<AppState, Theater>(
      converter: (store) => store.state.theaterState.currentTheater,
      builder: (BuildContext context, Theater currentTheater) {
        return new Text(
          currentTheater?.name ?? '',
          style: new TextStyle(
            fontSize: 12.0,
            color: Colors.white70,
          ),
        );
      },
    );

    return new InkWell(
      onTap: () => scaffoldKey.currentState.openDrawer(),
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            new Text('inKino'),
            subtitle,
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return new TextField(
      controller: _searchQuery,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search movies & showtimes...',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white30),
      ),
      style: new TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: _updateSearchQuery,
    );
  }

  void _updateSearchQuery(String newQuery) {
    var store = new StoreProvider.of(context).store;
    store.dispatch(new SearchQueryChangedAction(newQuery));
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: new Icon(Icons.clear),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              // Stop searching.
              Navigator.pop(context);
              return;
            }

            setState(() {
              _searchQuery.clear();
              _updateSearchQuery(null);
            });
          },
        ),
      ];
    }

    return <Widget>[
      new IconButton(
        icon: new Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  Widget _buildDrawer() {
    var textTheme = Theme.of(context).textTheme;
    var drawerHeader = new Container(
      color: Theme.of(context).primaryColor,
      constraints: new BoxConstraints.expand(height: 175.0),
      padding: const EdgeInsets.all(16.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          new Text(
            'inKino',
            style: textTheme.display1.copyWith(color: Colors.white70),
          ),
          new Text(
            'v1.0.0',
            style: textTheme.body2.copyWith(color: Colors.white),
          ),
        ],
      ),
    );

    return new Drawer(
      child: new TheaterList(
        header: drawerHeader,
        onTheaterTapped: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        leading: _isSearching ? new BackButton() : null,
        title: _isSearching ? _buildSearchField() : _buildTitle(context),
        bottom: new TabBar(
          controller: _controller,
          isScrollable: true,
          tabs: <Tab>[
            new Tab(text: 'Now in theaters'),
            new Tab(text: 'Showtimes'),
            new Tab(text: 'Coming soon'),
          ],
        ),
        actions: _buildActions(),
      ),
      drawer: _buildDrawer(),
      body: new TabBarView(
        controller: _controller,
        children: <Widget>[
          new EventsPage(EventListType.nowInTheaters),
          new ShowtimesPage(),
          new EventsPage(EventListType.comingSoon),
        ],
      ),
    );
  }
}
