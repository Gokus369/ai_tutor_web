import 'package:ai_tutor_web/features/attendance/domain/models/attendance_record.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

typedef AttendanceStatusCallback =
    void Function(AttendanceRecord record, AttendanceStatus status);

class AttendanceTable extends StatelessWidget {
  const AttendanceTable({
    super.key,
    required this.records,
    required this.onStatusUpdated,
  });

  final List<AttendanceRecord> records;
  final AttendanceStatusCallback onStatusUpdated;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.14),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isCompact = constraints.maxWidth < 720;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Students', style: AppTypography.sectionTitle),
              const SizedBox(height: 18),
              _AttendanceTableHeader(isCompact: isCompact),
              const SizedBox(height: 12),
              const Divider(
                height: 24,
                thickness: 1,
                color: AppColors.studentsTableDivider,
              ),
              if (records.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    'No students match your filters today.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                )
              else ...[
                for (int i = 0; i < records.length; i++) ...[
                  _AttendanceTableRow(
                    record: records[i],
                    isCompact: isCompact,
                    onStatusUpdated: onStatusUpdated,
                  ),
                  if (i != records.length - 1)
                    const Divider(
                      height: 30,
                      thickness: 1,
                      color: AppColors.studentsTableDivider,
                    ),
                ],
              ],
            ],
          );
        },
      ),
    );
  }
}

class _AttendanceTableHeader extends StatelessWidget {
  const _AttendanceTableHeader({required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final labelStyle = AppTypography.studentsTableHeader.copyWith(fontSize: 15);

    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 2, child: Text('Name', style: labelStyle)),
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Attendance Status', style: labelStyle),
          ),
        ),
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Notes', style: labelStyle),
          ),
        ),
      ],
    );

    if (isCompact) return row;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.studentsFilterBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.studentsTableDivider),
      ),
      child: row,
    );
  }
}

class _AttendanceTableRow extends StatelessWidget {
  const _AttendanceTableRow({
    required this.record,
    required this.isCompact,
    required this.onStatusUpdated,
  });

  final AttendanceRecord record;
  final bool isCompact;
  final AttendanceStatusCallback onStatusUpdated;

  @override
  Widget build(BuildContext context) {
    final statusButtons = _statusButtons();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: isCompact
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.name,
                        style: AppTypography.studentsTableCell.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        record.className,
                        style: AppTypography.classCardMeta.copyWith(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  )
                : Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      record.name,
                      style: AppTypography.studentsTableCell.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 1,
                      ),
                    ),
                  ),
          ),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: isCompact
                  ? Wrap(spacing: 12, runSpacing: 8, children: statusButtons)
                  : SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          for (int i = 0; i < statusButtons.length; i++) ...[
                            statusButtons[i],
                            if (i != statusButtons.length - 1)
                              const SizedBox(width: 12),
                          ],
                        ],
                      ),
                    ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 38,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.studentsCardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.studentsFilterBorder),
                ),
                child: Text(
                  record.notes,
                  style: AppTypography.classCardMeta.copyWith(
                    color: AppColors.greyMedium,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _statusButtons() {
    return [
      _buildStatusButton(
        label: 'Present',
        status: AttendanceStatus.present,
        color: AppColors.accentGreen,
      ),
      _buildStatusButton(
        label: 'Absent',
        status: AttendanceStatus.absent,
        color: AppColors.accentPink,
      ),
      _buildStatusButton(
        label: 'Late',
        status: AttendanceStatus.late,
        color: AppColors.accentRed,
      ),
    ];
  }

  Widget _buildStatusButton({
    required String label,
    required AttendanceStatus status,
    required Color color,
  }) {
    return SizedBox(
      width: 65,
      height: 32,
      child: _AttendanceStatusPill(
        label: label,
        selected: record.status == status,
        activeColor: color,
        onTap: () => onStatusUpdated(record, status),
      ),
    );
  }
}

class _AttendanceStatusPill extends StatelessWidget {
  const _AttendanceStatusPill({
    required this.label,
    required this.selected,
    required this.activeColor,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color textColor = selected ? AppColors.white : AppColors.textPrimary;
    final Color borderColor = selected
        ? activeColor
        : AppColors.studentsFilterBorder;
    final List<BoxShadow>? shadow = selected
        ? [
            BoxShadow(
              color: activeColor.withValues(alpha: 0.32),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ]
        : null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            color: selected ? activeColor : AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: shadow,
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.classCardMeta.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
