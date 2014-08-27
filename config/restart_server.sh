echo $(cat ./tmp/pids/unicorn.pid)

kill -s USR2 $(cat ./tmp/pids/unicorn.pid)
sleep 1
echo $(cat ./tmp/pids/unicorn.pid)
