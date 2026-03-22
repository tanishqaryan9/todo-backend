package com.todoApp.backend.service.impl;

import com.todoApp.backend.dto.AddTaskDto;
import com.todoApp.backend.dto.TaskDto;
import com.todoApp.backend.entity.Tasks;
import com.todoApp.backend.repository.TaskRepository;
import com.todoApp.backend.service.TaskService;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import lombok.AllArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@AllArgsConstructor
@Service
public class TaskServiceImpl implements TaskService {

    public final TaskRepository taskRepository;
    public final ModelMapper modelMapper;

    @PersistenceContext
    private EntityManager entityManager;

    @Transactional
    private void setSchema(String schema) {
        if (schema != null) {
            entityManager.createNativeQuery("SET search_path TO " + schema + ", public")
                    .executeUpdate();
        }
    }

    @Override
    @Transactional
    public List<TaskDto> getAllTasks(String schema) {
        setSchema(schema);
        return taskRepository.findAll()
                .stream().map(task -> modelMapper.map(task, TaskDto.class)).toList();
    }

    @Override
    @Transactional
    public List<TaskDto> getTasksByDueDate(String schema) {
        setSchema(schema);
        return taskRepository.findAllByOrderByDueDateAsc()
                .stream().map(task -> modelMapper.map(task, TaskDto.class)).toList();
    }

    @Override
    @Transactional
    public TaskDto addTask(AddTaskDto addTaskDto, String schema) {
        if (addTaskDto.getTask() == null || addTaskDto.getTask().isEmpty())
            throw new IllegalArgumentException("Task name cannot be empty");
        if (addTaskDto.getDueDate() != null && addTaskDto.getDueDate().isBefore(LocalDate.now()))
            throw new IllegalArgumentException("Due date cannot be in the past");
        if (addTaskDto.getDescription() != null && addTaskDto.getDescription().length() > 200)
            throw new IllegalArgumentException("Description too long. Max 200 characters allowed.");
        setSchema(schema);
        Tasks tasks = modelMapper.map(addTaskDto, Tasks.class);
        return modelMapper.map(taskRepository.save(tasks), TaskDto.class);
    }

    @Override
    @Transactional
    public void deleteTaskById(Long id, String schema) {
        setSchema(schema);
        if (!taskRepository.existsById(id))
            throw new IllegalArgumentException("Task not found");
        taskRepository.deleteById(id);
    }

    @Override
    @Transactional
    public void deleteTaskByTask(String task, String schema) {
        setSchema(schema);
        if (!taskRepository.existsByTaskIgnoreCase(task))
            throw new IllegalArgumentException("Task not found");
        taskRepository.deleteByTaskIgnoreCase(task);
    }

    @Override
    @Transactional
    public TaskDto updateTaskByTask(String task, AddTaskDto addTaskDto, String schema) {
        if (addTaskDto.getTask() == null || addTaskDto.getTask().isEmpty())
            throw new IllegalArgumentException("Task name cannot be empty");
        if (addTaskDto.getDueDate() != null && addTaskDto.getDueDate().isBefore(LocalDate.now()))
            throw new IllegalArgumentException("Due date cannot be in the past");
        if (addTaskDto.getDescription() != null && addTaskDto.getDescription().length() > 200)
            throw new IllegalArgumentException("Description too long. Max 200 characters allowed.");
        setSchema(schema);
        Tasks tasks = taskRepository.findByTaskIgnoreCase(task)
                .orElseThrow(() -> new IllegalArgumentException("Task not found"));
        modelMapper.map(addTaskDto, tasks);
        return modelMapper.map(taskRepository.save(tasks), TaskDto.class);
    }

    @Override
    @Transactional
    public TaskDto partialUpdateTaskByTask(String task, Map<String, Object> updates, String schema) {
        setSchema(schema);
        Tasks tasks = taskRepository.findByTaskIgnoreCase(task)
                .orElseThrow(() -> new IllegalArgumentException("Task not found"));
        updates.forEach((key, value) -> {
            switch (key) {
                case "task" -> {
                    String newTask = (String) value;
                    if (newTask == null || newTask.isEmpty())
                        throw new IllegalArgumentException("Task name cannot be empty");
                    tasks.setTask(newTask);
                }
                case "isCompleted" -> tasks.setIsCompleted((Boolean) value);
                case "description" -> {
                    String desc = (String) value;
                    if (desc.length() > 500) throw new IllegalArgumentException("Description too long");
                    tasks.setDescription(desc);
                }
                case "dueDate" -> {
                    LocalDate newDueDate = LocalDate.parse((String) value);
                    if (newDueDate.isBefore(LocalDate.now()))
                        throw new IllegalArgumentException("Due date cannot be in the past");
                    tasks.setDueDate(newDueDate);
                }
                default -> throw new IllegalArgumentException("Invalid Field");
            }
        });
        return modelMapper.map(taskRepository.save(tasks), TaskDto.class);
    }

    @Override
    @Transactional
    public List<TaskDto> getByStatus(String status, String schema) {
        setSchema(schema);
        List<Tasks> tasks = status.equals("true")
                ? taskRepository.findByIsCompletedTrue()
                : taskRepository.findByIsCompletedFalse();
        return tasks.stream().map(task -> modelMapper.map(task, TaskDto.class)).toList();
    }
}