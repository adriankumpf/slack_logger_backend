defmodule TelegramLoggerBackend.FormatHelper do
  @moduledoc """
  Simple formatter for Telegram messages.
  """

  import Poison, only: [encode: 1]

  @doc """
  Formats a log event for Telegram.
  """
  def format_event({level, message, module, function, file, line}) do
    {:ok, event} =
      %{
        attachments: [
          %{
            fallback: "An #{level} level event has occurred: #{message}",
            pretext: message,
            fields: [
              %{ title: "Level", value: level, short: true },
              %{ title: "Module", value: module, short: true },
              %{ title: "Function", value: function, short: true },
              %{ title: "File", value: file, short: true },
              %{ title: "Line", value: line, short: true }
            ]
          }
        ]
      }
      |> encode

    event
  end

  def format_event({level, message, application, module, function, file, line}) do
    {:ok, event} =
      %{
        attachments: [
          %{
            fallback: "An #{level} level event has occurred: #{message}",
            pretext: message,
            fields: [
              %{ title: "Level", value: level, short: true },
              %{ title: "Application", value: application, short: true },
              %{ title: "Module", value: module, short: true },
              %{ title: "Function", value: function, short: true },
              %{ title: "File", value: file, short: true },
              %{ title: "Line", value: line, short: true }
            ]
          }
        ]
      }
      |> encode

    event
  end
end
