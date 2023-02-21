// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

class AuthException implements Exception {
  String cause;
  AuthException(this.cause);
  @override
  String toString() {
    return cause;
  }
}
