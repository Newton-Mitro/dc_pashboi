import 'package:flutter/material.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class InstantLoanNotEligible extends StatefulWidget {
  const InstantLoanNotEligible({super.key});

  @override
  State<InstantLoanNotEligible> createState() => _InstantLoanNotEligibleState();
}

class _InstantLoanNotEligibleState extends State<InstantLoanNotEligible> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Instant Loan not eligible")),
      body: PageContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("data"),
        ),
      ),
    );
  }
}
