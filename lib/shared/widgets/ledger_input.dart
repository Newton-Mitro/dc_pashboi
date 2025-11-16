import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/domain/entities/collection_ledger_entity.dart';
import 'package:pashboi/features/authenticated/loan_payment/presentation/pages/bloc/loan_payment_bloc.dart';

class LedgerInput extends StatefulWidget {
  final CollectionLedgerEntity ledger;
  final bool isSelected;
  final Function(CollectionLedgerEntity, int) onAmountChanged;

  const LedgerInput({
    super.key,
    required this.ledger,
    required this.isSelected,
    required this.onAmountChanged,
  });

  @override
  State<LedgerInput> createState() => _LedgerInputState();
}

class _LedgerInputState extends State<LedgerInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.ledger.depositAmount.toString(),
    );
  }

  @override
  void didUpdateWidget(covariant LedgerInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ledger.depositAmount != widget.ledger.depositAmount) {
      _controller.text = widget.ledger.depositAmount.toString();
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
        enabled: widget.isSelected && !widget.ledger.editable,
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
          final amount = int.tryParse(value) ?? 0;
          widget.onAmountChanged(widget.ledger, amount);

          final l = widget.ledger;
          if (amount > 0 && l.lps && !l.subledger && l.plType == 2) {
            context.read<LoanPaymentBloc>().add(
              FetchLoanPayment(
                loanNumber: l.accountNumber,
                interestDays: 0,
                interestRate: l.intrestRate,
                loanBalance: l.loanBalance,
                loanRefundAmount:
                    amount, // Use typed value instead of stale one
                moduleCode: l.moduleCode,
                issuedDate: '',
                lastPaidDate: l.lastPaidDate.toIso8601String(),
              ),
            );
          }
        },
      ),
    );
  }
}
