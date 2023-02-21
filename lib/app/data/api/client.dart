// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/posts/posts.dart';

part '../../../base/generated/lib/app/data/api/client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('collections/posts/records')
  Future<Posts> getPosts();
}
