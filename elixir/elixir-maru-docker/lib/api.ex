defmodule Api do
  use Maru.Router
  plug :fetch_query_params

  namespace "hello" do
    get do
      who = conn.params["who"] || "world"
      conn
      |> json(%{data: %{greeting: "Hello, #{who}!"}})
    end
  end

  rescue_from Maru.Exceptions.NotFound do
    conn
    |> put_status(404)
    |> text("Not Found")
  end
end
