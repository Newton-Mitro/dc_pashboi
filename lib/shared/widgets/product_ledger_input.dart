import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/product_loan_collateral_account_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/product_loans_page/wigets/bloc/deposit_loan_product_bloc.dart';

class ProductLedgerInput extends StatefulWidget {
  final ProductLoanCollectionAccountEntity ledger;
  final bool isSelected;
  final Function(ProductLoanCollectionAccountEntity, double) onAmountChanged;

  const ProductLedgerInput({
    super.key,
    required this.ledger,
    required this.isSelected,
    required this.onAmountChanged,
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
      width: 105,
      height: 36,
      child: TextFormField(
        enabled: widget.isSelected && !widget.ledger.isEligible,
        controller: _controller,
        decoration: InputDecoration(
          labelText: "Amt",
          border: OutlineInputBorder(),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
        ),
        style: const TextStyle(fontSize: 13),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          final amount = double.tryParse(value) ?? 0.0;
          widget.onAmountChanged(widget.ledger, amount);

          final l = widget.ledger;

          if (amount > 0) {
            context.read<DepositLoanProductBloc>().add(
              UpdateLedgerAmount(ledger: widget.ledger, newAmount: amount),
            );
          }
        },
      ),
    );
  }
}
