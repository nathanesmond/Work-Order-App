import 'dart:async';

import 'package:flutter/material.dart';
import 'package:workorderapp/entity/work_order.dart';
import '../client/api_work_order.dart';

class WorkOrderProvider extends ChangeNotifier {
  bool isLoading = false;

  bool tableLoading = false;
  bool chartLoading = false;

  List<WorkOrder> workOrders = [];

  final ApiWorkOrder api;

  WorkOrderProvider(this.api);

  List<WorkOrder> allWorkOrders = [];
  List<WorkOrder> paginatedWorkOrders = [];

  int currentPage = 1;
  int rowsPerPage = 10;
  int totalRows = 0;

  String sortColumn = "created_at";
  bool sortAscending = false;
  String searchQuery = "";
  bool loading = false;
  String? rangeFilter;
  String? statusFilter;

  Timer? _debounce;

  Future loadOrders() async {
    tableLoading = true;
    notifyListeners();

    final response = await api.fetchPaginated(
      page: currentPage,
      perPage: rowsPerPage,
      sortBy: sortColumn,
      sortDir: sortAscending ? "asc" : "desc",
      search: searchQuery,
      range: rangeFilter,
    );

    paginatedWorkOrders = (response["data"] as List)
        .map((json) => WorkOrder.fromJson(json))
        .toList();
    totalRows = response["total"] ?? 0;
    currentPage = response["current_page"] ?? 1;

    tableLoading = false;
    notifyListeners();
  }

  void changePage(int page) {
    currentPage = page;
    loadOrders();
  }

  void sort(String column, bool ascending) {
    if (sortColumn == column) {
      sortAscending = !sortAscending;
    } else {
      sortColumn = column;
      sortAscending = true;
    }

    currentPage = 1;
    loadOrders();
  }

  void search(String query) {
    searchQuery = query;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      currentPage = 1;
      loadOrders();
    });
  }

  Future<void> fetchAll() async {
    chartLoading = true;
    notifyListeners();

    final data = await ApiWorkOrder.fetchWorkOrders(
      search: searchQuery,
      status: statusFilter,
      range: rangeFilter,
    );

    allWorkOrders = (data ?? [])
        .map((json) => WorkOrder.fromJson(json))
        .toList();
    chartLoading = false;
    notifyListeners();
  }

  Future<void> fetchAvailable() async {
    isLoading = true;
    notifyListeners();

    final data = await ApiWorkOrder.fetchAvailableWorkOrders(
      search: searchQuery,
    );

    workOrders = (data ?? [])
        .map<WorkOrder>((json) => WorkOrder.fromJson(json))
        .toList();
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMy() async {
    isLoading = true;
    notifyListeners();
    final data = await ApiWorkOrder.fetchMyWorkOrders();
    workOrders = (data ?? [])
        .map<WorkOrder>((json) => WorkOrder.fromJson(json))
        .toList();
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMyRequests() async {
    isLoading = true;
    notifyListeners();

    final data = await ApiWorkOrder.fetchMyRequests(
      search: searchQuery,
      status: statusFilter,
      range: rangeFilter,
    );

    workOrders = (data ?? [])
        .map<WorkOrder>((json) => WorkOrder.fromJson(json))
        .toList();

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMyRequestHistory() async {
    isLoading = true;
    notifyListeners();

    final data = await ApiWorkOrder.fetchMyRequestHistory(
      search: searchQuery,
      status: statusFilter,
      range: rangeFilter,
    );

    workOrders = (data ?? [])
        .map<WorkOrder>((json) => WorkOrder.fromJson(json))
        .toList();

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchHistory() async {
    isLoading = true;
    notifyListeners();
    final data = await ApiWorkOrder.fetchMyHistory();
    workOrders = (data ?? [])
        .map<WorkOrder>((json) => WorkOrder.fromJson(json))
        .toList();
    isLoading = false;
    notifyListeners();
  }

  Future<void> createRequest({
    required String title,
    required String description,
    required int hours,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      final apiWorkOrder = ApiWorkOrder();
      await apiWorkOrder.createWorkOrder(
        title: title,
        description: description,
        hours: hours,
      );
      await fetchMyRequests();
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> delete(int id) async {
    isLoading = true;
    notifyListeners();

    try {
      await ApiWorkOrder.deleteWorkOrder(id);

      workOrders.removeWhere((w) => w.id == id);

      await fetchAll();
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> start(int id) async {
    try {
      final success = await ApiWorkOrder.startWorkOrder(id);

      if (success) {
        await fetchAvailable();
      }
    } catch (e) {
      print('Start failed: $e');
    }
  }

  Future<void> complete(int id) async {
    try {
      final success = await ApiWorkOrder.completeWorkOrder(id);
      if (success) {
        await fetchMy();
      }
    } catch (e) {
      print('Complete failed: $e');
    }
  }

  Future<void> hold(int id, {String? comment}) async {
    try {
      final success = await ApiWorkOrder.holdWorkOrder(id, comment: comment);
      if (success) await fetchMy();
    } catch (e) {
      print('Hold failed: $e');
    }
  }

  Future<void> cancel(int id, {String? comment}) async {
    try {
      final success = await ApiWorkOrder.cancelWorkOrder(id, comment: comment);
      if (success) await fetchAll();
    } catch (e) {
      print('Cancel failed: $e');
    }
  }

  Future<void> resume(int id) async {
    try {
      final success = await ApiWorkOrder.resumeWorkOrder(id);
      if (success) await fetchMy();
    } catch (e) {
      print('Resume failed: $e');
    }
  }
}
