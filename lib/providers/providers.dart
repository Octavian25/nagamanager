// ignore: unused_import
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:nagamanager/models/batch-item.repose.dart';
import 'package:nagamanager/models/detail_stock_model.dart';
import 'package:nagamanager/models/item_model.dart';
import 'package:nagamanager/models/params/get_detail.dart';
import 'package:nagamanager/models/params/login.dart';
import 'package:nagamanager/models/stocking_model.dart';
import 'package:nagamanager/models/user_model.dart';
import 'package:nagamanager/providers/loading_provider.dart';
import 'package:nagamanager/providers/location_provider.dart';
import 'package:nagamanager/services/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_provider.dart';
part 'item_provider.dart';
part 'stocking_provider.dart';
