defmodule SimplechatWeb.ChatChannel do
  use SimplechatWeb, :channel

  alias SimplechatWeb.Presence
  @impl true
  def join("chat:lobby",  %{"id" => id}, socket) do
    if authorized?(id) do
      send(self(), :after_join)
      {:ok, assign(socket, :user_id, id)}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (chat:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    Presence.track(socket, socket.assigns.user_id, %{
      online_at: inspect(System.system_time(:second))
    })
    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end

  def id(socket), do: "user_socket:#{socket.assigns.user_id}"

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
