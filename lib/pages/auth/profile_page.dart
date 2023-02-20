// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../base/generated/locale/locale_keys.g.dart';
import '../../base/providers/app/app_user_info.dart';
import '../../base/providers/app/auth_user_info.dart';
import '../../configs/logger.dart';
import '../../configs/theme.dart';
import '../../extensions/providers/dialogs/common/provider.dart';
import '../../extensions/providers/firebase/analytics/provider.dart';
import '../../extensions/providers/firebase/auth/provider.dart';
import '../../extensions/providers/firebase/user/provider.dart';
import '../../extensions/providers/ui/circular_avatar.dart';
import '../../extensions/providers/ui/provider.dart';
import '../../extensions/repos/auth/classes/login_type.dart';
import '../../extensions/widgets/app_page.dart';
import 'widgets/auth_dropdown.dart';
import 'widgets/auth_text_box.dart';

final _isLoading = StateProvider.autoDispose<bool>((ref) => false);
final profilePhotoProvider = StateProvider.autoDispose<String>((ref) => '');

class ProfilePage extends ConsumerWidget {
  ProfilePage({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(uiProvider);
    final authUser = ref.watch(authUserInfoProvider);
    final appUser = ref.watch(appUserInfoProvider);

    return AppPage.safeArea(
      onAnalytics: () =>
          ref.read(analyticsProvider).screen(runtimeType.toString()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.auth_profile.tr()),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: ref.read(_isLoading)
              ? null
              : () => _onProfileDataSave(_formKey, context, ref),
          child: const Icon(FontAwesomeIcons.floppyDisk),
        ),
        body: LoadingOverlay(
          isLoading: ref.watch(_isLoading),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(ThemeConfigs.defaultAppPadding),
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: ThemeConfigs.pd_50x),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularAvatar(
                              name: authUser.name,
                              profilePicture: authUser.photoURL,
                              imageFile: ref.watch(profilePhotoProvider),
                            ),
                            if (authUser.loginType == LoginType.email)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: ThemeConfigs.pd9x),
                                child: ElevatedButton(
                                  onPressed: () => _readPhoto(context, ref),
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  child: const Icon(
                                    Icons.add_a_photo,
                                    color: Colors.white,
                                    size: ThemeConfigs.pd1_5x,
                                  ),
                                ),
                              )
                          ],
                        ),
                        const SizedBox(height: ThemeConfigs.pd1x),
                        Text(authUser.email ?? '-'),
                        const Divider(),
                        FormBuilder(
                          key: _formKey,
                          child: Column(
                            children: [
                              AuthTextBox(
                                  name: 'name',
                                  initialValue: authUser.name ?? '',
                                  decoration: ui.getAuthInputDecorator(
                                    context,
                                    LocaleKeys.auth_name.tr(),
                                    icon: const Icon(FontAwesomeIcons.user),
                                  ),
                                  validators: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.maxLength(50),
                                  ])),
                              AuthDropDown(
                                name: 'gender',
                                key: const Key('dropDownGender'),
                                label: LocaleKeys.auth_gender.tr(),
                                enabled: true,
                                allowClear: false,
                                icon: const Icon(Icons.attribution_outlined),
                                items: [
                                  '',
                                  LocaleKeys.auth_man.tr(),
                                  LocaleKeys.auth_woman.tr()
                                ],
                                initialValue: appUser.gender ?? '',
                                validators: FormBuilderValidators.compose(
                                    [FormBuilderValidators.required()]),
                              ),
                              AuthTextBox(
                                  name: 'password',
                                  key: const Key('textPassword'),
                                  obscureText: true,
                                  decoration: ui.getAuthInputDecorator(
                                    context,
                                    LocaleKeys.auth_password.tr(),
                                    icon: const Icon(FontAwesomeIcons.key),
                                  ),
                                  validators: FormBuilderValidators.compose([
                                    FormBuilderValidators.maxLength(50),
                                  ])),
                              AuthTextBox(
                                  name: 'confirmPassword',
                                  key: const Key('textConfirmPassword'),
                                  obscureText: true,
                                  decoration: ui.getAuthInputDecorator(
                                    context,
                                    LocaleKeys.auth_confirmPassword.tr(),
                                    icon: const Icon(FontAwesomeIcons.key),
                                  ),
                                  validators: FormBuilderValidators.compose([
                                    FormBuilderValidators.maxLength(50),
                                    (val) {
                                      String password = _formKey.currentState!
                                          .fields['password']?.value;
                                      if (password.isNotEmpty &&
                                          password != val) {
                                        return LocaleKeys
                                            .auth_confirmPasswordNotMatching
                                            .tr();
                                      }
                                      return null;
                                    }
                                  ])),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

_onProfileImageChange(File file, BuildContext context, WidgetRef ref) {
  Log.log.i('Uploaded a new File${file.path}');
  ref.read(profilePhotoProvider.notifier).state = file.path;
}

_readPhoto(BuildContext context, WidgetRef ref) async {
  ref.read(dialogsProvider).showOKDialog(context,
      textOK: LocaleKeys.generic_cancel.tr(),
      message: '',
      title: LocaleKeys.appName.tr(),
      content: const ImageSourceFragment(_onProfileImageChange));
}

_onProfileDataSave(GlobalKey<FormBuilderState> formKey, BuildContext context,
    WidgetRef ref) async {
  final authUser = ref.read(authUserInfoProvider);
  final firebaseAuth = ref.read(firebaseAuthProvider);
  Log.log.i('Profile Save clicked');
  if (formKey.currentState!.validate()) {
    Log.log.i('Profile Save form validation success');
    ref.read(_isLoading.notifier).state = true;
    var name = formKey.currentState!.fields['name']?.value;
    var password = formKey.currentState!.fields['password']?.value;
    firebaseAuth.updateUserInfo(context, ref, authUser.loginType!,
        success: (user) async {
      _onAppProfileDataSave(formKey, context, ref);
      ref.read(authUserInfoProvider.notifier).state = user;
    }, failed: (ex) {
      ref.read(_isLoading.notifier).state = false;
    },
        name: name,
        password: password,
        photo: File(ref.read(profilePhotoProvider)));
  } else {
    ref.read(_isLoading.notifier).state = false;
    Log.log.w('Profile Save form validation failed');
  }
}

class ImageSourceFragment extends ConsumerWidget {
  const ImageSourceFragment(this.onProfileImageChange, {Key? key})
      : super(key: key);

  final Function onProfileImageChange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(uiProvider);
    return Column(
      children: [
        Text(LocaleKeys.dialogs_pleaseSelectSource.tr()),
        const SizedBox(height: ThemeConfigs.pd1x),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                ui.getImageSourceButton(ImageSource.camera, context, () async {
                  Navigator.of(context).pop();
                  onProfileImageChange(
                      await ui.getProfileImage(ImageSource.camera),
                      context,
                      ref);
                }),
                const SizedBox(height: ThemeConfigs.pd_50x),
                Text(LocaleKeys.dialogs_camera.tr())
              ],
            ),
            const SizedBox(width: ThemeConfigs.pd3x),
            Column(
              children: [
                ui.getImageSourceButton(ImageSource.gallery, context, () async {
                  Navigator.of(context).pop();
                  onProfileImageChange(
                      await ui.getProfileImage(ImageSource.gallery),
                      context,
                      ref);
                }),
                const SizedBox(height: ThemeConfigs.pd_50x),
                Text(LocaleKeys.dialogs_gallery.tr())
              ],
            ),
          ],
        ),
      ],
    );
  }
}

_onAppProfileDataSave(GlobalKey<FormBuilderState> formKey, BuildContext context,
    WidgetRef ref) async {
  String gender = formKey.currentState?.fields['gender']?.value;
  final firebaseUser = ref.read(firebaseUserProvider);
  final appUser = ref.read(appUserInfoProvider);

  await firebaseUser.saveAppUser(context, ref, success: () {
    appUser.gender = gender;
    Navigator.of(context).pop();
  }, failed: () {
    Log.log.w('Saving user data failed');
  }, gender: gender);
  ref.read(_isLoading.notifier).state = false;
}
