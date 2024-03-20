// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

part of "../name_component.dart";

final class GenericNameComponent extends NameComponent {
  const GenericNameComponent(this.content);

  static Result<GenericNameComponent> fromValue(List<int> value) {
    try {
      // TODO: Will probably not be UTF-8
      final content = utf8.decode(value);
      final component = GenericNameComponent(content);
      return Success(component);
    } on Exception catch (exception) {
      return Fail(exception);
    }
  }

  final String content;

  @override
  TlvType get tlvType => TlvType.genericNameComponent;

  @override
  List<int> get encodedValue => utf8.encode(content);

  @override
  TlvValueFormat get tlvValueFormat => TlvValueFormat.octetStar;
}

// TODO: Move somewhere else?
final class ControlParametersNameComponent extends NameComponent {
  const ControlParametersNameComponent(this.controlParameters);

  final ControlParameters controlParameters;

  @override
  TlvType get tlvType => TlvType.genericNameComponent;

  @override
  List<int> get encodedValue => controlParameters.encode().toList();

  @override
  TlvValueFormat get tlvValueFormat => TlvValueFormat.octetStar;
}
