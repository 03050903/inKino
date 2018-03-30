import 'dart:io';

import 'package:flutter/services.dart';
import 'package:inkino/data/file_cache.dart';
import 'package:inkino/data/networking/finnkino_api.dart';
import 'package:inkino/data/models/show.dart';
import 'package:inkino/redux/app/app_state.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';

class MockFile extends Mock implements File {}

class MockFinnkinoApi extends Mock implements FinnkinoApi {}
class MockAssetBundle extends Mock implements AssetBundle {}

class MockStore extends Mock implements Store<AppState> {}
class MockCache extends Mock implements FileCache {}
class MockShow extends Mock implements Show {}