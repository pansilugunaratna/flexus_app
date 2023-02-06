// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/generated/locale/locale_keys.g.dart';
import '../../base/providers/firebase/analytics/provider.dart';
import '../../base/widgets/app_page.dart';
import 'widgets/home_drawer.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppPage.safeArea(
      onAnalytics: () =>
          ref.read(analyticsProvider).screen(runtimeType.toString()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.appName.tr()),
        ),
        drawer: const HomeDrawer(),
        body: Center(
          child: Text(LocaleKeys.homePageWelcome.tr(args: ['Flutter'])),
        ),
      ),
    );
  }
}
