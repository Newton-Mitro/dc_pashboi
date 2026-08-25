import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_locales/flutter_locales.dart';

class ContactUsPage extends StatelessWidget {
  ContactUsPage({super.key});

  final List<Map<String, dynamic>> pages = [
    {
      'title': 'It Support',
      'description':
          'We can assist you 24/7 with any technical issues regarding Dhaka Credit ATM, MMS or Web Portal.',
      'icon': FontAwesomeIcons.headset,
      'buttons': [
        {
          'label': 'Tap to call',
          'icon': Icons.phone_in_talk,
          'actionUrl': '8809678156156',
        },
      ],
    },
    {
      'title': 'Ambulance Service',
      'description':
          'Ambulance service Divine Mercy Hospital provide the ambulance service with highly-skilled operational staff who will treat our patient with care.For further information, do contact with us. ',
      'icon': FontAwesomeIcons.truckMedical,
      'buttons': [
        {
          'label': 'Tap to call',
          'icon': Icons.phone_in_talk,
          'actionUrl': 'tel:8809678156156',
        },
      ],
    },

    {
      'title': 'Member Care',
      'description':
          'During office hours, we are available to assist you on any kind of member support on membership, account,loan,service,project etc  ',
      'icon': FontAwesomeIcons.hospitalUser,
      'buttons': [
        {
          'label': 'Tap to call',
          'icon': Icons.phone_in_talk,
          'actionUrl': 'tel:8809678156156',
        },
      ],
    },
    {
      'title': 'Divine Mercy Hospital Ltd.',
      'description':
          'Divine Mercy Hospital Ltd.(DMHL)DMHL provides health care service with a multi discipline facility where people can get standard and quality treatment ',
      'icon': FontAwesomeIcons.hospital,
      'buttons': [
        {
          'label': 'Tap to call',
          'icon': Icons.phone_in_talk,
          'actionUrl': 'tel:8809678156156',
        },
        {
          'label': 'Tap to browser',
          'icon': FontAwesomeIcons.globe,
          'actionUrl': 'https://divinemercyhospital.com/',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Locales.string(context, 'emergency_contact'))),
      body: SafeArea(
        child: Accordion(
          headerBorderWidth: 3,
          headerBorderColor: context.theme.colorScheme.primary,
          headerBorderColorOpened: context.theme.colorScheme.primary,
          headerBackgroundColorOpened: context.theme.colorScheme.primary,
          contentBackgroundColor: context.theme.colorScheme.surface,
          contentBorderColor: context.theme.colorScheme.primary,
          contentBorderWidth: 3,
          contentHorizontalPadding: 20,
          scaleWhenAnimating: true,
          openAndCloseAnimation: true,
          headerPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          children:
              pages.map((page) {
                return AccordionSection(
                  isOpen: false,
                  headerBackgroundColor: context.theme.colorScheme.primary,
                  headerBackgroundColorOpened:
                      context.theme.colorScheme.primary,
                  headerBorderColor: context.theme.colorScheme.primary,
                  contentBorderColor: context.theme.colorScheme.primary,
                  contentVerticalPadding: 20,
                  paddingBetweenClosedSections: 20,
                  leftIcon: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      page['icon'] as IconData,
                      color: Colors.white, // Or use a theme color if needed
                      size: 24,
                    ),
                  ),
                  header: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        page['title'] ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        page['description'] ?? '',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children:
                              (page['buttons'] as List<Map<String, dynamic>>)
                                  .map<Widget>((button) {
                                    return ElevatedButton.icon(
                                      onPressed: () {
                                        final url = button['actionUrl'] ?? '';
                                        if (url.startsWith('mailto:') ||
                                            url.startsWith('tel:') ||
                                            url.startsWith('https:')) {
                                          launchUrl(Uri.parse(url));
                                        }
                                      },
                                      icon: Icon(button['icon'], size: 18),
                                      label: Text(button['label']),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            context.theme.colorScheme.primary,
                                        foregroundColor:
                                            context.theme.colorScheme.onPrimary,
                                      ),
                                    );
                                  })
                                  .toList(),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
