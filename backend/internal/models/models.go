package models

import (
	"database/sql"
	"time"
)

type User struct {
	ID            int64        `json:"id"`
	Username      string       `json:"username"`
	PasswordHash  string       `json:"-"`
	RegisteredAt  time.Time    `json:"registered_time"`
	LastLoginTime sql.NullTime `json:"last_login_time,omitempty"`
	ResetPassword sql.NullString `json:"reset_password,omitempty"`
	Active        bool         `json:"active"`
	IsAdmin       bool         `json:"is_admin"`
}

type LoginRequest struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

type PublicUser struct {
	ID            int64      `json:"id"`
	Username      string     `json:"username"`
	RegisteredAt  time.Time  `json:"registered_time"`
	LastLoginTime *time.Time `json:"last_login_time,omitempty"`
	Active        bool       `json:"active"`
	IsAdmin       bool       `json:"is_admin"`
}

type LoginResponse struct {
	Token string      `json:"token"`
	User  PublicUser  `json:"user"`
}
