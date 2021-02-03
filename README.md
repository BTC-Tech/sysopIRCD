# sysopIRCD

=-------------------------------------------------------------------=
Welcome to SysOp IRC Services RC1.1 release.
WEB: http://www.sysop-services.org
IRC: irc.btctech.co.uk PORT: 6667
EMAIL: support@btctech.co.uk
=-------------------------------------------------------------------=


Welcome to yet another version of SysOp IRCd Services.

In this version more and more of the core code is being converted
to use our new $lang method for end user multi langauage environment.
However this is not complete yet i guess about 30% of the core is
actually fully multi language.

We have introduced a better logging system CHANLOGS and SYSTEMLOGS
commands are availabe to irc operators and channel users with enough access.

The channel cap kick is now based on a channel setting percentage, set 
your channel CapKick to 70 and users will be kicked if they exceed 70%
capital letters in there sentence.

We have also included channel and nickname expire, based on XSET system settings
default 21d channels and nickanames will expire if not used within the time set.
The time format can be either 1d or 1w whatever you wish 7d and 1w would be the 
same time frame.

If you find a bug or something that isnt right email us at
support@sysop-services.org along with your network and nickname
as well as the problem.


SysOp has been tested on the UnrealIRCD protocol version 3.2xx
but she will connect to most common IRCD servers.

Please ensure before connecting that you create the C and U lines
for your services, refer to your server software documentation.

Help on each command can be found in the /help/ directory within this
package, for SysOp full list of commands available look in there.

=-------------------------------------------------------------------=
Installing SysOp
=-------------------------------------------------------------------=

Place a mirc.exe into the main directory available from www.mirc.com/get.html

open and edit the connection details under the topic [server] in services.conf
this must match the server you wish to connect too, have a look through this file 
and change various values to suit your needs.

change your email server address, this can be done by opening services.conf,
under topic [system] you see smtp= change that value to suit your needs.

DO NOT rename or change the directory structure as your help and database
locations may become corrupt if you do!

=-------------------------------------------------------------------=
Startin The Service
=-------------------------------------------------------------------=
Type /start

and /stop to stop the service

=-------------------------------------------------------------------=
Bugs And Support
=-------------------------------------------------------------------=

Email problems to support@sysop-services.org
Our website and support forums are online at www.sysop-services.org

=-------------------------------------------------------------------=
Credits
=-------------------------------------------------------------------=
Thanks to bozza of magixnetworks.org for his core re write and mailer
and support in SysOp Services



