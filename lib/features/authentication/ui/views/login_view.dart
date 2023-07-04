import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/views/app_view_builder.dart';
import '../../../../dependencies/app_dependencies.dart';
import '../../../../router/app_navigator.dart';
import '../../../../services/local_authentication_service/local_authentication_service.dart';
import '../../../../utilities/mixins/validator_mixin.dart';
import '../../../../utilities/theming/app_colors.dart';
import '../../../../utilities/theming/app_styles.dart';
import '../../../shared/components/app_button_widget.dart';
import '../../../shared/components/app_text_field.dart';
import '../../../shared/resources.dart';
import '../../../shared/widgets/app_phone_number_field.dart';
import '../../domain/models/login_method_enum.dart';
import '../../domain/view_models/login_view_model.dart';
import '../widgets/login_method_switch_button.dart';
import '../widgets/white_title_bar.dart';

class LoginView extends StatelessWidget with ValidatorMixin {
  const LoginView({super.key});
  void _goToSignup() {
    AppNavigator.pushNamedReplacement(AppRoutes.signupRoute);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _goToSignup();
        return Future.value(false);
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, kToolbarHeight * 1.5, 16, 16),
          child: Column(
            children: [
              const WhiteTitleBar(
                heading: 'Welcome Back!',
                subHeading: 'Complete the fields below to Login to Litrogen.',
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 12),
                  child: AppViewBuilder<LoginViewModel>(
                    model: AppDependencies.locate(),
                    initState: (loginVm) => loginVm.initialise(),
                    builder: (loginVm, _) => Form(
                      key: loginVm.loginForm,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (loginVm.loginMethod.isEmail)
                            AppTextField(
                              label: 'Email',
                              hint: 'Enter your email',
                              isRequired: true,
                              controller: loginVm.emailField,
                              validator: validateEmail,
                              keyboardType: TextInputType.emailAddress,
                              capitalization: TextCapitalization.none,
                              suffix: LoginMethodSwitchButton(
                                loginMethod: LoginMethod.phone,
                                onTapped: loginVm.changeLoginMethod,
                              ),
                            )
                          else if (loginVm.loginMethod.isPhone)
                            AppPhoneNumberField(
                              label: 'Phone Number',
                              hint: 'Enter your phone number',
                              isRequired: true,
                              controller: loginVm.phoneField,
                              suffix: LoginMethodSwitchButton(
                                loginMethod: LoginMethod.email,
                                onTapped: loginVm.changeLoginMethod,
                              ),
                              validator: validatePhone,
                            ),
                          const SizedBox(height: 16),
                          AppTextField.secret(
                            label: 'Password',
                            hint: 'Enter your password',
                            isRequired: true,
                            controller: loginVm.passwordField,
                            validator: (password) {
                              if (password.isEmpty) {
                                return 'Your password is required';
                              }
                              return null;
                            },
                            keyboardAction: TextInputAction.go,
                            onEditComplete: () {
                              FocusScope.of(context).unfocus();
                              loginVm.loginWithPassword();
                            },
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: loginVm.forgotPassword,
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontFamily: AppStyles.walsheimFontFamily,
                                  fontSize: 14,
                                  height: 20 / 14,
                                  color: AppColors.of(context).bodyText,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          AppButton(
                            label: 'Login',
                            busy: loginVm.isBusy,
                            onPressed: loginVm.loginWithPassword,
                          ),
                          const SizedBox(height: 24),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: AppStyles.of(context).normalTextStyle,
                              children: [
                                const TextSpan(
                                  text: "Don't have an account? ",
                                ),
                                TextSpan(
                                  text: 'Sign up on Litrogen',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _goToSignup,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          if (loginVm.hasBiometric)
                            InkResponse(
                              onTap: loginVm.loginWithBiometric,
                              child: Container(
                                height: MediaQuery.of(context).size.width / 3,
                                width: MediaQuery.of(context).size.width / 3,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.of(context).iconBgColor,
                                ),
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  loginVm.biometricMethod.svgIcon,
                                  height: MediaQuery.of(context).size.width / 6,
                                  width: MediaQuery.of(context).size.width / 6,
                                  colorFilter: ColorFilter.mode(
                                    AppColors.of(context).primaryColor,
                                    BlendMode.dst,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension _LocalAuthMethodExtension on LocalAuthMethod {
  String get svgIcon {
    switch (this) {
      case LocalAuthMethod.faceId:
        return AppRes.i.faceidIcon;
      case LocalAuthMethod.fingerprint:
      default:
        return AppRes.i.fingerprintIcon;
    }
  }
}
