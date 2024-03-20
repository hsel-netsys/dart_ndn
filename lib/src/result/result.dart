// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

sealed class Result<T> {
  T unwrap();
}

final class Success<T> extends Result<T> {
  Success(this.tlvElement);

  final T tlvElement;

  @override
  T unwrap() => tlvElement;
}

final class Fail<T> extends Result<T> {
  Fail(this.exception);

  final Exception exception;

  @override
  T unwrap() => throw StateError("Is instance of Fail, not Success.");
}
