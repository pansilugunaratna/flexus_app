// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthDropDown extends ConsumerWidget {
  const AuthDropDown(
      {required this.name,
      required this.initialValue,
      required this.validators,
      required this.label,
      required this.icon,
      required this.items,
      required this.enabled,
      required this.allowClear,
      super.key});

  final bool allowClear;
  final bool enabled;
  final Icon icon;
  final String initialValue;
  final List<String> items;
  final String label;
  final String name;
  final EdgeInsets padding = const EdgeInsets.only(top: 12.0, bottom: 12.0);
  final String? Function(String?) validators;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: padding,
      child: FormBuilderDropdown(
        name: name,
        key: key,
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.secondary),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.onBackground),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          ),
          border: const OutlineInputBorder(borderSide: BorderSide()),
          contentPadding: const EdgeInsets.all(4.0),
          prefixIcon: icon,
        ),
        validator: validators,
        enabled: enabled,
        dropdownColor: Theme.of(context).colorScheme.background,
        items: items
            .map((val) => DropdownMenuItem(
                  value: val,
                  child: Text(val),
                ))
            .toList(),
      ),
    );
  }
}
