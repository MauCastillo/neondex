import 'package:material_ui/material_ui.dart';

import '../theme/cyber_colors.dart';
import '../theme/cyber_text_styles.dart';
import 'cyber_hud_card.dart';

class CyberErrorPanel extends StatelessWidget {
  const CyberErrorPanel({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel = 'RECONNECT',
    this.title = 'SIGNAL INTERRUPTED',
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: CyberHudCard(
          accentColor: CyberColors.alertRed,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: CyberColors.alertRed,
                size: 40,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: CyberTextStyles.hudHeadline.copyWith(
                  color: CyberColors.alertRed,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: CyberTextStyles.bodyMedium,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: Text(retryLabel),
                  style: FilledButton.styleFrom(
                    backgroundColor: CyberColors.alertRed,
                    foregroundColor: CyberColors.textPrimary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
