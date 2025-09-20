import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/extensions/string_casing_extension.dart';
import 'package:pashboi/features/authenticated/agm_counter/domain/entities/agm_counter_entity.dart';
import 'package:pashboi/features/authenticated/agm_counter/presentation/pages/bloc/agm_counter_bloc.dart';
import 'package:pashboi/shared/widgets/app_text_input.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class AgmCounterInfoPage extends StatefulWidget {
  const AgmCounterInfoPage({super.key});

  @override
  State<AgmCounterInfoPage> createState() => _AgmCounterInfoPageState();
}

class _AgmCounterInfoPageState extends State<AgmCounterInfoPage> {
  final TextEditingController _accountNoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AgmCounterBloc>().add(FetchAgmCounterInfoEvent(accountNo: ""));
  }

  @override
  void dispose() {
    _accountNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AGM Counter Info")),
      body: PageContainer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 🔎 Search Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section title
                    Text(
                      "Search Counter",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: context.theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Account No Input
                    AppTextInput(
                      label: "Membership No",
                      controller: _accountNoController,
                    ),
                    const SizedBox(height: 12),

                    // Smaller Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 40,
                        width: 120, // smaller button width
                        child: ElevatedButton(
                          onPressed: () {
                            final accountNo = _accountNoController.text.trim();
                            if (accountNo.isNotEmpty) {
                              context.read<AgmCounterBloc>().add(
                                FetchAgmCounterInfoEvent(accountNo: accountNo),
                              );
                            }
                          },
                          child: const Text(
                            "Find",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 🖼 Bloc State Rendering
              Expanded(
                child: BlocBuilder<AgmCounterBloc, AgmCounterState>(
                  builder: (context, state) {
                    if (state is AgmCounterInfoLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is AgmCounterInfoError) {
                      return Center(
                        child: Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (state is AgmCounterInfoLoaded) {
                      return _buildCounterList(state.agmCounterInfo);
                    }
                    return const Center(
                      child: Text("Enter an account number to fetch info"),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCounterList(AGMCounterEntity counter) {
    // Extract digits from counterNo
    String digits = counter.counterNo.replaceAll(RegExp(r'[^0-9]'), '');

    return Card(
      color: context.theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: context.theme.colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                digits,
                style: TextStyle(
                  color: context.theme.colorScheme.onSecondary,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "SL: ${counter.slNo}",
              style: TextStyle(
                color: context.theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            // Text content
            Text(
              counter.fullName.toTitleCase().trim(),
              style: TextStyle(
                color: context.theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                "Location: ${counter.locationName}\nAccount No: ${counter.accountNo}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: context.theme.colorScheme.onSurface,
                ),
                softWrap: true, // ensures wrapping
              ),
            ),
          ],
        ),
      ),
    );
  }
}
