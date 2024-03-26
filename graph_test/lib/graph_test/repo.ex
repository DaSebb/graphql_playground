defmodule GraphTest.Repo do
  use Ecto.Repo,
    otp_app: :graph_test,
    adapter: Ecto.Adapters.Postgres
end
