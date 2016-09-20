defmodule RaliGuardian.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION citext;")

    create table(:users) do
      add :name, :string
      add :email, :citext

      timestamps
    end

    create index(:users, [:email], unique: true)
  end
end
