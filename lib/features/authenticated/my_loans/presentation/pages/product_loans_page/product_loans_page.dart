import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/product_loans_page/bloc/deposit_product_loan_bloc.dart';
import 'package:pashboi/routes/auth_routes_name.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';

class ProductLoansPage extends StatefulWidget {
  const ProductLoansPage({super.key});

  @override
  State<ProductLoansPage> createState() => _ProductLoansPageState();
}

class _ProductLoansPageState extends State<ProductLoansPage> {
  @override
  void initState() {
    super.initState();
    context.read<DepositProductLoanBloc>().add(
      FetchDepositLoanEligibilityEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final headerColor = context.theme.colorScheme.primary;
    final iconColor = context.theme.colorScheme.onPrimary;

    return Scaffold(
      appBar: AppBar(title: const Text('Product Loans')),
      body: PageContainer(
        child: Container(
          height: double.infinity,
          child: BlocBuilder<DepositProductLoanBloc, DepositProductLoanState>(
            builder: (context, state) {
              if (state is DepositProductLoanLoading ||
                  state is DepositProductLoanInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is DepositProductLoanError) {
                return Center(child: Text(state.message));
              }

              if (state is DepositProductLoanSuccess) {
                final accountList = state.depositLoanEligibilityDto;

                if (accountList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.boxOpen,
                          size: 50,
                          color: context.theme.colorScheme.onSurface
                              .withOpacity(0.6),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'You do not have any deposit accounts.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: context.theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Accordion(
                  headerBorderWidth: 3,
                  headerBorderColor: headerColor,
                  headerBorderColorOpened: headerColor,
                  headerBackgroundColorOpened: headerColor,
                  contentBackgroundColor: context.theme.colorScheme.surface,
                  contentBorderColor: headerColor,
                  contentBorderWidth: 3,
                  contentHorizontalPadding: 20,
                  scaleWhenAnimating: true,
                  openAndCloseAnimation: true,
                  headerPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                  sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                  sectionClosingHapticFeedback: SectionHapticFeedback.light,
                  children:
                      accountList.map((account) {
                        return AccordionSection(
                          isOpen: false,
                          headerBackgroundColor: headerColor,
                          headerBackgroundColorOpened: headerColor,
                          headerBorderColor: headerColor,
                          contentBorderColor: headerColor,
                          contentVerticalPadding: 20,
                          paddingBetweenClosedSections: 20,
                          header: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                account.loanProductName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: iconColor,
                                ),
                              ),
                            ],
                          ),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  "Account Details",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: context.theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Dynamically map all eligibilityDetails
                              ...account.eligibilityDetails.map((detail) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          Colors
                                              .grey
                                              .shade300, // You can customize this
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildRow(
                                        "Account No",
                                        detail.depositAccountNo,
                                      ),
                                      const Divider(),
                                      _buildRow(
                                        "Findings",
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children:
                                              [
                                                _buildFindingItem(
                                                  "Collateral covered",
                                                  detail.collareralEligible,
                                                ),
                                                if (detail.hasCertificate)
                                                  _buildFindingItem(
                                                    "Certificate Submitted",
                                                    detail
                                                        .isCertificateSubmitted,
                                                  ),
                                                _buildFindingItem(
                                                  "Family loan regular",
                                                  !detail.isFamilyDefaulter,
                                                ),
                                                _buildFindingItem(
                                                  "Self loan regular",
                                                  !detail.isSelfDefaulter,
                                                ),
                                              ].expand((widget) sync* {
                                                yield widget;
                                                yield const SizedBox(height: 8);
                                              }).toList(),
                                        ),
                                      ),
                                      const Divider(),
                                      _buildRow("Eligible", detail.isEligible),
                                    ],
                                  ),
                                );
                              }).toList(),

                              const SizedBox(height: 10),

                              // getEligibleCollateralAccounts
                              AppPrimaryButton(
                                label: "Apply",
                                enabled: account.isEligible,
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AuthRoutesName.depositLoanApplicationPage,
                                    arguments: {
                                      'account': account.loanProductCode,
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                );
              }

              return const SizedBox.shrink(); // fallback
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 3,
            child:
                value is bool
                    ? Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: (value ? Colors.green : Colors.red).withOpacity(
                          0.2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        value ? FontAwesomeIcons.check : FontAwesomeIcons.xmark,
                        color: value ? Colors.green : Colors.red,
                        size: 20,
                      ),
                    )
                    : value is Widget
                    ? value
                    : Text(value.toString()),
          ),
        ],
      ),
    );
  }

  Widget _buildFindingItem(String label, bool isPositive) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isPositive ? FontAwesomeIcons.check : FontAwesomeIcons.xmark,
            color: isPositive ? Colors.green : Colors.red,
            size: 14,
          ),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
