import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class AppTableColumn {
  const AppTableColumn({
    required this.label,
    this.flex = 1,
    this.alignment = Alignment.centerLeft,
  });

  final String label;
  final int flex;
  final Alignment alignment;
}

class AppTableRowData {
  const AppTableRowData({required this.cells, this.trailing})
    : assert(cells.length > 0, 'cells must not be empty');

  final List<Widget> cells;
  final Widget? trailing;
}

class AppDataTable extends StatelessWidget {
  AppDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.compact = false,
    this.showColumnDividers = true,
    this.columnSpacing = 18,
    this.rowPadding = const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
    this.headerPadding = const EdgeInsets.symmetric(horizontal: 22),
    this.trailingWidth = 38,
  }) : assert(
         rows.every((row) => row.cells.length == columns.length),
         'Each row must provide the same number of cells as columns',
       );

  final List<AppTableColumn> columns;
  final List<AppTableRowData> rows;
  final bool compact;
  final bool showColumnDividers;
  final double columnSpacing;
  final EdgeInsetsGeometry rowPadding;
  final EdgeInsetsGeometry headerPadding;
  final double trailingWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        const SizedBox(height: 4),
        for (int i = 0; i < rows.length; i++) ...[
          _buildRow(context, rows[i]),
          if (i != rows.length - 1)
            Divider(
              height: 1,
              thickness: 1,
              indent: rowPadding.horizontal / 2,
              endIndent: rowPadding.horizontal / 2,
              color: AppColors.progressSectionBorder.withValues(alpha: 0.55),
            ),
        ],
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 46,
      padding: headerPadding,
      decoration: BoxDecoration(
        color: AppColors.progressSectionBackground,
        borderRadius: BorderRadius.circular(compact ? 22 : 26),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (int i = 0; i < columns.length; i++) ...[
            Expanded(
              flex: columns[i].flex,
              child: Align(
                alignment: columns[i].alignment,
                child: Text(
                  columns[i].label,
                  style: AppTypography.metricLabel.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            if (showColumnDividers && i != columns.length - 1)
              _divider(AppColors.progressSectionBorder.withValues(alpha: 0.6)),
          ],
          SizedBox(width: trailingWidth),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, AppTableRowData row) {
    return Padding(
      padding: rowPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (int i = 0; i < columns.length; i++) ...[
            Expanded(
              flex: columns[i].flex,
              child: Align(
                alignment: columns[i].alignment,
                child: row.cells[i],
              ),
            ),
            if (showColumnDividers && i != columns.length - 1)
              _divider(AppColors.progressSectionBorder.withValues(alpha: 0.4)),
          ],
          SizedBox(width: trailingWidth, child: row.trailing),
        ],
      ),
    );
  }

  Widget _divider(Color color) {
    return Container(
      width: 1,
      height: 24,
      margin: EdgeInsets.symmetric(horizontal: columnSpacing / 2),
      color: color,
    );
  }
}
