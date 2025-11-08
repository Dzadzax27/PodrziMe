import 'package:podrzime_mobile/modals/uloga.dart';
import 'package:podrzime_mobile/providers/base_provider.dart';

class UlogaProvider extends ApiProvider<Uloga> {
  UlogaProvider() : super("UlogaConroller");

  @override
  Uloga fromJson(data) {
    return Uloga.fromJson(data);
  }
}
