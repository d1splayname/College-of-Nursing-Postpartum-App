package config

import (
	"log"
	"os"

	"github.com/joho/godotenv"
)

type Config struct {
	Port        string
	DatabaseURL string
	JWTSecret   string
}

func Load() Config {
	if err := godotenv.Load(); err != nil {
		_ = godotenv.Load("env")
	}

	cfg := Config{
		Port:        getEnv("PORT", "8080"),
		DatabaseURL: getEnv("DATABASE_URL", ""),
		JWTSecret:   getEnv("JWT_SECRET", "dev-secret-change-me"),
	}

	if cfg.DatabaseURL == "" {
		log.Println("DATABASE_URL is not set; the server will start but DB calls will fail until it is configured.")
	}

	return cfg
}

func getEnv(key string, fallback string) string {
	if value, ok := os.LookupEnv(key); ok && value != "" {
		return value
	}
	return fallback
}
