import 'package:podrzime_mobile/modals/donacija.dart';
import 'package:podrzime_mobile/providers/base_provider.dart';

class DonacijaProvider extends ApiProvider<Donacija> {
  DonacijaProvider() : super("Donacija");

  @override
  Donacija fromJson(data) {
    return Donacija.fromJson(data);
  }
}
