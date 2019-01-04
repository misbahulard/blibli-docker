if [[ ${GET_HOSTS_FROM:-dns} == "env" ]]; then
  redis-server --slaveof ${REDIS_SERVICE_HOST} 6379
else
  redis-server --slaveof redis-master 6379
fi
