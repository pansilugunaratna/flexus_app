// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../configs/api.dart';
import '../models/posts/posts.dart';

part '../../base/generated/lib/app/api/client.g.dart';

@Riverpod(keepAlive: true)
RestClient api(ApiRef ref) {
  final dio = Dio();
  dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  var baseURL = APIConfig.baseURL;
  if (APIConfig.useMockData) {
    baseURL = APIConfig.baseMockURL;
  }
  return RestClient(dio, baseUrl: baseURL);
}

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('collections/posts/records')
  Future<Posts> getPosts();
}
