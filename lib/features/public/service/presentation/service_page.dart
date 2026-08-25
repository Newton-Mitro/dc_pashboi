import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/utils/text_util.dart';
import 'package:pashboi/features/public/service/domain/enities/service_policy_entity.dart';
import 'package:pashboi/features/public/service/presentation/bloc/service_policy_bloc.dart';
import 'package:pashboi/features/public/service/presentation/bloc/service_policy_state.dart';
import 'package:pashboi/routes/public_routes_name.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/shared/widgets/public_app_image_card.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => sl<ServicePolicyBloc>()..add(FetchServicePolicyEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(Locales.string(context, "side_menu_title_for_services")),
          backgroundColor: context.theme.colorScheme.primary,
          foregroundColor: context.theme.colorScheme.onPrimary,
          elevation: 0,
        ),
        body: SafeArea(
          child: PageContainer(
            child: BlocBuilder<ServicePolicyBloc, ServicePolicyState>(
              builder: (context, state) {
                if (state is ServiceProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ServicePolicySuccess) {
                  final List<ServicePolicyEntity> policies =
                      state.servicePolicies;

                  if (policies.isEmpty) {
                    return const Center(
                      child: Text("No service policies available."),
                    );
                  }

                  return ListView.builder(
                    itemCount: policies.length,
                    itemBuilder: (context, index) {
                      final product = policies[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                          vertical: 10,
                        ), // Adjust spacing here
                        child: PublicAppImageCard(
                          leftIcon: CircleAvatar(
                            backgroundImage: NetworkImage(
                              product.attachmentUrl,
                            ),
                            radius: 20,
                          ),
                          rightIcon: FontAwesomeIcons.chevronRight,
                          boarderColor: context.theme.colorScheme.primary,
                          cardBody: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  product.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  TextUtil.truncateText(
                                    product.shortDescription,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              PublicRoutesName.serviceDetailsPage,
                              arguments: {"service": product},
                            );
                          },
                        ),
                      );
                    },
                  );
                } else if (state is ServicePolicyError) {
                  return Center(child: Text("Error: ${state.error}"));
                }

                return const SizedBox.shrink(); // Initial or unknown state
              },
            ),
          ),
        ),
      ),
    );
  }
}
