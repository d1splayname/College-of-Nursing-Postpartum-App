package handlers

import (
	"database/sql"
	"encoding/json"
	"net/http"
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

	response := models.LoginResponse{
		Token: token,
		User: models.PublicUser{
			ID:           user.ID,
			Username:     user.Username,
			RegisteredAt: user.RegisteredAt,
			Active:       user.Active,
			IsAdmin:      user.IsAdmin,
		},
	}

	if user.LastLoginTime.Valid {
		v := user.LastLoginTime.Time
		response.User.LastLoginTime = &v
	}

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
