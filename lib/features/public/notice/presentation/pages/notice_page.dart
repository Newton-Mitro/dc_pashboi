import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/injection.dart';
import 'package:pashboi/features/public/notice/domain/enities/notice_entity.dart';
import 'package:pashboi/features/public/notice/presentation/bloc/notice_bloc.dart';
import 'package:pashboi/routes/public_routes_name.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/shared/widgets/public_app_icon_card.dart';

class NoticesPage extends StatelessWidget {
  const NoticesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NoticeBloc>()..add(FetchNoticeEvent()),
      child: PageContainer(
        child: BlocBuilder<NoticeBloc, NoticeState>(
          builder: (context, state) {
            if (state is NoticeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NoticeError) {
              return Center(child: Text('Error: ${state.error}'));
            } else if (state is NoticeSuccess) {
              final List<NoticeEntity> notices = state.notices;

              if (notices.isEmpty) {
                return const Center(child: Text('No notices available.'));
              }

              return ListView.builder(
                itemCount: notices.length,
                itemBuilder: (context, index) {
                  final product = notices[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 10,
                    ), // Adjust spacing here
                    child: PublicAppIconCard(
                      leftIcon: FontAwesomeIcons.bullhorn,
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
                            Html(data: product.shortDescription),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          PublicRoutesName.noticesDetailsPage,
                          arguments: {"notice": product},
                        );
                      },
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink(); // fallback
          },
        ),
      ),
    );
  }
}
