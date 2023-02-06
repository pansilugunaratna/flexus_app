// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flexusrp_test_app/base/core/app.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'tests/app_test.dart';

void main() {
  setUpAll(() async {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    app.initApp();
  });

  testWidgets('Test Application Login with Email', (WidgetTester tester) async {
    await testAppLoginWithEmail(tester);
  });
}
