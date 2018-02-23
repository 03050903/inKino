import 'package:flutter/services.dart';
import 'package:inkino/data/finnkino_api.dart';
import 'package:inkino/redux/app/api_middleware.dart';
import 'package:inkino/redux/app/app_reducer.dart';
import 'package:inkino/redux/app/app_state.dart';
import 'package:inkino/redux/theater/theater_middleware.dart';
import 'package:redux/redux.dart';

Store<AppState> createStore() {
  return new Store(
    appReducer,
    initialState: new AppState.initial(),
    middleware: [
      new TheaterMiddleware(rootBundle),
      new ApiMiddleware(new FinnkinoApi()),
    ],
  );
}
