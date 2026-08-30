import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  final Color themeColor;

  const TermsAndConditionsScreen({
    super.key,
    required this.themeColor,
  });

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: widget.themeColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Terms & Conditions',
          style: TextStyle(color: widget.themeColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TERMS AND CONDITIONS & PRIVACY POLICY',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: widget.themeColor,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Postpartum Care Application',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Last Updated: March 16, 2026',
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
            Text(
              'Version: 1.0',
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
            const SizedBox(height: 25),
            _buildSection(
              '1. ACCEPTANCE OF TERMS',
              [
                'By downloading, installing, or using this postpartum care mobile application ("the App"), you agree to be bound by these Terms and Conditions and Privacy Policy. If you do not agree to these terms, please do not use the App.',
                'This App is intended for individuals who are 18 years of age or older. By using this App, you represent that you are at least 18 years old.',
              ],
            ),
            _buildSection(
              '2. HIPAA COMPLIANCE & DATA PRIVACY',
              [
                '2.1 Protected Health Information (PHI)',
                'We are committed to protecting your health information in compliance with the Health Insurance Portability and Accountability Act (HIPAA) and applicable privacy regulations.',
                '',
                'What We Collect:',
              ],
              bullets: [
                'Your name',
                'Baby\'s gender and birth/due date',
                'Baby care tracking data (feeding times, sleep patterns, diaper changes)',
                'Your self-care and mood tracking information',
                'Preferences and settings',
              ],
              additionalText: [
                'How We Store Your Data:',
              ],
              additionalBullets: [
                'All data is stored locally on your device using encrypted storage',
                'We do NOT transmit your data to external servers',
                'We do NOT share, sell, or distribute your information to third parties',
                'Your data remains entirely under your control',
              ],
            ),
            _buildSection(
              '2.2 Data Security',
              [
                'We implement industry-standard security measures including:',
              ],
              bullets: [
                'Encryption of data at rest on your device',
                'Secure local storage practices',
                'No cloud backup unless you explicitly enable device backup through your phone\'s settings',
              ],
              additionalText: [
                'Important: While we take reasonable measures to protect your data, no electronic storage method is 100% secure. You are responsible for:',
              ],
              additionalBullets: [
                'Keeping your device secure with a passcode/biometric lock',
                'Not sharing your device with unauthorized individuals',
                'Protecting your device from loss or theft',
              ],
            ),
            _buildSection(
              '3. MEDICAL DISCLAIMER',
              [
                'THIS APP IS NOT A MEDICAL DEVICE AND DOES NOT PROVIDE MEDICAL ADVICE.',
                '',
                '3.1 Informational Purposes Only',
                'This application is designed for:',
              ],
              bullets: [
                'Personal tracking and recordkeeping',
                'Self-care reminders and wellness tips',
                'Organizational support during the postpartum period',
              ],
              additionalText: [
                '3.2 Not a Substitute for Medical Care',
                'The App is NOT intended to:',
              ],
              additionalBullets: [
                'Diagnose any medical condition',
                'Provide medical treatment or advice',
                'Replace consultations with healthcare providers',
                'Monitor medical emergencies',
              ],
            ),
            _buildSection(
              '3.3 When to Seek Medical Help',
              [
                'Always consult your healthcare provider if you experience:',
              ],
              bullets: [
                'Severe postpartum depression or anxiety',
                'Thoughts of harming yourself or your baby',
                'Excessive bleeding or signs of infection',
                'Severe pain or complications',
                'Any concerns about your baby\'s health or development',
                'Fever above 100.4°F (38°C)',
                'Signs of postpartum preeclampsia (severe headaches, vision changes, upper abdominal pain)',
              ],
              additionalText: [
                'IN CASE OF EMERGENCY, CALL 911 OR GO TO YOUR NEAREST EMERGENCY ROOM IMMEDIATELY.',
                '',
                '3.4 No Doctor-Patient Relationship',
                'Use of this App does not create a doctor-patient relationship. The App does not provide personalized medical recommendations. All health decisions should be made in consultation with qualified healthcare professionals.',
              ],
            ),
            _buildSection(
              '4. YOUR DATA RIGHTS',
              [
                '4.1 Access and Control',
                'You have the right to:',
              ],
              bullets: [
                'Access all data stored in the App at any time',
                'Modify or correct any information',
                'Delete specific entries or all data',
                'Export your data (if feature is available)',
              ],
              additionalText: [
                '4.2 Data Deletion',
                'You may delete your data at any time through:',
              ],
              additionalBullets: [
                'Individual entry deletion within the App',
                'Complete data reset in Settings',
                'Uninstalling the App (removes all local data)',
                '',
                'Note: Once deleted, data cannot be recovered. Please export important information before deletion.',
                '',
                '4.3 Data Retention',
                'Data is retained on your device only for as long as:',
              ],
            ),
            _buildSection(
              '',
              [],
              bullets: [
                'You continue using the App',
                'You do not manually delete the data',
                'The App remains installed on your device',
              ],
            ),
            _buildSection(
              '5. NOTIFICATIONS & REMINDERS',
              [
                '5.1 Push Notifications',
                'The App may send you:',
              ],
              bullets: [
                'Self-care reminders (hydration, nutrition, rest)',
                'Baby care tracking prompts',
                'Wellness tips and affirmations',
              ],
              additionalText: [
                '5.2 Notification Control',
                'All notifications are:',
              ],
              additionalBullets: [
                'Generated locally on your device',
                'Optional and can be disabled',
                'Managed through App Settings or your device\'s system settings',
                '',
                'We do NOT send marketing messages or third-party advertisements.',
              ],
            ),
            _buildSection(
              '6. CHILDREN\'S PRIVACY (COPPA COMPLIANCE)',
              [
                '6.1 Age Restriction',
                'This App is intended for use by adults (18 years or older). We do not knowingly collect personal information from children under 13 years of age.',
                '',
                '6.2 Baby Tracking Data',
                'The baby tracking features are designed for parents/guardians to record care information about their infants. This data:',
              ],
              bullets: [
                'Is entered by the parent/guardian (not the child)',
                'Is stored locally on the parent/guardian\'s device',
                'Remains under the parent/guardian\'s control',
              ],
            ),
            _buildSection(
              '7. LIMITATION OF LIABILITY',
              [
                '7.1 "As Is" Provision',
                'The App is provided "AS IS" and "AS AVAILABLE" without warranties of any kind, either express or implied, including but not limited to:',
              ],
              bullets: [
                'Accuracy, reliability, or completeness of information',
                'Uninterrupted or error-free operation',
                'Fitness for a particular purpose',
              ],
              additionalText: [
                '7.2 No Liability for Health Outcomes',
                'TO THE FULLEST EXTENT PERMITTED BY LAW, WE SHALL NOT BE LIABLE FOR:',
              ],
              additionalBullets: [
                'Any health-related decisions made based on App data',
                'Missed or delayed healthcare appointments',
                'Errors or inaccuracies in self-tracked data',
                'Technical malfunctions or data loss',
                'Any direct, indirect, incidental, special, consequential, or punitive damages',
              ],
            ),
            _buildSection(
              '7.3 User Responsibility',
              [
                'You acknowledge and agree that:',
              ],
              bullets: [
                'You are solely responsible for decisions regarding your health and your baby\'s health',
                'You will consult qualified healthcare professionals for medical advice',
                'You will verify all tracking data for accuracy',
                'You will maintain regular prenatal and postpartum medical care',
              ],
            ),
            _buildSection(
              '8. INTELLECTUAL PROPERTY',
              [
                '8.1 Ownership',
                'All content, features, and functionality of the App, including but not limited to software code and design, text, graphics, logos, and icons are owned by [Your Company Name] and are protected by copyright, trademark, and other intellectual property laws.',
                '',
                '8.2 Limited License',
                'We grant you a limited, non-exclusive, non-transferable license to use the App for personal, non-commercial purposes. You may not:',
              ],
              bullets: [
                'Copy, modify, or distribute the App',
                'Reverse engineer or decompile the software',
                'Remove any copyright or proprietary notices',
                'Use the App for commercial purposes',
              ],
            ),
            _buildSection(
              '9. UPDATES AND MODIFICATIONS',
              [
                '9.1 App Updates',
                'We may release updates to:',
              ],
              bullets: [
                'Add new features',
                'Fix bugs or improve performance',
                'Enhance security',
                'Update medical disclaimers or terms',
              ],
              additionalText: [
                'Updates may be automatic depending on your device settings.',
                '',
                '9.2 Terms Updates',
                'We reserve the right to modify these Terms and Conditions at any time. Changes will be communicated through:',
              ],
              additionalBullets: [
                'In-app notifications',
                'Updated "Last Modified" date at the top of this document',
                'Email (if you have provided contact information)',
                '',
                'Your continued use of the App after changes constitutes acceptance of the updated terms.',
                '',
                '9.3 Right to Refuse Updates',
                'If you do not agree to updated terms, you may:',
              ],
            ),
            _buildSection(
              '',
              [],
              bullets: [
                'Discontinue use of the App',
                'Delete the App from your device',
              ],
            ),
            _buildSection(
              '10. THIRD-PARTY SERVICES',
              [
                '10.1 No Third-Party Integrations',
                'This App currently does NOT:',
              ],
              bullets: [
                'Share data with third-party services',
                'Use analytics or tracking tools',
                'Include advertisements or third-party content',
                'Connect to external databases or cloud services',
              ],
              additionalText: [
                '10.2 Future Integrations',
                'If we add third-party services in the future, we will:',
              ],
              additionalBullets: [
                'Update these Terms to reflect changes',
                'Obtain your explicit consent',
                'Provide clear opt-in/opt-out options',
              ],
            ),
            _buildSection(
              '11. TERMINATION',
              [
                '11.1 Your Right to Terminate',
                'You may stop using the App at any time by:',
              ],
              bullets: [
                'Uninstalling the App from your device',
                'Deleting all data through Settings',
              ],
              additionalText: [
                '11.2 Our Right to Terminate',
                'We reserve the right to:',
              ],
              additionalBullets: [
                'Discontinue the App at any time',
                'Modify or remove features',
                'Cease support or updates',
                'with or without notice',
              ],
            ),
            _buildSection(
              '12. GOVERNING LAW',
              [
                'These Terms shall be governed by and construed in accordance with the laws of [Your State/Country], without regard to its conflict of law provisions. Any disputes arising from these Terms or use of the App shall be resolved in the courts of [Your Jurisdiction].',
              ],
            ),
            _buildSection(
              '13. SEVERABILITY',
              [
                'If any provision of these Terms is found to be unenforceable or invalid, that provision shall be limited or eliminated to the minimum extent necessary, and the remaining provisions shall remain in full force and effect.',
              ],
            ),
            _buildSection(
              '14. ENTIRE AGREEMENT',
              [
                'These Terms and Conditions, together with the Privacy Policy, constitute the entire agreement between you and [Your Company Name] regarding use of the App.',
              ],
            ),
            _buildSection(
              '15. CONTACT INFORMATION',
              [
                'For questions, concerns, or requests regarding these Terms and Conditions, privacy practices, HIPAA compliance, data access or deletion, or general support, please contact [Your Company Name] through your designated support channels.',
              ],
            ),
            _buildSection(
              '16. ACKNOWLEDGMENT',
              [
                'By clicking "I Agree" or by using the App, you acknowledge that:',
              ],
              bullets: [
                'You have read and understood these Terms and Conditions',
                'You agree to be bound by these Terms',
                'You understand this App is not a medical device or substitute for medical care',
                'You are at least 18 years of age',
                'You will consult healthcare professionals for medical advice',
                'You accept responsibility for your use of the App',
              ],
            ),
            const SizedBox(height: 10),
            _buildMentalHealthNotice(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    String title,
    List<String> paragraphs, {
    List<String> bullets = const [],
    List<String> additionalText = const [],
    List<String> additionalBullets = const [],
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (title.isNotEmpty) const SizedBox(height: 10),
          ...paragraphs.map((p) {
            if (p.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                p,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            );
          }),
          ...bullets.map((bullet) {
            if (bullet.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 6, left: 10),
              child: Text(
                '• $bullet',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            );
          }),
          ...additionalText.map((text) {
            if (text.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
            );
          }),
          ...additionalBullets.map((bullet) {
            if (bullet.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 6, left: 10),
              child: Text(
                '• $bullet',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMentalHealthNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3B0B0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SPECIAL POSTPARTUM MENTAL HEALTH NOTICE',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: widget.themeColor.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'If you are experiencing postpartum depression, anxiety, or thoughts of harming yourself or your baby, please seek help immediately:',
            style: TextStyle(fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 12),
          _buildHotlineItem(
            'National Maternal Mental Health Hotline',
            '1-833-943-5746 (available 24/7)',
          ),
          _buildHotlineItem(
            'National Suicide Prevention Lifeline',
            '988 or 1-800-273-8255',
          ),
          _buildHotlineItem('Crisis Text Line', 'Text HOME to 741741'),
          _buildHotlineItem(
            'Postpartum Support International',
            '1-800-944-4773',
          ),
          const SizedBox(height: 12),
          const Text(
            'You are not alone. Help is available.',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotlineItem(String name, String number) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            number,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
