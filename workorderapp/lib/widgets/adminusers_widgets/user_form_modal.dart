import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/user_provider.dart';
import '../../entity/user.dart';

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
  {"id": 10, "name": "Chief Engineering"},
];

const _roles = ["admin", "requester", "engineer", "superadmin"];

void showUserFormModal(BuildContext context, {User? editUser}) {
  final parentContext = context;
  final currentUserId = context.read<UserProvider>().currentUser?.id;
  final isEditingSelf = editUser != null && editUser.id == currentUserId;
  final nameController = TextEditingController(text: editUser?.name ?? '');
  final usernameController = TextEditingController(
    text: editUser?.username ?? '',
  );
  final passwordController = TextEditingController();

  final _deptIds = _departments.map((d) => d["id"] as int).toList();
  int? selectedDeptId =
      editUser?.department?.id != null &&
          _deptIds.contains(editUser!.department!.id)
      ? editUser.department!.id
      : null;
  String? selectedRole = editUser != null && _roles.contains(editUser.firstRole)
      ? editUser.firstRole
      : null;
  bool isLoading = false;

  void showError(BuildContext ctx, String message) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  void showSuccess(BuildContext ctx, String message) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  String? _validate() {
    if (nameController.text.trim().isEmpty) return 'Name is required.';
    if (usernameController.text.trim().isEmpty) return 'Username is required.';
    if (editUser == null && passwordController.text.isEmpty)
      return 'Password is required.';
    if (selectedDeptId == null) return 'Please select a department.';
    if (selectedRole == null) return 'Please select a role.';
    return null;
  }

  String? _validateUpdate() {
    if (nameController.text.trim().isEmpty) return 'Name is required.';
    if (usernameController.text.trim().isEmpty) return 'Username is required.';
    return null;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setModalState) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFFFBFE),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // header
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      editUser == null
                          ? Icons.person_add_outlined
                          : Icons.edit_outlined,
                      size: 20,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    editUser == null ? 'Create User' : 'Edit User',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              _field(nameController, 'Name', icon: Icons.badge_outlined),
              const SizedBox(height: 12),
              _field(
                usernameController,
                'Username',
                icon: Icons.alternate_email,
              ),
              const SizedBox(height: 12),
              _field(
                passwordController,
                editUser == null
                    ? 'Password'
                    : 'Password (leave blank to keep)',
                obscure: true,
                icon: Icons.lock_outline,
              ),
              const SizedBox(height: 12),

              // department dropdown
              DropdownButtonFormField<int>(
                value: selectedDeptId,
                decoration: _dropdownDecor(
                  'Department',
                  icon: Icons.apartment_outlined,
                ),
                items: _departments
                    .map(
                      (d) => DropdownMenuItem<int>(
                        value: d["id"] as int,
                        child: Text(d["name"] as String),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setModalState(() => selectedDeptId = v),
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: _dropdownDecor('Role', icon: Icons.shield_outlined),
                items: _roles
                    .map(
                      (r) => DropdownMenuItem(
                        value: r,
                        child: Text(r[0].toUpperCase() + r.substring(1)),
                      ),
                    )
                    .toList(),
                onChanged: isEditingSelf
                    ? null
                    : (v) => setModalState(() => selectedRole = v),
                disabledHint: Text(
                  selectedRole != null && selectedRole!.isNotEmpty
                      ? selectedRole![0].toUpperCase() +
                            selectedRole!.substring(1)
                      : '-', // ← add empty check
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),

              if (isEditingSelf)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 13,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'You cannot change your own role.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              // buttons
              if (editUser == null)
                _submitButton(
                  ctx,
                  isLoading ? '' : 'Create User',
                  Colors.black,
                  isLoading
                      ? null
                      : () async {
                          final error = _validate();
                          if (error != null) {
                            if (ctx.mounted) Navigator.pop(ctx);
                            showError(parentContext, error);
                            return;
                          }
                          setModalState(() => isLoading = true);
                          try {
                            await ctx.read<UserProvider>().createUser(
                              name: nameController.text.trim(),
                              username: usernameController.text.trim(),
                              password: passwordController.text,
                              role: selectedRole!,
                              departmentid: selectedDeptId!,
                            );
                            await ctx.read<UserProvider>().fetchUsers();
                            if (ctx.mounted) Navigator.pop(ctx);
                            showSuccess(
                              parentContext,
                              'User created successfully.',
                            );
                          } catch (e) {
                            print('Create user error: $e');
                            setModalState(() => isLoading = false);
                            if (ctx.mounted) Navigator.pop(ctx);

                            final raw = e.toString();
                            String msg;
                            if (raw.contains('username') ||
                                raw.contains('Username')) {
                              msg = 'Username is already taken.';
                            } else if (raw.contains('<!DOCTYPE') ||
                                raw.contains('<html')) {
                              msg = 'Server error. Please try again.';
                            } else {
                              msg = raw.replaceFirst('Exception: ', '');
                            }
                            showError(parentContext, msg);
                          }
                        },
                  isLoading: isLoading,
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: _submitButton(
                        ctx,
                        isLoading ? '' : 'Delete',
                        Colors.red,
                        isLoading
                            ? null
                            : () async {
                                final confirm = await showDialog<bool>(
                                  context: ctx,
                                  builder: (_) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: const Text('Delete User'),
                                    content: Text(
                                      'Are you sure you want to delete ${editUser.name}? This cannot be undone.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, false),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, true),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm != true) return;
                                setModalState(() => isLoading = true);
                                try {
                                  await ctx.read<UserProvider>().delete(
                                    editUser.id,
                                  );
                                  if (ctx.mounted) {
                                    Navigator.pop(ctx);
                                    showSuccess(
                                      context,
                                      'User deleted successfully.',
                                    );
                                  }
                                } catch (e) {
                                  setModalState(() => isLoading = false);
                                  if (ctx.mounted) Navigator.pop(ctx);
                                  showError(
                                    parentContext,
                                    'Failed to delete user. Please try again.',
                                  );
                                }
                              },
                        isLoading: isLoading,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _submitButton(
                        ctx,
                        isLoading ? '' : 'Update',
                        const Color.fromRGBO(159, 125, 76, 1),
                        isLoading
                            ? null
                            : () async {
                                final error = _validateUpdate();
                                if (error != null) {
                                  if (ctx.mounted) Navigator.pop(ctx);
                                  showError(parentContext, error);
                                  return;
                                }

                                setModalState(() => isLoading = true);
                                try {
                                  await ctx.read<UserProvider>().updateUser(
                                    id: editUser.id,
                                    name: nameController.text.trim(),
                                    username: usernameController.text.trim(),
                                    role: selectedRole ?? editUser.firstRole,
                                    departmentid:
                                        selectedDeptId ??
                                        editUser.department?.id,
                                  );
                                  if (ctx.mounted) {
                                    Navigator.pop(ctx);
                                    showSuccess(
                                      context,
                                      'User updated successfully.',
                                    );
                                  }
                                } catch (e) {
                                  print('Update error: $e');
                                  setModalState(() => isLoading = false);
                                  if (ctx.mounted) Navigator.pop(ctx);
                                  showError(
                                    parentContext,
                                    'Failed to update user. Please try again.',
                                  );
                                }
                              },
                        isLoading: isLoading,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _field(
  TextEditingController c,
  String label, {
  bool obscure = false,
  IconData? icon,
}) {
  return TextField(
    controller: c,
    obscureText: obscure,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon, size: 20) : null,
      filled: true,
      fillColor: Colors.grey.shade100,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.black, width: 1.5),
      ),
    ),
  );
}

InputDecoration _dropdownDecor(String label, {IconData? icon}) =>
    InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon, size: 20) : null,
      filled: true,
      fillColor: Colors.grey.shade100,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.black, width: 1.5),
      ),
    );

Widget _submitButton(
  BuildContext ctx,
  String label,
  Color color,
  VoidCallback? onPressed, {
  bool isLoading = false,
}) {
  return SizedBox(
    width: double.infinity,
    height: 52,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        disabledBackgroundColor: color.withOpacity(.6),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
          : Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
    ),
  );
}
