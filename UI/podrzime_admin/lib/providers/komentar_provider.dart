import 'package:podrzime_admin/models/komentar.dart';
import 'package:podrzime_admin/providers/podrziMe_base_api.dart';

class KomentarProvider extends ApiProvider<Komentar> {
  KomentarProvider() : super("Komentar");

  @override
  Komentar fromJson(data) {
    return Komentar.fromJson(data);
  }
}
