import 'package:podrzime_admin/models/uloga.dart';
import 'package:podrzime_admin/providers/podrziMe_base_api.dart';

class UlogaProvider extends ApiProvider<Uloga> {
  UlogaProvider() : super("UlogaConroller");

  @override
  Uloga fromJson(data) {
    return Uloga.fromJson(data);
  }
}
