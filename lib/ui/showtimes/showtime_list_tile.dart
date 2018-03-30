import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:inkino/data/models/show.dart';
import 'package:inkino/ui/event_details/event_details_page.dart';
import 'package:intl/intl.dart';
import 'package:inkino/redux/selectors.dart';

class ShowtimeListTile extends StatelessWidget {
  static final DateFormat hoursAndMins = new DateFormat('HH:mm');

  ShowtimeListTile(
    this.show,
    this.useAlternateBackground,
  );

  final Show show;
  final bool useAlternateBackground;

  Widget _buildShowtimesInfo() {
    return new Column(
      children: <Widget>[
        new Text(
          hoursAndMins.format(show.start),
          style: new TextStyle(fontSize: 20.0),
        ),
        new Text(
          hoursAndMins.format(show.end),
          style: new TextStyle(
            fontSize: 14.0,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedInfo() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Text(
          show.title,
          style: new TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: new Text(show.theaterAndAuditorium),
        ),
        new Container(
          decoration: new BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: new BorderRadius.circular(4.0),
          ),
          margin: const EdgeInsets.only(top: 8.0),
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
          child: new Text(
            show.presentationMethod,
            style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var backgroundColor =
        useAlternateBackground ? const Color(0xFFF5F5F5) : Colors.white;

    return new Material(
      color: backgroundColor,
      child: new InkWell(
        onTap: () {
          var store = new StoreProvider.of(context).store;
          var event = eventForShowSelector(store.state, show);

          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (_) => new EventDetailsPage(event, show: show),
            ),
          );
        },
        child: new Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
          child: new Row(
            children: <Widget>[
              _buildShowtimesInfo(),
              new Expanded(
                child: new Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: _buildDetailedInfo(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
