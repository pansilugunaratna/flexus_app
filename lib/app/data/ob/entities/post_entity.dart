// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:objectbox/objectbox.dart';

@Entity()
class PostEntity {
  @Id()
  int id;
  String description;

  PostEntity({this.id = 0, required this.description});
}
