# This should send the image up to docker hub...
cat /var/jenkins_home/my_password.txt | docker login --username schulzdl --password-stdin
docker tag t3winc/hugo:$1 t3winc/hugo:latest
docker push t3winc/hugo:latest