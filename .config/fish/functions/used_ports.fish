function used_ports
    sudo lsof -i -P -n | grep LISTEN
end
