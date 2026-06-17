import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/shared/widgets/app_text_input.dart';

class AccountHolderSection extends StatelessWidget {
  final String? accountHolderName;
  final String? accountForText;
  final String? accountOperatorName;

  const AccountHolderSection({
    super.key,
    required this.accountHolderName,
    required this.accountForText,
    required this.accountOperatorName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildNomineeSelectionCard(context),
        const SizedBox(height: 25),
        _buildAppointedNomineesCard(context),
      ],
    );
  }

  Widget _buildNomineeSelectionCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        border: Border.all(color: context.theme.colorScheme.primary),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(
            context,
            Locales.string(context, 'select_account_holder'),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                AppTextInput(
                  controller: TextEditingController(text: accountForText),
                  enabled: false,
                  label: Locales.string(context, 'account_type'),
                  prefixIcon: Icon(
                    FontAwesomeIcons.creditCard,
                    color: context.theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                AppTextInput(
                  controller: TextEditingController(text: accountHolderName),
                  enabled: false,
                  label: Locales.string(context, 'account_holder_name'),
                  prefixIcon: Icon(
                    FontAwesomeIcons.user,
                    color: context.theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointedNomineesCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        border: Border.all(color: context.theme.colorScheme.primary),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, Locales.string(context, 'account_operator')),
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppTextInput(
              controller: TextEditingController(text: accountOperatorName),
              enabled: false,
              label: Locales.string(context, 'account_operator_name'),
              prefixIcon: Icon(
                FontAwesomeIcons.userShield,
                color: context.theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: context.theme.colorScheme.onPrimary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
