# This should send the image up to docker hub...
cat /var/jenkins_home/my_password.txt | docker login --username schulzdl --password-stdin
docker tag hugo:latest t3winc/hugo:$1
docker push t3winc/hugo:$1