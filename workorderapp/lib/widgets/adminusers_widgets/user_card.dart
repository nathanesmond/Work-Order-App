import 'package:flutter/material.dart';
import '../../entity/user.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onTap;
  final bool isCurrentUser;

  const UserCard({
    super.key,
    required this.user,
    required this.onTap,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: isCurrentUser
              ? const Color.fromRGBO(159, 125, 76, 1).withOpacity(.06)
              : const Color(0xFFFFFBFE),
          borderRadius: BorderRadius.circular(18),
          border: isCurrentUser
              ? Border.all(
                  color: const Color.fromRGBO(159, 125, 76, 1).withOpacity(.4),
                  width: 1.5,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // ← "You" badge
                        if (isCurrentUser) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(159, 125, 76, 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'You',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (user.roles.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _roleColor(user.firstRole).withOpacity(.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        user.firstRole.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _roleColor(user.firstRole),
                          letterSpacing: .4,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _Meta(
                      icon: Icons.person_outline,
                      label: user.username,
                    ),
                  ),
                  _Meta(
                    icon: Icons.apartment,
                    label: user.department?.name ?? '-',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _roleColor(String role) {
    switch (role) {
      case 'superadmin':
        return Colors.red;
      case 'admin':
        return Colors.purple;
      case 'engineer':
        return Colors.blue;
      case 'requester':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class _Meta extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Meta({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
      ],
    );
  }
}
