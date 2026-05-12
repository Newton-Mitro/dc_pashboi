import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/deposit_account_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/account_statement_page/bloc/account_statement_bloc.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/account_statement_page/widgets/account_statment_section.dart';
import 'package:pashboi/shared/widgets/app_date_picker.dart';
import 'package:pashboi/shared/widgets/buttons/app_secondary_button.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:pashboi/core/utils/my_date_utils.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/account_transaction_entity.dart';
import 'package:pashboi/core/extensions/app_context.dart';

class AccountStatementPage extends StatefulWidget {
  final DepositAccountEntity accountDetails;
  const AccountStatementPage({super.key, required this.accountDetails});
  @override
  State<AccountStatementPage> createState() => _AccountStatementPageState();
}

class _AccountStatementPageState extends State<AccountStatementPage> {
  late DateTime startDate;
  late DateTime endDate;
  String? _errorText;

  @override
  void initState() {
    print(widget.accountDetails.number.trim());

    super.initState();
    endDate = DateTime.now();
    startDate = DateTime(endDate.year, endDate.month - 3, endDate.day);

    _fetchTransactions();
  }

  void _fetchTransactions() {
    context.read<AccountStatementBloc>().add(
      FetchAccountStatementEvent(
        accountNumber: widget.accountDetails.number,
        fromDate: "${startDate.year}/${startDate.month}/${startDate.day}",
        toDate: "${endDate.year}/${endDate.month}/${endDate.day}",
      ),
    );
  }

  void _handleDateChange(DateTime date, {required bool isFromDate}) {
    setState(() {
      if (isFromDate) {
        startDate = date;
      } else {
        endDate = date;
      }

      if (endDate.isBefore(startDate)) {
        _errorText = Locales.string(
          context,
          'to_date_must_be_greater_than_from_date',
        );
      } else {
        _errorText = null;
      }
    });
  }

  Future<void> createAndSavePdf(
    List<AccountTransactionEntity> transactions,
  ) async {
    final pdf = pw.Document();
    final logoBytes = await rootBundle.load(
      'assets/images/brand/company_logo.png',
    );
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

    pdf.addPage(
      pw.MultiPage(
        build:
            (context) => [
              pw.Center(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    // 🖼️ Logo
                    pw.Image(logoImage, width: 80, height: 80),

                    pw.SizedBox(height: 10),

                    // 🏢 Company Name
                    pw.Text(
                      'The Christian Co-operative Credit Union Ltd., Dhaka',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),

                    // 📍 Address
                    pw.Text(
                      'Rev. Fr. Charles J. Young Bhaban 173/1/A, East Tejturi Bazar,Tejgaon, Dhaka-1215.',
                      style: pw.TextStyle(fontSize: 7),
                    ),
                    pw.Text(
                      'Phone: 09678771270, 02-48121156, 02-48121157, Hotline (MIS): 01709815406, Hotline (ATM): 01709815400,',
                      style: pw.TextStyle(fontSize: 7),
                    ),
                    pw.Text(
                      'E-mail:info@cccul.com. © 2025 Dhaka Credit. All Rights Reserved.',
                      style: pw.TextStyle(fontSize: 7),
                    ),

                    pw.SizedBox(height: 12),

                    pw.SizedBox(height: 20),
                    pw.Divider(),
                    pw.SizedBox(height: 10),

                    // 🧾 Title
                    pw.Text(
                      'Account Statement',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    // 👤 Account Info
                    pw.Text(
                      widget.accountDetails.typeName,
                      style: pw.TextStyle(fontSize: 9),
                    ),
                    pw.Text(
                      widget.accountDetails.number,
                      style: pw.TextStyle(fontSize: 9),
                    ),
                    // pw.Text('Account Type: ', style: pw.TextStyle(fontSize: 7)),
                    pw.Text(
                      '${startDate.toIso8601String().split('T').first} to ${endDate.toIso8601String().split('T').first}',
                      style: pw.TextStyle(fontSize: 9),
                    ),
                    pw.SizedBox(height: 10),
                  ],
                ),
              ),

              // 📊 Transaction Table
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(4),
                  2: const pw.FlexColumnWidth(2),
                  3: const pw.FlexColumnWidth(2),
                  4: const pw.FlexColumnWidth(2),
                },
                children: [
                  // Table Headers
                  pw.TableRow(
                    // decoration: pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(
                          'Date',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(
                          'Description',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Align(
                          alignment: pw.Alignment.centerRight,
                          child: pw.Text(
                            'Credit',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Align(
                          alignment: pw.Alignment.centerRight,
                          child: pw.Text(
                            'Debit',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Align(
                          alignment: pw.Alignment.centerRight,
                          child: pw.Text(
                            'Balance',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Table Rows
                  ...List.generate(transactions.length, (i) {
                    final txn = transactions[i];
                    final prev = i > 0 ? transactions[i - 1] : null;

                    String compare(num current, num? previous) {
                      if (previous == null) return '';
                      if (current > previous) return '';
                      if (current < previous) return '';
                      return '';
                    }

                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(
                            txn.date.toIso8601String().split('T').first,
                            style: pw.TextStyle(fontSize: 10),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(
                            txn.particular,
                            style: pw.TextStyle(fontSize: 10),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Align(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Text(
                              '${txn.credit.toStringAsFixed(2)}${compare(txn.credit, prev?.credit)}',
                              style: pw.TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Align(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Text(
                              '${txn.debit.toStringAsFixed(2)}${compare(txn.debit, prev?.debit)}',
                              style: pw.TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Align(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Text(
                              '${txn.balance.toStringAsFixed(2)}${compare(txn.balance, prev?.balance)}',
                              style: pw.TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ],
      ),
    );

    // For Android 13+ use `Permission.manageExternalStorage`
    final permission =
        Platform.isAndroid &&
                (await Permission.manageExternalStorage.status.isDenied ||
                    await Permission.storage.status.isDenied)
            ? await Permission.manageExternalStorage.request()
            : await Permission.storage.request();

    if (permission.isGranted) {
      try {
        final downloadsDir =
            await ExternalPath.getExternalStoragePublicDirectory(
              ExternalPath.DIRECTORY_DOWNLOAD,
            );

        final file = File(
          "$downloadsDir/account_statement_${DateTime.now().millisecondsSinceEpoch}.pdf",
        );

        await file.writeAsBytes(await pdf.save());

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("✅ PDF saved to Downloads: ${file.path}"),
            duration: const Duration(seconds: 3),
          ),
        );
      } catch (e) {
        debugPrint("⚠️ Error saving PDF: $e");
      }
    } else {
      // Prompt user to go to settings
      openAppSettings();
      debugPrint("❌ Permission not granted, please enable manually");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Locales.string(context, 'account_statement_page_title')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDatePickers(),
            const SizedBox(height: 20),
            _buildChartSection(),
            const SizedBox(height: 20),
            _buildStatementListSection(),
            const SizedBox(height: 20),
            BlocBuilder<AccountStatementBloc, AccountStatementState>(
              builder: (context, state) {
                if (state is AccountStatementSuccess) {
                  return ElevatedButton(
                    onPressed: () async {
                      await createAndSavePdf(state.transactions);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("PDF saved to Downloads folder"),
                        ),
                      );
                    },
                    child: Text(
                      Locales.string(
                        context,
                        'account_statement_page_download_pdf_button_text',
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePickers() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AppDatePicker(
                  selectedDate: startDate,
                  onDateChanged: (d) => _handleDateChange(d!, isFromDate: true),
                  label: Locales.string(
                    context,
                    'account_statement_page_from_date',
                  ),
                  errorText: _errorText,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppDatePicker(
                  selectedDate: endDate,
                  onDateChanged:
                      (d) => _handleDateChange(d!, isFromDate: false),
                  label: Locales.string(
                    context,
                    'account_statement_page_to_date',
                  ),
                  errorText: _errorText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppSecondaryButton(
            label: "",
            iconBefore: const Icon(Icons.filter_alt),
            onPressed: () {
              if (_errorText == null) {
                _fetchTransactions();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_errorText!),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    return BlocBuilder<AccountStatementBloc, AccountStatementState>(
      buildWhen:
          (prev, curr) =>
              curr is AccountStatementSuccess ||
              curr is AccountStatementLoading,
      builder: (context, state) {
        if (state is AccountStatementLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AccountStatementError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              state.error,
              style: TextStyle(
                color: context.theme.colorScheme.error,
                fontSize: 14,
              ),
            ),
          );
        }

        if (state is AccountStatementSuccess) {
          return _buildChart(state.transactions);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStatementListSection() {
    return BlocBuilder<AccountStatementBloc, AccountStatementState>(
      buildWhen: (prev, curr) => curr is AccountStatementSuccess,
      builder: (context, state) {
        if (state is AccountStatementSuccess) {
          return _buildStatementList(context, state.transactions);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildChart(List<AccountTransactionEntity> transactions) {
    return SfCartesianChart(
      title: ChartTitle(
        text: Locales.string(
          context,
          'account_statement_page_transaction_graph',
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      legend: Legend(
        isVisible: true,
        position: LegendPosition.top,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(),
      series: <CartesianSeries>[
        LineSeries<AccountTransactionEntity, String>(
          name: Locales.string(context, 'account_statement_page_cash_in'),
          dataSource: transactions,
          xValueMapper: (txn, _) => MyDateUtils.getShortMonthName(txn.date),
          yValueMapper: (txn, _) => txn.credit,
          color: Colors.green,
          markerSettings: const MarkerSettings(isVisible: true),
        ),
        LineSeries<AccountTransactionEntity, String>(
          name: Locales.string(context, 'account_statement_page_cash_out'),
          dataSource: transactions,
          xValueMapper: (txn, _) => MyDateUtils.getShortMonthName(txn.date),
          yValueMapper: (txn, _) => txn.debit,
          color: Colors.red,
          markerSettings: const MarkerSettings(isVisible: true),
        ),
      ],
    );
  }

  Widget _buildStatementList(
    BuildContext context,
    List<AccountTransactionEntity> transactions,
  ) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: context.theme.colorScheme.surface,
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            Locales.string(
              context,
              'account_statement_page_account_transactions',
            ),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: context.theme.colorScheme.onSurface,
            ),
          ),
          AccountStatementSection(accountStatment: transactions),
        ],
      ),
    );
  }
}
