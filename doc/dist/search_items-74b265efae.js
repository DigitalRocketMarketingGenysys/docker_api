searchNodes=[{"doc":"","ref":"DockerApi.html","title":"DockerApi","type":"module"},{"doc":"Callback implementation for Application.start/2 .","ref":"DockerApi.html#start/2","title":"DockerApi.start/2","type":"function"},{"doc":"","ref":"DockerApi.Container.html","title":"DockerApi.Container","type":"module"},{"doc":"","ref":"DockerApi.Container.html#all/0","title":"DockerApi.Container.all/0","type":"function"},{"doc":"Fetch all the containers from a given docker host host: &quot;127.0.0.1&quot; iex&gt; DockerApi.Container.all(&quot;127.0.0.1&quot;) [ %{ ... } , .. ]","ref":"DockerApi.Container.html#all/1","title":"DockerApi.Container.all/1","type":"function"},{"doc":"Fetch all the containers from a given docker host host: &quot;127.0.0.1&quot; opts: %{} See docker API documentation for full list of query parameters iex&gt; DockerApi.Container.all(&quot;127.0.0.1&quot;, %{all: 1}) [ %{ ... } , .. ]","ref":"DockerApi.Container.html#all/2","title":"DockerApi.Container.all/2","type":"function"},{"doc":"","ref":"DockerApi.Container.html#attach/2","title":"DockerApi.Container.attach/2","type":"function"},{"doc":"","ref":"DockerApi.Container.html#changes/2","title":"DockerApi.Container.changes/2","type":"function"},{"doc":"","ref":"DockerApi.Container.html#create/2","title":"DockerApi.Container.create/2","type":"function"},{"doc":"","ref":"DockerApi.Container.html#delete/2","title":"DockerApi.Container.delete/2","type":"function"},{"doc":"Delete a container host: &quot;127.0.0.1&quot; id: &quot;123456&quot; otps: %{}","ref":"DockerApi.Container.html#delete/3","title":"DockerApi.Container.delete/3","type":"function"},{"doc":"","ref":"DockerApi.Container.html#exec/3","title":"DockerApi.Container.exec/3","type":"function"},{"doc":"","ref":"DockerApi.Container.html#exec_start/3","title":"DockerApi.Container.exec_start/3","type":"function"},{"doc":"","ref":"DockerApi.Container.html#find/1","title":"DockerApi.Container.find/1","type":"function"},{"doc":"Find a container when hosts is a String hosts: &quot;127.0.0.1&quot; id: &quot;1234567&quot; iex&gt; DockerApi.Container . find ( &quot;127.0.0.1&quot; , &quot;123456&quot; ) %{ ... }","ref":"DockerApi.Container.html#find/2","title":"DockerApi.Container.find/2","type":"function"},{"doc":"","ref":"DockerApi.Container.html#kill/2","title":"DockerApi.Container.kill/2","type":"function"},{"doc":"Fetch the logs from a container Returns the last 50 entries for stdout and stderr.","ref":"DockerApi.Container.html#logs/2","title":"DockerApi.Container.logs/2","type":"function"},{"doc":"","ref":"DockerApi.Container.html#restart/2","title":"DockerApi.Container.restart/2","type":"function"},{"doc":"","ref":"DockerApi.Container.html#start/2","title":"DockerApi.Container.start/2","type":"function"},{"doc":"","ref":"DockerApi.Container.html#start/3","title":"DockerApi.Container.start/3","type":"function"},{"doc":"","ref":"DockerApi.Container.html#stop/2","title":"DockerApi.Container.stop/2","type":"function"},{"doc":"Top running processes inside the container","ref":"DockerApi.Container.html#top/2","title":"DockerApi.Container.top/2","type":"function"},{"doc":"","ref":"DockerApi.Daemon.html","title":"DockerApi.Daemon","type":"module"},{"doc":"","ref":"DockerApi.Daemon.html#connect/0","title":"DockerApi.Daemon.connect/0","type":"function"},{"doc":"","ref":"DockerApi.Events.html","title":"DockerApi.Events","type":"module"},{"doc":"Stream docker host events in real time This will block until the timeout is reached. iex&gt; DockerApi.Events.all(&quot;127.0.0.1&quot;) [%{...}, ..]","ref":"DockerApi.Events.html#all/1","title":"DockerApi.Events.all/1","type":"function"},{"doc":"Poll docker host events between since and until if until is not supplied the stream will block until the timeout is reached iex&gt; DockerApi.Events.all(&quot;127.0.0.1&quot;, %{since: 1374067924, until: 1425227650}) [%{...}, ..]","ref":"DockerApi.Events.html#all/2","title":"DockerApi.Events.all/2","type":"function"},{"doc":"HTTP handler for all REST calls to the Docker API","ref":"DockerApi.HTTP.html","title":"DockerApi.HTTP","type":"module"},{"doc":"","ref":"DockerApi.HTTP.html#delete/1","title":"DockerApi.HTTP.delete/1","type":"function"},{"doc":"","ref":"DockerApi.HTTP.html#delete/2","title":"DockerApi.HTTP.delete/2","type":"function"},{"doc":"","ref":"DockerApi.HTTP.html#encode_attribute/2","title":"DockerApi.HTTP.encode_attribute/2","type":"function"},{"doc":"","ref":"DockerApi.HTTP.html#encode_query_params/1","title":"DockerApi.HTTP.encode_query_params/1","type":"function"},{"doc":"","ref":"DockerApi.HTTP.html#encode_value/1","title":"DockerApi.HTTP.encode_value/1","type":"function"},{"doc":"GET iex&gt; DockerApi.HTTP . get ( &quot;http://httpbin.org/get&quot; ) { :ok , %{ body : &quot;foo&quot; , headers : _ , status_code : 200 } }","ref":"DockerApi.HTTP.html#get/1","title":"DockerApi.HTTP.get/1","type":"function"},{"doc":"GET with query params opts must be a map iex&gt; DockerApi.HTTP . get ( &quot;http://httpbin.org/get&quot; , %{ foo : 1 } ) { :ok , %{ body : &quot;foo&quot; , headers : _ , status_code : 200 } }","ref":"DockerApi.HTTP.html#get/2","title":"DockerApi.HTTP.get/2","type":"function"},{"doc":"","ref":"DockerApi.HTTP.html#handle_response/1","title":"DockerApi.HTTP.handle_response/1","type":"function"},{"doc":"","ref":"DockerApi.HTTP.html#parse_response/1","title":"DockerApi.HTTP.parse_response/1","type":"function"},{"doc":"POST with optional payload opts must be a map payload is sent as JSON iex&gt; DockerApi.HTTP . post ( &quot;http://httpbin.org/get&quot; , %{ foo : 1 } ) { :ok , %{ body : &quot;foo&quot; , headers : _ , status_code : 200 } }","ref":"DockerApi.HTTP.html#post/2","title":"DockerApi.HTTP.post/2","type":"function"},{"doc":"","ref":"DockerApi.HTTP.html#query_params/1","title":"DockerApi.HTTP.query_params/1","type":"function"},{"doc":"Docker Image API","ref":"DockerApi.Image.html","title":"DockerApi.Image","type":"module"},{"doc":"Get all the images from a docker host iex&gt; DockerApi.all(&quot;127.0.0.1&quot;) [ ]","ref":"DockerApi.Image.html#all/1","title":"DockerApi.Image.all/1","type":"function"},{"doc":"Build an image from a Dockerfile Dockerfile must be a tar file See docker api for query parameters iex&gt; DockerApi.Image(&quot;192.168.4.4:14443&quot;, %{t: &quot;foo&quot;}, &quot;/tmp/docker.tar.gz&quot; [%{&quot;stream&quot; =&gt; &quot;Successfully built 8b4&quot;}, ...]","ref":"DockerApi.Image.html#build/3","title":"DockerApi.Image.build/3","type":"function"},{"doc":"Create an image host: docker host opts: query parameters please see docker api docs for full list of query parameters","ref":"DockerApi.Image.html#create/2","title":"DockerApi.Image.create/2","type":"function"},{"doc":"","ref":"DockerApi.Image.html#delete/3","title":"DockerApi.Image.delete/3","type":"function"},{"doc":"Find a image when hosts is a List hosts: [&quot;127.0.0.1&quot;, 10.10.100.31&quot;] id: &quot;1234567&quot; iex&gt; DockerApi.Image . find ( [ &quot;127.0.0.1&quot; , 10.10 . 100.31 &quot;], &quot; 123456 &quot; ) %{ ... }","ref":"DockerApi.Image.html#find/2","title":"DockerApi.Image.find/2","type":"function"},{"doc":"","ref":"DockerApi.Image.html#history/2","title":"DockerApi.Image.history/2","type":"function"}]