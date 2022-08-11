#!/bin/bash
echo "Install common tools" 
yum install -y tcpdump telnet bind-utils wget zip unzip nfs-utils pygpgme yum-utils 
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

echo "Install Jenkins stable release" 
yum remove -y java 
yum install -y java-1.8.0-openjdk 
JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk-1.8.0.191.b12-1.el7_6.x86_64/; export JAVA_HOME 
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo 
rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key 
yum install -y jenkins 
sed -i 's/\/var\/lib\/jenkins/\/jenkins/g' /etc/sysconfig/jenkins 
sed -i 's/jenkins:\/bin\/false/jenkins:\/bin\/bash/g' /etc/passwd 
chown jenkins:jenkins /jenkins 
# mv $JENKINS_DIR/* /jenkins 

# Add jenkins user to the root group to enable building docker containers 
sudo usermod -a -G root jenkins 
chkconfig jenkins on 
service jenkins start


echo "install jq utility - JSON Parser" 
wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -O jq 
chmod +x jq 
mv jq /usr/local/bin

echo "install golang"
curl -LO https://storage.googleapis.com/golang/go1.18.linux-amd64.tar.gz 
tar -C /usr/local -xvzf go1.18.linux-amd64.tar.gz 
export GOPATH="/tmp" 
export GOBIN="/tmp"

echo "install aws ecr credentials helper for Jenkins" 
/usr/local/go/bin/go install github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cli/docker-credential-ecr-login@latest
cp /tmp/docker-credential-ecr-login /usr/local/bin 
echo "adding credential lookup function for docker"
sed -i.bak '2i\
  "credsStore": "ecr-login",\
' ~/.docker/config.json

echo "Install Groovy" 
curl -s get.sdkman.io | bash 
source "$HOME/.sdkman/bin/sdkman-init.sh" 
sdk install groovy 
groovy -version

echo "Install Docker engine" 
yum-config-manager --enable rhui-REGION-rhel-server-extras 
yum install -y docker 
usermod -a G docker ec2-user 
service docker start

echo "Install git" 
yum install -y git

echo "Setup SSH key" 
JENKINS_HOME=/var/lib/jenkins 
mkdir /var/lib/jenkins/.ssh 
touch /var/lib/jenkins/.ssh/known_hosts 
ssh-keygen -t rsa -b 2048 -f /var/lib/jenkins/.ssh/id_rsa -N ""
chmod 700 $JENKINS_HOME/.ssh 
chmod 644 $JENKINS_HOME/.ssh/id_rsa.pub 
chmod 600 $JENKINS_HOME/.ssh/id_rsa 
chown -R jenkins jenkins $JENKINS_HOME/.ssh

# Patch OS 
echo "Install OS Patches" 
yum update y

