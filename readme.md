# Docker Django Apache image

This image is used to put in production the Django application with docker. This image use apache2 as a web server.

I used this setup when i had multiple virtual hosts on my host computer. To do so, i use the host apache2 as a proxy for the docker apache2.

:443/:80 Host <--> Aapche2 proxy <--> :80 Docker <--> Apache2 <--> Django



