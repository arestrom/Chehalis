
# Chehalis

## Overview

This application provides a front-end interface to WDFWs SG (Spawning
Ground) database. The application is in an early developmental state. It
is intended to serve as a temporary bridge to enable WDFW biologists
working in the Chehalis Basin to enter and edit data until a permanent
solution can be built using our standard NodeJS Angular framework. This
application will only work for those who have been granted appropriate
permissions to the database…a tightly restricted group. No credentials
are stored in the `R` code.

If you are not an employee of WDFW, but want to explore the
functionality of the interface, you will need to create and host your
own database separately. A create script for the database can be found
in the `database` folder. The same folder includes generic `SQL` code to
define views and database roles, and also `R` code that can be used to
upload stream geometry to the database. A local instance of the database
is quick and easy to set up. For an overview of the SG database, you can
find the most recent version of the SG data dictionary at:
<https://arestrom.github.io/sgsdd/>

## Installation

Although the application code above can be run directly from an
`RStudio` session, the final application is designed to be compiled and
distributed as a standalone Windows installer. It does not require admin
rights to install. The installer will create a new directory called
`Apps\Chehalis` under the users `Documents` folder. It will also place
an icon on the users desktop for launching. The application comes
bundled with a portable version of R and includes all package
dependencies. No separate install of `R` is needed. This also means that
the application should continue to work well into the future, even as
the underlying technology and web of dependencies change. For details on
how to package up a standalone installer for `Shiny` framework
applicatons see: <https://github.com/arestrom/refreeze>

## Start and stop the application

Before launching the application you are strongly advised to make sure
your default browser is set to something like `Chrome` or `Firefox`. The
interface is unlikely to work correctly using a Microsoft browser. After
double-clicking the desktop icon, it may take a few seconds to open.
Please **do not** use the refresh icon in your browser when running the
application. If you do you will need to close and reopen.

## Permissions

In order to use this application you **must** first be granted
permissions to the database. For WDFW employees, please contact the
database administrator to be whitelisted and granted the appropriate
permissions. When you run the application the user name is set by
default to be the same as the user name of the person that logged into
the computer. This is by design. It allows recording the user name to
the database `created_by` or `modified_by` fields anytime new entries,
updates, or edits are committed.

The first time you use the application you will be automatically routed
to an entry form to enable storing your database credentials and
required connection information. Afterwards you will only see the
credentials screen if changes are made to the server, or your password
lapses. If that happens please contact the database administrator to
verify that your password is current, and that you have entered the
correct values for the server host and port. Database connection
credentials are secured as encrypted values in the Windows Credential
Manager.

### In case of a crash

If after installing the standalone application, it crashes, or fails to
load, navigate to the `out.txt` folder in the App directory:
`C:\Documents\Apps\Chehalis\out.txt`. The `out.txt` file will log the
first fatal error encountered. Please include this information when
reporting the error.

After a crash you may also need to kill any active `R` processes using
Windows Task Manager. Click `Ctrl-Alt-Delete` to open Task Manager. Then
in the `Processes` tab, look for any processes named
`R for Windows front-end` or `R for Windows terminal front-end`. You can
right-click on these and select `End task` to terminate the process.
