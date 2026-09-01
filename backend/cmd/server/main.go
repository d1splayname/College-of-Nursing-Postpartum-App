package main

import (
	"fmt"
	"log"
	"net/http"

	"nursing-ai/internal/config"
	"nursing-ai/internal/db"
	"nursing-ai/internal/handlers"
	"nursing-ai/internal/repository"
)

func main() {
	cfg := config.Load()

	database, err := db.Open(cfg.DatabaseURL)
	if err != nil {
		log.Fatalf("failed to connect to database: %v", err)
	}
	defer database.Close()

	repo := &repository.UserRepository{DB: database}
	authHandler := &handlers.AuthHandler{
		Repo:     repo,
		JWTSecret: cfg.JWTSecret,
	}

	http.HandleFunc("/health", authHandler.Ping)
	http.HandleFunc("/api/login", authHandler.Login)
	http.HandleFunc("/api/users", authHandler.GetUsers)

	fmt.Printf("Server running on http://localhost:%s\n", cfg.Port)
	if err := http.ListenAndServe(":"+cfg.Port, nil); err != nil {
		log.Fatalf("server failed: %v", err)
	}
}
