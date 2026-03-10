package com.todoApp.backend.service;

import com.todoApp.backend.dto.AddTaskDto;
import com.todoApp.backend.dto.TaskDto;
import java.util.List;
import java.util.Map;

public interface TaskService {
    List<TaskDto> getAllTasks(String schema);
    List<TaskDto> getTasksByDueDate(String schema);
    TaskDto addTask(AddTaskDto addTaskDto, String schema);
    void deleteTaskById(Long id, String schema);
    void deleteTaskByTask(String task, String schema);
    TaskDto updateTaskByTask(String task, AddTaskDto addTaskDto, String schema);
    TaskDto partialUpdateTaskByTask(String task, Map<String, Object> updates, String schema);
    List<TaskDto> getByStatus(String status, String schema);
}