import '../../../shared/widgets/app_phone_number_field.dart';

class LoginDto {
  final String? email;
  final String? phone;
  final CountryModel? country;
  final String password;

  LoginDto({
    this.email,
    this.phone,
    this.country,
    required this.password,
  }) : assert(
          email != null || (phone != null && country != null),
          'Invalid credential pair provided',
        );

  String get fullPhoneNumber => '${country?.phoneCode}${phone?.replaceAll(' ', '')}';
}
