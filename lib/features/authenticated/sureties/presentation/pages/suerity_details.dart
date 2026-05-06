import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/extensions/string_casing_extension.dart';
import 'package:pashboi/core/utils/my_date_utils.dart';
import 'package:pashboi/features/authenticated/sureties/domain/entities/surety_entity.dart';

class SuerityDetails extends StatelessWidget {
  final SuretyEntity surety;
  const SuerityDetails({super.key, required this.surety});

  String _boolToYesNo(bool? value) {
    if (value == null) return '';
    return value ? 'Yes' : 'No';
  }

  bool _isNullOrEmpty(dynamic value) {
    if (value == null) return true;
    if (value is String && value.trim().isEmpty) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [];

    void addItem({
      required IconData icon,
      required String label,
      required dynamic value,
      bool isDate = false,
      bool isBool = false,
    }) {
      if (_isNullOrEmpty(value)) return;

      final displayValue =
          isDate
              ? MyDateUtils.formatDate(value)
              : isBool
              ? _boolToYesNo(value)
              : value.toString();

      if (displayValue.isEmpty) return;

      items.add(
        _buildItem(context, icon: icon, label: label, value: displayValue),
      );
    }

    addItem(
      icon: Icons.confirmation_num,
      label: Locales.string(context, "loan_id"),
      value: surety.loanNumber,
    );
    addItem(
      icon: Icons.date_range,
      label: Locales.string(context, "loan_open_date"),
      value: surety.loanOpenDate,
      isDate: true,
    );
    addItem(
      icon: Icons.account_circle,
      label: Locales.string(context, "account"),
      value: surety.suretyAccountNumber,
    );
    addItem(
      icon: Icons.person,
      label: Locales.string(context, "name"),
      value: surety.accountHolderName.toTitleCase(),
    );
    addItem(
      icon: Icons.phone,
      label: Locales.string(context, "mobile"),
      value: surety.mobileNumber,
    );
    addItem(
      icon: Icons.shield,
      label: Locales.string(context, "collateral"),
      value: surety.collateralType,
    );
    addItem(
      icon: Icons.monetization_on,
      label: Locales.string(context, "loan_amount"),
      value: surety.loanAmount,
    );
    addItem(
      icon: Icons.balance,
      label: Locales.string(context, "loan_balance"),
      value: surety.loanBalance,
    );
    addItem(
      icon: Icons.lock,
      label: Locales.string(context, "surety_amount"),
      value: surety.suretyAmount,
    );
    addItem(
      icon: Icons.lock_open,
      label: Locales.string(context, "surety_release_amount"),
      value: surety.suretyReleaseAmount,
    );
    addItem(
      icon: Icons.date_range,
      label: Locales.string(context, "start_date"),
      value: surety.loanStartDate,
      isDate: true,
    );
    addItem(
      icon: Icons.calendar_today,
      label: Locales.string(context, "end_date"),
      value: surety.loanEndDate,
      isDate: true,
    );
    addItem(
      icon: Icons.event_available,
      label: Locales.string(context, "last_paid_date"),
      value: surety.lastPaidDate,
      isDate: true,
    );
    addItem(
      icon: Icons.report_problem,
      label: Locales.string(context, "defaulter"),
      value: surety.defaulter,
      isBool: true,
    );
    addItem(
      icon: Icons.note,
      label: Locales.string(context, "defaulter_details"),
      value: surety.defaulterReason,
    );
    addItem(
      icon: Icons.info,
      label: Locales.string(context, "surety_status"),
      value: surety.status,
    );

    return Column(children: items);
  }

  Widget _buildItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final color = context.theme.colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: color),
              const SizedBox(width: 10),
              Text(label, style: TextStyle(color: color)),
            ],
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(color: color),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
