import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../base/generated/locale/locale_keys.g.dart';
import '../common/provider.dart';

part '../../../../base/generated/lib/extensions/providers/dialogs/auth_exceptions/provider.g.dart';

@Riverpod(keepAlive: true)
AuthExceptionDialogProvider authExceptionDialogs(AuthExceptionDialogsRef ref) =>
    AuthExceptionDialogProvider(ref);

class AuthExceptionDialogProvider {
  final ProviderRef ref;

  AuthExceptionDialogProvider(this.ref);

  _showAuthException(BuildContext context, String message) {
    ref.read(dialogsProvider).showOKDialog(context,
        message: message, title: LocaleKeys.appName.tr());
  }

  _showGenericAuthException(BuildContext context) {
    ref.read(dialogsProvider).showOKDialog(context,
        message: LocaleKeys.authErrors_signInFailure.tr(),
        title: LocaleKeys.appName.tr());
  }

  showExceptionMessage(BuildContext context, Object? exception) {
    if (exception is FirebaseAuthException) {
      _showAuthException(context, exception.message ?? 'FAuth Exception');
    } else {
      _showGenericAuthException(context);
    }
  }
}
