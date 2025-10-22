import 'package:flutter/material.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/product_loan_collateral_account_entity.dart';

class ProductLedgerInput extends StatefulWidget {
  final ProductLoanCollectionAccountEntity ledger;
  final bool isSelected;
  final Function(ProductLoanCollectionAccountEntity, double) onAmountChanged;
  final Function(ProductLoanCollectionAccountEntity) onUpdateAccounts;

  const ProductLedgerInput({
    super.key,
    required this.ledger,
    required this.isSelected,
    required this.onAmountChanged,
    required this.onUpdateAccounts,
  });

  @override
  State<ProductLedgerInput> createState() => _ProductLedgerInputState();
}

class _ProductLedgerInputState extends State<ProductLedgerInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.ledger.partialApplyLoan.toString(),
    );
  }

  @override
  void didUpdateWidget(covariant ProductLedgerInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ledger.partialApplyLoan != widget.ledger.partialApplyLoan) {
      _controller.text = widget.ledger.partialApplyLoan.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: TextFormField(
        enabled: widget.isSelected,
        controller: _controller,
        decoration: InputDecoration(
          labelText: "Apply Loan Amount ",
          border: OutlineInputBorder(),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
        ),
        style: const TextStyle(fontSize: 15),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          final amount = double.tryParse(value) ?? 0.0;
          widget.onAmountChanged(widget.ledger, amount);
          widget.onUpdateAccounts(widget.ledger);
        },
      ),
    );
  }
}
