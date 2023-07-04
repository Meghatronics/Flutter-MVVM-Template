import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

import '../../../../main/application.dart';
import '../../../identity_verification/domain/models/id_verification_status_enum.dart';
import '../../../sender/connect_bank/domain/models/connected_bank_model.dart';

class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String phoneCode;
  final String phoneNumber;
  final String? _avatarUrl;
  final UserType type;
  final bool phoneVerified;
  final bool emailVerified;
  final IdVerificationStatus idVerificationStatus;
  final SenderInfo? senderInfo;
  final BeneficiaryInfo? beneficiaryInfo;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneCode,
    required this.phoneNumber,
    required String? avatarUrl,
    required this.phoneVerified,
    required this.emailVerified,
    required this.type,
    required this.idVerificationStatus,
    required this.senderInfo,
    required this.beneficiaryInfo,
  }) : _avatarUrl = avatarUrl;

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final type = UserType.values.firstWhere(
      (v) => v.serverCode == map['role'],
    );
    return UserModel(
      id: map['id'].toString(),
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      phoneCode: map['phone_code'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      avatarUrl: map['avatar'],
      phoneVerified: map['isPhoneVerified'] ?? false,
      emailVerified: map['isEmailVerified'] ?? false,
      type: type,
      idVerificationStatus: IdVerificationStatus.values.firstWhere(
        (v) => v.serverCode == map['kyc_status'],
        orElse: () => IdVerificationStatus.unverified,
      ),
      senderInfo: type.isSender ? SenderInfo.fromMap(map['sender']) : null,
      beneficiaryInfo: type.isBeneficiary
          ? BeneficiaryInfo.fromMap(map['beneficiary'])
          : null,
    );
  }

  num get amountSpent =>
      type.isSender ? senderInfo!.amountSpent : beneficiaryInfo!.amountSpent;
  num get availableBalance => type.isSender
      ? senderInfo!.availableBalance
      : beneficiaryInfo!.availableBalance;

  String get fullName => '$firstName $lastName';
  String? get avatarUrl =>
      _avatarUrl != null ? 'http://${ThisApp.env.apiUrl}/$_avatarUrl' : null;
  ImageProvider? get avatarImage =>
      avatarUrl == null ? null : CachedNetworkImageProvider(avatarUrl!);

  UserModel copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? phoneCode,
    String? phoneNumber,
    String? avatarUrl,
    UserType? type,
    bool? phoneVerified,
    bool? emailVerified,
    IdVerificationStatus? idVerificationStatus,
    SenderInfo? senderInfo,
    BeneficiaryInfo? beneficiaryInfo,
  }) {
    return UserModel(
      id: id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneCode: phoneCode ?? this.phoneCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      type: type ?? this.type,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      emailVerified: emailVerified ?? this.emailVerified,
      idVerificationStatus: idVerificationStatus ?? this.idVerificationStatus,
      senderInfo: senderInfo ?? this.senderInfo,
      beneficiaryInfo: beneficiaryInfo ?? this.beneficiaryInfo,
    );
  }
}

enum UserType {
  beneficiary(serverCode: 'BENEFICIARY'),
  sender(serverCode: 'SENDER');

  final String serverCode;
  const UserType({required this.serverCode});

  bool get isBeneficiary => this == beneficiary;
  bool get isSender => this == sender;
}

class SenderInfo {
  final num availableBalance;
  final num litroCreditBookBalance;
  final num amountSpent;
  final Iterable<ConnectedBankModel>? bankItems;

  bool get hasConnectedBank => bankItems != null && bankItems!.isNotEmpty;

  SenderInfo.fromMap(Map<String, dynamic> map)
      : availableBalance = map['available_balance'],
        amountSpent = map['amount_spent'],
        litroCreditBookBalance = map['litro_credit_book_balance'],
        bankItems = (map['bankItems'] as List?)
            ?.map((e) => ConnectedBankModel.fromMap(e));
}

class BeneficiaryInfo {
  final num availableBalance;
  final num amountSpent;
  // final VirtualAccountInfo virtualAccountInfo;

  BeneficiaryInfo.fromMap(Map<String, dynamic> map)
      : availableBalance = map['available_balance'] ?? 0,
        amountSpent = map['amount_spent'] ?? 0;
  // virtualAccountInfo = map['virtualAccount'];
}

class VirtualAccountInfo {
  final String accountNo;
  final String accountName;
  final String bankName;
  final num accountBalance;
  final num availableBalance;

  VirtualAccountInfo.fromMap(Map<String, dynamic> map)
      : accountNo = map['accountNo'],
        accountName = map['accountName'],
        bankName = map['bankName'],
        accountBalance = map['account_balance'],
        availableBalance = map['available_balance'];
}
