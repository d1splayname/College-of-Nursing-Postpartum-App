package repository

import (
	"database/sql"
	"errors"
	"fmt"
	"time"

	"nursing-ai/internal/models"
)

type UserRepository struct {
	DB *sql.DB
}

func (r *UserRepository) GetByUsername(username string) (*models.User, error) {
	row := r.DB.QueryRow(`
		SELECT id, username, password_hash, registered_time, last_login_time, reset_password, active, is_admin
		FROM `+"`user`"+`
		WHERE username = ?
	`, username)

	var user models.User
	if err := row.Scan(
		&user.ID,
		&user.Username,
		&user.PasswordHash,
		&user.RegisteredAt,
		&user.LastLoginTime,
		&user.ResetPassword,
		&user.Active,
		&user.IsAdmin,
	); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil
		}
		return nil, err
	}

	return &user, nil
}

func (r *UserRepository) UpdateLastLogin(userID int64) error {
	_, err := r.DB.Exec(`
		UPDATE `+"`user`"+`
		SET last_login_time = ?
		WHERE id = ?
	`, time.Now(), userID)
	return err
}

func (r *UserRepository) CreateUser(username, passwordHash string) (int64, error) {
	result, err := r.DB.Exec(`
		INSERT INTO `+"`user`"+` (username, password_hash, registered_time, active, is_admin)
		VALUES (?, ?, NOW(), 1, 0)
	`, username, passwordHash)
	if err != nil {
		return 0, err
	}

	id, err := result.LastInsertId()
	if err != nil {
		return 0, err
	}
	return id, nil
}

func (r *UserRepository) CheckPasswordByUsername(username, passwordHash string) (*models.User, error) {
	row := r.DB.QueryRow(`
		SELECT id, username, password_hash, registered_time, last_login_time, reset_password, active, is_admin
		FROM `+"`user`"+`
		WHERE username = ? AND password_hash = ?
	`, username, passwordHash)

	var user models.User
	if err := row.Scan(
		&user.ID,
		&user.Username,
		&user.PasswordHash,
		&user.RegisteredAt,
		&user.LastLoginTime,
		&user.ResetPassword,
		&user.Active,
		&user.IsAdmin,
	); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil
		}
		return nil, err
	}
	return &user, nil
}

func (r *UserRepository) ListUsers() ([]models.PublicUser, error) {
	rows, err := r.DB.Query(`
		SELECT id, username, registered_time, last_login_time, active, is_admin
		FROM `+"`user`"+`
		ORDER BY id ASC
	`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var users []models.PublicUser
	for rows.Next() {
		var user models.PublicUser
		var lastLogin sql.NullTime
		if err := rows.Scan(
			&user.ID,
			&user.Username,
			&user.RegisteredAt,
			&lastLogin,
			&user.Active,
			&user.IsAdmin,
		); err != nil {
			return nil, err
		}
		if lastLogin.Valid {
			v := lastLogin.Time
			user.LastLoginTime = &v
		}
		users = append(users, user)
	}

	if err := rows.Err(); err != nil {
		return nil, err
	}

	return users, nil
}

func (r *UserRepository) GetByID(id int64) (*models.User, error) {
	row := r.DB.QueryRow(`
		SELECT id, username, password_hash, registered_time, last_login_time, reset_password, active, is_admin
		FROM `+"`user`"+`
		WHERE id = ?
	`, id)

	var user models.User
	if err := row.Scan(
		&user.ID,
		&user.Username,
		&user.PasswordHash,
		&user.RegisteredAt,
		&user.LastLoginTime,
		&user.ResetPassword,
		&user.Active,
		&user.IsAdmin,
	); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil
		}
		return nil, err
	}
	return &user, nil
}

func (r *UserRepository) ValidateUser(username, passwordHash string) (*models.User, error) {
	user, err := r.GetByUsername(username)
	if err != nil {
		return nil, err
	}
	if user == nil {
		return nil, fmt.Errorf("user not found")
	}
	if !user.Active {
		return nil, fmt.Errorf("user is inactive")
	}
	if user.PasswordHash != passwordHash {
		return nil, fmt.Errorf("invalid credentials")
	}
	return user, nil
}
