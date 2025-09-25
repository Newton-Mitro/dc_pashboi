import 'package:flutter/material.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class InstantLoanEligible extends StatefulWidget {
  const InstantLoanEligible({super.key});

  @override
  State<InstantLoanEligible> createState() => _InstantLoanEligibleState();
}

class _InstantLoanEligibleState extends State<InstantLoanEligible> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Instant Loan ")),
      body: PageContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("data"),
        ),
      ),
    );
    ;
  }
}
