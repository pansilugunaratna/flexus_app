// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/events.dart';

part '../../../base/generated/lib/app/providers/app/events.g.dart';

@Riverpod(keepAlive: true)
Events events(EventsRef ref) => Events();
