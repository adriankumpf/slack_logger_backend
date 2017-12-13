defmodule TelegramLoggerBackend.Formatter do
  @moduledoc """
  Formats log events into pretty Telegram messages.
  """

  use GenStage

  alias TelegramLoggerBackend.{Producer, FormatHelper}

  @doc false
  def start_link(max_demand, min_demand) do
    GenStage.start_link(__MODULE__, {max_demand, min_demand}, name: __MODULE__)
  end

  @doc false
  def init({max_demand, min_demand}) do
    {
      :producer_consumer,
      %{},
      subscribe_to: [{Producer, max_demand: max_demand, min_demand: min_demand}]
    }
  end

  @doc false
  def handle_events(events, _from, state) do
    {:noreply, Enum.map(events, &format_event/1), state}
  end

  defp format_event({url, event}) do
    {url, FormatHelper.format_event(event)}
  end
end
