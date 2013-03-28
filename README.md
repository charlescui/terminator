<link href="https://raw.github.com/gcollazo/mou-theme-github2/master/GitHub2.css" rel="stylesheet"/>

# Terminator

sinatra开发框架模板

## 根目录

默认根目录`/`是解析README.md内容，作为首页.

## 例子

代码位置
`lib/terminator/app/controller/home.rb`

### /home

这个例子约定了作为webservice的返回数据结构

```
{:status => 0, :msg => 'ok', :data => [1,2,3]}
```

### /home/ansync

这个例子实现了异步长连接的http请求，基于eventmachine，

```
A -> Server
B -> Server
.      .
.      .
.      .
A <- Server
B <- Server
```

用curl测试下

```
saimatoMacBook-Pro:terminator cuizheng$ curl -v localhost:7000/home/async
* About to connect() to localhost port 7000 (#0)
*   Trying ::1... Connection refused
*   Trying 127.0.0.1... connected
* Connected to localhost (127.0.0.1) port 7000 (#0)
> GET /home/async HTTP/1.1
> User-Agent: curl/7.21.4 (universal-apple-darwin11.0) libcurl/7.21.4 OpenSSL/0.9.8r zlib/1.2.5
> Host: localhost:7000
> Accept: */*
> 
< HTTP/1.1 200 OK
< X-Frame-Options: SAMEORIGIN
< X-XSS-Protection: 1; mode=block
< X-Content-Type-Options: nosniff
< Content-Type: text/html;charset=utf-8
< Connection: close
< Server: thin 1.5.0 codename Knife
< 
* Closing connection #0
2013-03-28 17:18:20 +0800Someone comming.2013-03-28 17:18:30 +0800
```

`ab`性能测试结果如下

```
ab -c 100 -n 100 http://218.108.172.21:7000/home/async
This is ApacheBench, Version 2.3 <$Revision: 655654 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 218.108.172.21 (be patient).....done


Server Software:        thin
Server Hostname:        218.108.172.21
Server Port:            7000

Document Path:          /home/async
Document Length:        1634 bytes

Concurrency Level:      100
Time taken for tests:   10.259 seconds
Complete requests:      100
Failed requests:        99
   (Connect: 0, Receive: 0, Length: 99, Exceptions: 0)
Write errors:           0
Total transferred:      104900 bytes
HTML transferred:       84200 bytes
Requests per second:    9.75 [#/sec] (mean)
Time per request:       10259.021 [ms] (mean)
Time per request:       102.590 [ms] (mean, across all concurrent requests)
Transfer rate:          9.99 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        1    2   0.6      2       3
Processing: 10151 10181  44.5  10156   10254
Waiting:       86  113  17.8    114     136
Total:      10155 10184  44.1  10159   10256

Percentage of the requests served within a certain time (ms)
  50%  10159
  66%  10160
  75%  10256
  80%  10256
  90%  10256
  95%  10256
  98%  10256
  99%  10256
 100%  10256 (longest request)
```

平均每个请求10.259秒，而代码中是延迟10秒才返回的，可以看到100个并发并没有发生阻塞，性能没问题。

## Contributing to terminator
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 zheng.cuizh. See LICENSE.txt for
further details.

