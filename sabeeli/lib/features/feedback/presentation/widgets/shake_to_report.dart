import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/app_info.dart';
import '../../../../core/platform/feedback_channels.dart';
import '../../../../core/platform/live_state.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/l10n.dart';
import '../../../quran/presentation/cubit/quran_cubit.dart';
import '../../../settings/domain/entities/app_settings.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';

/// During the beta, shaking the phone opens a problem report: a screenshot of
/// what is on screen, an optional note, sent from the user's own mail app.
/// The sensor is on only while the app is in the foreground, and only if the
/// user keeps the option on.
class ShakeToReport extends StatefulWidget {
  const ShakeToReport({super.key, required this.child});

  final Widget child;

  /// What is captured for the report.
  static final _boundary = GlobalKey();

  /// Opens the report by hand (Settings, About), with a screenshot of the
  /// screen as it is now.
  static Future<void> open(BuildContext context) async {
    final shot = await _capture();
    if (!context.mounted) return;
    await _showReport(context, shot);
  }

  static Future<Uint8List?> _capture() async {
    final box =
        _boundary.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (box == null) return null;
    final image = await box.toImage(pixelRatio: 1.5);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return data?.buffer.asUint8List();
  }

  static Future<void> _showReport(BuildContext context, Uint8List? shot) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (_) => _ReportSheet(screenshot: shot),
      );

  @override
  State<ShakeToReport> createState() => _ShakeToReportState();
}

class _ShakeToReportState extends State<ShakeToReport> with LiveStateMixin {
  StreamSubscription<void>? _shakes;
  bool _open = false;

  @override
  void onLiveChanged(bool live) => _listen();

  void _listen() {
    final enabled = context.read<SettingsCubit>().state.shakeToReport;
    if (isLive && enabled) {
      _shakes ??= Shake.watch().listen((_) => _report());
    } else {
      _shakes?.cancel();
      _shakes = null;
    }
  }

  Future<void> _report() async {
    final navigator = rootNavigatorKey.currentContext;
    if (_open || navigator == null) return;
    _open = true;
    HapticFeedback.mediumImpact();
    final shot = await ShakeToReport._capture();
    if (navigator.mounted) await ShakeToReport._showReport(navigator, shot);
    _open = false;
  }

  @override
  void dispose() {
    _shakes?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<SettingsCubit, AppSettings>(
        listenWhen: (a, b) => a.shakeToReport != b.shakeToReport,
        listener: (_, _) => _listen(),
        child: RepaintBoundary(
          key: ShakeToReport._boundary,
          child: widget.child,
        ),
      );
}

class _ReportSheet extends StatefulWidget {
  const _ReportSheet({required this.screenshot});

  final Uint8List? screenshot;

  @override
  State<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<_ReportSheet> {
  final _note = TextEditingController();
  bool _attach = true;
  bool _sending = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    setState(() => _sending = true);
    final l10n = context.l10n;
    String? path;
    final shot = widget.screenshot;
    if (_attach && shot != null) {
      // Only the reports/ folder of the cache is lent to the mail app.
      final dir = Directory('${(await getTemporaryDirectory()).path}/reports');
      await dir.create(recursive: true);
      final file = File('${dir.path}/screenshot.png');
      await file.writeAsBytes(shot);
      path = file.path;
    }
    if (!mounted) return;
    final location = appRouter.routerDelegate.currentConfiguration.uri;
    final riwayah = context.read<QuranCubit>().riwayah.name;
    final body = [
      _note.text.trim(),
      '',
      '—',
      '${AppInfo.name} ${AppInfo.version}',
      'Screen: $location',
      'Language: ${context.languageCode}',
      'Riwayah: $riwayah',
      'System: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}',
    ].join('\n');
    final opened = await ReportMail.compose(
      to: AppInfo.feedbackEmail,
      subject: '${AppInfo.name} ${AppInfo.version} · ${l10n.reportTitle}',
      body: body,
      attachmentPath: path,
    );
    if (!mounted) return;
    setState(() => _sending = false);
    if (opened) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.reportNoMail)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final shot = widget.screenshot;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            0,
            AppSpacing.xl,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.messageSquareWarning, color: colors.accent),
                  const SizedBox(width: AppSpacing.sm),
                  Text(l10n.reportTitle, style: text.titleLarge),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              if (shot != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      child: Image.memory(shot, height: 150),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            value: _attach,
                            onChanged: (v) =>
                                setState(() => _attach = v ?? true),
                            title: Text(l10n.reportAttach),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                          Text(l10n.reportPrivacy, style: text.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _note,
                minLines: 3,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: l10n.reportHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: _sending ? null : _send,
                icon: const Icon(LucideIcons.mail),
                label: Text(l10n.reportSend),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The beta notice, shown once: what the app is not yet, and how to tell us.
Future<void> showBetaNotice(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  isDismissible: false,
  useRootNavigator: true,
  builder: (sheet) {
    final l10n = sheet.l10n;
    final colors = sheet.colors;
    final text = Theme.of(sheet).textTheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          0,
          AppSpacing.xl,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: colors.accent.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                l10n.betaBadge,
                style: text.labelMedium?.copyWith(color: colors.accent),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.betaTitle, style: text.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.betaBody, style: text.bodyMedium?.copyWith(height: 1.6)),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Icon(LucideIcons.vibrate, color: colors.primary),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    l10n.betaShakeHint,
                    style: text.bodyMedium?.copyWith(color: colors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(sheet).pop(),
                child: Text(l10n.betaUnderstood),
              ),
            ),
          ],
        ),
      ),
    );
  },
);
