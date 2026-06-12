watch -t -n 1 'ps -C '$1' -o comm=,rss= | awk '\''{printf "%s | RAM: %.2f MB | RSS: %d KB\n", $1, $2/1024, $2}'\'''
