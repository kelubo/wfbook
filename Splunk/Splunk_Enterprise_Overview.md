# Splunk Enterprise Overview
Version 6.2.4
## Introduction
### What's in this manual
This manual serves two purposes.  

>* About Splunk Enterprise: Provides a technical overview of Splunk Enterprise and its users. Discusses the Splunk Enterprise features and describes the components that make up a Splunk Enterprise deployment. 
>* Splunk Enterprise Resources and Documentation: Provides topics that help you navigate the documentation based on tasks you want to complete.  

## About Splunk Enterprise
### About Splunk Enterprise
Contents
What is Splunk Enterprise
Splunk Enterprise features
Download the Splunk Enterprise Quick Reference Guide
#### What is Splunk Enterprise
Splunk Enterprise is a software platform to search, analyze, and visualize the machine-generated data gathered from the websites, applications, sensors, devices, and so on, that comprise your IT infrastructure or business.
After you define the data source, Splunk Enterprise indexes the data stream and parses it into a series of individual events that you can view and search.
You can use the search processing language or the interactive pivot feature to create reports and visualizations.
#### Splunk Enterprise features
The following table highlights seven Splunk Enterprise features. You can read about more features on Splunk.com.
Feature 	Description
Indexing 	Splunk indexes machine data. This includes data streaming from packaged and custom applications, application servers, web servers, databases, networks, virtual machines, telecoms equipment, operating systems, sensors, and so on, that make up your IT infrastructure. The maximum indexing volume depends on the Splunk Enterprise license.
Data model 	A data model is a hierarchically-structured search-time mapping of semantic knowledge about one or more datasets. It encodes the domain knowledge necessary to build a variety of specialized searches of those datasets. These specialized searches are used by Splunk Enterprise to generate reports for Pivot users. Data model objects represent different datasets within the larger set of data indexed by Splunk Enterprise.
Pivot 	Pivot refers to the table, chart, or data visualization you create using the Pivot Editor. The Pivot Editor lets users map attributes defined by data model objects to a table or chart data visualization without having to write the searches to generate them. Pivots can be saved as reports and added to dashboards.
Search 	Search is the primary way users navigate data in Splunk Enterprise. You can write a search to retrieve events from an index, use statistical commands to calculate metrics and generate reports, search for specific conditions within a rolling time window, identify patterns in your data, predict future trends, and so on. Searches can be saved as reports and used to power dashboard panels.
Alerts 	Alerts are triggered when conditions are met by search results for both historical and real-time searches. Alerts can be configured to trigger actions such as sending alert information to designated email addresses, post alert information to an RSS feed, and run a custom script, such as one that posts an alert event to syslog.
Reports 	Reports are saved searches and pivots. You can run reports on an ad hoc basis, schedule them to run on a regular interval, set a scheduled report to generate alerts when the results of their runs meet particular conditions. Reports can be added to dashboards as dashboard panels.
Dashboards 	Dashboards are made up of panels that contain modules such as search boxes, fields, charts, tables, forms, and so on. Dashboard panels are usually hooked up to saved searches or pivots. They can display the results of completed searches as well as data from backgrounded real-time searches.
#### Download the Splunk Enterprise Quick Reference Guide

The Splunk Enterprise Quick Reference Guide (updated for version 6.1), is available only as a PDF file. It is a six-page reference card that provides information about Splunk Enterprise features, concepts, search commands, and search examples. 
### About Splunk Enterprise users

Splunk Enterprise serves different types of users. There are five main personas that use Splunk Enterprise:
Persona 	Industry Role 	Activities
Administrator 	network engineer, system administrator 	
Configures, administers, optimizes, and secures the Splunk Enterprise deployment.
    Sets up user accounts and permissions.
    Gets data into Splunk Enterprise. 

Knowledge Manager 	data analyst, system administrator 	
Oversees knowledge object creation, normalization, and usage across teams, departments, and deployments.
Gets the data into Splunk, or works with the administrator to do so.
Creates and shares data models. 

Search User 	data analyst, IT professional, network engineer, security analyst, system administrator 	
Uses Search to investigate server problems, understand configurations, monitor user activities, and troubleshoot escalated problems.
    Builds reports and dashboards to monitor the health, performance, activity, and capacity of their IT infrastructure.
    Identifies patterns and trends that are indicators of routine problems. 

Pivot User 	business professional, data analyst, executive, IT professional, manager, system administrator 	
    Uses Pivot to build reports based on data models created by the Knowledge Manager.
    Creates reports and dashboards to monitor their businesses.
    Identifies trends in the health and performance of their businesses. 

Developer 	system integrator, professional developer 	
    Integrates data and functionality of applications with Splunk Enterprise.
    Builds Splunk Apps and add-ons with custom dashboards and data visualizations. 
### About Splunk Enterprise deployments
Contents

     
    Splunk Enterprise and your IT infrastructure
     
    Splunk Enterprise Components

#### Splunk Enterprise and your IT infrastructure

Splunk Enterprise indexes data from the servers, applications, databases, network devices, virtual machines, and so on, that make up your IT infrastructure. As long as the machine that generates the data is a part of your network, Splunk Enterprise can collect the data from machines located anywhere, whether it is local (on-the-premises in a server room), remote (off-the-premises in a datacenter), entirely in the cloud, or a hybrid (such as on-premise and in the cloud).

Most users connect to Splunk Enterprise with a web browser and use Splunk Web to administer their deployment, manage and create knowledge objects, run searches, create pivots and reports, and so on. You can also use the command-line interface to administer your Splunk Enterprise deployment.

Splunk Enterprise supports a multi-user and distributed product architecture. This means that you can search and report on data spanning multiple Splunk Enterprise deployments within a single datacenter or globally across multiple datacenters and cloud infrastructures.
#### Splunk Enterprise Components
Component 	Description
Apps 	Apps are a collection of configurations, knowledge objects, and customer designed views and dashboards that extend the Splunk Enterprise environment to fit the specific needs of organizational teams such as Unix or Windows system administrators, network security specialists, website managers, business analysts, and so on. A single Splunk Enterprise installation can run multiple apps simultaneously.
Forwarder 	A forwarder is a Splunk Enterprise instance that forwards data to another Splunk Enterprise instance (an indexer or another forwarder) or to a third-party system.
Indexer 	An indexer is the Splunk Enterprise instance that indexes data. The indexer transforms the raw data into events and stores the events into an index. The indexer also searches the indexed data in response to search requests.
Receiver 	A receiver is a Splunk Enterprise instance configured to receive data from a forwarder. The receiver is either an indexer or another forwarder.
Search head 	In a distributed search environment, the search head is the Splunk Enterprise instance that handles search management functions, directing search requests to a set of search peers and then merging the results back to the user. If this instance does only searching and not indexing, it is usually referred to as a dedicated search head.
Search peer 	In a distributed search environment, the search peer is the Splunk Enterprise instance that performs indexing and fulfills search requests originating from the search head.


For more information about these components and their roles in a distributed deployment, see "Components and roles" in the Distributed Deployment Manual. 
## Splunk Enterprise Resources and Documentation
### Product resources
Contents
Documentation
Education
Community

This topic is an overview of the documentation, education, community resources to help you find the information you want about Splunk Enterprise and other Splunk products.
#### Documentation
What are you looking for? 	Where should you look?
Splunk Enterprise 	Everything you need to know about Splunk Enterprise configuration and usage is in the Splunk Enterprise documentation. The following topics will help you find information in the Splunk Enterprise documentation.
    Splunk Enterprise Administration
    Searching and Reporting
    Managing Knowledge
    Customize and Extend Splunk Enterprise
    Troubleshooting 

Splunk products 	Splunk products include Splunk Enterprise, Hunk, Splunk Cloud, and Splunk Storm. Each Splunk product has its own set of documentation which can be found on the Splunk.com documentation site.
Splunkbase 	Each app should have its own documentation. Typically, an app's documentation will be linked from the app's download page or included in the app's download package. An app's documentation will only be found on Splunk's documentation site if the app is supported by Splunk.
Splunk SDKs 	Splunk SDKs are documented on the Splunk for Developers site. There you will find information, tutorials, and examples for each of the Splunk SDKs. Find module libraries and other reference materials on the Splunk documentation site for SDKs.
#### Education
What are you looking for? 	Where should you look?
Splunk Education 	Splunk Classes and Certification Tracks
How-to video tutorials 	Splunk Education Videos
#### Community
What are you looking for? 	Where should you look?
Splunk Answers 	If you cannot find what you are looking for in the documentation, search Splunk Answers to see what the community has to say or ask your question there.
#splunk 	Log in to an IRC server on efnet and chat with Splunk developers, Splunk Support, and other Splunk community members. 
### Splunk Enterprise Administration
Contents
    Install and upgrade Splunk Enterprise
    Get data into Splunk Enterprise
    Manage indexes and indexers
    Scale Splunk Enterprise
    Secure Splunk Enterprise

This topic lists tasks that administrators might want to do and takes you to the manuals and topics to learn how to do them.
#### Install and upgrade Splunk Enterprise

The Installation Manual describes how to install and upgrade Splunk Enterprise.
Task: 	Look here:
Understand installation requirements 	Plan your installation
Estimate hardware capacity needs 	Estimate hardware requirements
Install Splunk 	Install Splunk on Windows
Install Splunk on Unix, Linux, or MacOS
Upgrade Splunk 	Upgrade from an earlier version
Perform backups 	Back up configuration information
Back up indexed data
Set a retirement and archiving policy
#### Get data into Splunk Enterprise

Getting Data In is the place to go for information about Splunk data inputs, including how to consume data from external sources and how to enhance the value of your data.
Task: 	Look here:
Learn how to consume external data 	How to get data into Splunk
Configure file and directory inputs 	Get data from files and directories
Configure network inputs 	Get network events
Configure Windows inputs 	Get Windows data
Configure miscellaneous inputs 	Other ways to get stuff in
Enhance the value of your data 	Configure event processing
Configure timestamps
Configure indexed field extraction
Configure host values
Configure source types
Manage event segmentation
See how your data will look after indexing 	Preview your data
Improve the process 	Improve the data input process
Understand the data pipeline 	How data moves through Splunk Enterprise: the data pipeline
#### Manage indexes and indexers

Managing Indexers and Clusters tells you how to configure indexes. It also explains how to manage the components that maintain indexes: indexers and clusters of indexers.
Task: 	Look here:
Learn about indexing 	Indexing overview
Manage indexes 	Manage indexes
Manage index storage 	How the indexer stores indexes
Back up indexes 	Back up indexed data
Archive indexes 	Set a retirement and archiving policy
Learn about clusters and index replication 	About clusters and index replication
Deploy clusters 	Deploy clusters
Configure clusters 	Configure clusters
Manage clusters 	Manage clusters
Learn about cluster architecture 	How clusters work
#### Scale Splunk Enterprise

The Distributed Deployment Manual describes how to distribute Splunk Enterprise functionality across multiple components, such as forwarders, indexers, and search heads. Associated manuals cover distributed components in detail:
    The Forwarding Data Manual describes forwarders.
    The Distributed Search Manual describes search heads.
    The Updating Splunk Components Manual explains how to use the deployment server and forwarder management to manage your deployment. 

Task: 	Look here:
Learn about distributed Splunk 	Distributed Splunk overview
Perform capacity planning for Splunk deployments 	Estimate hardware requirements
Learn how to forward data 	Forward data
Distribute searches across multiple indexers 	Search across multiple indexers
Update the deployment 	Deploy configuration updates across your environment
#### Secure Splunk Enterprise

Securing Splunk discusses how to secure your Splunk Enterprise deployment.
Task: 	Look here:
Authenticate users and edit roles 	User and role-based access control
Secure Splunk data with SSL 	Secure authentication and encryption
Audit Splunk 	Audit Splunk activity
Use Single Sign-on (SSO) with Splunk 	Configure Single Sign-on
Use Splunk with LDAP 	Set up user authentication with LDAP
### Searching and Reporting
Contents
    Searching
    Creating Pivots
    Reporting
    Alerting
    Creating dashboards and visualizations

The Searching and Reporting app lets you search your data, create data models and pivots, save your searches and pivots as reports, configure alerts, and create dashboards.
#### Searching

The Search Manual discusses how to search and use the Search Processing Language (SPL). See the Search Reference for a catalog of the search commands with syntax, descriptions, and examples for each command.
Task: 	Look here:
You are new to Splunk Enterprise and want to learn how to search and use the search processing language 	Start with the Search Tutorial
Learn more about the search processing language 	About search

About the search language

The search processing language syntax

About transforming commands and searches

About real-time searches and reports
Find a specific search command or function 	List of search commands

List of search commands by category

Evaluation functions

Statistical and charting functions
Manage search jobs 	About jobs and jobs management

View search job properties with the Search Jobs Inspector
#### Creating Pivots

The Knowledge Manager Manual includes a section that discusses how to design and build data models using the data model editor. The Pivot Manual discusses how to build pivots tables and charts.
Task: 	Look here:
You are new to Splunk Enterprise and want to learn about data model and pivot 	Pivot Tutorial
Learn about data models and how to build them 	About data models
Learn more about Pivot and how to use the Pivot Editor to design tables and charts. 	Pivot Manual
#### Reporting

See more about reports and report management in the Reporting Manual.
Task: 	Look here:
Use search commands to generate reports 	About transforming commands and searches
Learn about the different kinds of visualizations (tables, charts, event listings, and so on) 	Dashboards and Visualizations

Data structure requirements for visualizations
Save a search or pivot as a report 	Create and edit reports
Accelerate a report

Understand requirements for report acceleration
	Accelerate reports
Schedule a report 	Schedule reports
Generate a PDF of your report 	Generate PDFs of your reports and dashboards
#### Alerting

See how to create and dispatch alerts in the Alerting Manual.
Task: 	Look here:
Learn about alerts 	About alerts
Set up email notifications, RSS notifications, or alert scripts 	Set up alert actions
See alerting examples 	Alert Examples
See recently triggered alerts 	Review triggered alerts using the Alert Manager
Set up alerts using the configuration files 	Configure alerts in savedsearches.conf
#### Creating dashboards and visualizations
Task: 	Look here:
Learn about dashboards 	Overview of dashboards
Learn how to create and edit dashboards 	Create and edit dashboards via Splunk Web

Edit dashboard panel visualizations

Build and edit dashboards with simple XML
Learn about the different kinds of visualizations (tables, charts, event listings, and so on) 	Visualization Reference

Data structure requirements for visualizations
Learn about the default activity and summary dashboards 	Splunk default dashboards
Learn about the Splunk Web Framework 	Splunk Web Framework Overview
### Managing Knowledge
Contents
     Splunk Enterprise Knowledge
     Events and event processing
     Fields and field extractions
     Build Data models

These tables direct you to topics for understanding and managing knowledge objects such as events, fields, lookups, and data models.
#### Splunk Enterprise Knowledge
Task: 	Look here:
Understand Splunk Enterprise knowledge 	What is Splunk Enterprise Knowledge?

Understand and use the Common Information Model
Manage knowledge objects 	Monitor and organize knowledge objects

Disable or delete knowledge objects
#### Events and event processing
Task: 	Look here:
Configure event processing 	Configure event processing
Manage event segmentation 	Manage event segmentation
Understand events and event types 	About event types

Classify and group similar events
#### Fields and field extractions
Task: 	Look here:
Understand fields 	About fields

Use default fields

Configure multivalue fields

Define calculated fields
Understand and manage field extractions 	About fields

When Splunk Enterprise extracts fields

Manage search-time field extractions

About Splunk Enterprise regular expressions
#### Build Data models
Task: 	Look here:
Learn about data models and objects 	About data models
Manage data models and objects 	Manage data models
Use the Data Model Editor 	Design data models and objects
### Customize and Extend Splunk Enterprise
Developers can build Splunk Apps and integrate Splunk Enterprise with other tools and applications.Follow these links to help you get started.
#### Develop Splunk Apps
task:	look here:
use the Splunk Web Framework	Splunk Web Framework Overview
See Splunk Web Framework examples	Splunk Web Framework Code examples
See Splunk web Framework components	Splunk web framework component Reference
#### use the Splunk REST API
using the Splunk REST API,developers can programmatically index,search,and visualize data in Splunk Enterprise from any application.
Task:	Look here:
Get started with the Splunk REST API	Splunk REST API Overview
Learn how to use the Splunk REST API	Rest API Tutorials
Understand how to improve your logs to work with Splunk	Logging overview Logging best practices
See the REST API Reference	REST API Reference
#### Download and install the Splunk SDKs
Find information about Splunk SDKs on the Splunk for Developers Site and the Splunk Documentation site for SDKs.
Task:	look here:
Learn more about the Splunk SDKs	overview of the Splunk SDKs
see the code library and examples for a Splunk SDK	Splunk SDK Reference
#### Extend Splunk Enterprise Functionality
Developers can expand the search language to perform custom processing or calculations and customize data inputs programmatically.
Task:	Look here:
Expand the search language	Write custom search commands create and use search macros configure scripted alerts
manage custom data inputs	scripted inputs overview Modular inputs overview
### Troubleshooting
The troubleshooting manaual discusses how to analyze activity and diagnose problems with Splunk Enterprise.You can also look in other manuals to find specific information.For example,you can find topics on how to improve search performance in the Search Manual.
Task:	Look here:
Learn about new features,known issues,and fixed probles	what's new in the version Known issues for this release
Learn about splunk Enterprise troubleshooting tools 	introduction to troubleshooting splunk enterprise use btool to troubleshoot configurations use the Splunk on Splunk App
Use th Platform information Framework	About the platform instrumentation framework
Understand Splunk Enterprise log files what Splunk Enterprise logs about itself About metrics.log
Troubleshoot Search Performance	write better searches view search properites with the search job inspector
Troubleshoot license violations	about license violations USe the License Usage Report View