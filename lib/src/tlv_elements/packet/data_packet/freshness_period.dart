import "../../../extensions/non_negative_integer.dart";
import "../../../result/result.dart";
import "../../tlv_element.dart";
import "../../tlv_type.dart";

final class FreshnessPeriod extends NonNegativeIntegerTlvElement {
  FreshnessPeriod(this.duration)
      : super(NonNegativeInteger(duration.inMilliseconds));

  static Result<FreshnessPeriod> fromValue(List<int> value) {
    switch (NonNegativeInteger.fromValue(value)) {
      // ignore: pattern_never_matches_value_type
      case Success(:final tlvElement):
        return Success(FreshnessPeriod(Duration(milliseconds: tlvElement)));
      case Fail(:final exception):
        return Fail(exception);
    }
  }

  final Duration duration;

  @override
  TlvType get tlvType => TlvType.freshnessPeriod;
}
