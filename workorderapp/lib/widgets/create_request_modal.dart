import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workorderapp/auth/work_order_provider.dart';

void showCreateRequestModal(BuildContext context) {
  final parentContext = context;
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final hoursController = TextEditingController();
  String timeMode = 'hours';
  DateTime? selectedDateTime;
  bool isLoading = false;

  void showError(String message) {
    ScaffoldMessenger.of(parentContext).showSnackBar(
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

  void showSuccess(String message) {
    ScaffoldMessenger.of(parentContext).showSnackBar(
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

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => StatefulBuilder(
      builder: (ctx, modalSetState) => GestureDetector(
        onTap: () => FocusScope.of(ctx).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Create Work Request',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),
              _field(titleController, 'Title'),
              const SizedBox(height: 12),
              _field(descController, 'Description', maxLines: 4),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      title: const Text("Hours"),
                      value: 'hours',
                      groupValue: timeMode,
                      onChanged: (v) => modalSetState(() => timeMode = v!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      title: const Text("Date"),
                      value: 'date',
                      groupValue: timeMode,
                      onChanged: (v) {
                        FocusScope.of(ctx).unfocus();
                        modalSetState(() => timeMode = v!);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (timeMode == 'hours')
                _field(
                  hoursController,
                  'Time Limit (hours)',
                  keyboardType: TextInputType.number,
                ),
              if (timeMode == 'date') ...[
                InkWell(
                  onTap: () async {
                    FocusScope.of(ctx).unfocus();
                    final date = await showDatePicker(
                      context: ctx,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      modalSetState(() => selectedDateTime = date);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Text(
                      selectedDateTime == null
                          ? "Select date"
                          : DateFormat('yyyy-MM-dd').format(selectedDateTime!),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Select Time",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => FocusScope.of(ctx).unfocus(),
                  child: SizedBox(
                    height: 180,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime: DateTime.now().add(
                        const Duration(hours: 1),
                      ),
                      use24hFormat: true,
                      onDateTimeChanged: (dt) {
                        modalSetState(() {
                          selectedDateTime = DateTime(
                            selectedDateTime?.year ?? dt.year,
                            selectedDateTime?.month ?? dt.month,
                            selectedDateTime?.day ?? dt.day,
                            dt.hour,
                            dt.minute,
                          );
                        });
                      },
                    ),
                  ),
                ),
                if (selectedDateTime != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    "Selected: ${DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime!)}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ],

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          // validate
                          if (titleController.text.trim().isEmpty) {
                            if (ctx.mounted) Navigator.pop(ctx);
                            showError('Title is required.');
                            return;
                          }
                          if (descController.text.trim().isEmpty) {
                            if (ctx.mounted) Navigator.pop(ctx);
                            showError('Description is required.');
                            return;
                          }

                          int hours = 0;
                          if (timeMode == 'hours') {
                            hours = int.tryParse(hoursController.text) ?? 0;
                            if (hours < 1) {
                              if (ctx.mounted) Navigator.pop(ctx);
                              showError(
                                'Please enter a valid number of hours or Date and Time.',
                              );
                              return;
                            }
                          } else {
                            if (selectedDateTime == null) {
                              if (ctx.mounted) Navigator.pop(ctx);
                              showError(
                                'Please enter a valid number of hours or Date and Time.',
                              );
                              return;
                            }
                            final diff = selectedDateTime!.difference(
                              DateTime.now(),
                            );
                            if (diff.isNegative) {
                              if (ctx.mounted) Navigator.pop(ctx);
                              showError('Selected date must be in the future.');
                              return;
                            }
                            if (diff.inHours < 1) {
                              if (ctx.mounted) Navigator.pop(ctx);
                              showError(
                                'Due time must be at least 1 hour from now.',
                              );
                              return;
                            }
                            hours = diff.inHours;
                          }

                          modalSetState(() => isLoading = true);

                          try {
                            await ctx.read<WorkOrderProvider>().createRequest(
                              title: titleController.text.trim(),
                              description: descController.text.trim(),
                              hours: hours,
                            );
                            if (ctx.mounted) Navigator.pop(ctx);
                            showSuccess('Work request created successfully.');
                          } catch (e) {
                            modalSetState(() => isLoading = false);
                            if (ctx.mounted) Navigator.pop(ctx);
                            showError(
                              'Failed to create request. Please try again.',
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    disabledBackgroundColor: Colors.black.withOpacity(.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
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
                      : const Text(
                          'Submit Request',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
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
  int maxLines = 1,
  TextInputType? keyboardType,
}) {
  return TextField(
    controller: c,
    maxLines: maxLines,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade100,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.black),
      ),
    ),
  );
}
