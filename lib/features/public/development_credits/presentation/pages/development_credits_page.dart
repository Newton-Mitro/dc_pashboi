import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/utils/text_util.dart';
import 'package:pashboi/features/public/development_credits/domain/entites/development_credits_entity.dart';
import 'package:pashboi/features/public/development_credits/presentation/bloc/development_credit_bloc.dart';
import 'package:pashboi/routes/public_routes_name.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/shared/widgets/public_app_image_card.dart';

class DevelopmentCreditsPage extends StatelessWidget {
  const DevelopmentCreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              sl<DevelopmentCreditBloc>()..add(FetchDevelopmentCreditEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Locales.string(context, "side_menu_title_for_development_credits"),
          ),
        ),
        body: SafeArea(
          child: PageContainer(
            child: BlocBuilder<DevelopmentCreditBloc, DevelopmentCreditState>(
              builder: (context, state) {
                if (state is DevelopmentCreditLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DevelopmentCreditSuccess) {
                  final List<DevelopmentCreditsEntity> pages =
                      state.developmentCredit;

                  if (pages.isEmpty) {
                    return const Center(child: Text("No pages available."));
                  }
                  return ListView.builder(
                    itemCount: pages.length,
                    itemBuilder: (context, index) {
                      final product = pages[index];
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
                                  product.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  TextUtil.truncateText(product.designation),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              PublicRoutesName.developmentTeamsDetailsPage,
                              arguments: {"developmentTeams": product},
                            );
                          },
                        ),
                      );
                    },
                  );

                  // return ListView.builder(
                  //   itemCount: pages.length,
                  //   itemBuilder: (context, index) {
                  //     final page = pages[index];
                  //     return Card(
                  //       elevation: 1,
                  //       shadowColor: const Color.fromARGB(179, 0, 0, 0),
                  //       surfaceTintColor: context.theme.colorScheme.surface,
                  //       color: context.theme.colorScheme.surface,
                  //       margin: const EdgeInsets.symmetric(
                  //         horizontal: 12,
                  //         vertical: 8,
                  //       ),
                  //       child: ListTile(
                  //         leading: CircleAvatar(
                  //           backgroundImage: NetworkImage(page.attachmentUrl),
                  //           radius: 20,
                  //           backgroundColor: Colors.transparent,
                  //         ),
                  //         title: Text(
                  //           page.name,
                  //           style: TextStyle(
                  //             color: context.theme.colorScheme.onSurface,
                  //           ),
                  //         ),
                  //         subtitle: Text(
                  //           page.designation ?? 'No description',
                  //           style: TextStyle(
                  //             color: context.theme.colorScheme.onSurface,
                  //           ),
                  //         ),
                  //         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  //         onTap: () {
                  //           Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //               builder:
                  //                   (context) =>
                  //                       DevelopmentCreditDetails(credit: page),
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //     );
                  //   },
                  // );
                } else if (state is DevelopmentCreditError) {
                  return Center(child: Text('Error: ${state.error}'));
                }

                return const SizedBox.shrink(); // For initial/unknown state
              },
            ),
          ),
        ),
      ),
    );
  }
}
