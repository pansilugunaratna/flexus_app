import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../configs/pb.dart';
import '../../pb/client.dart';

part '../../../base/generated/lib/app/providers/app/pocketbase.g.dart';

@Riverpod(keepAlive: true)
PBClient pb(PbRef ref) {
  return PBClient(PBConfig.baseURL, PBConfig.user, PBConfig.pass);
}
