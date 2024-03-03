defmodule ZenohexPhoenixDemo.ZenohexManager do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(args) do
    session = Map.fetch!(args, :session)
    key_expr = Map.fetch!(args, :key_expr)

    {:ok, subscriber} = Zenohex.Session.declare_subscriber(session, key_expr)
    {:ok, publisher} = Zenohex.Session.declare_publisher(session, key_expr)
    state = %{subscriber: subscriber, publisher: publisher, callback: &callback/1, msgs: []}

    recv_timeout(state)

    {:ok, state}
  end

  def callback(msg) do
    GenServer.cast(__MODULE__, {:callback, msg})
  end

  def handle_cast({:callback, msg}, state) do
    {:noreply, %{state | msgs: [msg.value | state.msgs] }}
  end

  def handle_call(:get_msgs, _form, state) do
    {:reply, state.msgs, state}
  end

  def handle_call({:put, msg}, _form, state) do
    Zenohex.Publisher.put(state.publisher, msg)
    {:reply, state.msgs, state}
  end

  def handle_info(:loop, state) do
    recv_timeout(state)
    {:noreply, state}
  end

  defp recv_timeout(state) do
    case Zenohex.Subscriber.recv_timeout(state.subscriber) do
      {:ok, sample} ->
        state.callback.(sample)
        send(self(), :loop)

      {:error, :timeout} ->
        send(self(), :loop)

      {:error, error} ->
        Logger.error(inspect(error))
    end
  end
end
