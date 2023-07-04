import 'package:flutter/material.dart';

import '../../../../core/view_model/app_view_model.dart';
import '../../../../router/app_navigator.dart';
import '../../../shared/widgets/app_phone_number_field.dart';
import '../../../shared/widgets/app_success_bottomsheet.dart';
import '../repository_contracts/authentication_repository.dart';

class PhoneVerificationViewModel extends AppViewModel {
  final AuthenticationRepository _authRepo;

  PhoneVerificationViewModel({required AuthenticationRepository authRepo})
      : _authRepo = authRepo;

  final codeLength = 6;
  final resendCodeDuration = const Duration(seconds: 30);

  final formKey = GlobalKey<FormState>();
  late DateTime resendCodeAvailableAt;
  final otpField = TextEditingController();

  late CountryModel _country;
  late String _phone;

  String get phoneNumber => '${_country.phoneCode}$_phone';
  String get _cleanedPhone => _phone.replaceAll(' ', '');

  void call(CountryModel country, String phone) {
    _country = country;
    _phone = phone;
    resendCodeAvailableAt = DateTime.now().add(resendCodeDuration);
  }

  Future<void> resendResetOtp() async {
    setState(VmState.busy);
    final sendOtp = await _authRepo.sendVerificationOtp(
      _country,
      _cleanedPhone,
    );

    if (sendOtp.hasError) {
      handleErrorAndSetVmState(sendOtp.error!);
    } else {
      resendCodeAvailableAt = DateTime.now().add(resendCodeDuration);
      setState(VmState.none);
    }
  }

  Future<void> verifyOtp() async {
    final valid = formKey.currentState!.validate();
    if (!valid) return;

    setState(VmState.busy);
    final verifyOtp = await _authRepo.confirmVerificationOtp(
      country: _country,
      phone: _cleanedPhone,
      otp: otpField.text,
    );

    if (verifyOtp.hasError) {
      handleErrorAndSetVmState(verifyOtp.error!);
      otpField.clear();
    } else {
      setState(VmState.none);

      AppSuccessSheet(
        heading: 'Phone Number Verified!',
        body: 'Your phone number has been \nsuccessfully verified!',
        onPressed: () {
          AppNavigator.pushNamedAndClear(AppRoutes.dashboardRoute);
        },
      ).show();
    }
  }
}
