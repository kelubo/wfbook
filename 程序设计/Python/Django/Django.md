# Django

## 安装

在终端输入Python命令来查看是否已经安装。

    Python 2.7.3 (default, Aug  1 2012, 05:14:39)
    [GCC 4.6.3] on linux2
    Type "help", "copyright", "credits" or "license" for more information.
    >>>

1.easy_install方法  

安装 setuptools

    yum install setuptools

使用 easy_install 命令安装 django

    easy_install django

2.pip 命令安装方法

安装pip

(1). ubuntu:

    sudo apt-get install python-pip

(2). Fedora:

    yum install python-pip

安装jango

    pip install Django

3.源码安装方法

下载源码包：https://www.djangoproject.com/download/

输入以下命令并安装：

    tar xzvf Django-X.Y.tar.gz    # 解压下载包
    cd Django-X.Y                 # 进入 Django 目录
    python setup.py install       # 执行安装命令

安装成功后 Django 位于 Python 安装目录的 site-packages 目录下。

4.Linux用自带源进行安装

ubuntu

    sudo apt-get install python-django -y

Fedora

    yum install python-django

4.检查是否安装成功

进行 python 环境

     >>> import django
     >>> django.VERSION
    (1, 7, 6, 'final', 0)
     >>>
    >>> django.get_version()
    '1.7.6'

## Django 创建项目

### Django 管理工具 django-admin.py

    [root@solar ~]# django-admin.py
    Usage: django-admin.py subcommand [options] [args]

    Options:
      -v VERBOSITY, --verbosity=VERBOSITY
                        Verbosity level; 0=minimal output, 1=normal output,
                        2=verbose output, 3=very verbose output
      --settings=SETTINGS   The Python path to a settings module, e.g.
                        "myproject.settings.main". If this isn't provided, the
                        DJANGO_SETTINGS_MODULE environment variable will be
                        used.
      --pythonpath=PYTHONPATH
                        A directory to add to the Python path, e.g.
                        "/home/djangoprojects/myproject".
      --traceback           Raise on exception
      --version             show program's version number and exit
      -h, --help            show this help message and exit

    Type 'django-admin.py help <subcommand>' for help on a specific subcommand.

    Available subcommands:

    [django]
        check
        cleanup
        compilemessages
        createcachetable
    ……省略部分……

### 创建第一个项目

    django-admin.py startproject HelloWorld

创建完成后我们可以查看下项目的目录结构：

    [root@solar ~]# cd HelloWorld/
    [root@solar HelloWorld]# tree
    .
    |-- HelloWorld
    |   |-- __init__.py
    |   |-- settings.py
    |   |-- urls.py
    |   `-- wsgi.py
    `-- manage.py

进入 HelloWorld 目录输入以下命令，启动服务器：

     python manage.py runserver 0.0.0.0:8000

新建一个 view.py 文件，并输入代码：

    from django.http import HttpResponse

    def hello(request):
    	return HttpResponse("Hello world ! ")

绑定 URL 与视图函数。打开 urls.py 文件，删除原来代码，将以下代码复制粘贴到 urls.py 文件中：

    from django.conf.urls import *
    from HelloWorld.view import hello

    urlpatterns = patterns("",
    	('^hello/$', hello),
    )

整个目录结构如下：

    [root@solar HelloWorld]# tree
    .
    |-- HelloWorld
    |   |-- __init__.py
    |   |-- __init__.pyc
    |   |-- settings.py
    |   |-- settings.pyc
    |   |-- urls.py              # url 配置
    |   |-- urls.pyc
    |   |-- view.py              # 添加的视图文件
    |   |-- view.pyc             # 编译后的视图文件
    |   |-- wsgi.py
    |   `-- wsgi.pyc
    `-- manage.py

完成后，启动 Django 开发服务器.

    注意：项目中如果代码有改动，服务器会自动监测代码的改动并自动重新载入，所以不需手动重启。

## 目录说明

**HelloWorld:** 项目的容器。

**manage.py:** 一个实用的命令行工具，可让你以各种方式与该 Django 项目进行交互。

**__init__.py:** 一个空文件，告诉 Python 该目录是一个 Python 包。

**settings.py:** 该 Django 项目的设置/配置。

**urls.py:** 该 Django 项目的 URL 声明; 一份由 Django 驱动的网站"目录"。
        网址入口，关联到对应的views.py中的一个函数（或者generic类），访问网址就对应一个函数。

**wsgi.py:** 一个 WSGI 兼容的 Web 服务器的入口，以便运行你的项目。

**views.py:** 处理用户发出的请求，从urls.py中对应过来, 通过渲染templates中的网页可以将显示内容，比如登陆后的用户名，用户请求的数据，输出到网页。

**models.py:** 与数据库操作相关，存入或读取数据时用到这个。

**forms.py:** 表单，用户在浏览器上输入数据提交，对数据的验证工作以及输入框的生成等工作，当然你也可以不使用。

**templates目录:** 中的函数渲染templates中的Html模板，得到动态内容的网页，当然可以用缓存来提高速度。

**admin.py:** 后台，可以用很少量的代码就拥有一个强大的后台。

**settings.py:** Django 的设置，配置文件，比如 DEBUG 的开关，静态文件的位置等。

## Django 基本命令
1.新建一个 django project

    django-admin.py startproject project-name

project-name 项目名称，要符合Python 的变量命名规则（以下划线或字母开头）

2.新建 app

    python manage.py startapp app-name
    或 django-admin.py startapp app-name

一般一个项目有多个app, 当然通用的app也可以在多个项目中使用。

3.同步数据库

    python manage.py syncdb

注意：Django 1.7.1及以上的版本需要用以下命令

    python manage.py makemigrations
    python manage.py migrate

这种方法可以创建表，当你在models.py中新增了类时，运行它就可以自动在数据库中创建表了，不用手动创建。

备注：对已有的 models 进行修改，Django 1.7之前的版本的Django都是无法自动更改表结构的，不过有第三方工具 south,详见 Django 数据库迁移 一节。

4.使用开发服务器

    python manage.py runserver
    # 当提示端口被占用的时候，可以用其它端口：
    python manage.py runserver 8001
    # 监听所有可用 ip
    python manage.py runserver 0.0.0.0:8000

5.清空数据库

    python manage.py flush

此命令会询问是 yes 还是 no, 选择 yes 会把数据全部清空掉，只留下空表。

6.创建超级管理员

    python manage.py createsuperuser
    # 按照提示输入用户名和对应的密码就好了邮箱可以留空，用户名和密码必填
    # 修改 用户密码可以用：
    python manage.py changepassword username

7.导出数据 导入数据

    python manage.py dumpdata appname > appname.json
    python manage.py loaddata appname.json

8.Django 项目环境终端

    python manage.py shell

这个命令和 直接运行 python 或 bpython 进入 shell 的区别是：你可以在这个 shell 里面调用当前项目的 models.py 中的 API，对于操作数据，还有一些小测试非常方便。

9.数据库命令行

    python manage.py dbshell

## Django 视图与网址

Django中网址是写在 urls.py 文件中，用正则表达式对应 views.py 中的一个函数(或者generic类)。

一，首先，新建一个项目(project), 名称为 mysite

    django-admin startproject mysite

运行后,如果成功的话, 我们会看到如下的目录样式   (没有成功的请参见环境搭建一节)：

    mysite
    ├── manage.py
    └── mysite
        ├── __init__.py
        ├── settings.py
        ├── urls.py
        └── wsgi.py

二, 新建一个应用(app), 名称叫 learn

    python manage.py startapp learn

我们可以看到mysite中多个一个 learn 文件夹，其中有以下文件。

    learn/
    ├── __init__.py
    ├── admin.py
    ├── models.py
    ├── tests.py
    └── views.py

三，把新定义的app加到settings.py中的INSTALL_APPS中

修改 mysite/mysite/settings.py

    INSTALLED_APPS = (
        'django.contrib.admin',
        'django.contrib.auth',
        'django.contrib.contenttypes',
        'django.contrib.sessions',
        'django.contrib.messages',
        'django.contrib.staticfiles',

        'learn',
    )

四，定义视图函数（访问页面时的内容）

在learn这个目录中,把views.py打开,修改其中的源代码

    #coding:utf-8
    from django.http import HttpResponse

    def index(request):
        return HttpResponse(u"Hello World!")

五，定义视图函数相关的URL(网址)

打开 mysite/mysite/urls.py 这个文件, 修改其中的代码:

    from django.conf.urls import url
    from django.contrib import admin
    from learn import views as learn_views  # new

    urlpatterns = [
        url(r'^$', learn_views.index),  # new
        url(r'^admin/', admin.site.urls),
    ]

六，在终端上运行 python manage.py runserver :

    $ python manage.py runserver

    Performing system checks...

    System check identified no issues (0 silenced).

    You have unapplied migrations; your app may not work properly until they are applied.
    Run 'python manage.py migrate' to apply them.

    December 22, 2015 - 11:57:33
    Django version 1.9, using settings 'mysite.settings'
    Starting development server at http://127.0.0.1:8000/
    Quit the server with CONTROL-C.
