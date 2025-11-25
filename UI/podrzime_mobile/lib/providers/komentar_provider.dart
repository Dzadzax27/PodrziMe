import 'package:podrzime_mobile/modals/komentar.dart';
import 'package:podrzime_mobile/providers/base_provider.dart';

class KomentarProvider extends ApiProvider<Komentar> {
  KomentarProvider() : super("Komentar");

  @override
  Komentar fromJson(data) {
    return Komentar.fromJson(data);
  }
}
