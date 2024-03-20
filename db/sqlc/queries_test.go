package db

import (
	"context"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestCreateUser(t *testing.T) {
	args := CreateUserParams{
		Username: "Tom",
		Currency: "USD",
		Balance: 100,
	}

	user, err := testQueries.CreateUser(context.Background(),args)
	require.NoError(t,err)
	require.NotEmpty(t,user)
	require.Equal(t,args.Username,user.Username)
	require.Equal(t,args.Balance,user.Balance)
	require.Equal(t,args.Currency,user.Currency)

	require.NotZero(t, user.ID)
	require.NotZero(t,user.CreatedAt)
}