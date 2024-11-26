// terms_of_service_page.dart

import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''
**Terms of Service**

_Last updated: November 11, 2024_

**Acceptance of Terms**

By accessing and using the MAGI Ministries application ("Service"), you agree to be bound by these Terms of Service ("Terms"). If you do not agree with any part of these Terms, you must not access the Service.

**Use of the Service**

1. **Eligibility**

   You must be at least 13 years old to use the Service. By using the Service, you represent and warrant that you meet this requirement.

2. **User Accounts**

   - **Registration:** You may be required to create an account to access certain features.
   - **Account Responsibility:** You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.

3. **Prohibited Activities**

   You agree not to engage in any of the following prohibited activities:

   - Using the Service for any unlawful purpose.
   - Impersonating any person or entity.
   - Interfering with or disrupting the integrity or performance of the Service.
   - Attempting to gain unauthorized access to any portion of the Service.

**Intellectual Property Rights**

All content, features, and functionality on the Service are the exclusive property of MAGI Ministries and are protected by copyright, trademark, and other intellectual property laws.

**Termination**

We reserve the right to suspend or terminate your access to the Service at any time, without notice or liability, for any reason, including if you breach these Terms.

**Disclaimer of Warranties**

The Service is provided on an "AS IS" and "AS AVAILABLE" basis. MAGI Ministries makes no warranties, either express or implied, regarding the Service.

**Limitation of Liability**

In no event shall MAGI Ministries be liable for any indirect, incidental, special, consequential, or punitive damages arising out of or related to your use of the Service.

**Indemnification**

You agree to indemnify and hold harmless MAGI Ministries and its affiliates from any claims, losses, liabilities, damages, expenses, or costs arising from your use of the Service or violation of these Terms.

**Governing Law**

These Terms shall be governed by and construed in accordance with the laws of the State of [Your State], without regard to its conflict of law provisions.

**Changes to Terms**

We reserve the right to modify these Terms at any time. Any changes will be effective immediately upon posting. Your continued use of the Service after changes are posted constitutes your acceptance of the new Terms.

**Contact Us**

If you have any questions about these Terms, please contact us at:

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
