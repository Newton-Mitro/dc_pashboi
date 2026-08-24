import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/features/public/development_credits/domain/entites/development_credits_entity.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class DevelopmentCreditDetails extends StatelessWidget {
  final DevelopmentCreditsEntity credit;

  const DevelopmentCreditDetails({super.key, required this.credit});

  @override
  Widget build(BuildContext context) {
    final String imageUrl = credit.attachmentUrl;
    final bool showIcon = imageUrl.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Locales.string(
            context,
            "side_menu_title_for_development_credits_details",
          ),
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
                        FontAwesomeIcons.handshake,
                        size: 100,
                        color: Colors.grey,
                      ),
                    )
                    : Container(
                      height: 400,
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
                Center(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          credit.name,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(credit.designation),
                        const SizedBox(height: 8),
                        Text(credit.email),
                        const SizedBox(height: 8),
                        Text(credit.mobileNumber),
                        const SizedBox(height: 24),

                        // 3 Rounded Icon Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                final url = credit.facebookUrl;
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(
                                    Uri.parse(url),
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(16),
                              ),
                              child: const Icon(FontAwesomeIcons.facebook),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final url = credit.linkedinUrl;
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(
                                    Uri.parse(url),
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(16),
                              ),
                              child: const Icon(FontAwesomeIcons.linkedinIn),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final url = credit.githubUrl;
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(
                                    Uri.parse(url),
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(16),
                              ),
                              child: const Icon(FontAwesomeIcons.github),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        Html(
                          data: credit.bio,
                          style: {"*": Style(textAlign: TextAlign.justify)},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
