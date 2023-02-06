// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthTextBox extends ConsumerWidget {
  const AuthTextBox(
      {required this.name,
      this.initialValue = '',
      this.obscureText = false,
      required this.decoration,
      required this.validators,
      super.key});

  final InputDecoration decoration;
  final String initialValue;
  final String name;
  final bool obscureText;
  final EdgeInsets padding = const EdgeInsets.only(top: 12.0, bottom: 12.0);
  final String? Function(String?) validators;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: padding,
      child: FormBuilderTextField(
          initialValue: initialValue,
          name: name,
          decoration: decoration,
          obscureText: obscureText,
          validator: validators),
    );
  }
}
