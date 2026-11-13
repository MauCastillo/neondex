import 'package:material_ui/material_ui.dart';

import '../theme/cyber_colors.dart';
import '../theme/cyber_text_styles.dart';

class CyberLoadingIndicator extends StatelessWidget {
  const CyberLoadingIndicator({
    super.key,
    this.label = 'SCANNING NEURAL NET...',
    this.color = CyberColors.neonCyan,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: CircularProgressIndicator(
                strokeWidth: 2.8,
                color: color,
                backgroundColor: color.withValues(alpha: 0.14),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              textAlign: TextAlign.center,
              style: CyberTextStyles.monoTag.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
