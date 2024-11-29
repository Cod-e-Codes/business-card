import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:diagonal_decoration/diagonal_decoration.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context)
              .textTheme
              .apply(bodyColor: Colors.black, displayColor: Colors.black),
        ).copyWith(
          displayLarge: GoogleFonts.montserrat(
            textStyle: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          // Define other text styles as needed
        ),
      ),
      home: const BusinessCard(),
    );
  }
}

class BusinessCard extends StatelessWidget {
  const BusinessCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CodēCodes Business Card'),
      ),
      body: Center(
        child: GestureFlipCard(
          animationDuration: const Duration(milliseconds: 300),
          axis: FlipAxis.horizontal,
          frontWidget: _buildFrontCard(context),
          backWidget: _buildBackCard(context),
        ),
      ),
    );
  }

  Widget _buildFrontCard(BuildContext context) {
    return _CardFront();
  }

  Widget _buildBackCard(BuildContext context) {
    return _CardBack(context);
  }
}

class _CardFront extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: 300,
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: const MatrixDecoration(
          backgroundColor: Colors.white,
          radius: Radius.circular(20),
          lineWidth: 2,
          lineCount: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.code,
                  size: 50,
                  color: Colors.blue,
                ),
                const SizedBox(width: 10),
                const SizedBox(
                  height: 40,
                  child: VerticalDivider(
                    color: Colors.blue,
                    thickness: 3,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'CodēCodes',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '"Where Code Meets Creativity"',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                  ),
            ),
            const SizedBox(height: 16),
            _SkillTags(),
          ],
        ),
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  final BuildContext context;

  const _CardBack(this.context);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          width: 300,
          height: 200,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cody Marsengill',
                    style: GoogleFonts.montserrat(
                      textStyle:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Share my business card',
                    icon: const Icon(Icons.share, size: 30),
                    color: Colors.white70,
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Share.share(
                        'CodēCodes\n\n'
                        'Name: Cody Marsengill\n'
                        'Title: Software Developer\n'
                        'Email: cod.e.codes.dev@gmail.com\n'
                        'Phone: (864) 275-0396\n'
                        'LinkedIn: https://www.linkedin.com/in/cod-e-codes/\n'
                        'GitHub: https://github.com/cod-e-codes\n'
                        'Website: https://www.cod-e-codes.com',
                        subject: 'CodēCodes',
                      );
                    },
                  ),
                ],
              ),
              Text(
                'Software Developer',
                style: GoogleFonts.roboto(
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                      ),
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 48),
              _ContactIcons(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillTags extends StatefulWidget {
  @override
  _SkillTagsState createState() => _SkillTagsState();
}

class _SkillTagsState extends State<_SkillTags> {
  late final ScrollController _scrollController;
  late final Timer _scrollTimer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          (_scrollController.offset + 1) %
              (_scrollController.position.maxScrollExtent + 1),
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollTimer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40, // Adjust height as needed
      child: ListView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        children: const [
          _SkillTag(text: 'Web Dev'),
          _SkillTag(text: 'Mobile Apps'),
          _SkillTag(text: 'Flutter'),
          _SkillTag(text: 'Dart'),
          _SkillTag(text: 'Python'),
          _SkillTag(text: 'Java'),
          _SkillTag(text: 'JavaScript'),
          _SkillTag(text: 'React'),
          _SkillTag(text: 'Node.js'),
          _SkillTag(text: 'Full Stack'),
          // Add more skills here
        ],
      ),
    );
  }
}

class _SkillTag extends StatelessWidget {
  final String text;

  const _SkillTag({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: GoogleFonts.roboto(
            textStyle: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
          const SizedBox(
            height: 20,
            child: VerticalDivider(
              color: Colors.grey,
              thickness: 2,
            ),
          ),
        ],
    );
  }
}

class _ContactIcons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ContactIcon(
          icon: FaIcon(FontAwesomeIcons.envelope, size: 30),
          tooltip: 'Send me an email',
          url: 'mailto:cod.e.codes.dev@gmail.com',
        ),
        _ContactIcon(
          icon: FaIcon(FontAwesomeIcons.phone, size: 30),
          tooltip: 'Give me a call',
          url: 'tel:+18642750396',
        ),
        _ContactIcon(
          icon: FaIcon(FontAwesomeIcons.linkedin, size: 30),
          tooltip: 'Visit my LinkedIn',
          url: 'https://www.linkedin.com/in/cod-e-codes/',
        ),
        _ContactIcon(
          icon: FaIcon(FontAwesomeIcons.github, size: 30),
          tooltip: 'Visit my GitHub',
          url: 'https://github.com/cod-e-codes',
        ),
        _QrCode(
          url: 'https://www.cod-e-codes.com',
        ),
      ],
    );
  }
}

class _ContactIcon extends StatelessWidget {
  final FaIcon icon;
  final String tooltip;
  final String url;

  const _ContactIcon({
    required this.icon,
    required this.tooltip,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      icon: icon,
      color: Colors.white70,
      onPressed: () {
        HapticFeedback.lightImpact();
        _launchURL(context, Uri.parse(url));
      },
    );
  }
}

class _QrCode extends StatelessWidget {
  final String url;

  const _QrCode({required this.url});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        _launchURL(context, Uri.parse(url));
      },
      child: Tooltip(
        message: 'Visit my website',
        child: QrImageView(
          eyeStyle: const QrEyeStyle(color: Colors.white70),
          dataModuleStyle: const QrDataModuleStyle(color: Colors.white70),
          data: url,
          version: QrVersions.auto,
          size: 60.0,
        ),
      ),
    );
  }
}

Future<void> _launchURL(BuildContext context, Uri url) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  try {
    if (!await launchUrl(url)) {
      if (scaffoldMessenger.mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: const Text('Could not launch URL',
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.blueAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(16),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  } catch (e) {
    if (scaffoldMessenger.mounted) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.blueAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
