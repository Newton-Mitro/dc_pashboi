import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/injection.dart';
import 'package:pashboi/features/public/pages/domain/usecases/fetch_page_usecase.dart';
import 'package:pashboi/features/public/pages/presentation/bloc/page_bloc.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class PolicyPage extends StatefulWidget {
  const PolicyPage({super.key});

  @override
  State<PolicyPage> createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              sl<PageBloc>()
                ..add(FetchPageEvent(PageProps(pageSlug: 'privacy-policy'))),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Locales.string(context, "side_menu_title_for_privacy_policy"),
          ),
          backgroundColor: context.theme.colorScheme.primary,
          foregroundColor: context.theme.colorScheme.onPrimary,
          elevation: 0,
        ),
        body: SafeArea(
          child: PageContainer(
            child: BlocBuilder<PageBloc, PageState>(
              builder: (context, state) {
                if (state is PageLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is PageError) {
                  return Center(child: Text(state.error));
                }

                if (state is PageSuccess) {
                  final page = state.pageData;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Html(
                      data: page.longDescription,
                      style: {
                        "*": Style(
                          textAlign: TextAlign.justify,
                          fontSize: FontSize(16.0),
                          lineHeight: LineHeight.number(1.6),
                        ),
                      },
                    ),
                  );
                }

                return const SizedBox(); // fallback empty state
              },
            ),
          ),
        ),
      ),
    );
  }
}
