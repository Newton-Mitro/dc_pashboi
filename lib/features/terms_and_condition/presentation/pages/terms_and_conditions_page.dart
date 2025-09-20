import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/terms_and_condition/presentation/pages/bloc/term_and_condition_bloc.dart';
import 'package:pashboi/routes/public_routes_name.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/shared/widgets/buttons/app_error_button.dart';
import 'package:pashboi/shared/widgets/buttons/app_warning_button.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({super.key});

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  @override
  void initState() {
    super.initState();
    context.read<TermAndConditionBloc>().add(
      const FetchTermAndConditionEvent(contentName: "Terms And Conditions"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Locales.string(context, 'terms_and_conditions_page_title')),
      ),
      body: PageContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: BlocBuilder<TermAndConditionBloc, TermAndConditionState>(
            builder: (context, state) {
              if (state is TermAndConditionLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TermAndConditionError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 20),
                      AppErrorButton(
                        label: Locales.string(
                          context,
                          'terms_and_conditions_page_retry_button',
                        ),
                        onPressed: () {
                          context.read<TermAndConditionBloc>().add(
                            const FetchTermAndConditionEvent(
                              contentName: "terms_and_conditions",
                            ),
                          );
                        },
                        iconBefore: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                );
              } else if (state is TermAndConditionLoaded) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      HtmlWidget(
                        state.content,
                        customStylesBuilder: (element) {
                          if (element.localName == 'a') {
                            return {'color': 'red'};
                          }
                          return null;
                        },
                        renderMode: RenderMode.column,
                        textStyle: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AppErrorButton(
                            label: Locales.string(
                              context,
                              'terms_and_conditions_page_decline_button',
                            ),
                            onPressed: () => Navigator.pop(context),
                            iconBefore: Icon(
                              Icons.close,
                              color: context.theme.colorScheme.onError,
                            ),
                            horizontalPadding: 0,
                          ),
                          AppWarningButton(
                            label: Locales.string(
                              context,
                              'terms_and_conditions_page_accept_button',
                            ),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                PublicRoutesName.mobileVerificationPage,
                                arguments: {
                                  'routeName': PublicRoutesName.registerPage,
                                  'pageTitle': Locales.string(
                                    context,
                                    'mobile_verification_page_title',
                                  ),
                                },
                              );
                            },
                            iconBefore: Icon(
                              Icons.check,
                              color: context.theme.colorScheme.onTertiary,
                            ),
                            horizontalPadding: 0,
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink(); // fallback
            },
          ),
        ),
      ),
    );
  }
}
