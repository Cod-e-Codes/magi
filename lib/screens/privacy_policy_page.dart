// privacy_policy_page.dart

import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''
**Privacy Policy**

_Last updated: November 11, 2024_

**Introduction**

MAGI Ministries ("we", "us", or "our") is committed to protecting your personal information and respecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our application.

**Information We Collect**

1. **Personal Data**

   We may collect personally identifiable information, such as your name, email address, phone number, and other details that you voluntarily provide when you register or participate in various activities within the app.

2. **Usage Data**

   We may collect information about your interactions with the app, including the pages you visit, the features you use, and the time and date of your visits.

3. **Device Information**

   Information about your device may be collected automatically, including IP address, operating system, browser type, and device identifiers.

**How We Use Your Information**

We may use the information we collect for various purposes, including:

- To provide, operate, and maintain our services.
- To improve, personalize, and expand our services.
- To communicate with you, including customer service and support.
- To send you notifications, updates, and promotional materials.
- To monitor and analyze usage and trends to improve user experience.
- To detect and prevent fraudulent activities.

**Disclosure of Your Information**

We may share your information in the following situations:

- **With Service Providers:** We may share your information with third-party vendors, contractors, or agents who perform services on our behalf.
- **Legal Obligations:** We may disclose your information if required by law or in response to valid requests by public authorities.
- **Business Transfers:** In the event of a merger, sale, or transfer of assets, your information may be transferred to the acquiring entity.

**Security of Your Information**

We implement commercially reasonable security measures to protect your personal information. However, no method of transmission over the Internet or electronic storage is completely secure, and we cannot guarantee absolute security.

**Your Choices and Rights**

- **Access and Update:** You may access, update, or delete your personal information by contacting us.
- **Opt-Out:** You may opt out of receiving promotional communications from us by following the unsubscribe instructions provided in those communications.
- **Data Retention:** We will retain your information for as long as your account is active or as needed to provide you services.

**Children's Privacy**

Our services are not intended for individuals under the age of 13. We do not knowingly collect personal information from children under 13 years of age. If we become aware that we have collected personal data from a child under 13, we will take steps to remove that information.

**Third-Party Links**

Our application may contain links to third-party websites or services that are not owned or controlled by us. We are not responsible for the content or privacy practices of such third parties.

**Changes to This Privacy Policy**

We may update our Privacy Policy from time to time. We will notify you of any changes by updating the "Last updated" date at the top of this policy. We encourage you to review this Privacy Policy periodically.

**Contact Us**

If you have any questions or concerns about this Privacy Policy, please contact us at:

- **Email:** support@magiministries.org
- **Address:** 1234 Church Street, Anytown, State, ZIP Code

''',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
