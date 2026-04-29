import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      header: (context) => pw.Container(
        alignment: pw.Alignment.centerRight,
        margin: const pw.EdgeInsets.only(bottom: 20),
        child: pw.Text(
          'LifeProgreX - Project Charter',
          style: pw.TextStyle(color: PdfColors.grey700, fontSize: 10),
        ),
      ),
      footer: (context) => pw.Container(
        alignment: pw.Alignment.centerRight,
        margin: const pw.EdgeInsets.only(top: 20),
        child: pw.Text(
          'Page ${context.pageNumber} of ${context.pagesCount}',
          style: pw.TextStyle(color: PdfColors.grey700, fontSize: 10),
        ),
      ),
      build: (context) => [
        // Header Pattern (Vertical Bar Style)
        pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 30),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 5,
                height: 90,
                color: PdfColors.black,
              ),
              pw.SizedBox(width: 20),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Capstone Project Charter',
                    style: pw.TextStyle(
                      fontSize: 36,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Project Name: LifeProgreX',
                    style: const pw.TextStyle(fontSize: 18, color: PdfColors.grey900),
                  ),
                  pw.Text(
                    'Capstone Clark University',
                    style: const pw.TextStyle(fontSize: 18, color: PdfColors.grey900),
                  ),
                ],
              ),
            ],
          ),
        ),
        pw.Divider(thickness: 2, color: PdfColors.black),
        pw.SizedBox(height: 20),

        _buildSectionTitle('1. Project Overview'),
        pw.Paragraph(
          text: 'LifeProgreX is an advanced personal growth platform that combines health data analytics with generative AI coaching. The project focuses on creating a holistic "Life Resume" for users to track their development over time.',
        ),

        _buildSectionTitle('2. Core Objectives'),
        _buildBulletPoint('Deliver a cross-platform mobile app using Flutter.'),
        _buildBulletPoint('Integrate real-time health data (Steps, Sleep, Workouts) via HealthKit.'),
        _buildBulletPoint('Implement "Max," an AI coach powered by Google Gemini.'),
        _buildBulletPoint('Establish a secure Firebase backend for user data and authentication.'),

        _buildSectionTitle('3. Project Deliverables'),
        _buildTable(
          ['Objective', 'Deliverable', 'Description'],
          [
            ['Habit Engine', 'Core Tracking Module', 'Handles daily logs and streaks.'],
            ['Health Sync', 'Integration Service', 'Maps Apple Health data to app metrics.'],
            ['AI Interface', 'Gemini AI Coach', 'Generative chat for personalized insights.'],
          ],
        ),

        _buildSectionTitle('4. Risk Management'),
        _buildTable(
          ['Risk', 'Prob.', 'Impact', 'Mitigation'],
          [
            ['API Limits', 'M', 'H', 'Implement data caching.'],
            ['Privacy', 'L', 'H', 'Firebase Security Rules.'],
            ['Sync Errors', 'M', 'M', 'Retry logic and local storage.'],
          ],
        ),

        _buildSectionTitle('5. Project Organization'),
        _buildTable(
          ['Role', 'Name', 'Responsibilities'],
          [
            ['PM / Architect', 'Satya Pranav Nagunoori', 'Overall system design.'],
            ['Frontend Lead', 'Naga Sai Donthi', 'UI/UX and Flutter development.'],
            ['QA / Integration', 'Bhanu Sai Priya Gomasani', 'Testing and HealthKit sync.'],
          ],
        ),

        _buildSectionTitle('6. Technical Features'),
        pw.Bullet(text: 'Flutter Framework (iOS & Android)'),
        pw.Bullet(text: 'Firebase Auth & Firestore'),
        pw.Bullet(text: 'Google Generative AI (Gemini SDK)'),
        pw.Bullet(text: 'HealthKit / Google Fit Integration'),

        pw.SizedBox(height: 40),
        pw.Center(
          child: pw.Text(
            'Proprietary & Confidential - LifeProgreX Team 2026',
            style: pw.TextStyle(fontSize: 10, color: PdfColors.grey500, fontStyle: pw.FontStyle.italic),
          ),
        ),
      ],
    ),
  );

  final file = File('Assets/Capstone Project charter.pdf');
  await file.writeAsBytes(await pdf.save());
  print('PDF updated successfully: ${file.path}');
}

pw.Widget _buildSectionTitle(String title) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(top: 25, bottom: 12),
    child: pw.Text(
      title,
      style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.black),
    ),
  );
}

pw.Widget _buildBulletPoint(String text) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 5),
    child: pw.Bullet(text: text, style: const pw.TextStyle(fontSize: 12)),
  );
}

pw.Widget _buildTable(List<String> headers, List<List<String>> data) {
  return pw.TableHelper.fromTextArray(
    headers: headers,
    data: data,
    border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey300),
    headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
    headerDecoration: const pw.BoxDecoration(color: PdfColors.black),
    cellHeight: 30,
    cellAlignment: pw.Alignment.centerLeft,
    cellStyle: const pw.TextStyle(fontSize: 11),
  );
}
