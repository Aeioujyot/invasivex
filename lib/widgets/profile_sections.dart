import 'package:flutter/material.dart';

import '../models/classification_profile.dart';
import '../models/threat_level.dart';
import '../theme/app_theme.dart';

/// Pill showing invasive / not-invasive status, used on both live
/// identification results and library entries.
class InvasiveBadge extends StatelessWidget {
  final bool isInvasive;
  const InvasiveBadge({super.key, required this.isInvasive});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = isInvasive ? scheme.warning : scheme.accent;
    final bg = isInvasive ? scheme.warningFill : scheme.sageTint.withValues(alpha: 0.4);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isInvasive ? Icons.warning_amber_rounded : Icons.verified_rounded, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            isInvasive ? 'Invasive' : 'Not Invasive',
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

/// Simple horizontal gauge for threat level, staying within the app's
/// green→amber→rust ramp.
class ThreatGaugeView extends StatelessWidget {
  final ThreatLevel level;
  const ThreatGaugeView({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = AppColors.threatColor(level, isDark: isDark);
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(level.label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                Container(height: 8, width: constraints.maxWidth, color: scheme.surfaceAlt),
                Container(
                  height: 8,
                  width: (constraints.maxWidth * level.gaugeValue).clamp(8, constraints.maxWidth),
                  color: color,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Confidence meter shown on live AI results (not shown for library entries,
/// which carry no confidence score).
class ConfidenceView extends StatelessWidget {
  final double confidence;
  const ConfidenceView({super.key, required this.confidence});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Identification Confidence', style: TextStyle(color: scheme.primaryText, fontWeight: FontWeight.w600)),
            Text('${(confidence * 100).round()}%', style: TextStyle(color: scheme.accentStrong, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                Container(height: 8, width: constraints.maxWidth, color: scheme.surfaceAlt),
                Container(
                  height: 8,
                  width: (constraints.maxWidth * confidence).clamp(8, constraints.maxWidth),
                  color: scheme.accent,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Root → leaf taxonomy table.
class TaxonomyTableView extends StatelessWidget {
  final List<(String, String)> rows;
  const TaxonomyTableView({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(rows[i].$1, style: TextStyle(color: scheme.secondaryText, fontSize: 13)),
                ),
                Expanded(
                  child: Text(
                    rows[i].$2,
                    style: TextStyle(
                      color: scheme.primaryText,
                      fontWeight: FontWeight.w500,
                      fontStyle: rows[i].$1 == 'Species' ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (i < rows.length - 1) Divider(height: 1, color: scheme.accent.withValues(alpha: 0.1)),
        ],
      ],
    );
  }
}

/// A titled card wrapper reused across every profile section.
class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  const SectionCard({super.key, required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface2,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.accent.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: scheme.accentStrong),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(color: scheme.accentStrong, fontSize: 17, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

/// Chips used for "invasive in" regions.
class RegionChips extends StatelessWidget {
  final List<String> regions;
  const RegionChips({super.key, required this.regions});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (regions.isEmpty) {
      return Text('No regions on record.', style: TextStyle(color: scheme.secondaryText));
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final region in regions)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: scheme.sageTint.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(999)),
            child: Text(region, style: TextStyle(color: scheme.accentStrong, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }
}

/// The full profile body — taxonomy, origin, invasive status, impact, and
/// control methods — shared by the result screen and the library detail screen.
class ClassificationProfileSections extends StatelessWidget {
  final ClassificationProfile profile;
  const ClassificationProfileSections({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionCard(
          title: 'Origin',
          icon: Icons.public,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(profile.nativeRange, style: TextStyle(color: scheme.primaryText)),
              const SizedBox(height: 4),
              Text(profile.habitat, style: TextStyle(color: scheme.secondaryText, fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SectionCard(
          title: 'Invasive Status',
          icon: Icons.warning_amber_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InvasiveBadge(isInvasive: profile.isInvasive),
              if (profile.isInvasive) ...[
                const SizedBox(height: 10),
                Text('Invasive in:', style: TextStyle(color: scheme.primaryText, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                RegionChips(regions: profile.invasiveRegions),
              ],
              const SizedBox(height: 8),
              Text(profile.invasiveStatusNotes, style: TextStyle(color: scheme.secondaryText, fontSize: 13)),
              const SizedBox(height: 10),
              ThreatGaugeView(level: profile.threatLevel),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SectionCard(
          title: 'What It Does & Harms',
          icon: Icons.eco,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _labeledParagraph(context, 'Ecological Impact', profile.ecologicalImpact),
              const SizedBox(height: 10),
              _labeledParagraph(context, 'Economic Impact', profile.economicImpact),
              const SizedBox(height: 10),
              _labeledParagraph(context, 'Control Methods', profile.controlMethods),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SectionCard(
          title: 'Classification Profile',
          icon: Icons.format_list_bulleted,
          child: TaxonomyTableView(rows: profile.taxonomyRows),
        ),
      ],
    );
  }

  Widget _labeledParagraph(BuildContext context, String label, String text) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: scheme.primaryText, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(text, style: TextStyle(color: scheme.secondaryText, fontSize: 13)),
      ],
    );
  }
}
