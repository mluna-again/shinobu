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
      "#{IO.ANSI.yellow()}(%counter)#{IO.ANSI.reset()} " <>
        "#{IO.ANSI.blue()}#{app_name || project_dir}#{IO.ANSI.reset()}" <>
        "@" <>
        "#{IO.ANSI.magenta()}#{local_ip}#{IO.ANSI.reset()}" <>
        ">"
  )
end
