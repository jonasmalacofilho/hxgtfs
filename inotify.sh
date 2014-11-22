while true; do
    tput bold
    tput setaf 2
    inotifywait -rq -e modify \
        --excludei ".+(swp|swo|git|hxml)" \
        ./ 2>/dev/null
    tput sgr0
    sleep 1;
    tput setaf 3
    haxe TestAll.neko.hxml
    tput sgr0
    neko TestAll.n
done
