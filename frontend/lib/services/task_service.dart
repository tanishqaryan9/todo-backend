// lib/services/task_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

class TaskApiService {
  // ── Environment-aware base URL ──────────────────────────────
  // Testing on real phone → Render URL
// Testing on emulator  → http://10.0.2.2:8080
static const String baseUrl = 'https://todo-backend-1-3mk2.onrender.com';      // Android Emulator (debug)

  final http.Client _client;

  TaskApiService({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  List<Task> _parseTaskList(String body) {
    debugPrint('>>> RAW JSON: $body');
    final dynamic decoded = json.decode(body);
    debugPrint('>>> DECODED TYPE: ${decoded.runtimeType}');
    if (decoded is List) {
      debugPrint('>>> LIST LENGTH: ${decoded.length}');
      if (decoded.isNotEmpty) {
        debugPrint('>>> FIRST ITEM KEYS: ${(decoded[0] as Map).keys.toList()}');
        debugPrint('>>> FIRST ITEM: ${decoded[0]}');
      }
      return decoded.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
    } else if (decoded is Map<String, dynamic>) {
      debugPrint('>>> MAP KEYS: ${decoded.keys.toList()}');
      return [Task.fromJson(decoded)];
    }
    return [];
  }

  Future<List<Task>> getAllTasks() async {
    debugPrint('>>> GET $baseUrl/tasks');
    final response = await _client.get(
      Uri.parse('$baseUrl/tasks'),
      headers: _headers,
    );
    debugPrint('>>> STATUS: ${response.statusCode}');
    _handleError(response);
    return _parseTaskList(response.body);
  }

  Future<List<Task>> getTasksSortedByDueDate() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/tasks/sorted-by-due-date'),
      headers: _headers,
    );
    _handleError(response);
    return _parseTaskList(response.body);
  }

  Future<Task> addTask(Task task) async {
    debugPrint('>>> POST $baseUrl body: ${json.encode(task.toJson())}');
    final response = await _client.post(
      Uri.parse('$baseUrl/tasks'),
      headers: _headers,
      body: json.encode(task.toJson()),
    );
    debugPrint('>>> ADD STATUS: ${response.statusCode} BODY: ${response.body}');
    _handleError(response);
    return Task.fromJson(json.decode(response.body) as Map<String, dynamic>);
  }

  Future<Task> updateTask(String taskName, Task task) async {
    final response = await _client.put(
      Uri.parse('$baseUrl/tasks/$taskName'),
      headers: _headers,
      body: json.encode(task.toJson()),
    );
    _handleError(response);
    return Task.fromJson(json.decode(response.body) as Map<String, dynamic>);
  }

  Future<Task> patchTask(String taskName, Map<String, dynamic> updates) async {
    final response = await _client.patch(
      Uri.parse('$baseUrl/tasks/$taskName'),
      headers: _headers,
      body: json.encode(updates),
    );
    _handleError(response);
    return Task.fromJson(json.decode(response.body) as Map<String, dynamic>);
  }

  Future<void> deleteTaskById(int id) async {
    final response = await _client.delete(
      Uri.parse('$baseUrl/tasks/by-id/$id'),
      headers: _headers,
    );
    _handleError(response);
  }

  Future<void> deleteTaskByName(String taskName) async {
    final response = await _client.delete(
      Uri.parse('$baseUrl/tasks/$taskName'),
      headers: _headers,
    );
    _handleError(response);
  }

  Future<List<Task>> getTasksByStatus(bool isCompleted) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/tasks/status/$isCompleted'),
      headers: _headers,
    );
    _handleError(response);
    return _parseTaskList(response.body);
  }

  void _handleError(http.Response response) {
    if (response.statusCode >= 400) {
      String message = 'Request failed';
      try {
        final body = json.decode(response.body);
        message = body['message'] ?? body.toString();
      } catch (_) {
        message = response.body;
      }
      throw ApiException(response.statusCode, message);
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}
