## PHP on centOS/httpd

Troubleshooting the PHP tracer in CentOS/httpd

### 1 - The tracer cannot connect to the agent by default

![SElinux Error](https://p-qkfgo2.t2.n0.cdn.getcloudapp.com/items/X6u9qnLP/6fc17106-2bcc-4e85-8f36-11abfa2a7e84.png?v=65f2f504e2027dff7c69dcfa6e06dd23)

The php tracer is not able to connect to the agent OOTB if SElinux is enabled (SElinux is enabled by default in CentOS, RHEL, and Fedora). The fix to this issue was not included in the startup script so you will be able to reproduce and solve this issue yourself.

**Fix:**
```
sudo setsebool -P httpd_can_network_connect 1
```
As noted by Luca in the github issue: You might want to vet this solution with your system admin before. If this is the case there might be other approaches that your system admin can recommend.

**Sources:**

- Github issue: https://github.com/DataDog/dd-trace-php/issues/646

- Stackoverflow thread: https://stackoverflow.com/questions/25338295/getting-permission-denied-while-posting-xml-using-curl/27038088#27038088

### 2 - Setting env vars in httpd.conf

You can set env vars in the /etc/httpd/conf/httpd.conf file:

![DD_TRACE_DEBUG](https://p-qkfgo2.t2.n0.cdn.getcloudapp.com/items/bLugzw0l/bae7f9ff-5235-4a7a-a3e9-4b9cfe77a31b.png?v=d3d5cd4bb7ec7fca373e73d6ab2cc82d)

 Once you have done this, you will need to restart the server:
```
sudo systemctl restart httpd.service
```
By default, the debug tracer logs are located in `/var/log/httpd/error_log` and you can see them by running:
```
sudo less /var/log/httpd/error_log
```
Note: `"debug":true` will not be reflected in `php --ri=ddtrace`, but only in `<?php phpinfo(); ?>`

### Usage:

Visit `http://localhost:8080/` in your browser. This will bring you onto the `<?php phpinfo(); ?>` page and create traces that look like this:

![sample trace](https://p-qkfgo2.t2.n0.cdn.getcloudapp.com/items/KouZ0wnn/93d37ea3-ac0d-49e7-9e8f-004de55cdcd7.png?v=3a41f2dc531a7f3b26518777383a70da)
