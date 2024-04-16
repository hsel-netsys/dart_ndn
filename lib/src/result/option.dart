// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:meta/meta.dart";

@immutable
sealed class Option<T> {
  const Option();

  T? unwrapOrNull();
}

final class Some<T> extends Option<T> {
  const Some(this.value);

  final T value;

  @override
  T unwrapOrNull() => value;
}

final class None<T> extends Option<T> {
  const None();

  @override
  T? unwrapOrNull() => null;
}
