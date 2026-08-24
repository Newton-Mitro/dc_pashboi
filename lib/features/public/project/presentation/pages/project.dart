import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/utils/text_util.dart';
import 'package:pashboi/features/public/project/domain/entites/project_entity.dart';
import 'package:pashboi/features/public/project/presentation/bloc/project_bloc.dart';
import 'package:pashboi/routes/public_routes_name.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/shared/widgets/public_app_image_card.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Locales.string(context, "side_menu_title_for_project")),
        backgroundColor: context.theme.colorScheme.primary,
        foregroundColor: context.theme.colorScheme.onPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => sl<ProjectBloc>()..add(FetchProjectEvent()),
          child: PageContainer(
            child: BlocBuilder<ProjectBloc, ProjectState>(
              builder: (context, state) {
                if (state is ProjectLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProjectError) {
                  return Center(child: Text('Error: ${state.error}'));
                } else if (state is ProjectSuccess) {
                  final List<ProjectEntity> projects = state.projects;

                  if (projects.isEmpty) {
                    return const Center(child: Text('No projects available.'));
                  }

                  return ListView.builder(
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final product = projects[index];
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
                              PublicRoutesName.projectDetailsPage,
                              arguments: {"projects": product},
                            );
                          },
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
