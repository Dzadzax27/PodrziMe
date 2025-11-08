import 'package:podrzime_mobile/modals/takmicar.dart';
import 'package:podrzime_mobile/modals/takmicarProfil.dart';
import 'package:podrzime_mobile/providers/base_provider.dart';

class TakmicarProfilProvider extends ApiProvider<TakmicarProfil> {
  TakmicarProfilProvider() : super("TakmicarProfil");

  @override
  TakmicarProfil fromJson(data) {
    return TakmicarProfil.fromJson(data);
  }
}
