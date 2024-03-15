defmodule ZenohexPhoenixDemoWeb.ZenohexLive do
  use ZenohexPhoenixDemoWeb, :live_view
  alias Zenohex.Examples.Subscriber
  def mount(_param, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 500)

    socket = socket
    |> assign(:msgs, "")
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1 class="mb-4 text-4xl font-extrabold leading-none tracking-tight text-gray-900 md:text-5xl lg:text-6xl">Zenohex demo</h1>
    <button phx-click="pub" class="focus:outline-none text-white bg-purple-700 hover:bg-purple-800 focus:ring-4 focus:ring-purple-300 font-medium rounded-lg text-sm px-5 py-2.5 mb-2 dark:bg-purple-600 dark:hover:bg-purple-700 dark:focus:ring-purple-900"> Pubish Message</button>
    <div>
      <label>subscribe</label>
      <textarea rows=20 class="block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"><%= @msgs %></textarea>
    </div>
    <button phx-click="clear" class="focus:outline-none text-white bg-purple-700 hover:bg-purple-800 focus:ring-4 focus:ring-purple-300 font-medium rounded-lg text-sm px-5 py-2.5 mb-2 dark:bg-purple-600 dark:hover:bg-purple-700 dark:focus:ring-purple-900"> Clear</button>
    """
  end

  def handle_event("pub", _value, socket) do
    GenServer.call(ZenohexPhoenixDemo.ZenohexManager, {:put, "Pub from Elixir/Phoenix!"})
    {:noreply, socket}
  end

  def handle_event("clear", _value, socket) do
    GenServer.call(ZenohexPhoenixDemo.ZenohexManager, :clear_msgs)
    {:noreply, socket}
  end

  def handle_cast({:callback, msg}, _from, socket) do
    socket = update(socket, :zenoh_sub_status, fn msgs -> msgs <> msg end)
    {:noreply, socket}
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 500)
    msgs = GenServer.call(ZenohexPhoenixDemo.ZenohexManager, :get_msgs)
    |> Enum.join("\n")
    {:noreply, assign(socket, :msgs, msgs)}
  end
end
