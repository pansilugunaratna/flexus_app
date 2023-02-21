// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'objectbox.dart';

part '../../../base/generated/lib/app/data/ob/provider.g.dart';

@Riverpod(keepAlive: true)
ObjectBox ob(ObRef ref) => ObjectBox();
