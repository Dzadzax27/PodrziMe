import 'package:podrzime_mobile/modals/takmicar.dart';
import 'package:podrzime_mobile/providers/base_provider.dart';

class TakmicarProvider extends ApiProvider<Takmicar> {
  TakmicarProvider() : super("Takmicari");

  @override
  Takmicar fromJson(data) {
    return Takmicar.fromJson(data);
  }
}
