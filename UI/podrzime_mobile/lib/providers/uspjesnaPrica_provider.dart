import 'package:podrzime_mobile/modals/uspjesnaPrica.dart';
import 'package:podrzime_mobile/providers/base_provider.dart';

class UspjesnaPricaProvider extends ApiProvider<UspjesnaPrica> {
  UspjesnaPricaProvider() : super("UspjesnaPrica");

  @override
  UspjesnaPrica fromJson(data) {
    return UspjesnaPrica.fromJson(data);
  }
}
