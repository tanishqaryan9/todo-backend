package com.todoApp.backend.controller;

import com.todoApp.backend.dto.AddTaskDto;
import com.todoApp.backend.dto.TaskDto;
import com.todoApp.backend.service.TaskService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/tasks")
@AllArgsConstructor
public class TaskController {

    public final TaskService taskService;

    private String getSchema(HttpServletRequest request) {
        return (String) request.getAttribute("userSchema");
    }

    @GetMapping
    public ResponseEntity<List<TaskDto>> getAllTasks(HttpServletRequest request) {
        return ResponseEntity.ok(taskService.getAllTasks(getSchema(request)));
    }

    @GetMapping("/sorted-by-due-date")
    public ResponseEntity<List<TaskDto>> getTasksByDueDate(HttpServletRequest request) {
        return ResponseEntity.ok(taskService.getTasksByDueDate(getSchema(request)));
    }

    @PostMapping
    public ResponseEntity<TaskDto> addTask(@RequestBody AddTaskDto addTaskDto, HttpServletRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(taskService.addTask(addTaskDto, getSchema(request)));
    }

    @PutMapping("/{task}")
    public ResponseEntity<TaskDto> updateTaskByTask(@PathVariable String task,
                                                    @RequestBody AddTaskDto addTaskDto,
                                                    HttpServletRequest request) {
        return ResponseEntity.ok(taskService.updateTaskByTask(task, addTaskDto, getSchema(request)));
    }

    @PatchMapping("/{task}")
    public ResponseEntity<TaskDto> partialUpdateTaskByTask(@PathVariable String task,
                                                           @RequestBody Map<String, Object> updates,
                                                           HttpServletRequest request) {
        return ResponseEntity.ok(taskService.partialUpdateTaskByTask(task, updates, getSchema(request)));
    }

    @DeleteMapping("/by-id/{id}")
    public ResponseEntity<Void> deleteTaskById(@PathVariable Long id, HttpServletRequest request) {
        taskService.deleteTaskById(id, getSchema(request));
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/{task}")
    public ResponseEntity<Void> deleteTaskByTask(@PathVariable String task, HttpServletRequest request) {
        taskService.deleteTaskByTask(task, getSchema(request));
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/status/{status}")
    public ResponseEntity<List<TaskDto>> getByStatus(@PathVariable String status, HttpServletRequest request) {
        return ResponseEntity.ok(taskService.getByStatus(status.toLowerCase(), getSchema(request)));
    }
}