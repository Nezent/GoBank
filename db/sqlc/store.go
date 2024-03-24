package db

import (
	"context"
	"database/sql"
	"fmt"
)

type Store struct {
	*Queries
	db *sql.DB
}

func NewStore(db *sql.DB) *Store {
	return &Store {
		db: db,
		Queries: New(db),
	}
}

func (store *Store) execTx(ctx context.Context, fn func(*Queries) error) error {
	tx, err := store.db.BeginTx(ctx,nil)
	if err != nil {
		return err
	}

	q := New(tx)
	err = fn(q)
	if err != nil {
		if rbErr := tx.Rollback(); rbErr != nil {
			return fmt.Errorf("tx err: %v, rb err: %v",err,rbErr)

		}
		return err
	}
	return tx.Commit()
}


type TransferTxParams struct {
	FromUserID int64 `json:"from_user_id"`
	ToUserID int64 `json:"to_user_id"`
	Amount int64 `json:"amount"`
}

type TransferResult struct {
	Transfer Transfer `json:"transfer"`
	FromUser User `json:"from_user"`
	ToUser User `json:"to_user"`
	FromEntry Entry `json:"from_entry"`
	ToEntry Entry `json:"to_entry"`

}

func (store *Store) TransferTx(ctx context.Context, arg TransferTxParams) (TransferResult, error) {
	var result TransferResult

	err := store.execTx(ctx, func(q *Queries) error {
		var err error

		result.Transfer, err = q.CreateTransfer(ctx,CreateTransferParams{
			FromUserID: arg.FromUserID,
			ToUserID: arg.ToUserID,
			Amount: arg.Amount,
		})

		if err != nil {
			return err
		}

		result.FromEntry, err = q.CreateEntry(ctx, CreateEntryParams{
			UserID: arg.FromUserID,
			Amount: -arg.Amount,
		})

		if err != nil {
			return err
		}

		result.ToEntry, err = q.CreateEntry(ctx, CreateEntryParams{
			UserID: arg.ToUserID,
			Amount: arg.Amount,
		})

		if err != nil {
			return err
		}
		return nil
	})

	return result, err
}