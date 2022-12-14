#!/bin/bash

# Install Common Tools
sudo yum -y install tcpdump telnet bind-utils zip unzip tcpdump telnet bind-utils wget -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Create Gitlab Repo
curl -s https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
sudo yum install pygpgme yum-utils

# Mount EFS Filesystem
AZ=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
REGION=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/\(.*\)[a-z]/\1/'`
GITLAB_DIR="/var/opt/gitlab"
EFS_FSID_SSH=`/usr/local/bin/aws --region us-east-1 --output text efs describe-file-systems | grep git-ssh | awk '{print $6}'`
EFS_FSID_UPLOADS=`/usr/local/bin/aws --region us-east-1 --output text efs describe-file-systems | grep git-rails-uploads | awk '{print $6}'` 
EFS_FSID_SHARED=`/usr/local/bin/aws --region us-east-1 --output text efs describe-file-systems | grep git-rails-shared | awk '{print $6}'`
EFS_FSID_BUILDS=`/usr/local/bin/aws --region us-east-1 --output text efs describe-file-systems | grep git-builds | awk '{print $6}'` 
EFS_FSID_DATA=`/usr/local/bin/aws --region us-east-1 --output text efs describe-file-systems | grep git-data | awk '{print $6}'`
EFS_PATH_SSH="$AZ.$EFS_FSID_SSH.efs.$REGION.amazonaws.com"
EFS_PATH_UPLOADS="$AZ.$EFS_FSID_UPLOADS.efs.$REGION.amazonaws.com"
EFS_PATH_SHARED="$AZ.$EFS_FSID_SHARED.efs.$REGION.amazonaws.com"
EFS_PATH_BUILDS="$AZ.$EFS_FSID_BUILDS.efs.$REGION.amazonaws.com"
EFS_PATH_DATA="$AZ.$EFS_FSID_DATA.efs.$REGION.amazonaws.com"


mkdir -p $GITLAB_DIR/.ssh \
  $GITLAB_DIR/gitlab-rails/uploads \
  $GITLAB_DIR/gitlab-rails/shared \
  $GITLAB_DIR/gitlab-ci/builds \
  $GITLAB_DIR/git-data

cat >> /etc/fstab << EOF
$EFS_PATH_SSH:/ $GITLAB_DIR/.ssh nfs nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0
$EFS_PATH_UPLOADS:/ $GITLAB_DIR/gitlab-rails/uploads nfs nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0
$EFS_PATH_SHARED:/ $GITLAB_DIR/gitlab-rails/shared nfs nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0
$EFS_PATH_BUILDS:/ $GITLAB_DIR/gitlab-ci/builds nfs nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0
$EFS_PATH_DATA:/ $GITLAB_DIR/git-data nfs nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0
EOF

mount -a 

URL=`aws elbv2 --region=us-east-1 --output=text describe-load-balancers | grep private-apps | awk '{print $4}'`; export URL
EXTERNAL_URL="http://$URL"; export EXTERNAL_URL
yum install -y gitlab-ce

sudo yum install -y git
sudo yum install -y postfix
sudo systemctl enable postfix
sudo systemctl start postfix

# Install OS Patches
sudo yum update -y