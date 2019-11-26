### Debian（未测试）

```bash
apt install curl gnupg2 ca-certificates lsb-release

# use stable nginx packages
echo "deb http://nginx.org/packages/debian `lsb_release -cs` nginx" | tee /etc/apt/sources.list.d/nginx.list
# use mainline nginx packages
echo "deb http://nginx.org/packages/mainline/debian `lsb_release -cs` nginx" | tee /etc/apt/sources.list.d/nginx.list

curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -
apt-key fingerprint ABF5BD827BD9BF62

apt-get update
apt-get install nginx
```

### Ubuntu（未测试）


```bash
sudo apt install curl gnupg2 ca-certificates lsb-release

# stable nginx packages
echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx"   | sudo tee /etc/apt/sources.list.d/nginx.list
# mainline nginx packages
echo "deb http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx"   | sudo tee /etc/apt/sources.list.d/nginx.list

curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
sudo apt-key fingerprint ABF5BD827BD9BF62

sudo apt update
sudo apt install nginx
```

### FreeBSD（未测试）

```bash
pkg_install -r nginx
```

### SLES（未测试）

```bash
sudo zypper install curl ca-certificates gpg2

# stable nginx packages
sudo zypper addrepo --gpgcheck --type yum --refresh --check 'http://nginx.org/packages/sles/$releasever' nginx-stable

# mainline nginx packages
sudo zypper addrepo --gpgcheck --type yum --refresh --check  'http://nginx.org/packages/mainline/sles/$releasever' nginx-mainline

curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key

gpg --with-fingerprint /tmp/nginx_signing.key

sudo rpmkeys --import /tmp/nginx_signing.key

sudo zypper install nginx
```

### Alpine（未测试）

```bash
sudo apk add openssl curl ca-certificates

# stable nginx packages
# 格式可能异常，需要确认
printf "%s%s%s\n" "http://nginx.org/packages/alpine/v" `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` "/main" | sudo tee -a /etc/apk/repositories

# mainline nginx packages
# 格式可能异常，需要确认
printf "%s%s%s\n" "http://nginx.org/packages/mainline/alpine/v" `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` "/main" | sudo tee -a /etc/apk/repositories

curl -o /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub

openssl rsa -pubin -in /tmp/nginx_signing.rsa.pub -text -noout

sudo mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/

sudo apk add nginx
```