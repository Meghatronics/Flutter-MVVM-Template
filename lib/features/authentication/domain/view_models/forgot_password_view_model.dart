import 'package:flutter/material.dart';

import '../../../../core/view_model/app_view_model.dart';
import '../../../../core/views/app_toast.dart';
import '../../../../router/app_navigator.dart';
import '../../../shared/geo_data_manager.dart';
import '../../../shared/widgets/app_phone_number_field.dart';
import '../../../shared/widgets/app_success_bottomsheet.dart';
import '../../ui/views/forgot_password_otp_view.dart';
import '../../ui/views/forgot_password_set_new_view.dart';
import '../models/login_dto.dart';
import '../models/login_method_enum.dart';
import '../models/user_model.dart';
import '../repository_contracts/forgot_password_repository.dart';

class ForgotPasswordViewModel extends AppViewModel {
  final ForgotPasswordRepository _forgotPasswordRepo;
  final GeoDataManager _geoDataManager;

  ForgotPasswordViewModel({
    required ForgotPasswordRepository forgotPasswordRepo,
    required GeoDataManager geoDataManager,
  })  : _forgotPasswordRepo = forgotPasswordRepo,
        _geoDataManager = geoDataManager;

  final codeLength = 6;
  final resendCodeDuration = const Duration(seconds: 30);

  final formKeys = List.generate(3, (_) => GlobalKey<FormState>());
  final emailField = TextEditingController();
  final phoneField = PhoneInputController();
  late DateTime resendCodeAvailableAt;
  late TextEditingController otpField;
  late TextEditingController newPasswordField;
  late TextEditingController confirmPasswordField;
  late String _otpToken;
  late String _resetToken;

  LoginMethod _loginMethod = LoginMethod.phone;
  LoginMethod get loginMethod => _loginMethod;
  LoginDto get _credential => LoginDto(
        password: '',
        email: _loginMethod.isEmail ? emailField.text : null,
        phone: _loginMethod.isPhone ? phoneField.text : null,
        country: _loginMethod.isPhone ? phoneField.country : null,
      );

  String get credString =>
      (_loginMethod.isEmail ? _credential.email : _credential.fullPhoneNumber) ??
      '';

  void init(LoginDto? cred) {
    if (cred != null) {
      emailField.text = cred.email ?? '';
      phoneField.text = cred.phone ?? '';
      phoneField.country = cred.country;
      if (cred.email != null) {
        _loginMethod = LoginMethod.email;
      }
    }
    _setupSupportedCountries();
  }

  void _setupSupportedCountries() {
    Stream.fromFutures([
      _geoDataManager.getSupportedCountries(UserType.sender),
      _geoDataManager.getSupportedCountries(UserType.beneficiary),
    ]).listen((resp) {
      if (resp.isSuccessful) {
        phoneField.addCountries(resp.data!);
        phoneField.country ??= resp.data!.first;
      } else {
        AppToast.error(
          'Failed to setup supported countries: ${resp.error!.message}',
        ).show();
      }
    });
  }

  void changeRecoveryMethod(LoginMethod method) {
    if (method == _loginMethod) return;
    _loginMethod = method;
    setState();
  }

  Future<void> sendResetOtp() async {
    final valid = formKeys[0].currentState!.validate();
    if (!valid) return;

    setState(VmState.busy);
    final sendOtp = await _forgotPasswordRepo.sendResetOtp(_credential);

    if (sendOtp.hasError) {
      handleErrorAndSetVmState(sendOtp.error!);
    } else {
      setState(VmState.none);
      otpField = TextEditingController();
      _otpToken = sendOtp.data!;
      resendCodeAvailableAt = DateTime.now().add(resendCodeDuration);
      AppNavigator.push(ForgotPasswordOtpView(this));
    }
  }

  Future<void> resendResetOtp() async {
    setState(VmState.busy);
    final sendOtp = await _forgotPasswordRepo.sendResetOtp(_credential);

    if (sendOtp.hasError) {
      handleErrorAndSetVmState(sendOtp.error!);
    } else {
      _otpToken = sendOtp.data!;
      resendCodeAvailableAt = DateTime.now().add(resendCodeDuration);
      setState(VmState.none);
    }
  }

  Future<void> verifyOtp() async {
    final valid = formKeys[1].currentState!.validate();
    if (!valid) return;

    setState(VmState.busy);
    final verifyOtp = await _forgotPasswordRepo.verifyResetOtp(
      otpField.text,
      _otpToken,
    );

    if (verifyOtp.hasError) {
      handleErrorAndSetVmState(verifyOtp.error!);
      otpField.clear();
    } else {
      setState(VmState.none);
      _resetToken = verifyOtp.data!;
      newPasswordField = TextEditingController();
      confirmPasswordField = TextEditingController();
      AppNavigator.pushAndClear(ForgotPasswordSetNewView(this));
      AppToast.info('Your OTP  has been successfully verified!').show();
    }
  }

  Future<void> resetPassword() async {
    final valid = formKeys[2].currentState!.validate();
    if (!valid) return;

    setState(VmState.busy);
    final verifyOtp = await _forgotPasswordRepo.resetPassword(
      newPassword: newPasswordField.text.trim(),
      token: _resetToken,
    );

    if (verifyOtp.hasError) {
      handleErrorAndSetVmState(verifyOtp.error!);
    } else {
      setState(VmState.none);
      AppSuccessSheet(
        heading: 'Password Reset',
        body: 'You can login with your new password',
        buttonLabel: 'Go to Login',
        onPressed: () => AppNavigator.pushNamed(AppRoutes.loginRoute),
      ).show();
    }
  }
}
