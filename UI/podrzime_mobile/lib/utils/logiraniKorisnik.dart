import 'package:podrzime_mobile/modals/korisnik.dart';

class Logiranikorisnik {
  static Korisnik? _logiraniKorisnik;

  static Korisnik? get korisnik => _logiraniKorisnik;

  static set korisnik(Korisnik? k) {
    _logiraniKorisnik = k;
  }
}
