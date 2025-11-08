import 'package:podrzime_mobile/modals/donor.dart';
import 'package:podrzime_mobile/providers/base_provider.dart';

class DonorProvider extends ApiProvider<Donor> {
  DonorProvider() : super("DonorContoller");

  @override
  Donor fromJson(data) {
    return Donor.fromJson(data);
  }
}
