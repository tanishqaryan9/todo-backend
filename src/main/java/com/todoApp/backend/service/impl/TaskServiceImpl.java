package com.todoApp.backend.service.impl;

import com.todoApp.backend.dto.AddTaskDto;
import com.todoApp.backend.dto.TaskDto;
import com.todoApp.backend.entity.Tasks;
import com.todoApp.backend.repository.TaskRepository;
import com.todoApp.backend.service.TaskService;
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

    @Override
    public List<TaskDto> getAllTasks() {
        List<Tasks> tasks=taskRepository.findAll();
        return tasks.stream().map(task -> modelMapper.map(task, TaskDto.class)).toList();
    }

    @Override
    public List<TaskDto> getTasksByDueDate() {
        List<Tasks> tasks=taskRepository.findAllByOrderByDueDateAsc();
        return tasks.stream().map(task -> modelMapper.map(task,TaskDto.class)).toList();
    }

    @Override
    public TaskDto addTask(AddTaskDto addTaskDto) {
        if(addTaskDto.getTask() == null || addTaskDto.getTask().isEmpty()) {
            throw new IllegalArgumentException("Task name cannot be empty");
        }
        if(addTaskDto.getDueDate() != null && addTaskDto.getDueDate().isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("Due date cannot be in the past");
        }
        if(addTaskDto.getDescription() != null && addTaskDto.getDescription().length() > 200) {
            throw new IllegalArgumentException("Description too long. Max 500 characters allowed.");
        }
        Tasks tasks=modelMapper.map(addTaskDto,Tasks.class);
        Tasks savedTasks=taskRepository.save(tasks);
        return modelMapper.map(savedTasks,TaskDto.class);
    }

    @Override
    public void deleteTaskById(Long id) {
        if(!taskRepository.existsById(id))
        {
            throw new IllegalArgumentException("Task not found");
        }
        taskRepository.deleteById(id);
    }

    @Override
    public void deleteTaskByTask(String task) {
        if(!taskRepository.existsByTaskIgnoreCase(task))
        {
            throw new IllegalArgumentException("Task not found");
        }
        taskRepository.deleteByTaskIgnoreCase(task);
    }

    @Override
    public TaskDto updateTaskByTask(String task, AddTaskDto addTaskDto) {
        if(addTaskDto.getTask() == null || addTaskDto.getTask().isEmpty()) {
            throw new IllegalArgumentException("Task name cannot be empty");
        }
        if(addTaskDto.getDueDate() != null && addTaskDto.getDueDate().isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("Due date cannot be in the past");
        }
        if(addTaskDto.getDescription() != null && addTaskDto.getDescription().length() > 200) {
            throw new IllegalArgumentException("Description too long. Max 500 characters allowed.");
        }
        Tasks tasks=taskRepository.findByTaskIgnoreCase(task).orElseThrow(()-> new IllegalArgumentException("Task not found"));
        modelMapper.map(addTaskDto,tasks);
        Tasks updatedTask=taskRepository.save(tasks);
        return modelMapper.map(updatedTask,TaskDto.class);
    }

    @Override
    public TaskDto partialUpdateTaskByTask(String task, Map<String,Object> updates) {
        Tasks tasks=taskRepository.findByTaskIgnoreCase(task).orElseThrow(()-> new IllegalArgumentException("Task not found"));
        updates.forEach((key,value)-> {
            switch (key)
            {
                case "task":
                    String newTask = (String) value;
                    if(newTask == null || newTask.isEmpty()) {
                        throw new IllegalArgumentException("Task name cannot be empty");
                    }
                    tasks.setTask(newTask);
                    break;
                case "isCompleted": tasks.setIsCompleted((Boolean) value);
                    break;
                case "description":
                    String desc = (String) value;
                    if(desc.length() > 500) throw new IllegalArgumentException("Description too long");
                    tasks.setDescription(desc);
                    break;
                case "dueDate":
                    LocalDate newDueDate = LocalDate.parse((String) value);
                    if(newDueDate.isBefore(LocalDate.now())) {
                        throw new IllegalArgumentException("Due date cannot be in the past");
                    }
                    tasks.setDueDate(newDueDate);
                    break;
                default:
                    throw new IllegalArgumentException("Invalid Field");
            }
        }
        );
        Tasks newtasks=taskRepository.save(tasks);
        return modelMapper.map(newtasks,TaskDto.class);
    }

    @Override
    public List<TaskDto> getByStatus(String status) {
        List<Tasks> tasks;
        if (status.equals("true")) {
            tasks = taskRepository.findByIsCompletedTrue();
        } else {
            tasks = taskRepository.findByIsCompletedFalse();
        }
        return tasks.stream().map(task -> modelMapper.map(task, TaskDto.class)).toList();
    }
}
