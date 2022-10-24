# .NET

[TOC]

## 概述

.NET 6.0

## Installing and running .NET 6.0 on RHEL 9

Red Hat Customer Content Services

[Legal Notice](https://access.redhat.com/documentation/en-us/net/6.0/html-single/getting_started_with_.net_on_rhel_9/index#idm140661790357488)

**Abstract**

​				This guide describes how to install and run .NET 6.0 on RHEL 9. 		

------

# Making open source more inclusive

​			Red Hat is committed to replacing problematic language in our code,  documentation, and web properties. We are beginning with these four  terms: master, slave, blacklist, and whitelist. Because of the enormity  of this endeavor, these changes will be implemented gradually over  several upcoming releases. For more details, see [our CTO Chris Wright’s message](https://www.redhat.com/en/blog/making-open-source-more-inclusive-eradicating-problematic-language). 	

# Providing feedback on Red Hat documentation

​			We appreciate your input on our documentation. Please let us know how we could make it better. To do so: 	

- ​					For simple comments on specific passages: 			
  1. ​							Make sure you are viewing the documentation in the *Multi-page HTML* format. In addition, ensure you see the **Feedback** button in the upper right corner of the document. 					
  2. ​							Use your mouse cursor to highlight the part of text that you want to comment on. 					
  3. ​							Click the **Add Feedback** pop-up that appears below the highlighted text. 					
  4. ​							Follow the displayed instructions. 					
- ​					For submitting more complex feedback, create a Bugzilla ticket: 			
  1. ​							Go to the [Bugzilla](https://bugzilla.redhat.com/enter_bug.cgi?product=Red Hat Enterprise Linux 8) website. 					
  2. ​							As the Component, use **Documentation**. 					
  3. ​							Fill in the **Description** field with your suggestion for improvement. Include a link to the relevant part(s) of documentation. 					
  4. ​							Click **Submit Bug**. 					

# Chapter 1. Introducing .NET 6.0

​			.NET is a general-purpose development platform featuring automatic  memory management and modern programming languages. Using .NET, you can  build high-quality applications efficiently. .NET is available on  Red Hat Enterprise Linux (RHEL) and OpenShift Container Platform through certified containers. 	

​			.NET offers the following features: 	

- ​					The ability to follow a microservices-based approach, where some  components are built with .NET and others with Java, but all can run on a common, supported platform on RHEL and OpenShift Container Platform. 			
- ​					The capacity to more easily develop new .NET workloads on Microsoft Windows. You can deploy and run your applications on either RHEL or  Windows Server. 			
- ​					A heterogeneous data center, where the underlying infrastructure is capable of running .NET applications without having to rely solely on  Windows Server. 			

​			.NET 6.0 is supported on RHEL 7, RHEL 8, RHEL 9, and OpenShift Container Platform versions 3.11 and later. 	

# Chapter 2. Installing .NET 6.0

​			.NET 6.0 is included in the AppStream repositories for RHEL 9. The  AppStream repositories are enabled by default on RHEL 9 systems. 	

​			You can install the .NET 6.0 runtime with the latest 6.0 Software  Development Kit (SDK). When a newer SDK becomes available for .NET 6.0,  you can install it by running `sudo yum upgrade`. 	

**Prerequisites**

- ​					Installed and registered RHEL 9 with attached subscriptions. 			

  ​					For more information, see [Performing a standard RHEL installation](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html-single/performing_a_standard_rhel_installation/index). 			

**Procedure**

- ​					Install .NET 6.0 and all of its dependencies: 			

  ```none
  $ sudo yum install dotnet-sdk-6.0 -y
  ```

**Verification steps**

- ​					Verify the installation: 			

  ```none
  $ dotnet --info
  ```

  ​					The output returns the relevant information about the .NET installation and the environment. 			

# Chapter 3. Creating an application using .NET 6.0

​			Learn how to create a C# `hello-world` application. 	

**Procedure**

1. ​					Create a new Console application in a directory called `my-app`: 			

   ```none
   $ dotnet new console --output my-app
   ```

   ​					The output returns: 			

   ```none
   The template "Console Application" was created successfully.
   
   Processing post-creation actions...
   Running 'dotnet restore' on my-app/my-app.csproj...
     Determining projects to restore...
     Restored /home/username/my-app/my-app.csproj (in 67 ms).
   Restore succeeded.
   ```

   ​					A simple `Hello World` console application is created from a template. The application is stored in the specified `my-app` directory. 			

**Verification steps**

- ​					Run the project: 			

  ```none
  $ dotnet run --project my-app
  ```

  ​					The output returns: 			

  ```none
  Hello World!
  ```

# Chapter 4. Publishing applications with .NET 6.0

​			.NET 6.0 applications can be published to use a shared system-wide version of .NET or to include .NET. 	

​			The following methods exist for publishing .NET 6.0 applications: 	

- ​					Single-file application - The application is self-contained and can be deployed as a single executable with all dependent files contained  in a single binary. 			

Note

​				Single-file application deployment is not available on IBM Z and LinuxONE. 		

- ​					Framework-dependent deployment (FDD) - The application uses a shared system-wide version of .NET. 			

Note

​				When publishing an application for RHEL, Red Hat recommends using  FDD, because it ensures that the application is using an up-to-date  version of .NET, built by Red Hat, that uses a set of native  dependencies. 		

- ​					Self-contained deployment (SCD) - The application includes .NET. This method uses a runtime built by Microsoft. 			

Note

​				SCD is not available on IBM Z and LinuxONE. 		

**Prerequisites**

- ​					Existing .NET application. 			

  ​					For more information on how to create a .NET application, see [Creating an application using .NET](https://access.redhat.com/documentation/en-us/net/6.0/html/getting_started_with_.net_on_rhel_9/creating-an-application-using-dotnet_getting-started-with-dotnet-on-rhel-9). 			

## 4.1. Publishing .NET applications

​				The following procedure outlines how to publish a framework-dependent application. 		

**Procedure**

1. ​						Publish the framework-dependent application: 				

   ```none
   $ dotnet publish my-app -f net6.0 -c Release
   ```

   ​						Replace *my-app* with the name of the application you want to publish. 				

2. ​						**Optional:** If the application is for RHEL only, trim out the dependencies needed for other platforms: 				

   ```none
   $ dotnet publish my-app -f net6.0 -c Release -r rhel.9-architecture --self-contained false
   ```

   - ​								Replace *architecture* based on the platform you are using: 						
     - ​										For Intel: `x64` 								
     - ​										For IBM Z and LinuxONE: `s390x` 								
     - ​										For 64-bit Arm: `arm64` 								

# Chapter 5. Running .NET 6.0 applications in containers

​			Use the `ubi8/dotnet-60-runtime` image to run a precompiled application inside a Linux container. 	

**Prerequisites**

- ​					Preconfigured containers. 			

  ​					The following example uses podman. 			

**Procedure**

1. ​					**Optional:** If  you are in another project’s directory and do not wish to create a  nested project, return to the parent directory of the project: 			

   ```none
   # cd ..
   ```

2. ​					Create a new MVC project in a directory called `mvc_runtime_example`: 			

   ```none
   $ dotnet new mvc --output mvc_runtime_example
   ```

3. ​					Publish the project: 			

   ```none
   $ dotnet publish mvc_runtime_example -f net6.0 -c Release
   ```

4. ​					Create the `Dockerfile`: 			

   ```none
   $ cat > Dockerfile <<EOF
   FROM registry.access.redhat.com/ubi8/dotnet-60-runtime
   
   ADD bin/Release/net6.0/publish/ .
   
   CMD ["dotnet", "mvc_runtime_example.dll"]
   EOF
   ```

5. ​					Build your image: 			

   ```none
   $ podman build -t dotnet-60-runtime-example .
   ```

6. ​					Run your image: 			

   ```none
   $ podman run -d -p8080:8080 dotnet-60-runtime-example
   ```

**Verification steps**

- ​					View the application running in the container: 			

  ```none
  $ xdg-open http://127.0.0.1:8080
  ```

# Chapter 6. Using .NET 6.0 on OpenShift Container Platform

## 6.1. Overview

**NET images are added to OpenShift by importing imagestream definitions from [s2i-dotnetcore](https://github.com/redhat-developer/s2i-dotnetcore).**

​					The imagestream definitions includes the `dotnet` imagestream which contains sdk images for different supported versions of .NET. [.NET Life Cycle](https://access.redhat.com/support/policy/updates/net-core) provides an up-to-date overview of supported versions. 			

| Version         | Tag             | Alias      |
| --------------- | --------------- | ---------- |
| .NET Core 3.1   | dotnet:3.1-el7  | dotnet:3.1 |
| dotnet:3.1-ubi8 |                 |            |
| .NET 5          | dotnet:5.0-ubi8 | dotnet:5.0 |
| .NET 6          | dotnet:6.0-ubi8 | dotnet:6.0 |

​				The sdk images have corresponding runtime images which are defined under the `dotnet-runtime` imagestream. 		

​				The container images work across different versions of Red Hat Enterprise Linux and OpenShift. 		

​				The RHEL7-based (suffix -el7) are hosted on the `registry.redhat.io` image repository. Authentication is required to pull these images.  These credentials are configured by adding a pull secret to the  OpenShift namespace. 		

​				The UBI-8 based images (suffix -ubi8) are hosted on the `registry.access.redhat.com` and do not require authentication. 		

## 6.2. Installing .NET image streams

​				To install .NET image streams, use image stream definitions from [s2i-dotnetcore](https://github.com/redhat-developer/s2i-dotnetcore/) with the OpenShift Client (`oc`) binary. Image streams can be installed from Linux, Mac, and Windows. A  script enables you to install, update or remove the image streams. 		

​				You can define .NET image streams in the global `openshift` namespace or locally in a project namespace. Sufficient permissions are required to update the `openshift` namespace definitions. 		

### 6.2.1. Installing image streams using OpenShift Client

​					You can use OpenShift Client (`oc`) to install .NET image streams. 			

**Prerequisites**

- ​							An existing pull secret must be present in the namespace. If no  pull secret is present in the namespace. Add one by following the  instructions in the [Red Hat Container Registry Authentication](https://access.redhat.com/RegistryAuthentication) guide. 					

**Procedure**

1. ​							List the available .NET image streams: 					

   ```none
   $ oc describe is dotnet
   ```

   ​							The output shows installed images. If no images are installed, the `Error from server (NotFound)` message is displayed. 					

   - ​									If the `Error from server (NotFound)` message **is** displayed: 							

     - ​											Install the .NET image streams: 									

       ```none
       $ oc create -f https://raw.githubusercontent.com/redhat-developer/s2i-dotnetcore/master/dotnet_imagestreams.json
       ```

   - ​									If the `Error from server (NotFound)` message **is not** displayed: 							

     - ​											Include newer versions of existing .NET image streams: 									

       ```none
       $ oc replace -f https://raw.githubusercontent.com/redhat-developer/s2i-dotnetcore/master/dotnet_imagestreams.json
       ```

### 6.2.2. Installing image streams on Linux and macOS

​					You can use [this script](https://raw.githubusercontent.com/redhat-developer/s2i-dotnetcore/master/install-imagestreams.sh) to install, upgrade, or remove the image streams on Linux and macOS. 			

**Procedure**

1. ​							Download the script. 					

   1. ​									On Linux use: 							

      ```none
      $ wget https://raw.githubusercontent.com/redhat-developer/s2i-dotnetcore/master/install-imagestreams.sh
      ```

   2. ​									On Mac use: 							

      ```none
      $ curl https://raw.githubusercontent.com/redhat-developer/s2i-dotnetcore/master/install-imagestreams.sh -o install-imagestreams.sh
      ```

2. ​							Make the script executable: 					

   ```none
   $ chmod +x install-imagestreams.sh
   ```

3. ​							Log in to the OpenShift cluster: 					

   ```none
   $ oc login
   ```

4. ​							Install image streams and add a pull secret for authentication against the `registry.redhat.io`: 					

   ```none
   ./install-imagestreams.sh --os rhel [--user subscription_username --password subscription_password]
   ```

   ​							Replace *subscription_username* with the name of the user, and replace *subscription_password* with the user’s password. The credentials may be omitted if you do not plan to use the RHEL7-based images. 					

   ​							If the pull secret is already present, the `--user` and `--password` arguments are ignored. 					

**Additional information**

- ​							`./install-imagestreams.sh --help` 					

### 6.2.3. Installing image streams on Windows

​					You can use [this script](https://raw.githubusercontent.com/redhat-developer/s2i-dotnetcore/master/install-imagestreams.ps1) to install, upgrade, or remove the image streams on Windows. 			

**Procedure**

1. ​							Download the script. 					

   ```none
   Invoke-WebRequest https://raw.githubusercontent.com/redhat-developer/s2i-dotnetcore/master/install-imagestreams.ps1 -UseBasicParsing -OutFile install-imagestreams.ps1
   ```

2. ​							Log in to the OpenShift cluster: 					

   ```none
   $ oc login
   ```

3. ​							Install image streams and add a pull secret for authentication against the `registry.redhat.io`: 					

   ```none
   .\install-imagestreams.ps1 --OS rhel [-User subscription_username -Password subscription_password]
   ```

   ​							Replace *subscription_username* with the name of the user, and replace *subscription_password* with the user’s password. The credentials may be omitted if you do not plan to use the RHEL7-based images. 					

   ​							If the pull secret is already present, the `-User` and `-Password` arguments are ignored. 					

Note

​						The PowerShell `ExecutionPolicy` may prohibit executing this script. To relax the policy, run `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force`. 				

**Additional information**

- ​							`Get-Help .\install-imagestreams.ps1` 					

## 6.3. Deploying applications from source using oc

​				The following example demonstrates how to deploy the *example-app* application using `oc`, which is in the `app` folder on the `{dotnet-branch}` branch of the `redhat-developer/s2i-dotnetcore-ex` GitHub repository: 		

**Procedure**

1. ​						Create a new OpenShift project: 				

   ```none
   $ oc new-project sample-project
   ```

2. ​						Add the ASP.NET Core application: 				

   ```none
   $ oc new-app --name=example-app 'dotnet:6.0-ubi8~https://github.com/redhat-developer/s2i-dotnetcore-ex#{dotnet-branch}' --build-env DOTNET_STARTUP_PROJECT=app
   ```

3. ​						Track the progress of the build: 				

   ```none
   $ oc logs -f bc/example-app
   ```

4. ​						View the deployed application once the build is finished: 				

   ```none
   $ oc logs -f dc/example-app
   ```

   ​						The application is now accessible within the project. 				

5. ​						**Optional**: Make the project accessible externally: 				

   ```none
   $ oc expose svc/example-app
   ```

6. ​						Obtain the shareable URL: 				

   ```none
   $ oc get routes
   ```

## 6.4. Deploying applications from binary artifacts using oc

​				You can use .NET Source-to-Image (S2I) builder image to build applications using binary artifacts that you provide. 		

**Prerequisites**

1. ​						Published application. 				

   ​						For more information, see [Publishing applications with .NET 6.0](https://access.redhat.com/documentation/en-us/net/6.0/html-single/getting_started_with_.net_on_rhel_9/index.xml#assembly_publishing-apps-using-dotnet_getting-started-with-dotnet-on-rhel-9). 				

**Procedure**

1. ​						Create a new binary build: 				

   ```none
   $ oc new-build --name=my-web-app dotnet:6.0-ubi8 --binary=true
   ```

2. ​						Start the build and specify the path to the binary artifacts on your local machine: 				

   ```none
   $ oc start-build my-web-app --from-dir=bin/Release/net6.0/publish
   ```

3. ​						Create a new application: 				

   ```none
   $ oc new-app my-web-app
   ```

## 6.5. Environment variables for .NET 6.0

​				The .NET images support several environment variables to control the build behavior of your .NET application. You can set these variables as part of the build configuration, or add them to the `.s2i/environment` file in the application source code repository. 		

| **Variable Name**                   | **Description**                                              | **Default**                   |
| ----------------------------------- | ------------------------------------------------------------ | ----------------------------- |
| **DOTNET_STARTUP_PROJECT**          | Selects the project to run. This must be a project file (for example, `csproj` or `fsproj`) or a folder containing a single project file. | `.`                           |
| **DOTNET_ASSEMBLY_NAME**            | Selects the assembly to run. This must not include the `.dll` extension. Set this to the output assembly name specified in `csproj` (PropertyGroup/AssemblyName). | The name of the `csproj` file |
| **DOTNET_PUBLISH_READYTORUN**       | When set to `true`, the application  will be compiled ahead of time. This reduces startup time by reducing  the amount of work the JIT needs to perform when the application is  loading. | `false`                       |
| **DOTNET_RESTORE_SOURCES**          | Specifies the space-separated list of NuGet package sources used during the restore operation. This overrides all of the sources  specified in the `NuGet.config` file. This variable cannot be combined with `DOTNET_RESTORE_CONFIGFILE`. |                               |
| **DOTNET_RESTORE_CONFIGFILE**       | Specifies a `NuGet.Config` file to be used for restore operations. This variable cannot be combined with `DOTNET_RESTORE_SOURCES`. |                               |
| **DOTNET_TOOLS**                    | Specifies a list of .NET tools to install before building the  app. It is possible to install a specific version by post pending the  package name with `@<version>`. |                               |
| **DOTNET_NPM_TOOLS**                | Specifies a list of NPM packages to install before building the application. |                               |
| **DOTNET_TEST_PROJECTS**            | Specifies the list of test projects to test. This must be project files or folders containing a single project file. `dotnet test` is invoked for each item. |                               |
| **DOTNET_CONFIGURATION**            | Runs the application in Debug or Release mode. This value should be either `Release` or `Debug`. | `Release`                     |
| **DOTNET_VERBOSITY**                | Specifies the verbosity of the `dotnet build` commands. When set, the environment variables are printed at the start  of the build. This variable can be set to one of the msbuild verbosity  values (`q[uiet]`, `m[inimal]`, `n[ormal]`, `d[etailed]`, and `diag[nostic]`). |                               |
| **HTTP_PROXY, HTTPS_PROXY**         | Configures the HTTP or HTTPS proxy used when building and running the application, respectively. |                               |
| **DOTNET_RM_SRC**                   | When set to `true`, the source code will not be included in the image. |                               |
| **DOTNET_SSL_DIRS**                 | Specifies a list of folders or files with additional SSL  certificates to trust. The certificates are trusted by each process that runs during the build and all processes that run in the image after the build (including the application that was built). The items can be  absolute paths (starting with `/`) or paths in the source repository (for example, certificates). |                               |
| **NPM_MIRROR**                      | Uses a custom NPM registry mirror to download packages during the build process. |                               |
| **ASPNETCORE_URLS**                 | This variable is set to `http://*:8080` to configure ASP.NET Core to use the port exposed by the image. Changing this is not recommended. | `http://*:8080`               |
| **DOTNET_RESTORE_DISABLE_PARALLEL** | When set to `true`, disables  restoring multiple projects in parallel. This reduces restore timeout  errors when the build container is running with low CPU limits. | `false`                       |
| **DOTNET_INCREMENTAL**              | When set to `true`, the NuGet packages will be kept so they can be re-used for an incremental build. | `false`                       |
| **DOTNET_PACK**                     | When set to `true`, creates a `tar.gz` file at `/opt/app-root/app.tar.gz` that contains the published application. |                               |

## 6.6. Creating the MVC sample application

​				`s2i-dotnetcore-ex` is the default Model, View, Controller (MVC) template application for .NET. 		

​				This application is used as the example application by the .NET S2I  image and can be created directly from the OpenShift UI using the *Try Example* link. 		

​				The application can also be created with the OpenShift client binary (`oc`). 		

**Procedure**

​					To create the sample application using `oc`: 			

1. ​						Add the .NET application: 				

   ```none
   $ oc new-app dotnet:6.0-ubi8~https://github.com/redhat-developer/s2i-dotnetcore-ex#{dotnet-branch} --context-dir=app
   ```

2. ​						Make the application accessible externally: 				

   ```none
   $ oc expose service s2i-dotnetcore-ex
   ```

3. ​						Obtain the sharable URL: 				

   ```none
   $ oc get route s2i-dotnetcore-ex
   ```

**Additional resources**

- ​						[`s2i-dotnetcore-ex` application repository on GitHub](https://github.com/redhat-developer/s2i-dotnetcore-ex/tree/{github-path}-6.0) 				

## 6.7. Creating the CRUD sample application

​				`s2i-dotnetcore-persistent-ex` is a simple Create, Read, Update, Delete (CRUD) .NET web application that stores data in a PostgreSQL database. 		

**Procedure**

​					To create the sample application using `oc`: 			

1. ​						Add the database: 				

   ```none
   $ oc new-app postgresql-ephemeral
   ```

2. ​						Add the .NET application: 				

   ```none
   $ oc new-app dotnet:6.0-ubi8~https://github.com/redhat-developer/s2i-dotnetcore-persistent-ex#{dotnet-branch} --context-dir app
   ```

3. ​						Add environment variables from the `postgresql` secret and database service name environment variable: 				

   ```none
   $ oc set env dc/s2i-dotnetcore-persistent-ex --from=secret/postgresql -e database-service=postgresql
   ```

4. ​						Make the application accessible externally: 				

   ```none
   $ oc expose service s2i-dotnetcore-persistent-ex
   ```

5. ​						Obtain the sharable URL: 				

   ```none
   $ oc get route s2i-dotnetcore-persistent-ex
   ```

**Additional resources**

- ​						[`s2i-dotnetcore-ex` application repository on GitHub](https://github.com/redhat-developer/s2i-dotnetcore-persistent-ex) 				

# Chapter 7. Migration from previous versions of .NET

## 7.1. Migration from previous versions of .NET

​				Microsoft provides instructions for migrating from most previous versions of .NET Core. 		

​				If you are using a version of .NET that is no longer supported or  want to migrate to a newer .NET version to expand functionality, see the following articles: 		

- ​						[Migrate from ASP.NET Core 5.0 to 6.0](https://docs.microsoft.com/en-us/aspnet/core/migration/50-to-60) 				
- ​						[Migrate from ASP.NET Core 3.1 to 5.0](https://docs.microsoft.com/en-us/aspnet/core/migration/31-to-50) 				
- ​						[Migrate from ASP.NET Core 3.0 to 3.1](https://docs.microsoft.com/en-us/aspnet/core/migration/31-to-50) 				
- ​						[Migrate from ASP.NET Core 2.2 to 3.0](https://docs.microsoft.com/en-us/aspnet/core/migration/22-to-30) 				
- ​						[Migrate from ASP.NET Core 2.1 to 2.2](https://docs.microsoft.com/en-us/aspnet/core/migration/21-to-22) 				
- ​						[Migrate from .NET Core 2.0 to 2.1](https://docs.microsoft.com/en-us/dotnet/core/migration/20-21) 				
- ​						[Migrate from ASP.NET to ASP.NET Core](https://docs.microsoft.com/en-us/aspnet/core/migration/?view=aspnetcore-2.1) 				
- ​						[Migrating .NET Core projects from project.json](https://docs.microsoft.com/en-us/dotnet/core/migration/) 				
- ​						[Migrate from project.json to .csproj format](https://docs.microsoft.com/en-us/dotnet/core/tools/project-json-to-csproj) 				

Note

​					If migrating from .NET Core 1.x to 2.0, see the first few related sections in [Migrate from ASP.NET Core 1.x to 2.0](https://docs.microsoft.com/en-us/aspnet/core/migration/1x-to-2x/?view=aspnetcore-2.1). These sections provide guidance that is appropriate for a .NET Core 1.x to 2.0 migration path. 			

## 7.2. Porting from .NET Framework

​				Refer to the following Microsoft articles when migrating from .NET Framework: 		

- ​						For general guidelines, see [Porting to .NET Core from .NET Framework](https://docs.microsoft.com/en-us/dotnet/core/porting/). 				
- ​						For porting libraries, see [Porting to .NET Core - Libraries](https://docs.microsoft.com/en-us/dotnet/core/porting/libraries). 				
- ​						For migrating to ASP.NET Core, see [Migrating to ASP.NET Core](https://docs.microsoft.com/en-us/aspnet/core/migration/?view=aspnetcore-2.2). 				

​				Several technologies and APIs present in the .NET Framework are not  available in .NET Core and .NET. If your application or library requires these APIs, consider finding alternatives or continue using the .NET  Framework. .NET Core and .NET do not support the following technologies  and APIs: 		

- ​						Desktop applications, for example, Windows Forms and Windows Presentation Foundation (WPF) 				
- ​						Windows Communication Foundation (WCF) servers (WCF clients are supported) 				
- ​						.NET remoting 				

​				Additionally, several .NET APIs can only be used in Microsoft  Windows environments. The following list shows examples of these  Windows-specific APIs: 		

- ​						`Microsoft.Win32.Registry` 				
- ​						`System.AppDomains` 				
- ​						`System.Drawing` 				
- ​						`System.Security.Principal.Windows` 				

Important

​					Several APIs that are not supported in the default version of .NET may be available from the [Microsoft.Windows.Compatibility](https://blogs.msdn.microsoft.com/dotnet/2017/11/16/announcing-the-windows-compatibility-pack-for-net-core/#using-the-windows-compatibility-pack) NuGet package. Be careful when using this NuGet package. Some of the APIs provided (such as `Microsoft.Win32.Registry`) only work on Windows, making your application incompatible with Red Hat Enterprise Linux. 			

# Legal Notice

​				Copyright © 2021 Red Hat, inc. 		

​				The text of and illustrations in this document are licensed by Red  Hat under a Creative Commons Attribution–Share Alike 3.0 Unported  license ("CC-BY-SA"). An explanation of CC-BY-SA is available at http://creativecommons.org/licenses/by-sa/3.0/. In accordance with CC-BY-SA, if you distribute this document or an  adaptation of it, you must provide the URL for the original version. 		

​				Red Hat, as the licensor of this document, waives the right to  enforce, and agrees not to assert, Section 4d of CC-BY-SA to the fullest extent permitted by applicable law. 		

​				Red Hat, Red Hat Enterprise Linux, the Shadowman logo, the Red Hat  logo, JBoss, OpenShift, Fedora, the Infinity logo, and RHCE are  trademarks of Red Hat, Inc., registered in the United States and other  countries. 		

​				Linux® is the registered trademark of Linus Torvalds in the United States and other countries. 		

​				Java® is a registered trademark of Oracle and/or its affiliates. 		

​				XFS® is a trademark of Silicon Graphics International Corp. or its subsidiaries in the United States and/or other countries. 		

​				MySQL® is a registered trademark of MySQL AB in the United States, the European Union and other countries. 		

​				Node.js® is an official trademark of  Joyent. Red Hat is not formally related to or endorsed by the official  Joyent Node.js open source or commercial project. 		

​				The OpenStack® Word Mark and  OpenStack logo are either registered trademarks/service marks or  trademarks/service marks of the OpenStack Foundation, in the United  States and other countries and are used with the OpenStack Foundation's  permission. We are not affiliated with, endorsed or sponsored by the  OpenStack Foundation, or the OpenStack community. 		

​				IBM® and IBM Z® are trademarks or registered trademarks of International Business Machines Corp., registered in many jurisdictions worldwide. 		

​				All other trademarks are the property of their respective owners. 		