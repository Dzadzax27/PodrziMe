import 'package:podrzime_admin/models/donacija.dart';
import 'package:podrzime_admin/models/takmicar.dart';
import 'package:podrzime_admin/providers/podrziMe_base_api.dart';

class TakmicarProvider extends ApiProvider<Takmicar> {
  TakmicarProvider() : super("Takmicari");

  @override
  Takmicar fromJson(data) {
    return Takmicar.fromJson(data);
  }
}
