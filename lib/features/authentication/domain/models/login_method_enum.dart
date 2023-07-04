enum LoginMethod {
  email(true, false),
  phone(false, true);

  final bool isEmail;
  final bool isPhone;
  const LoginMethod(this.isEmail, this.isPhone);
}
