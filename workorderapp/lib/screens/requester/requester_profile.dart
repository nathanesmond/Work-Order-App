import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:workorderapp/auth/user_provider.dart';
import 'package:workorderapp/entity/work_order.dart';
import 'package:workorderapp/widgets/workorder_widgets/_work_order_card.dart';
import 'package:workorderapp/widgets/workorder_widgets/status_filter.dart';
import '../../auth/work_order_provider.dart';

class RequesterProfile extends StatefulWidget {
  const RequesterProfile({super.key});

  @override
  State<RequesterProfile> createState() => _RequesterProfileState();
}

class _RequesterProfileState extends State<RequesterProfile> {
  String _search = '';
  String _status = 'all';
  Timer? _debounce;

  static const _statusOrder = [
    'on_request',
    'in_progress',
    'completed',
    'overdue',
    'cancelled',
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<WorkOrderProvider>().fetchMyRequestHistory();
      context.read<UserProvider>().fetchUserDetails();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _syncAndFetch() {
    final provider = context.read<WorkOrderProvider>();
    provider.searchQuery = _search;
    provider.statusFilter = _status == 'all' ? null : _status;
    provider.fetchMyRequestHistory();
  }

  List<WorkOrder> _getHistory(List<WorkOrder> orders) {
    final filtered = orders
        .where((w) => w.status == 'completed' || w.status == 'cancelled')
        .toList();

    filtered.sort((a, b) {
      final s = _statusOrder
          .indexOf(a.status)
          .compareTo(_statusOrder.indexOf(b.status));
      if (s != 0) return s;
      if (a.dueAt == null && b.dueAt == null) return 0;
      if (a.dueAt == null) return 1;
      if (b.dueAt == null) return -1;
      return a.dueAt!.compareTo(b.dueAt!);
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkOrderProvider>();
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.currentUser;

    if (userProvider.isLoading || user == null) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2.5));
    }

    final all = provider.workOrders;
    final total = all.length;
    final completed = all.where((w) => w.status == 'completed').length;
    final cancelled = all.where((w) => w.status == 'cancelled').length;
    final active = all
        .where(
          (w) =>
              w.status == 'on_request' ||
              w.status == 'in_progress' ||
              w.status == 'on_hold' ||
              w.status == 'overdue',
        )
        .length;
    final history = _getHistory(all);

    return Container(
      color: const Color(0xFFFFFBFE),
      child: RefreshIndicator(
        onRefresh: () async {
          _search = '';
          _status = 'all';
          _syncAndFetch();
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 32),

                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(
                        159,
                        125,
                        76,
                        1,
                      ).withOpacity(.12),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(159, 125, 76, 1),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 6),

                  if (user.roles.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(
                          159,
                          125,
                          76,
                          1,
                        ).withOpacity(.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        user.firstRole.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(159, 125, 76, 1),
                          letterSpacing: .4,
                        ),
                      ),
                    ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.apartment,
                        size: 15,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        user.department?.name ?? '-',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.05),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          _StatCell(
                            value: total.toString(),
                            label: 'Total',
                            color: Colors.blueGrey,
                          ),
                          _DividerCell(),
                          _StatCell(
                            value: active.toString(),
                            label: 'Active',
                            color: Colors.purple,
                          ),
                          _DividerCell(),
                          _StatCell(
                            value: completed.toString(),
                            label: 'Completed',
                            color: Colors.green,
                          ),
                          _DividerCell(),
                          _StatCell(
                            value: cancelled.toString(),
                            label: 'Cancelled',
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  StatusFilter(
                    selected: _status,
                    onChanged: (s) {
                      setState(() => _status = s);
                      _syncAndFetch();
                    },
                    statuses: const ['all', 'completed', 'cancelled'],
                  ),
                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search history...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 16,
                        ),
                      ),
                      onChanged: (q) {
                        _debounce?.cancel();
                        _debounce = Timer(
                          const Duration(milliseconds: 400),
                          () {
                            setState(() => _search = q);
                            _syncAndFetch();
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Text(
                          'History',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${history.length}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),

            history.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Center(
                        child: Text(
                          'No work order history',
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => WorkOrderCard(item: history[i]),
                        childCount: history.length,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatCell({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DividerCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: Colors.grey.shade200);
  }
}
