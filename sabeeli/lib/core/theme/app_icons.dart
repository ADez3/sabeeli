import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Lucide icons do not mirror themselves in right-to-left layouts, so "forward"
/// arrows are picked by text direction here.
extension DirectionalIcons on BuildContext {
  bool get isRtl => Directionality.of(this) == TextDirection.rtl;

  IconData get forwardArrow =>
      isRtl ? LucideIcons.arrowLeft : LucideIcons.arrowRight;

  IconData get forwardChevron =>
      isRtl ? LucideIcons.chevronLeft : LucideIcons.chevronRight;
}
