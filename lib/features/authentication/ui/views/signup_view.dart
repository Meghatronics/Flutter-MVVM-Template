import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/views/app_view_builder.dart';
import '../../../../dependencies/app_dependencies.dart';
import '../../../../router/app_navigator.dart';
import '../../../../utilities/mixins/validator_mixin.dart';
import '../../../../utilities/theming/app_colors.dart';
import '../../../../utilities/theming/app_styles.dart';
import '../../../profile/domain/models/legal_agreement_enum.dart';
import '../../../profile/ui/views/legal_agreement_view.dart';
import '../../../sender/add_beneficiary/domain/models/new_beneficiary_model.dart';
import '../../../shared/components/app_button_widget.dart';
import '../../../shared/components/app_text_field.dart';
import '../../../shared/widgets/app_phone_number_field.dart';
import '../../domain/view_models/signup_view_model.dart';
import '../widgets/white_title_bar.dart';

class SignupView extends StatelessWidget with ValidatorMixin {
  const SignupView({super.key}) : beneficiary = null;
  const SignupView.asBeneficiary({
    super.key,
    required this.beneficiary,
  });

  final NewBeneficiaryModel? beneficiary;

  void _goToLogin() {
    AppNavigator.pushNamedReplacement(AppRoutes.loginRoute);
  }

  void _goToTermsAndConditions() {
    AppNavigator.push(
      const LegalAgreementView(type: LegalAgreementType.terms),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _goToLogin();
        return Future.value(false);
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, kToolbarHeight * 1.5, 16, 16),
          child: Column(
            children: [
              const WhiteTitleBar(
                heading: 'Get Started on Litrogen',
                subHeading: 'Welcome to Litrogen! Complete the form '
                    'below to setup your account.',
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 12),
                  child: AppViewBuilder<SignupViewModel>(
                    model: AppDependencies.locate(),
                    initState: (signupVm) => signupVm.initialise(beneficiary),
                    builder: (signupVm, _) => Form(
                      key: signupVm.signupForm,
                      child: Column(
                        children: [
                          AppTextField(
                            label: 'First Name',
                            hint: 'Enter First Name',
                            isRequired: true,
                            controller: signupVm.firstNameField,
                            validator: validateRequiredField,
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            label: 'Last Name',
                            hint: 'Enter Last Name',
                            isRequired: true,
                            controller: signupVm.lastNameField,
                            validator: validateRequiredField,
                          ),
                          const SizedBox(height: 16),
                          AppPhoneNumberField(
                            controller: signupVm.phoneField,
                            label: 'Phone number',
                            isRequired: true,
                            enabled: !signupVm.protectInputs,
                            validator: (phone, country) {
                              if (country == null) {
                                return "Select your country's phone code";
                              }
                              if (phone == null || phone.trim().isEmpty) {
                                return 'Phone number is required';
                              }
                              if (phone.length < 7) {
                                return 'Enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            label: 'Email Address',
                            hint: 'Enter Email Address',
                            isRequired: true,
                            controller: signupVm.emailField,
                            validator: validateEmail,
                            keyboardType: TextInputType.emailAddress,
                            validatorMode: AutovalidateMode.onUserInteraction,
                            capitalization: TextCapitalization.none,
                            enabled: !signupVm.protectInputs,
                          ),
                          const SizedBox(height: 16),
                          AppTextField.secret(
                            label: 'Password',
                            hint: 'Enter Password',
                            isRequired: true,
                            controller: signupVm.passwordField,
                            validator: validatePassword,
                            validatorMode: AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 16),
                          AppTextField.secret(
                            label: 'Confirm Password',
                            hint: 'Confirm your password',
                            isRequired: true,
                            controller: signupVm.confirmPasswordField,
                            validator: (confirmPassword) =>
                                validateConfirmPassword(
                              confirmPassword,
                              signupVm.passwordField.text,
                            ),
                          ),
                          const SizedBox(height: 32),
                          RichText(
                            text: TextSpan(
                              style: AppStyles.of(context).normalTextStyle,
                              children: [
                                const TextSpan(
                                  text:
                                      'See important information about procedures for opening a new account in our ',
                                ),
                                TextSpan(
                                  text: 'Terms and Conditions',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _goToTermsAndConditions,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppButton(
                            label: 'Continue',
                            busy: signupVm.isBusy,
                            onPressed: signupVm.saveInformation,
                          ),
                          const SizedBox(height: 56),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 8,
                    bottom:
                        MediaQuery.of(context).viewInsets.bottom > 40 ? 0 : 40,
                  ),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: AppStyles.of(context).normalTextStyle,
                      children: [
                        const TextSpan(
                          text: 'Already have an account? ',
                        ),
                        TextSpan(
                          text: 'Login to Litrogen',
                          recognizer: TapGestureRecognizer()
                            ..onTap = _goToLogin,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.of(context).primaryColor,
                          ),
                        ),
                      ],
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
