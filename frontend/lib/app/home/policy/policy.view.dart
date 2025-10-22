import 'package:flutter/material.dart';
import 'package:frontend/app/home/policy/policy.controller.dart';
import 'package:frontend/widgets/app_bar/app_bar.dart';
import 'package:frontend/widgets/page_card.dart';
import 'package:frontend/widgets/page_scaffold.dart';
import 'package:get/get.dart';

class PolicyPageView extends GetView {
  const PolicyPageView({super.key});

  @override
  Widget build(BuildContext context) {
    const policyText = '''
Your privacy is important to us. This policy outlines the collection, processing, and protection of personal data by our poker application (the "App"). By using the App, you (the "User") agree to the terms of this policy.

Scope of Collected Data:

Registration data: username, email address, password, registration date.

Purpose of Data Collection and Usage:

Verification of identity and user authentication.

Provision of services related to App functionality, including account management, poker gameplay, and technical support.

Data analysis and statistics to improve functionality, quality, and security of provided services.

Direct marketing and promotional activities (if consent is provided by the User).

Sharing Personal Data:

User personal data will not be sold or shared with third parties for commercial purposes.

The App reserves the right to share data with trusted technical and operational service providers, such as hosting services, payment processing, and analytical tools, who process data solely upon instruction from and under supervision of the Administrator.

Data Security:

The App employs appropriate technical and organizational measures to prevent unauthorized access, loss, destruction, or unauthorized processing of personal data.

Despite security measures, the App is not responsible for security breaches arising from external factors such as hacking attacks or errors resulting from User actions.

User Rights:

Users have the right to access, correct, update, limit processing, or delete their personal data.

Users also have the right to withdraw consent to data processing at any time by contacting privacy@pokerapp.com

Users have the right to lodge a complaint with the relevant data protection supervisory authority.

Data Retention Period:

Personal data will be stored for as long as necessary to fulfill the purposes for which it was collected unless a longer retention period is required by law.

Cookies:

The App may use cookies and similar technologies to enhance service quality and personalize content.

Users can manage cookie settings via their browser or mobile device settings.

Changes to Privacy Policy:

The Administrator reserves the right to modify this privacy policy at any time.

Users will be notified of significant changes via the App or email.

Continued use of the App following policy changes constitutes acceptance of the updated privacy policy.
''';
    return ThemedScaffold(
      appBar: const ThemedAppBar(title: 'Privacy Policy'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: PageCard(
          title: 'Privacy Policy',
          child: const Text(policyText),
        ),
      ),
    );
  }
}
