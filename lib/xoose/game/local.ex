defmodule Xoose.Game.Local do
  @doc """
  Rules for a local game

    pid = Xoose.Game.Local.spawn_link(5)

    Xoose.Processes.request(pid, {:players, nil}) |> Task.await()
  """

  require Logger

  alias Xoose.Game
  alias Xoose.Player

  def spawn_link(players_n) do
    Kernel.spawn_link(fn -> init(players_n) end)
  end

  def init(players_n) do
    Logger.debug("[Xoose.Game.Local] init")

    %Game{type: :local, pids: start_players(players_n), players: []}
    |> Game.refresh_players()
    |> Game.assign(:xooser)
    |> Game.loop()
  end

  # Function to start players and return players pids
  defp start_players(players_n) do
    Logger.debug("[Xoose.Game.Local] start_players #{players_n}")

    Enum.map(1..players_n, fn id ->
      Player.spawn_link(id)
    end)
  end
end