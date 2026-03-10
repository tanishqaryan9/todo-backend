package com.todoApp.backend.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AddTaskDto {

    private Long id;

    private String task;

    @JsonProperty("isCompleted")
    private Boolean isCompleted=false;

    private LocalDate dueDate;

    private String description;
}
