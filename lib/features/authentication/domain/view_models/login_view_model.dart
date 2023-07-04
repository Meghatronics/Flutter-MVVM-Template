import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../core/view_model/app_view_model.dart';
import '../../../../core/view_model/failure.dart';
import '../../../../core/views/app_toast.dart';
import '../../../../router/app_navigator.dart';
import '../../../../services/local_authentication_service/local_authentication_service.dart';
import '../../../../services/local_storage_service/local_storage_service.dart';
import '../../../shared/geo_data_manager.dart';
import '../../../shared/session_manager.dart';
import '../../../shared/widgets/app_phone_number_field.dart';
import '../../ui/views/forgot_password_view.dart';
import '../../ui/views/phone_verification_view.dart';
import '../models/login_dto.dart';
import '../models/login_method_enum.dart';
import '../models/successful_login_model.dart';
import '../models/user_model.dart';
import '../repository_contracts/authentication_repository.dart';

class LoginViewModel extends AppViewModel {
  final AuthenticationRepository _authRepo;
  final SessionManager _sessionManager;
  final GeoDataManager _geoDataManager;
  final LocalStorageService _localStorage;
  final LocalAuthenticationService _localAuthService;

  LoginViewModel({
    required AuthenticationRepository authRepo,
    required SessionManager sessionManager,
    required GeoDataManager geoDataManager,
    required LocalAuthenticationService localAuthService,
  })  : _authRepo = authRepo,
        _sessionManager = sessionManager,
        _geoDataManager = geoDataManager,
        _localStorage = sessionManager.store,
        _localAuthService = localAuthService;

  final loginForm = GlobalKey<FormState>();
  final emailField = TextEditingController();
  final phoneField = PhoneInputController();
  final passwordField = TextEditingController();

  LocalAuthMethod _biometricMethod = LocalAuthMethod.unavailable;
  LoginMethod _loginMethod = LoginMethod.phone;

  bool get hasBiometric => _biometricMethod != LocalAuthMethod.unavailable;
  LocalAuthMethod get biometricMethod => _biometricMethod;
  LoginMethod get loginMethod => _loginMethod;
  LoginDto get _credential => LoginDto(
        password: passwordField.text.trim(),
        email: _loginMethod.isEmail ? emailField.text : null,
        phone: _loginMethod.isPhone ? phoneField.text : null,
        country: _loginMethod.isPhone ? phoneField.country : null,
      );

  void initialise() {
    _getLastLoginCredential();
    _initialiseBiometricLogin();
    _setupSupportedCountries();
  }

  Future<void> _getLastLoginCredential() async {
    final phone = await Future.wait([
      _localStorage.fetchString(LocalStorageKeys.i.lastUserPhone),
      _localStorage.fetchString(LocalStorageKeys.i.lastUserCountry),
    ]);
    if (!phone.contains(null)) {
      final phoneNumber = phone[0]!;
      final country = CountryModel.fromMap(jsonDecode(phone[1]!));
      phoneField.text = phoneNumber;
      phoneField.country = country;
      changeLoginMethod(LoginMethod.phone);
      return;
    }

    final email = await _localStorage.fetchString(
      LocalStorageKeys.i.lastUserEmail,
    );
    if (email != null) {
      emailField.text = email;
      changeLoginMethod(LoginMethod.email);
    }
  }

  Future<void> _initialiseBiometricLogin() async {
    // Check refresh token expiration
    final expiration = await _localStorage
            .fetchDouble(LocalStorageKeys.i.refreshTokenExpiration) ??
        0;
    final expirationDate =
        DateTime.fromMillisecondsSinceEpoch(expiration.toInt());

    // If refresh token has expired
    final tokenExpired = expirationDate.isBefore(DateTime.now());
    if (tokenExpired) return;

    // Check user preference setting for biometric
    bool? userEnabledBiometric =
        await _localStorage.fetchBool(LocalStorageKeys.i.localAuthEnabled);

    if (userEnabledBiometric == null) {
      _localStorage.saveBool(LocalStorageKeys.i.localAuthEnabled, true);
      userEnabledBiometric = true;
    }

    // If user has disabled biometric login
    if (!userEnabledBiometric) return;

    await _localAuthService.init();
    _biometricMethod = _localAuthService.availableAuthMethod;
    setState();
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

  void changeLoginMethod(LoginMethod method) {
    if (method == _loginMethod) return;
    _loginMethod = method;
    setState();
  }

  Future<void> loginWithPassword() async {
    final validInput = loginForm.currentState!.validate();

    if (!validInput) return;

    setState(VmState.busy);
    final login = await _authRepo.login(login: _credential);
    // print(login.error!.message);
    if (login.hasError) {
      handleErrorAndSetVmState(login.error!);
    } else {
      _concludeLogin(login.data!);
    }
  }

  Future<void> loginWithBiometric() async {
    setState(VmState.busy);
    final authenticate = await _localAuthService.authenticate();
    if (authenticate.hasError) {
      AppToast.info(
        'Unsuccessful login with ${biometricMethod.description}',
        duration: const Duration(seconds: 2),
      ).show();
      setState(VmState.none);
    } else {
      final refreshToken = await _localStorage.fetchString(
        LocalStorageKeys.i.refreshToken,
      );
      final login = await _authRepo.refreshLogin(refreshToken: refreshToken!);

      if (login.hasError) {
        if (login.error is BadAuthFailure) {
          _localStorage.clearField(LocalStorageKeys.i.refreshToken);
          _localStorage.clearField(LocalStorageKeys.i.refreshTokenExpiration);
        }
        handleErrorAndSetVmState(login.error!);
      } else {
        _concludeLogin(login.data!);
      }
    }
  }

  void _concludeLogin(SuccessfulLoginModel loginData) {
    final user = loginData.user;
    _sessionManager.open(
      tokenData: loginData.tokenData,
      user: user,
    );
    if (_loginMethod.isPhone) {
      _localStorage.saveString(
        LocalStorageKeys.i.lastUserCountry,
        jsonEncode(phoneField.country?.toMap()),
      );
      _localStorage.saveString(
        LocalStorageKeys.i.lastUserPhone,
        phoneField.text,
      );
    }
    setState(VmState.none);
    if (!user.phoneVerified) {
      final userCountry = phoneField.supportedCountries.firstWhere(
        (country) => country.phoneCode == user.phoneCode,
        orElse: () => CountryModel(
            name: '', iso2: '', phoneCode: user.phoneCode, states: []),
      );

      AppNavigator.push(
        PhoneVerificationView(
          phoneCountry: userCountry,
          phoneNumber: user.phoneNumber,
        ),
      );
    } else {
      AppNavigator.pushNamedAndClear(AppRoutes.dashboardRoute);
    }
  }

  void forgotPassword() {
    AppNavigator.push(
      ForgotPasswordView(credential: _credential),
    );
  }
}
