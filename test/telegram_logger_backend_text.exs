ExUnit.start()

defmodule TelegramLoggerBackendTest do
  use ExUnit.Case
  require Logger

  setup do
    bypass = Bypass.open()
    url = "http://localhost:#{bypass.port}/hook"
    Application.put_env(TelegramLoggerBackend, :telegram, url: url)
    System.put_env("SLACK_LOGGER_WEBHOOK_URL", url)
    {:ok, _} = Logger.add_backend(TelegramLoggerBackend.Logger, flush: true)
    Application.put_env(TelegramLoggerBackend, :levels, [:debug, :info, :warn, :error])
    TelegramLoggerBackend.start(nil, nil)

    on_exit(fn ->
      Logger.remove_backend(TelegramLoggerBackend.Logger, flush: true)
      TelegramLoggerBackend.stop(nil)
    end)

    {:ok, %{bypass: bypass}}
  end

  test "posts the error to the Telegram incoming webhook", %{bypass: bypass} do
    Application.put_env(TelegramLoggerBackend, :levels, [:error])

    on_exit(fn ->
      Application.put_env(TelegramLoggerBackend, :levels, [:debug, :info, :warn, :error])
    end)

    Bypass.expect(bypass, fn conn ->
      assert "/hook" == conn.request_path
      assert "POST" == conn.method
      Plug.Conn.resp(conn, 200, "ok")
    end)

    Logger.error("This error should be logged to Telegram")
    Logger.flush()
    :timer.sleep(100)
  end

  test "doesn't post a debug message to Telegram if the level is not set", %{bypass: bypass} do
    Application.put_env(TelegramLoggerBackend, :levels, [:info])

    on_exit(fn ->
      Application.put_env(TelegramLoggerBackend, :levels, [:debug, :info, :warn, :error])
    end)

    Bypass.expect(bypass, fn _conn ->
      flunk("Telegram should not have been notified")
    end)

    Bypass.pass(bypass)

    Logger.error("This error should not be logged to Telegram")
    Logger.flush()
    :timer.sleep(100)
  end
end
