import '../../../shared/widgets/app_phone_number_field.dart';

class SignupDto {
  final String firstName;
  final String lastName;
  final CountryModel phoneCountry;
  final String phone;
  final String email;
  final String password;
  final String confirmPassword;
  final String? inviteToken;

  SignupDto({
    required this.firstName,
    required this.lastName,
    required this.phoneCountry,
    required this.phone,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.inviteToken,
  });
}
