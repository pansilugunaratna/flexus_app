import 'package:flexusrp_test_app/configs/configs.dart';
import 'package:flexusrp_test_app/pages/auth/sign_in_page.dart';
import 'package:flexusrp_test_app/pages/front/front_page.dart';
import 'package:flexusrp_test_app/pages/front/intro_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testAppLoginWithEmail(WidgetTester tester) async {
  await testFrontPage(tester);

  expect(find.byType(SignInPage), findsOneWidget);
  await tester.enterText(
      find.byKey(const Key('textEmail')), 'chatdilper@gmail.com');
  await tester.enterText(find.byKey(const Key('textPassword')), 'abc12345');
  await tester.tap(find.byKey(const Key('buttonSignIn')));
  await tester.pumpAndSettle();

  // expect(find.byType(HomePage), findsOneWidget);
  // expect(find.text(LocaleKeys.homePageWelcome.tr(args: ['Flutter'])),
  //     findsOneWidget);
}

Future<void> testFrontPage(WidgetTester tester) async {
  await tester.pumpAndSettle();
  await tester
      .pumpAndSettle(const Duration(seconds: Configs.splashScreenDelay));

  expect(find.byType(IntroPage), findsOneWidget);

  await tester.tap(find.byKey(const Key('buttonSkip')));
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('buttonDone')));
  await tester.pumpAndSettle();

  expect(find.byType(FrontPage), findsOneWidget);
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('signInButton')));
  await tester.pumpAndSettle();
}
