# Composer

## 安装

```bash
# CentOS 8 mini
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'a5c698ffe4b8e849a443b120cd5ba38043260d5c4023dbf93e1558871f1f07f58274fc6f4c93bcfd858c6bd0775cd8d1') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
yum install php-json git
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
# 使用国内源
composer config -g repo.packagist composer https://packagist.phpcomposer.com
```

## Demo

### 文件结构

首先创建如下目录结构及文件，`talking_robot`为项目的根目录：

```bash
tree
.
└── src
    └── TalkingRobot
        └── Talk.php

2 directories, 1 file
```

### 编辑`Talk.php`文件

```php
<?php
namespace TalkingRobot;

class Talk
{
    public static function sayHello()
    {
        return 'Hello Composer';
    }
}
```

### 开始 Composer

#### 1. composer init

现在要在项目的根目录里创建一个`composer.json`的文件,我们可以手动创建，也可以在根目录里通过`composer init`命令来根据提示创建：

```bash
composer init


  Welcome to the Composer config generator



This command will guide you through creating your composer.json config.

Package name (<vendor>/<name>) [cl/talking_robot]: greatcl/talking_robot
Description []: I am a talking robot and an example of composer package.
Author [caolei <caolei@qiyi.com>, n to skip]:
Minimum Stability []: dev
Package Type (e.g. library, project, metapackage, composer-plugin) []:
License []: MIT

Define your dependencies.

Would you like to define your dependencies (require) interactively [yes]?
Search for a package:
Would you like to define your dev dependencies (require-dev) interactively [yes]?
Search for a package:

{
    "name": "greatcl/talking_robot",
    "description": "I am a talking robot and an example of composer package.",
    "license": "MIT",
    "authors": [
        {
            "name": "caolei",
            "email": "caolei@qiyi.com"
        }
    ],
    "minimum-stability": "dev",
    "require": {}
}

Do you confirm generation [yes]?
```

创建完成后,根目录下就生成了`composer.json`文件，目录结构如下：

```bash
tree
.
├── composer.json
└── src
    └── TalkingRobot
        └── Talk.php

2 directories, 2 files
```

#### 2. 添加自动加载

手动编辑生成的`composer.json`文件，添加php的版本要求和自动加载（使用PSR-0)，使用`TalkingRobot`命名空间，加载`src`目录下的所有文件,如下：

```json
{
    "name": "greatcl/talking_robot",
    "description": "I am a talking robot and an example of composer package.",
    "license": "MIT",
    "authors": [
        {
            "name": "caolei",
            "email": "caolei@qiyi.com"
        }
    ],
    "minimum-stability": "dev",
    "require": {
        "php": ">=5.3.0"
    },
    "autoload": {
        "psr-0": {
            "TalkingRobot": "src/"
        }
    }
}
```

### 进行测试

#### 1. composer install

在根目录中使用`composer install`安装composer文件。

```bash
composer install
Loading composer repositories with package information
Updating dependencies (including require-dev)
Nothing to install or update
Writing lock file
Generating autoload files

tree -L 2
.
├── composer.json
├── composer.lock
├── src
│   └── TalkingRobot
│       └── Talk.php
└── vendor
    ├── autoload.php
    └── composer

4 directories, 12 files
```

#### 2. 创建测试文件

在根目录中创建`tests`文件夹，在`tests`文件夹里创建`test.php`内容如下：

```php
<?php

// Autoload files using Composer autoload
require_once __DIR__ . '/../vendor/autoload.php';

use TalkingRobot\Talk;

echo Talk::sayHello();
```

当前的目录结构为：

```bash
tree -L 2
.
├── composer.json
├── composer.lock
├── src
│   └── TalkingRobot
├── tests
│   └── test.php
└── vendor
    ├── autoload.php
    └── composer

5 directories, 4 files
```

在根目录中运行测试文件：

```bash
php tests/test.php
Hello Composer
```

返回字符串`Hello Composer`。

## 发布到Packagist.org

最简单的方法是使用Github。

### 创建Github仓库

在Github上创建一个仓库`talking_robot`，然后将代码推到Github仓库里。

我们先在根目录里创建.gitignore文件，把vendor目录和composer.lock文件排除git在外。

```bash
cat .gitignore

vendor/*
composer.lock
```

推送代码

```js
git init
git add .
git commit -m 'First commit'
git remote add origin git@github.com:username/talking_robot.git
git push origin master
```

### 提交到Packagist

1. 首先要在Packagist上注册账号并登录
2. 点击顶部导航条中的Summit按钮
3. 在输入框中输入github上的仓库地址，如：https://github.com/username/talking_robot
4. 然后点击Check按钮 Packagist会去检测此仓库地址的代码是否符合Composer的Package包的要求。
5. 检测正常的话，会出现Submit按钮，再点击一下Submit按钮，我们的包就提交到Packagist上了。

## 使用

我们就可以在其他项目引用talking_robot这个包了，方法如下：

在需要引用的项目的`composer.json`文件的require段加入：

```js
{
    "require": {
        "greatcl/talking_robot":"dev-master"
    }
}
```

如果项目初次使用composer执行`composer install`进行安装，否则使用`composer update`进行更新。

```js
0 use-test-packagist $ composer install
Loading composer repositories with package information
Updating dependencies (including require-dev)
  - Installing greatcl/talking_robot (dev-master 103b7cc)
    Cloning 103b7cc721d9509d3b041487fe1d0e1c46bc8cce from cache

Writing lock file
Generating autoload files
```