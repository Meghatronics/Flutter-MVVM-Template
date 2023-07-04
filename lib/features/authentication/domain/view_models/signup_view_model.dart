import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../core/view_model/app_view_model.dart';
import '../../../../core/views/app_toast.dart';
import '../../../../router/app_navigator.dart';
import '../../../../utilities/constants.dart/local_storage_keys.dart';
import '../../../sender/add_beneficiary/domain/models/new_beneficiary_model.dart';
import '../../../shared/geo_data_manager.dart';
import '../../../shared/session_manager.dart';
import '../../../shared/widgets/app_phone_number_field.dart';
import '../../ui/views/phone_verification_view.dart';
import '../models/signup_dto.dart';
import '../models/successful_login_model.dart';
import '../models/user_model.dart';
import '../repository_contracts/authentication_repository.dart';

class SignupViewModel extends AppViewModel {
  final AuthenticationRepository _authRepo;
  final SessionManager _sessionManager;
  final GeoDataManager _geoDataManager;

  SignupViewModel({
    required AuthenticationRepository authRepo,
    required SessionManager sessionManager,
    required GeoDataManager geoDataManager,
  })  : _authRepo = authRepo,
        _sessionManager = sessionManager,
        _geoDataManager = geoDataManager;

  final signupForm = GlobalKey<FormState>();
  final firstNameField = TextEditingController();
  final lastNameField = TextEditingController();
  final phoneField = PhoneInputController();
  final emailField = TextEditingController();
  final passwordField = TextEditingController();
  final confirmPasswordField = TextEditingController();
  UserType _userType = UserType.sender;
  String? _inviteToken;

  bool get protectInputs => _userType.isBeneficiary;

  Future<void> initialise(NewBeneficiaryModel? beneficiary) async {
    if (beneficiary != null) {
      _userType = UserType.beneficiary;
      _inviteToken = beneficiary.inviteToken;
      firstNameField.text = beneficiary.firstName;
      lastNameField.text = beneficiary.lastName;
      emailField.text = beneficiary.email;
      phoneField.text = beneficiary.phone;
    }
    final getSupportedCountries =
        await _geoDataManager.getSupportedCountries(_userType);

    if (getSupportedCountries.hasError) {
      AppToast.error(
        'Failed to setup supported countries: ${getSupportedCountries.error!.message}',
      ).show();
    } else {
      phoneField.supportedCountries = getSupportedCountries.data!;
      phoneField.country = phoneField.supportedCountries.firstWhere(
        (element) => element.phoneCode == beneficiary?.phoneCode,
        orElse: () => phoneField.supportedCountries.first,
      );
    }
  }

  Future<void> saveInformation() async {
    final validInputs = signupForm.currentState!.validate();
    if (!validInputs) return;

    setState(VmState.busy);
    final signupData = SignupDto(
      firstName: firstNameField.text,
      lastName: lastNameField.text,
      phoneCountry: phoneField.country!,
      phone: phoneField.text,
      email: emailField.text.trim().toLowerCase(),
      password: passwordField.text.trim(),
      confirmPassword: confirmPasswordField.text.trim(),
      inviteToken: _inviteToken,
    );
    final signup = await _authRepo.signup(signupData, _userType);

    if (signup.hasError) {
      handleErrorAndSetVmState(signup.error!);
    } else {
      setState(VmState.none);
      _continueToPhoneVerification(signup.data!);
    }
  }

  void _continueToPhoneVerification(SuccessfulLoginModel signedUp) {
    _sessionManager.open(
      tokenData: signedUp.tokenData,
      user: signedUp.user,
    );
    _sessionManager.store.saveString(
      LocalStorageKeys.i.lastUserCountry,
      jsonEncode(phoneField.country?.toMap()),
    );
    _sessionManager.store.saveString(
      LocalStorageKeys.i.lastUserPhone,
      phoneField.text,
    );
    AppNavigator.pushAndClear(PhoneVerificationView(
      phoneCountry: phoneField.country!,
      phoneNumber: phoneField.text,
    ));
  }
}
