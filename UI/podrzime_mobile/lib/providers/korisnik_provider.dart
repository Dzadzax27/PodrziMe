import 'package:podrzime_mobile/modals/korisnik.dart';
import 'package:podrzime_mobile/providers/base_provider.dart';

class KorisnikProvider extends ApiProvider<Korisnik> {
  KorisnikProvider() : super("KorisnikConrtoller");

  @override
  Korisnik fromJson(data) {
    return Korisnik.fromJson(data);
  }
}
