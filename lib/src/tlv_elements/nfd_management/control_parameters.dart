// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../../extensions/bytes_encoding.dart";
import "../../extensions/non_negative_integer.dart";
import "../../result/result.dart";
import "../name/name.dart";
import "../name/name_component.dart";
import "../tlv_element.dart";
import "../tlv_type.dart";
import "cost.dart";
import "expiration_period.dart";
import "face_id.dart";
import "flags.dart";
import "origin.dart";

final class ControlParameters extends KnownTlvElement {
  const ControlParameters({
    this.name,
    this.faceId,
    this.uri,
    this.localUri,
    this.origin,
    this.cost,
    this.capacity,
    this.count,
    this.baseCongestionMarkingInterval,
    this.defaultCongestionThreshold,
    this.mtu,
    this.flags,
    this.mask,
    this.strategy,
    this.expirationPeriod,
  });

  static Result<ControlParameters> fromValue(List<int> value) {
    // TODO: Implement
    final _ = value.toTvlElements();

    return const Success(ControlParameters());
  }

  final Name? name;

  final NonNegativeInteger? faceId;

  final Uri? uri;

  final Uri? localUri;

  final NonNegativeInteger? origin;

  final NonNegativeInteger? cost;

  final NonNegativeInteger? capacity;

  final NonNegativeInteger? count;

  final NonNegativeInteger? baseCongestionMarkingInterval;

  final NonNegativeInteger? defaultCongestionThreshold;

  final NonNegativeInteger? mtu;

  final NonNegativeInteger? flags;

  final NonNegativeInteger? mask;

  final Name? strategy;

  final NonNegativeInteger? expirationPeriod;

  @override
  TlvType get tlvType => TlvType.controlParameters;

  @override
  List<int> get encodedValue {
    final encodedValue = <int>[];

    final name = this.name;
    if (name != null) {
      encodedValue.addAll(name.encode());
    }

    final faceId = this.faceId;
    if (faceId != null) {
      encodedValue.addAll(FaceId(faceId).encode());
    }

    final origin = this.origin;
    if (origin != null) {
      encodedValue.addAll(Origin(origin).encode());
    }

    final cost = this.cost;
    if (cost != null) {
      encodedValue.addAll(Cost(cost).encode());
    }

    final flags = this.flags;
    if (flags != null) {
      encodedValue.addAll(Flags(flags).encode());
    }

    final expirationPeriod = this.expirationPeriod;
    if (expirationPeriod != null) {
      encodedValue.addAll(ExpirationPeriod(expirationPeriod).encode());
    }

    return encodedValue;
  }

  GenericNameComponent asNameComponent() {
    return GenericNameComponent(encode());
  }
}
