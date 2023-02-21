import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../configs/pb.dart';
import 'client.dart';

part '../../base/generated/lib/app/pb/provider.g.dart';

@Riverpod(keepAlive: true)
PBClient pb(PbRef ref) {
  return PBClient(PBConfig.baseURL, PBConfig.user, PBConfig.pass);
}
