import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/extensions/string_casing_extension.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/presentation/bloc/collection_ledger_bloc.dart';
import 'package:pashboi/features/authenticated/transfer/domain/entities/dc_bank_entity.dart';
import 'package:pashboi/features/authenticated/transfer/presentation/pages/bank_to_dc_transfer_page/sections/bank_transfer_info_section/bloc/dc_bank_account_bloc.dart';
import 'package:pashboi/shared/widgets/app_dropdown_select.dart';
import 'package:pashboi/shared/widgets/app_text_input.dart';

class BankTransferInfoSection extends StatefulWidget {
  final String? sectionTitle;
  final DcBankEntity selectedBankAccount;
  final String? bankSelectionError;
  final void Function(DcBankEntity bankAccount) onBankAccountChange;
  final String transactionId;
  final void Function(String tnxId) onTransactionIdChange;
  final String amount;
  final String? amountError;
  final void Function(String amount) onAmountChange;
  final File? receiptFile;
  final String? receiptError;
  final void Function(File? receiptFile) onReceiptFileChange;

  const BankTransferInfoSection({
    super.key,
    required this.sectionTitle,
    required this.selectedBankAccount,
    required this.bankSelectionError,
    required this.onBankAccountChange,
    required this.transactionId,
    required this.onTransactionIdChange,
    required this.amount,
    required this.amountError,
    required this.onAmountChange,
    required this.receiptFile,
    required this.receiptError,
    required this.onReceiptFileChange,
  });

  @override
  State<BankTransferInfoSection> createState() =>
      _BankTransferInfoSectionState();
}

class _BankTransferInfoSectionState extends State<BankTransferInfoSection> {
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    context.read<DcBankAccountBloc>().add(DcBankAccountLoadEvent());
  }

  void _pickImage() async {
    final result = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      final file = File(result.path);
      widget.onReceiptFileChange(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CollectionLedgerBloc, CollectionLedgerState>(
      listener: (context, state) {
        // Removed undefined calls for now
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context, widget.sectionTitle ?? "Bank Transfer Info"),
          _buildFormBody(context),
        ],
      ),
    );
  }

  Widget _buildFormBody(BuildContext context) {
    final theme = context.theme;

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.primary),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(6)),
      ),
      child: BlocBuilder<DcBankAccountBloc, DcBankAccountState>(
        builder: (context, state) {
          if (state is DcBankAccountLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DcBankAccountError) {
            return Center(child: Text(state.message));
          }

          if (state is DcBankAccountLoaded) {
            final bankList =
                state.dcBankAccounts
                    .map(
                      (m) => DcBankEntity(
                        id: m.id,
                        bankName: m.bankName,
                        bankAccNumber: m.bankAccNumber,
                        bankRoutingNo: m.bankRoutingNo,
                        bankBranch: m.bankBranch,
                      ),
                    )
                    .toList();

            return Scrollbar(
              thumbVisibility: true,
              radius: const Radius.circular(8),
              thickness: 6,
              trackVisibility: true,
              interactive: true,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppDropdownSelect(
                      label: Locales.string(context, 'bank_account'),
                      value: widget.selectedBankAccount.id,
                      prefixIcon: FontAwesomeIcons.buildingColumns,
                      errorText: widget.bankSelectionError,
                      items:
                          bankList
                              .map(
                                (bank) => DropdownMenuItem(
                                  value: bank.id,
                                  child: Text(
                                    "${bank.bankName.toTitleCase()} - (${bank.bankAccNumber})",
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (val) {
                        final bank = bankList.firstWhere(
                          (b) => b.id == val,
                          orElse: () => DcBankEntity.empty(),
                        );
                        widget.onBankAccountChange(bank);
                      },
                    ),
                    const SizedBox(height: 16),

                    AppTextInput(
                      enabled: false,
                      label: Locales.string(context, 'routing_number'),
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(Icons.route),
                      initialValue: widget.selectedBankAccount.bankRoutingNo,
                    ),
                    const SizedBox(height: 16),

                    // AppTextInput(
                    //   label: "Transaction ID",
                    //   prefixIcon: const Icon(Icons.confirmation_number),
                    //   initialValue: widget.transactionId,
                    //   onChanged: widget.onTransactionIdChange,
                    // ),
                    // const SizedBox(height: 16),
                    AppTextInput(
                      label: Locales.string(context, 'deposit_amount'),
                      errorText: widget.amountError,
                      prefixIcon: const Icon(Icons.attach_money),
                      keyboardType: TextInputType.number,
                      initialValue: widget.amount.toString(),
                      onChanged: (val) {
                        widget.onAmountChange(val);
                      },
                    ),
                    const SizedBox(height: 10),

                    Text(
                      Locales.string(context, 'attach_bank_transfer_receipt'),
                    ),
                    const SizedBox(height: 8),

                    GestureDetector(
                      onTap: _pickImage,
                      child: DottedBorder(
                        key: const ValueKey("dotted_border_key"),
                        options: RectDottedBorderOptions(
                          color:
                              widget.receiptError != null
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.primary,
                          dashPattern: [8, 4],
                        ),
                        child: Container(
                          height: 120,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child:
                              widget.receiptFile != null
                                  ? Image.file(widget.receiptFile!)
                                  : Text(
                                    Locales.string(
                                      context,
                                      'tap_to_upload_receipt_image',
                                    ),
                                  ),
                        ),
                      ),
                    ),
                    // const SizedBox(height: 16),

                    // AppTextInput(
                    //   label: "Remarks",
                    //   prefixIcon: const Icon(Icons.edit_note),
                    //   initialValue: widget.remarks,
                    //   onChanged: widget.onRemarksChange,
                    // ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    final theme = context.theme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
