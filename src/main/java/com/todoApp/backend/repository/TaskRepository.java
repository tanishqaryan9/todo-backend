package com.todoApp.backend.repository;

import com.todoApp.backend.entity.Tasks;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
@Transactional
public interface TaskRepository extends JpaRepository<Tasks,Long> {
    List<Tasks> findAllByOrderByDueDateAsc();

    @Modifying
    @Query("DELETE FROM Tasks t WHERE LOWER(t.task) = LOWER(:task)")
    void deleteByTaskIgnoreCase(String task);

    @Query("SELECT CASE WHEN COUNT(t) > 0 THEN true ELSE false END FROM Tasks t WHERE LOWER(t.task) = LOWER(:task)")
    boolean existsByTaskIgnoreCase(String task);

    @Query("SELECT t FROM Tasks t WHERE LOWER(t.task) = LOWER(:task)")
    Optional<Tasks> findByTaskIgnoreCase(@Param("task") String task);

    List<Tasks> findByIsCompletedTrue();

    List<Tasks> findByIsCompletedFalse();
}
