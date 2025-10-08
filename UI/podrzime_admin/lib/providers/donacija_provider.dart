import 'package:podrzime_admin/models/donacija.dart';
import 'package:podrzime_admin/providers/podrziMe_base_api.dart';

class DonacijaProvider extends ApiProvider<Donacija> {
  DonacijaProvider() : super("Donacija");

  @override
  Donacija fromJson(data) {
    return Donacija.fromJson(data);
  }
}
