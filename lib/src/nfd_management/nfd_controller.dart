// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../extensions/bytes_encoding.dart";
import "../face.dart";
import "../result/interest_expression_result.dart";
import "../result/result.dart";
import "../tlv_elements/name/name.dart";
import "../tlv_elements/nfd_management/control_parameters.dart";
import "../tlv_elements/nfd_management/control_response.dart";
import "../tlv_elements/packet/interest_packet.dart";

class NfdController {
  NfdController(this._face);

  final Face _face;

  Future<void> registerRoute(Name prefix) async {
    final nameComponents = [
      ..."/localhost/nfd/rib/register".toNameComponents(),
      ControlParameters(name: prefix).asNameComponent(),
    ];
    final name = Name(nameComponents);

    final interest = InterestPacket.fromName(name);
    final interestExpressionResult = await _face.expressInterest(interest);

    switch (interestExpressionResult) {
      case DataReceived(:final data):
        final response = data.content?.toTvlElements().firstOrNull;

        if (response is Success<ControlResponse>) {
          // TODO: Process response
          // ignore: avoid_print
          print(response);
        }

      default:
    }
  }
}
