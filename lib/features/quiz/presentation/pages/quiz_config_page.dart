import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzical/routes/app_pages.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/utils/toast_util.dart';
import '../controllers/quiz_controller.dart';

class QuizConfigPage extends StatefulWidget {
  const QuizConfigPage({super.key});

  @override
  State<QuizConfigPage> createState() => _QuizConfigPageState();
}

class _QuizConfigPageState extends State<QuizConfigPage> {
  final QuizController _quizController = Get.find<QuizController>();

  // Local UI state
  int _numQuestions = 25;
  String _difficulty = 'any';
  String _type = 'any';

  late final int categoryId;
  late final String categoryName;

  // Track whether we've shown the loading dialog so we only try to dismiss it when appropriate
  bool _loadingDialogShown = false;
  // Store the BuildContext of the modal's builder so we can safely dismiss it
  BuildContext? _loadingDialogContext;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    categoryId = (args is Map && args['categoryId'] != null) ? (args['categoryId'] as int) : 0;
    categoryName = (args is Map && args['categoryName'] != null) ? (args['categoryName'] as String) : 'Category';
  }

  Future<void> _onStartPressed() async {
    try {
      // show loading dialog while fetching (use native showDialog so dismissal is tied to Navigator)
      if (mounted) {
        _loadingDialogShown = true;
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) {
            // capture the dialog's context so we can pop it reliably later
            _loadingDialogContext = ctx;
            return const Center(child: CircularProgressIndicator());
          },
        );
      }

      await _quizController.loadQuiz(
        amount: _numQuestions,
        categoryId: categoryId,
        difficulty: _difficulty,
        type: _type,
      );

      // remove loading
      if (_loadingDialogShown) {
        try {
          if (_loadingDialogContext != null) {
            Navigator.of(_loadingDialogContext!).pop();
          } else if (mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        } catch (_) {
          // ignore any error while dismissing dialog
        }
        _loadingDialogContext = null;
        _loadingDialogShown = false;
      }

      // navigate to play page
      Get.offNamed(AppPages.quizPlayPage);
    } catch (e) {
      // remove loading if still visible
      if (_loadingDialogShown) {
        try {
          if (_loadingDialogContext != null) {
            Navigator.of(_loadingDialogContext!).pop();
          } else if (mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        } catch (_) {
          // ignore
        }
        _loadingDialogShown = false;
      }

      // Normalize the error text for pattern matching
      final errText = e.toString().toLowerCase();

      String title = 'Error';
      String message = 'Failed to load questions. Please try again.';

      // Handle Trivia API response codes specifically (OpenTDB uses response_code)
      if (errText.contains('trivia api response_code')) {
        final m = RegExp(r'trivia api response_code[:\s]+(\d+)').firstMatch(errText);
        final code = m != null ? int.tryParse(m.group(1) ?? '') ?? -1 : -1;
        switch (code) {
          case 1:
            title = 'No Questions';
            message = 'The trivia service returned no results for your selection. Try adjusting the category, difficulty, or reduce the number of questions.';
            break;
          case 2:
            title = 'Invalid Request';
            message = 'One or more selected options are invalid. Please check your selections and try again.';
            break;
          case 3:
          case 4:
            title = 'Session Error';
            message = 'There was a session/token issue with the trivia service. Please try again later.';
            break;
          default:
            title = 'Trivia Service';
            message = 'Trivia service returned an error (code $code). Please try again.';
        }
      } else if (errText.contains('no questions returned') || errText.contains('empty response') || errText.contains('no question')) {
        title = 'No Questions';
        message = 'No questions are available for the selected category or filters. Try changing the number, difficulty, or question type.';
      } else if (errText.contains('formatexception') || errText.contains('unexpected payload') || errText.contains('unexpected results') || errText.contains('unsupported question')) {
        title = 'Data Error';
        message = 'Received unexpected data from the server. Please try again later.';
      } else {
        // For other errors show a concise message but include the error string so it's helpful
        message = 'Failed to load questions. ${e.toString()}';
      }

      // Use the centralized ToastUtil (CherryToast) to show messages consistently.
      // Use info toast for 'No Questions', otherwise show an error toast.
      if (mounted) {
        try {
          final isNoQuestions = title.toLowerCase().contains('no question');
          if (isNoQuestions) {
            ToastUtil.info(context, message, title: title);
          } else {
            ToastUtil.error(context, message, title: title);
          }
        } catch (_) {
          // fallback to native dialog if toast cannot be shown
          showDialog<void>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('OK'),
                )
              ],
            ),
          );
        }
      } else {
        // if we're not mounted, log the message so it's not lost
        if (kDebugMode) {
          print('UI not mounted to show error: $title - $message');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 18),

            // Top illustration
            SizedBox(
              height: 160,
              child: Center(
                child: Image.asset(
                  Assets.assetImages.splashLogo,
                  width: 140,
                  height: 140,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => Icon(Icons.settings_rounded, size: 96, color: Colors.grey[300]),
                ),
              ),
            ),

            const SizedBox(height: 6),

            // Title + subtitle
            Text(
              'Quizzical',
            ),
            const SizedBox(height: 6),
            Text(
              'Configuration',
            ),

            const SizedBox(height: 22),

            // Form area
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Number of Questions label
                    Text(
                      'Number of Questions',
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select 1–50',
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: const Color(0xFF1E9AE6),
                                  inactiveTrackColor: Colors.grey.shade300,
                                  trackHeight: 6,
                                  thumbColor: const Color(0xFF1E9AE6),
                                  overlayColor: Color.fromRGBO(30, 154, 230, 0.12),
                                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                                ),
                                child: Slider(
                                  min: 1,
                                  max: 50,
                                  divisions: 49,
                                  value: _numQuestions.toDouble(),
                                  onChanged: (v) => setState(() => _numQuestions = v.round()),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // numeric value on right
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            '$_numQuestions',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Difficulty Label
                    Text(
                      'Difficulty Level',
                    ),
                    const SizedBox(height: 8),

                    // Difficulty dropdown
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _difficulty,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: 'any', child: Text('Any Difficulty')),
                            DropdownMenuItem(value: 'easy', child: Text('Easy')),
                            DropdownMenuItem(value: 'medium', child: Text('Medium')),
                            DropdownMenuItem(value: 'hard', child: Text('Hard')),
                          ],
                          onChanged: (val) => setState(() {
                            _difficulty = val ?? 'any';
                          }),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Optional: Question Type (multiple / boolean) - kept compact and subtle
                    Text(
                      'Question Type',
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _type,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: 'any', child: Text('Any Type')),
                            DropdownMenuItem(value: 'multiple', child: Text('Multiple Choice')),
                            DropdownMenuItem(value: 'boolean', child: Text('True / False')),
                          ],
                          onChanged: (val) => setState(() => _type = val ?? 'any'),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),

            // START button anchored to bottom (outlined, rounded with filled text color)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
              child: SizedBox(
                width: double.infinity,
                height: 68,
                child: OutlinedButton(
                  onPressed: _onStartPressed,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0E5E59), width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    'START',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF0E5E59),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
