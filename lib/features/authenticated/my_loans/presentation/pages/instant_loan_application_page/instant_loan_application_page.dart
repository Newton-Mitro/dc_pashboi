import 'package:flutter/material.dart';

class InstantLoanApplicationPage extends StatefulWidget {
  const InstantLoanApplicationPage({super.key});

  @override
  State<InstantLoanApplicationPage> createState() =>
      _InstantLoanApplicationPageState();
}

class _InstantLoanApplicationPageState
    extends State<InstantLoanApplicationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Instant Loan Application')),
      body: Center(child: Text('Instant Loan Application Page')),
    );
  }
}
