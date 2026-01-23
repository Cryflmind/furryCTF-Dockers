docker run -dit -v "/home/hydro/q2_redis/logs/run/:/var/run/" -v "/home/hydro/q2_redis/logs:/var/www/logs" -p 10005:80 -p 10008:6379 --read-only q2_redis_redis
