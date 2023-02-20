import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/events.dart';

part '../../generated/lib/base/providers/app/events.g.dart';

@Riverpod(keepAlive: true)
Events events(EventsRef ref) => Events();
