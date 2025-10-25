import 'package:podrzime_admin/models/donacija.dart';
import 'package:podrzime_admin/models/kategorija.dart';
import 'package:podrzime_admin/providers/podrziMe_base_api.dart';

class KategorijaProvider extends ApiProvider<Kategorija> {
  KategorijaProvider() : super("Kategorija");

  @override
  Kategorija fromJson(data) {
    return Kategorija.fromJson(data);
  }
}
