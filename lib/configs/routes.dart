// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lifecycle/lifecycle.dart';

import '../pages/auth/email_confirmation_page.dart';
import '../pages/auth/forgot_password_page.dart';
import '../pages/auth/profile_page.dart';
import '../pages/auth/sign_in_page.dart';
import '../pages/auth/sign_up_page.dart';
import '../pages/extra/api_call_page.dart';
import '../pages/extra/pocketbase_page.dart';
import '../pages/front/front_page.dart';
import '../pages/front/intro_page.dart';
import '../pages/front/splash_page.dart';
import '../pages/home/home_page.dart';

class Routes {
  static const apiCallPage = '/api-call';
  static const pocketBasePage = '/pb-page';
  static const emailConfirmationPage = '/email-confirmation';
  static const forgotPasswordPage = '/forgot-password';
  static const frontPage = '/front';
  static const homePage = '/home';
  static const introPage = '/intro';
  static const profilePage = '/profile';
  static const signInPage = '/sign-in';
  static const signUpPage = '/sign-up';
  static const splashPage = '/';

  GoRouter router = GoRouter(observers: [
    defaultLifecycleObserver
  ], routes: [
    _goRoute(splashPage, const SplashPage()),
    _goRoute(introPage, const IntroPage()),
    _goRoute(frontPage, const FrontPage()),
    _goRoute(homePage, const HomePage()),
    _goRoute(signInPage, const SignInPage()),
    _goRoute(signUpPage, const SignUpPage()),
    _goRoute(forgotPasswordPage, const ForgotPasswordPage()),
    _goRoute(emailConfirmationPage, const EmailConfirmationPage()),
    _goRoute(profilePage, ProfilePage()),
    _goRoute(apiCallPage, const APICallPage()),
    _goRoute(pocketBasePage, const PocketBasePage()),
  ]);
}

GoRoute _goRoute(String path, Widget widget) {
  return GoRoute(
      path: path, pageBuilder: (context, state) => MaterialPage(child: widget));
}
