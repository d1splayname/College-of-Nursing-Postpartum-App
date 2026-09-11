package handlers

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"
	"strings"
	"time"

	"golang.org/x/crypto/bcrypt"

	"nursing-ai/internal/auth"
	"nursing-ai/internal/models"
	"nursing-ai/internal/repository"
)

type AuthHandler struct {
	Repo      *repository.UserRepository
	JWTSecret string
}

func setCORS(w http.ResponseWriter) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
}

func setSessionCookie(w http.ResponseWriter, token string) {
	http.SetCookie(w, &http.Cookie{
		Name:     "session",
		Value:    token,
		Path:     "/",
		HttpOnly: true,
		SameSite: http.SameSiteLaxMode,
		MaxAge:   24 * 60 * 60,
	})
}

func publicUser(user *models.User) models.PublicUser {
	response := models.PublicUser{
		ID:           user.ID,
		Username:     user.Username,
		RegisteredAt: user.RegisteredAt,
		Active:       user.Active,
		IsAdmin:      user.IsAdmin,
	}
	if user.LastLoginTime.Valid {
		lastLogin := user.LastLoginTime.Time
		response.LastLoginTime = &lastLogin
	}
	return response
}

func (h *AuthHandler) Signup(w http.ResponseWriter, r *http.Request) {
	setCORS(w)
	if r.Method == http.MethodOptions {
		w.WriteHeader(http.StatusNoContent)
		return
	}
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req models.SignupRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "invalid JSON", http.StatusBadRequest)
		return
	}
	req.Username = strings.TrimSpace(req.Username)
	req.Name = strings.TrimSpace(req.Name)
	if req.Name == "" || req.Username == "" || req.Password == "" {
		http.Error(w, "name, username, and password are required", http.StatusBadRequest)
		return
	}
	if len(req.Password) < 8 {
		http.Error(w, "password must be at least 8 characters", http.StatusBadRequest)
		return
	}

	existing, err := h.Repo.GetByUsername(req.Username)
	if err != nil {
		log.Printf("signup username lookup failed for %q: %v", req.Username, err)
		http.Error(w, "database lookup failed", http.StatusInternalServerError)
		return
	}
	if existing != nil {
		http.Error(w, "username is already registered", http.StatusConflict)
		return
	}

	hash, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		http.Error(w, "failed to secure password", http.StatusInternalServerError)
		return
	}
	userID, err := h.Repo.CreateUser(req.Name, req.Username, string(hash))
	if err != nil {
		log.Printf("signup insert failed for %q: %v", req.Username, err)
		http.Error(w, "failed to create account", http.StatusInternalServerError)
		return
	}
	user, err := h.Repo.GetByID(userID)
	if err != nil || user == nil {
		log.Printf("signup reload failed for %q (id %d): %v", req.Username, userID, err)
		http.Error(w, "failed to load created account", http.StatusInternalServerError)
		return
	}

	token, err := auth.GenerateToken(h.JWTSecret, user.ID, user.Username, user.IsAdmin)
	if err != nil {
		http.Error(w, "failed to generate token", http.StatusInternalServerError)
		return
	}
	setSessionCookie(w, token)
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	_ = json.NewEncoder(w).Encode(models.LoginResponse{
		Token: token,
		User:  publicUser(user),
	})
}

func (h *AuthHandler) Login(w http.ResponseWriter, r *http.Request) {
	setCORS(w)
	if r.Method == http.MethodOptions {
		w.WriteHeader(http.StatusNoContent)
		return
	}
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req models.LoginRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "invalid JSON", http.StatusBadRequest)
		return
	}

	if req.Username == "" || req.Password == "" {
		http.Error(w, "username and password are required", http.StatusBadRequest)
		return
	}

	user, err := h.Repo.GetByUsername(req.Username)
	if err != nil {
		http.Error(w, "database lookup failed", http.StatusInternalServerError)
		return
	}
	if user == nil {
		http.Error(w, "invalid credentials", http.StatusUnauthorized)
		return
	}
	if !user.Active {
		http.Error(w, "user is inactive", http.StatusUnauthorized)
		return
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(req.Password)); err != nil {
		http.Error(w, "invalid credentials", http.StatusUnauthorized)
		return
	}

	if err := h.Repo.UpdateLastLogin(user.ID); err != nil {
		http.Error(w, "failed to update login time", http.StatusInternalServerError)
		return
	}

	token, err := auth.GenerateToken(h.JWTSecret, user.ID, user.Username, user.IsAdmin)
	if err != nil {
		http.Error(w, "failed to generate token", http.StatusInternalServerError)
		return
	}

	setSessionCookie(w, token)
	response := models.LoginResponse{Token: token, User: publicUser(user)}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	_ = json.NewEncoder(w).Encode(response)
}

func (h *AuthHandler) GetUsers(w http.ResponseWriter, r *http.Request) {
	setCORS(w)
	if r.Method == http.MethodOptions {
		w.WriteHeader(http.StatusNoContent)
		return
	}
	if r.Method != http.MethodGet {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	users, err := h.Repo.ListUsers()
	if err != nil {
		http.Error(w, "failed to fetch users", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(users)
}

func (h *AuthHandler) Ping(w http.ResponseWriter, r *http.Request) {
	setCORS(w)
	if r.Method == http.MethodOptions {
		w.WriteHeader(http.StatusNoContent)
		return
	}
	if r.Method != http.MethodGet {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string]string{
		"status": "ok",
		"time":   time.Now().UTC().Format(time.RFC3339),
	})
}

func GetDBUser(db *sql.DB, username string) (*models.User, error) {
	return nil, nil
}
