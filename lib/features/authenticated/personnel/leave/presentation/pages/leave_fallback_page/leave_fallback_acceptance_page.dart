import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_fallback_page/bloc/fallback_request_bloc.dart';
import 'package:pashboi/routes/auth_routes_name.dart';
import 'package:pashboi/shared/widgets/app_icon_card.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class LeaveFallbackAcceptancePage extends StatefulWidget {
  const LeaveFallbackAcceptancePage({super.key});

  @override
  State<LeaveFallbackAcceptancePage> createState() =>
      _LeaveFallbackAcceptancePageState();
}

class _LeaveFallbackAcceptancePageState
    extends State<LeaveFallbackAcceptancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fallback Acceptance")),
      body: PageContainer(
        child: Container(
          height: double.infinity,

          child: SingleChildScrollView(child: _buildForm()),
        ),
      ),
    );
  }

  void initState() {
    super.initState();
    context.read<FallbackRequestBloc>().add(FetchFallbackRequests());
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<FallbackRequestBloc, FallbackRequestState>(
            builder: (context, state) {
              if (state is FallbackRequestLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is FallbackRequestError) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: const Center(
                    child: Text(
                      'An error occurred',
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              if (state is FallbackRequestSuccess) {
                final requestList = state.requests;
                if (requestList.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            FontAwesomeIcons.boxOpen,
                            size: 60,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'There are currently no pending fallback requests',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: List.generate(
                    requestList.length,
                    (index) => AppIconCard(
                      leftIcon: FontAwesomeIcons.mugHot,
                      rightIcon: FontAwesomeIcons.chevronRight,
                      boarderColor: context.theme.colorScheme.primary,
                      cardBody: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            requestList[index].employeeName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "From: ${requestList[index].fromDate.toLocal().toString().split(' ')[0]}",
                          ),
                          Text(
                            "To: ${requestList[index].toDate.toLocal().toString().split(' ')[0]}",
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AuthRoutesName.fallbackAcceptedPage,
                          arguments: {'fallbackRequest': requestList[index]},
                        );
                      },
                    ),
                  ),
                );
              }

              return const SizedBox(height: 10);
            },
          ),
        ],
      ),
    );
  }
}
