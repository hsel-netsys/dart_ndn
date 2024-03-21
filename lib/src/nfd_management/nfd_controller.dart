// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../extensions/bytes_encoding.dart";
import "../extensions/non_negative_integer.dart";
import "../face.dart";
import "../result/interest_expression_result.dart";
import "../result/result.dart";
import "../signer.dart";
import "../tlv_elements/name/name.dart";
import "../tlv_elements/nfd_management/control_response.dart";
import "command_interest.dart";

class NfdController {
  NfdController(
    this._face, {
    Signer? signer,
  }) : _signer = signer;

  final Face _face;

  final Signer? _signer;

  Future<void> registerRoute(
    Name prefix, {
    NonNegativeInteger? faceId,
    NonNegativeInteger? origin,
    NonNegativeInteger? cost,
    NonNegativeInteger? flags,
    NonNegativeInteger? expirationPeriod,
  }) async {
    var interestPacket = RegisterRouteCommand(
      prefix,
      faceId: faceId,
      origin: origin,
      cost: cost,
      flags: flags,
      expirationPeriod: expirationPeriod,
    ).toInterestPacket();

    if (_signer != null) {
      interestPacket = _signer.signInterest(interestPacket);
    }

    final interestExpressionResult =
        await _face.expressInterest(interestPacket);

    switch (interestExpressionResult) {
      case DataReceived(:final data):
        final response = data.content?.toTvlElements().firstOrNull;

        if (response is Success<ControlResponse>) {
          // TODO: Process response
          // ignore: avoid_print
          print(response.tlvElement);
        }

      default:
    }
  }
}
