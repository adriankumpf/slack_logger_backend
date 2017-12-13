ExUnit.start()

defmodule TelegramLoggerBackend.PoolWorkerTest do
  use ExUnit.Case
  alias TelegramLoggerBackend.{PoolWorker}

  setup do
    bypass = Bypass.open()
    url = "http://localhost:#{bypass.port}/hook"
    {:ok, %{bypass: bypass, url: url}}
  end

  test "posts the error to the Telegram incoming webhook", %{
    bypass: bypass,
    url: url
  } do
    Bypass.expect(bypass, fn conn ->
      assert "/hook" == conn.request_path
      assert "POST" == conn.method
      Plug.Conn.resp(conn, 200, "ok")
    end)

    {:ok, pid} = PoolWorker.start_link([])
    {:ok, _} = PoolWorker.post(pid, url, "test")
  end
end
