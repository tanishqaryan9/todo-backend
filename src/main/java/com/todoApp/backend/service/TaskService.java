package com.todoApp.backend.service;

import com.todoApp.backend.dto.AddTaskDto;
import com.todoApp.backend.dto.TaskDto;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public interface TaskService {

    List<TaskDto> getAllTasks();

    List<TaskDto> getTasksByDueDate();

    TaskDto addTask(AddTaskDto addTaskDto);

    void deleteTaskById(Long id);

    void deleteTaskByTask(String task);

    TaskDto updateTaskByTask(String task, AddTaskDto addTaskDto);

    TaskDto partialUpdateTaskByTask(String task, Map<String,Object> updates);

    List<TaskDto> getByStatus(String status);
}
