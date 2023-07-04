import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../../router/app_navigator.dart';
import '../../../../utilities/theming/app_styles.dart';
import '../../../shared/components/app_button_widget.dart';
import '../../../shared/components/app_back_button.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  const VerifyPhoneNumberScreen({super.key});

  @override
  State<VerifyPhoneNumberScreen> createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen> {
  final _formKey = GlobalKey<FormState>();
  dynamic typedNumber = '';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');
  TextEditingController phoneTextController = TextEditingController(text: '');

  final bool _isLoading = false;
  final bool _phoneError = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const AppBackButton(),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Your Mobile Number',
                    style: AppStyles.of(context).headerStyle.copyWith(
                        color: const Color(0xFF383838),
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Please enter your mobile phone number, and we\'ll send you a verification code. Your phone number will be used for account verification and providing updates on your Litrogen account.',
                    style: AppStyles.of(context).textStyle.copyWith(color: const Color(0XFF606060)),
                  ),
                  const SizedBox(height: 30),
                  RichText(
                      text: TextSpan(
                    text: 'Your Mobile Number',
                    style: AppStyles.of(context).formText,
                  )),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0XFFCFBCFF)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    child: InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        // print(number.phoneNumber);
                        setState(() {
                          typedNumber = phoneTextController.text;
                        });
                      },
                      onInputValidated: (bool value) {
                        // print(value);
                      },
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        setSelectorButtonAsPrefixIcon: true,
                        leadingPadding: 20,
                        useEmoji: true,
                      ),
                      ignoreBlank: false,
                      // autoValidateMode: AutovalidateMode.onUserInteraction,
                      selectorTextStyle: const TextStyle(color: Colors.black),
                      initialValue: number,
                      textFieldController: phoneTextController,
                      formatInput: false,
                      inputDecoration: const InputDecoration(
                        isDense: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color(0XFF93CBFF).withOpacity(0.5),
                            width: 1.0),
                      ),
                      onSaved: (PhoneNumber number) {
                        // print('On Saved: $number');
                      },
                    ),
                  ),
                  const SizedBox(height: 5),
                  _phoneError
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Icon(Icons.warning_amber_rounded,
                                  color: Color(0XFFFA3636)),
                              Text(
                                ' Your phone number is already registered',
                                style: TextStyle(
                                    color: Color(0XFFEE4223), fontSize: 14),
                              )
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 30,
                  ),
                  AppButton(
                    label: 'Continue',
                    busy: _isLoading,
                    onPressed: () {
                      // if (_formKey.currentState!.validate()) {
                      AppNavigator.pushNamed(AppRoutes.otpRoute);
                      // }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
