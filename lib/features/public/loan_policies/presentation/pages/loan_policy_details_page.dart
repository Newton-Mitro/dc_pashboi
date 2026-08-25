import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/public/loan_policies/domain/entites/loan_policy_entity.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class LoanPolicyDetailsPage extends StatelessWidget {
  final LoanPolicyEntity loanPolicy;

  const LoanPolicyDetailsPage({super.key, required this.loanPolicy});

  @override
  Widget build(BuildContext context) {
    final String imageUrl =
        loanPolicy.attachmentUrl; // optional: add this field in entity
    final bool showIcon = imageUrl.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Locales.string(context, "public_bottom_nav_menu_loans_details"),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: PageContainer(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                showIcon
                    ? Container(
                      alignment: Alignment.center,
                      height: 150,
                      width: double.infinity,
                      child: FaIcon(
                        FontAwesomeIcons.sackDollar,
                        size: 100,
                        color: context.theme.colorScheme.onSurface,
                      ),
                    )
                    : Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                const SizedBox(height: 16),

                Html(data: loanPolicy.longDescription),
                // HtmlContentWebView(htmlContent: depositPolicy.longDescription),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
