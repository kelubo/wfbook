## I am trying to open Facebook,                Yahoo!, Yandex, Tumblr,  Google etc., and                instead I am getting “Welcome to nginx!” page 我正在尝试打开 Facebook、Yahoo！、Yandex、Tumblr、Google 等，但我得到的是“欢迎来到 nginx！

**Q:** I am trying to open Facebook, Yahoo!, Yandex, Google, or some other well known web site and instead I am getting a blank web page with a message referring to nginx: “Welcome to nginx!” or “404 Not Found / nginx”. 
我正在尝试打开 Facebook、Yahoo！、Yandex、Google 或其他一些知名网站，但我收到一个空白网页，其中包含一条涉及 nginx 的消息：“欢迎来到 nginx！”或“404 Not Found / nginx”。

I suspect something is wrong and there is probably a malicious attempt to direct me to a rogue web page (to break into my computer, do phishing etc.). Why is that, and what has nginx to do with my attempts to connect to Facebook (Yahoo!, Google, etc.) ? 
我怀疑出了点问题，可能有人恶意试图将我引导到一个流氓网页（闯入我的电脑、进行网络钓鱼等）。为什么会这样，nginx 与我尝试连接到 Facebook（雅虎、谷歌等）有什么关系？

 

**A:** First of all, the “Welcome to nginx!” page you see is NOT our website. At nginx, we write and distribute a **free** [ open source](http://en.wikipedia.org/wiki/Open-source_software) web server software. A web page saying “Welcome to nginx!” is just a diagnostics response that can be produced by any of the websites out there, running nginx web server. Currently, nginx is the 2nd most popular open source web server in the world, it’s being used by over 126,000,000 (or 14% of the Internet) websites. Most of these websites are legitimate, but some aren’t. Our software was created with a good reason of enabling performance and scalability on the Internet, it is licensed under [ popular open source license](http://nginx.org/LICENSE), and has nothing to do with any kind of threatening or malicious activity per se — nginx is NOT a malware, and it is NOT on your computer. But someone’s malware could have indeed tampered with your computer or router, redirecting you to a fraudulent Internet server. 
首先，您看到的“欢迎来到nginx！”页面不是我们的网站。在nginx，我们编写和分发一个免费的开源Web服务器软件。一个网页上写着“欢迎来到nginx！”只是一个诊断响应，可以由任何运行nginx web服务器的网站生成。目前，nginx 是世界上第二大最受欢迎的开源 Web 服务器，它被超过 126,000,000 个（或 14%  的互联网）网站使用。这些网站中的大多数都是合法的，但有些不是。我们的软件是在互联网上实现性能和可扩展性的充分理由而创建的，它是根据流行的开源许可证授权的，并且与任何类型的威胁或恶意活动本身无关——nginx 不是恶意软件，它不在您的计算机上。但是，某人的恶意软件可能确实篡改了您的计算机或路由器，将您重定向到欺诈性的Internet服务器。

We recommend running an anti-virus check on your computer, and we recommend to check and verify your entire system setup with the help of your ISP, or another support personnel: 
我们建议在您的计算机上运行防病毒检查，我们建议您在 ISP 或其他支持人员的帮助下检查和验证您的整个系统设置：

(Disclaimer: at nginx we are not responsible for any negative impact or effects that the actions below might cause. Use the following recommendations at your own risk, especially if you aren’t an experienced user of your operating system and/or Internet applications. In no event shall nginx be liable for any direct, indirect, incidental, special, exemplary, or consequential damages, including, but not limited to loss of use, data, or profits; or business interruption). 
（免责声明：在nginx，我们不对以下行为可能造成的任何负面影响负责。使用以下建议的风险由您自行承担，特别是如果您不是操作系统和/或 Internet 应用程序的有经验的用户。在任何情况下，nginx  均不对任何直接、间接、偶然、特殊、惩戒性或后果性损害负责，包括但不限于使用、数据或利润损失;或业务中断）。



- Check your TCP/IP settings and see if the DNS servers configuration matches the valid one (suggested by your Internet service provider or IT support personnel). 
  检查您的 TCP/IP 设置，并查看 DNS 服务器配置是否与有效的配置匹配（由 Internet 服务提供商或 IT 支持人员建议）。
- Use [Google Public DNS](http://developers.google.com/speed/public-dns/), and see if it fixes the problem. From Google’s description of its Public DNS — "Google Public DNS is a free, global Domain Name System (DNS) resolution service, that you can use as an alternative to your current DNS provider. [..] By using Google Public DNS you can: Speed up your browsing experience. **Improve your security**." 
  使用 Google 公共 DNS，看看它是否能解决问题。来自 Google 对其公共 DNS 的描述——“Google 公共 DNS  是一项免费的全球域名系统 （DNS） 解析服务，您可以将其用作当前 DNS 提供商的替代方案。[..]通过使用 Google 公共  DNS，您可以： 加快您的浏览体验。提高您的安全性。
- Clear your DNS resolver cache. On Microsoft Windows XP go to Start > Run, and then type the following command: "ipconfig /flushdns". On Microsoft Vista, Windows 7, and Windows 8 click on Start logo, follow All Programs > Accessories, right-click on Command Prompt, choose "Run As Administrator", type in "ipconfig /flushdns" and hit Enter. 
  清除 DNS 解析程序缓存。在 Microsoft Windows XP 上，转到“开始”>“运行”，然后键入以下命令：“ipconfig  /flushdns”。在 Microsoft Vista、Windows 7 和 Windows 8  上，单击“开始”徽标，按照“所有程序”>“附件”进行操作，右键单击“命令提示符”，选择“以管理员身份运行”，输入“ipconfig  /flushdns”并按 Enter。
- Click the "page reload" button in your browser. Clear browser data (cache, cookies etc.). E.g. with Chrome find and click "Clear Browsing Data" (Settings > Under the Hood). With Internet Explorer find Tools > Internet Options > General. **Caution:** you may be deleting saved passwords information here, so do it carefully and check what exact actions you are performing. 
  单击浏览器中的“页面重新加载”按钮。清除浏览器数据（缓存、cookie 等）。例如，使用 Chrome 找到并单击“清除浏览数据”（设置>在引擎盖下）。使用 Internet Explorer  时，找到“工具”>“Internet  选项”>“常规”。注意：您可能要在此处删除已保存的密码信息，因此请仔细执行并检查您正在执行的确切操作。
- Check if the "hosts" file doesn’t contain entries other than "127.0.0.1 localhost", and if so — if these entries are for the web site you’re trying to reach. The "hosts" files is located in C:\WINDOWS\system32\drivers\etc directory. Typically there should be just one entry in it, for "127.0.0.1 localhost", that’s it. The "hosts" file can be viewed and edited with your standard Notepad application. 
  检查“hosts”文件是否不包含“127.0.0.1 localhost”以外的条目，如果是，则这些条目是否适用于您尝试访问的网站。“hosts”文件位于  C：\WINDOWS\system32\drivers\etc 目录中。通常，其中应该只有一个条目，对于“127.0.0.1  localhost”，仅此而已。可以使用标准记事本应用程序查看和编辑“主机”文件。
- Check the plugins and extensions installed with your browser. Re-install your browser or try an alternative one if possible. 
  检查随浏览器一起安装的插件和扩展。如果可能，请重新安装您的浏览器或尝试其他浏览器。

 

Something must be wrong with your **operating system** settings, **home router** setup, or **browser** configuration, if you are trying to access a well known web site and what you get instead is “Welcome to nginx!”. This should NOT happen if your computers and network are clean and safe. 
如果您尝试访问一个知名网站，并且您得到的是“欢迎来到 nginx！”，那么您的操作系统设置、家庭路由器设置或浏览器配置一定有问题。如果您的计算机和网络干净且安全，则不应发生这种情况。

If changing DNS servers to Google Public DNS, flushing DNS resolver cache, fixing your browser configuration, or cleaning "hosts" file (when applicable) have helped, it might be that there’s a malware somewhere on your PC or around. Find and clean it using your preferred anti-virus and anti-malware tools. 
如果将 DNS 服务器更改为 Google 公共 DNS、刷新 DNS 解析器缓存、修复浏览器配置或清理“主机”文件（如果适用）有所帮助，则可能是您的 PC 上或周围某处存在恶意软件。使用您喜欢的防病毒和反恶意软件工具查找并清理它。

Additional articles that might be helpful: 
可能有用的其他文章：

DCWG.org: DCWG.org：

[ How can you detect if your computer has been violated and infected with DNS Changer?
如何检测您的计算机是否被侵犯并感染了DNS Changer？](http://www.dcwg.org/detect/)

[ How to clean up or fix malicious software (“malware”) associated with DNS Changer
如何清理或修复与 DNS Changer 关联的恶意软件（“恶意软件”）](http://www.dcwg.org/fix/)

Microsoft: Microsoft：

[ Malicious Software Removal Tool
恶意软件删除工具](http://www.microsoft.com/security/pc-security/malware-removal.aspx)

[ How can I reset the Hosts file back to the default?
如何将 Hosts 文件重置为默认值？](http://support.microsoft.com/kb/972034)

[ How to reset Internet Protocol (TCP/IP)
如何重置 Internet 协议 （TCP/IP）](http://support.microsoft.com/kb/299357)

Firefox Help: Firefox Help：

[ Disable or remove Add-ons
禁用或删除附加组件](http://support.mozilla.org/en-US/kb/disable-or-remove-add-ons)

Tech-Recipes: 技术食谱：

[ DNS Cache Flush, Clear, or Reset in Vista, Windows 7, and Windows 8
Vista、Windows 7 和 Windows 8 中的 DNS 缓存刷新、清除或重置](http://www.tech-recipes.com/rx/1600/vista_dns_cache_flush/)

## How can nginx copyright be acknowledged                when using nginx as part of a proprietary                software  distribution?

**Q:** I’d like to use nginx distribution as part of my proprietary software package. How can nginx copyright be acknowledged when using nginx as part of a proprietary software distribution?

 

**A:** The text below should be added to your license conditions, followed by the text of the applicable 2-clause BSD license described [here](http://nginx.org/LICENSE).

> ```
> This product contains software provided by Nginx, Inc. and its contributors.
> ```

 

Also, if your build of nginx includes any of the following 3rd party products: zlib, PCRE, OpenSSL — it’s worth including their copyright acknowledgements and disclaimers as well.

## What does the following error mean in the log  file:                “accept() failed (53: Software caused connection  abort)                while accepting new connection on 0.0.0.0:80”?

**Q:** What does the following error mean in the log file: "accept() failed (53: Software caused connection abort) while accepting new connection on 0.0.0.0:80"?

 

**A:** Such errors stem from the connections that the clients managed to close before nginx was able to process them. For instance, this can happen in a situation when the user didn’t wait for a page heavily populated with images to load fully, and clicked on a different link. In this case user’s browser would close all of the prior connections which aren’t longer necessary. It is a non-critical error.

## Is there a proper way to use nginx variables to                make sections of the configuration shorter,                 using them as macros for making                parts of configuration  work as templates?

**Q:** Is there a proper way to use nginx variables to make sections of the configuration shorter, using them as macros for making parts of configuration work as templates?

 

**A:** Variables should not be used as template macros. Variables are evaluated in the run-time during the processing of each request, so they are rather costly compared to plain static configuration. Using variables to store static strings is also a bad idea. Instead, a macro expansion and "include" directives should be used to generate configs more easily and it can be done with the external tools, e.g. sed + make or any other common template mechanism.

## Can I run nginx with “daemon off” or                “master_process off” settings                in a production environment?

**Q:** Can I run nginx with "daemon off" or "master_process off" settings in a production environment?

 

**A:** First of all, both "daemon on|off" and "master_process on|off" directives were intended to be used primarily for nginx code development.

While many people use "daemon off" in production it wasn’t really meant for that. Since version 1.0.9 it is now quite safe to run nginx in production with "daemon off", though. Bear in mind that non-stop upgrade is not an option with "daemon off".

In a development environment, using "master_process off", nginx can run in the foreground without the master process and can be terminated simply with ^C (SIGINT). This is somewhat similar to running Apache with an 'X' command-line option. However you should NEVER run nginx in production with "master_process off".

## Why nginx doesn’t handle chunked encoding                responses from my backend properly?

**Q:** My backend server appears to send HTTP/1.0 responses using chunked encoding but nginx doesn’t handle it correctly. For instance, I’m using nginx as a frontend to my node.js application and instead of pure JSON from backend, nginx returns something framed in decimal numbers like

> ```
> 47
> {"error":"query error","message":"Parameter(s) missing: user,password"}
> 0
> ```

 

 

**A:** Your backend violates HTTP specification (see [RFC 2616, "3.6 Transfer Codings"](https://datatracker.ietf.org/doc/html/rfc2616#section-3.6)). The "chunked" transfer-codings must not be used with HTTP/1.0. You’d need to either fix your backend application or upgrade to nginx version 1.1.4 and newer, where an additional code was introduced to handle such erratic backend behavior.

## A message “ ‘sys_errlist’                 is  deprecated;                 use ‘strerror’ or ‘strerror_r’                 instead ”

**Q:** While building nginx version 0.7.66, 0.8.35 or higher on Linux the following warning messages are issued:

> ```
> warning: `sys_errlist' is deprecated;
>     use `strerror' or `strerror_r' instead
> warning: `sys_nerr' is deprecated;
>     use `strerror' or `strerror_r' instead
> ```

 

**A:** This is normal: nginx has to use the deprecated sys_errlist[] and sys_nerr in signal handlers because strerror() and strerror_r() functions are not Async-Signal-Safe.