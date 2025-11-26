import 'package:podrzime_mobile/modals/korisnik.dart';
import 'package:podrzime_mobile/modals/obavijest.dart';
import 'package:podrzime_mobile/providers/base_provider.dart';

class ObavijestProvider extends ApiProvider<Obavijest> {
  ObavijestProvider() : super("Obavijest");

  @override
  Obavijest fromJson(data) {
    return Obavijest.fromJson(data);
  }
}
