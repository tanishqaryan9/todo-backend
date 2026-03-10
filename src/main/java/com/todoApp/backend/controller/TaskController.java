package com.todoApp.backend.controller;

import com.todoApp.backend.dto.AddTaskDto;
import com.todoApp.backend.dto.TaskDto;
import com.todoApp.backend.entity.Tasks;
import com.todoApp.backend.service.TaskService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/tasks")
@AllArgsConstructor
public class TaskController{

    public final TaskService taskService;

    @GetMapping
    public ResponseEntity<List<TaskDto>> getAllTasks()
    {
        return ResponseEntity.status(HttpStatus.ACCEPTED).body(taskService.getAllTasks());
    }

    @GetMapping("/sorted-by-due-date")
    public ResponseEntity<List<TaskDto>> getTasksByDueDate()
    {
        return ResponseEntity.status(HttpStatus.ACCEPTED).body(taskService.getTasksByDueDate());
    }

    @PostMapping
    public ResponseEntity<TaskDto> addTask(@RequestBody AddTaskDto addTaskDto)
    {
        return ResponseEntity.status(HttpStatus.CREATED).body(taskService.addTask(addTaskDto));
    }

    @PutMapping("/{task}")
    public ResponseEntity<TaskDto> updateTaskByTask(@PathVariable String task, @RequestBody AddTaskDto addTaskDto)
    {
        return ResponseEntity.status(HttpStatus.ACCEPTED).body(taskService.updateTaskByTask(task,addTaskDto));
    }

    @PatchMapping("/{task}")
    public ResponseEntity<TaskDto> partialUpdateTaskByTask(@PathVariable String task, @RequestBody Map<String, Object> updates)
    {
        return ResponseEntity.status(HttpStatus.ACCEPTED).body(taskService.partialUpdateTaskByTask(task,updates));
    }

    @DeleteMapping("/by-id/{id}")
    public ResponseEntity<Void> deleteTaskById(@PathVariable Long id)
    {
        taskService.deleteTaskById(id);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/{task}")
    public ResponseEntity<Void> deleteTaskByTask(@PathVariable String task)
    {
        taskService.deleteTaskByTask(task);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/status/{status}")
    public ResponseEntity<List<TaskDto>> getByStatus(@PathVariable String status)
    {
        return ResponseEntity.status(HttpStatus.ACCEPTED).body(taskService.getByStatus(status.toLowerCase()));
    }
}
