import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/user_provider.dart';
import '../../widgets/adminusers_widgets/user_card.dart';
import '../../widgets/adminusers_widgets/user_form_modal.dart';

// at the top of admin_users.dart, outside the class
const _departments = [
  {"id": 1, "name": "IT"},
  {"id": 2, "name": "FO"},
  {"id": 3, "name": "F&B"},
  {"id": 4, "name": "Engineering"},
  {"id": 5, "name": "Housekeeping"},
  {"id": 6, "name": "Sales & Marketing"},
  {"id": 7, "name": "Kitchen"},
  {"id": 8, "name": "HR"},
  {"id": 9, "name": "A&G"},
];

class AdminUsers extends StatefulWidget {
  const AdminUsers({super.key});

  @override
  State<AdminUsers> createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = context.read<UserProvider>();
      provider.searchQuery = '';
      provider.departmentFilter = null;
      provider.fetchUsers();
      provider.fetchUserDetails();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearch(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final provider = context.read<UserProvider>();
      provider.searchQuery = q;
      provider.fetchUsers();
    });
  }

  void _onDeptChanged(int? deptId) {
    final provider = context.read<UserProvider>();
    provider.departmentFilter = deptId;
    provider.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final isSuperAdmin =
        provider.currentUser?.roles.contains('superadmin') ?? false;
    final currentUserId = provider.currentUser?.id;

    final sortedUsers = [...provider.users];
    sortedUsers.sort((a, b) {
      if (a.id == currentUserId) return -1;
      if (b.id == currentUserId) return 1;
      return 0;
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBFE),
      body: Column(
        children: [
          // search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
              ),
              onChanged: _onSearch,
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _departments.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final isAll = i == 0;
                final deptId = isAll ? null : _departments[i - 1]["id"] as int;
                final deptName = isAll
                    ? 'All'
                    : _departments[i - 1]["name"] as String;
                final isSelected = provider.departmentFilter == deptId;

                return GestureDetector(
                  onTap: () => _onDeptChanged(deptId),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.black
                          : const Color(0xFFFFFBFE),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      deptName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${provider.users.length} user${provider.users.length == 1 ? '' : 's'}',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                final provider = context.read<UserProvider>();
                provider.searchQuery = '';
                provider.departmentFilter = null;
                await provider.fetchUsers();
              },
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : provider.users.isEmpty
                  ? ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 80),
                          child: Center(
                            child: Text(
                              'No users found',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      itemCount: sortedUsers.length,
                      itemBuilder: (_, i) => UserCard(
                        user: sortedUsers[i],
                        isCurrentUser:
                            sortedUsers[i].id == currentUserId, // ← add
                        onTap: () => showUserFormModal(
                          context,
                          editUser: sortedUsers[i],
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isSuperAdmin
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12, left: 20, right: 20),
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBFE),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.08),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(26),
                    onTap: () => showUserFormModal(context),
                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_circle, size: 26),
                          SizedBox(width: 10),
                          Text(
                            'Create User',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
