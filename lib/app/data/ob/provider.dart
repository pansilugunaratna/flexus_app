import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'objectbox.dart';

part '../../../base/generated/lib/app/data/ob/provider.g.dart';

@Riverpod(keepAlive: true)
ObjectBox ob(ObRef ref) => ObjectBox();
