import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workorderapp/entity/work_order.dart';
import 'package:workorderapp/widgets/adminreports_widgets/build_pagination.dart';
import 'package:workorderapp/widgets/adminreports_widgets/report_range_selector.dart';
import 'package:workorderapp/widgets/adminreports_widgets/pie_chart.dart';
import 'package:workorderapp/widgets/adminreports_widgets/report_table.dart';
import '../../auth/work_order_provider.dart';

class AdminReports extends StatefulWidget {
  const AdminReports({super.key});

  @override
  State<AdminReports> createState() => _AdminReportsState();
}

class _AdminReportsState extends State<AdminReports> {
  ReportRange selectedRange = ReportRange.all;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refresh();
    });
  }

  Map<String, int> getStatusCounts(List<WorkOrder> orders) {
    Map<String, int> counts = {
      "on_request": 0,
      "in_progress": 0,
      "completed": 0,
      "cancelled": 0,
      "overdue": 0,
      "on_hold": 0,
    };

    for (var order in orders) {
      final status = order.status;

      if (counts.containsKey(status)) {
        counts[status] = counts[status]! + 1;
      }
    }

    return counts;
  }

  Future<void> _refresh() async {
    final provider = context.read<WorkOrderProvider>();

    setState(() {
      selectedRange = ReportRange.all;
    });

    provider.rangeFilter = null;
    provider.currentPage = 1;

    await provider.loadOrders();
    await provider.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkOrderProvider>();
    final counts = getStatusCounts(provider.allWorkOrders);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReportRangeSelector(
                  selected: selectedRange,
                  onChanged: (range) {
                    setState(() => selectedRange = range);

                    final provider = context.read<WorkOrderProvider>();

                    provider.rangeFilter = range == ReportRange.all
                        ? null
                        : range.name;
                    provider.currentPage = 1;

                    provider.loadOrders();
                    provider.fetchAll();
                  },
                ),

                const SizedBox(height: 20),

                ReportPieChart(counts: counts),

                const SizedBox(height: 20),

                Text("Total Orders: ${provider.totalRows}"),

                const SizedBox(height: 12),

                TextField(
                  decoration: const InputDecoration(
                    labelText: "Search work orders",
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    context.read<WorkOrderProvider>().search(value);
                  },
                ),

                const SizedBox(height: 20),

                ReportTable(
                  orders: provider.paginatedWorkOrders,
                  provider: provider,
                ),

                const SizedBox(height: 20),

                buildPagination(provider),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
