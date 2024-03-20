postgres:
	docker run --name postgresDB -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=anon -d postgres:16-alpine
createdb:
	docker exec -it postgresDB createdb --username=root --owner=root simplebank
dropdb:
	docker exec -it postgresDB dropdb simplebank
migrateup:
	migrate -path db/migration -database "postgresql://root:anon@localhost:5432/simplebank?sslmode=disable" -verbose up
migratedown:
	migrate -path db/migration -database "postgresql://root:anon@localhost:5432/simplebank?sslmode=disable" -verbose down
sqlc:
	sqlc generate
test:
	go test -v -cover ./...

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test