import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/features/public/notice/domain/enities/notice_entity.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class NoticeDetailsPage extends StatelessWidget {
  final NoticeEntity notice;

  const NoticeDetailsPage({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    final String imageUrl = notice.attachmentUrl; // Optional field
    final bool showIcon = imageUrl.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Locales.string(context, "public_bottom_nav_menu_notice_details"),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: PageContainer(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                showIcon
                    ? Container(
                      alignment: Alignment.center,
                      height: 150,
                      width: double.infinity,
                      child: const FaIcon(
                        FontAwesomeIcons.bullhorn,
                        size: 100,
                        color: Colors.grey,
                      ),
                    )
                    : Container(
                      height: 500,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                const SizedBox(height: 16),
                Text(notice.title),
                const SizedBox(height: 16),
                Html(data: notice.description),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
