// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../base/providers/firebase/auth/login_type.dart';

class SocialAuthButton extends ConsumerWidget {
  const SocialAuthButton(this.loginType, this.onPressed, {super.key});

  final LoginType loginType;
  final Function onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    IconData iconData;
    switch (loginType) {
      case LoginType.facebook:
        iconData = FontAwesomeIcons.facebook;
        break;
      case LoginType.google:
        iconData = FontAwesomeIcons.google;
        break;
      case LoginType.apple:
        iconData = FontAwesomeIcons.apple;
        break;
      case LoginType.email:
        iconData = FontAwesomeIcons.user;
        break;
      case LoginType.auto:
        iconData = FontAwesomeIcons.user;
        break;
    }
    return SizedBox(
        height: 48.0,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.background,
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1.0, color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () => onPressed(loginType, context, ref),
            child:
                Icon(iconData, color: Theme.of(context).colorScheme.primary)));
  }
}
