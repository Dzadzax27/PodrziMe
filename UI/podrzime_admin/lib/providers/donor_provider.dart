import 'package:podrzime_admin/models/donacija.dart';
import 'package:podrzime_admin/models/donor.dart';
import 'package:podrzime_admin/providers/podrziMe_base_api.dart';

class DonorProvider extends ApiProvider<Donor> {
  DonorProvider() : super("DonorContoller");

  @override
  Donor fromJson(data) {
    return Donor.fromJson(data);
  }
}
