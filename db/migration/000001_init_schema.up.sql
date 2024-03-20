CREATE TABLE "entries" (
  "entries_id" bigSerial PRIMARY KEY,
  "user_id" bigSerial NOT NULL,
  "amount" bigint NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "users" (
  "id" bigSerial PRIMARY KEY,
  "username" varchar NOT NULL,
  "currency" varchar NOT NULL,
  "balance" bigint NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "transfers" (
  "transfer_id" bigSerial PRIMARY KEY,
  "from_user_id" bigSerial NOT NULL,
  "to_user_id" bigSerial NOT NULL,
  "amount" bigint NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE INDEX ON "entries" ("user_id");

CREATE INDEX ON "users" ("username");

CREATE INDEX ON "transfers" ("from_user_id");

CREATE INDEX ON "transfers" ("to_user_id");

CREATE INDEX ON "transfers" ("from_user_id", "to_user_id");

COMMENT ON COLUMN "entries"."amount" IS 'It can be both negative and positive';

COMMENT ON COLUMN "transfers"."amount" IS 'It must be positive';

ALTER TABLE "entries" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "transfers" ADD FOREIGN KEY ("from_user_id") REFERENCES "users" ("id");

ALTER TABLE "transfers" ADD FOREIGN KEY ("to_user_id") REFERENCES "users" ("id");
