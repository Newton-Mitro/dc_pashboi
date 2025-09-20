import 'package:flutter/material.dart';

class ProductLoansPage extends StatefulWidget {
  const ProductLoansPage({super.key});

  @override
  State<ProductLoansPage> createState() => _ProductLoansPageState();
}

class _ProductLoansPageState extends State<ProductLoansPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Loans')),
      body: Center(child: Text('Product Loans Page')),
    );
  }
}
