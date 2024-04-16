// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:meta/meta.dart";

@immutable
sealed class Result<T, U extends Exception> {
  const Result();

  T unwrap();
}

final class Success<T, U extends Exception> extends Result<T, U> {
  const Success(this.tlvElement);

  final T tlvElement;

  @override
  T unwrap() => tlvElement;
}

final class Fail<T, U extends Exception> extends Result<T, U> {
  const Fail(this.exception);

  final U exception;

  @override
  T unwrap() => throw StateError("Is instance of Fail, not Success.");
}
