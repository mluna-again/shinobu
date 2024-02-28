if function_exported?(Mix, :target, 0) do
  cwd = File.cwd!()
  project_dir = Path.basename(cwd)
  app_name = Mix.Project.config()[:app]
  {:ok, local_net_interfaces} = :inet.getifaddrs()

  wlan_interface =
    local_net_interfaces
    |> Enum.find({nil, []}, fn {i, _opts} -> String.starts_with?(to_string(i), "w") end)
    |> elem(1)
    |> Keyword.get(:addr)

  ethernet_interface =
    local_net_interfaces
    |> Enum.find({nil, []}, fn {i, _opts} -> String.starts_with?(to_string(i), "e") end)
    |> elem(1)
    |> Keyword.get(:addr)

  local_ip =
    (wlan_interface || ethernet_interface ||
       {127, 0, 0, 1})
    |> Tuple.to_list()
    |> Enum.join(".")

  IEx.configure(
    history_size: 50,
    width: 100,
    default_prompt:
      "#{IO.ANSI.yellow()}(%counter) " <>
        "#{IO.ANSI.blue()}#{app_name || project_dir}" <>
        "#{IO.ANSI.red()}@" <>
        "#{IO.ANSI.magenta()}#{local_ip}#{IO.ANSI.reset()}" <>
        "$",
    continuation_prompt: "..."
  )
end

defmodule IExHelpers do
  def neofetch do
    """
    #{IO.ANSI.magenta()}
                x
               WNX
              Odc:xN
            0ddko,oX                 #{IO.ANSI.yellow()}#{username()}#{IO.ANSI.blue()}@#{IO.ANSI.green()}#{path()}#{IO.ANSI.magenta()}
           kokNWOllOW                -------------------------------
         KdoKWMMNKxl0W               Elixir: #{IO.ANSI.yellow()}#{version()}#{IO.ANSI.magenta()}
        0odXMMMMMMNxoON              Erlang: #{IO.ANSI.yellow()}#{erl_version()}#{IO.ANSI.magenta()}
       0lxNMMMMMMMMW0dd0N
      0oxNMMMMMMMMMMMNOodKW
      odXMMMMMMMMMMMMMMXxokN
     xl0MMMMMMMMMMMMMMMMW0odX
    xoxWMMMMMMMMMMMMMMMMMMKodN
    0lOMMMMMMMMMMMMMMMMMMMWOlO
    OlOMWKXMMMMMMMMMMMMMMMMKlxW
    KlxWXodNMMMMMMMMMMMMMMM0lkW
    xxoKWOlkNMMMMMMMMMMMMMWkl0
     XooKN0ddkKNWWWMMMMMMWOlkW
      XxokXN0kxxkkKMMMMN0doON
       WKxdxk0KKKKXK0OxddkXW
         WNKOxxxxxxxxkOXW
             WWWWWWW
    """
    |> IO.puts()
  end

  defp username do
    System.get_env("USER")
  end

  defp path do
    {:ok, cwd} = File.cwd()
    Path.basename(cwd)
  end

  defp version do
    System.version()
  end

  defp erl_version do
    "OTP #{:erlang.system_info(:otp_release)}"
  end
end
