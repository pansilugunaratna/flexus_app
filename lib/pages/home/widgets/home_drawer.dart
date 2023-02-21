import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../app/providers/app/auth_user_info.dart';
import '../../../app/providers/app/events.dart';
import '../../../base/generated/assets/assets.gen.dart';
import '../../../base/generated/locale/locale_keys.g.dart';
import '../../../configs/routes.dart';
import '../../../extensions/providers/ui/circular_avatar.dart';
import '../../auth/profile_page.dart';

class HomeDrawer extends ConsumerWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authUserInfoProvider);

    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        CircularAvatar(
                            name: authUser.name,
                            profilePicture: authUser.photoURL),
                        const SizedBox(height: 8),
                        Text(
                            LocaleKeys.appWelcomeMessage
                                .tr(args: [authUser.name ?? '']),
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.color))
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: Text(LocaleKeys.auth_profile.tr()),
                  onTap: () {
                    context.pop();
                    ref.read(profilePhotoProvider.notifier).state = '';
                    context.push(Routes.profilePage);
                  },
                ),
                ListTile(
                  title: Text(LocaleKeys.apiPage_menuName.tr()),
                  onTap: () {
                    context.pop();
                    context.push(Routes.apiCallPage);
                  },
                ),
                ListTile(
                  title: Text(LocaleKeys.pocketBasePage_menuName.tr()),
                  onTap: () {
                    context.pop();
                    context.push(Routes.pocketBasePage);
                  },
                ),
                const Divider(),
                ListTile(
                  title: Text(LocaleKeys.auth_signOut.tr()),
                  onTap: () => ref.read(eventsProvider).onSignOut(context, ref),
                ),
              ],
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Column(
              children: [
                Assets.images.app.logoLong.image(
                    width: 96.0, color: Theme.of(context).colorScheme.primary),
                Text(
                  'version: ${ref.watch(_version).value}',
                  style: GoogleFonts.abel(color: Colors.grey),
                ),
                const SizedBox(
                  height: 16.0,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

final _version = FutureProvider<String>(
    (ref) async => (await PackageInfo.fromPlatform()).version);
