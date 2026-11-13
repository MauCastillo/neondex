import 'package:material_ui/material_ui.dart';

import '../theme/cyber_colors.dart';
import '../theme/cyber_text_styles.dart';

class CyberSectionHeader extends StatelessWidget {
  const CyberSectionHeader({
    super.key,
    required this.title,
    this.codeTag,
    this.accentColor = CyberColors.neonCyan,
    this.trailing,
  });

  final String title;
  final String? codeTag;
  final Color accentColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: accentColor,
            boxShadow: CyberColors.neonGlow(accentColor, intensity: 0.6, blur: 8),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (codeTag != null)
                Text(
                  '// $codeTag',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CyberTextStyles.monoTag.copyWith(
                    fontSize: 10,
                    color: accentColor,
                  ),
                ),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: CyberTextStyles.hudHeadline,
              ),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}
