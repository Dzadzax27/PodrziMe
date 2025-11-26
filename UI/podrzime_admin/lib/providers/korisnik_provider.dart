import 'package:podrzime_admin/models/korisnik.dart';
import 'package:podrzime_admin/providers/podrziMe_base_api.dart';

class KorisnikProvider extends ApiProvider<Korisnik> {
  KorisnikProvider() : super("KorisnikConrtoller");

  @override
  Korisnik fromJson(data) {
    return Korisnik.fromJson(data);
  }
}
