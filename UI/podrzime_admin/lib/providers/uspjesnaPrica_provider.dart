import 'package:podrzime_admin/models/donacija.dart';
import 'package:podrzime_admin/models/takmicar.dart';
import 'package:podrzime_admin/models/uspjesnaPrica.dart';
import 'package:podrzime_admin/providers/podrziMe_base_api.dart';

class UspjesnaPricaProvider extends ApiProvider<UspjesnaPrica> {
  UspjesnaPricaProvider() : super("UspjesnaPrica");

  @override
  UspjesnaPrica fromJson(data) {
    return UspjesnaPrica.fromJson(data);
  }
}
