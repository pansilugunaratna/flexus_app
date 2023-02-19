// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../../../../base/generated/lib/extensions/providers/firebase/analytics/provider.g.dart';

@Riverpod(keepAlive: true)
FirebaseAnalyticsProvider analytics(AnalyticsRef ref) =>
    FirebaseAnalyticsProvider();

class FirebaseAnalyticsProvider {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  screen(String screenName) {
    analytics.setCurrentScreen(
        screenName: screenName, screenClassOverride: screenName);
  }
}
