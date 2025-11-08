import 'package:podrzime_mobile/modals/kategorija.dart';
import 'package:podrzime_mobile/providers/base_provider.dart';

class KategorijaProvider extends ApiProvider<Kategorija> {
  KategorijaProvider() : super("Kategorija");

  @override
  Kategorija fromJson(data) {
    return Kategorija.fromJson(data);
  }
}
