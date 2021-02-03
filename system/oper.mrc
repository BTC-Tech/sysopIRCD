; Copying or editing of any of the scripts included in this module is strictly prohibited, you may distribute the package
; in its entireity un edited in any form. Support can only be given to those who do not edit these files please do not ask
; if you plan to edit them yourself. Credits and links back to us must remain in the script we do not advertise using your
; network unless the .VERSION command is triggered. You must also agree when connecting the service to any IRC net
; that you have the correct permission to connect the service, you MUST NOT connect the service to Digi-Net and you
; connect the service at your own risk. For support see http://www.digi-net.org

alias system.modcmd {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :4,4. $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY to use this command.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($hasaccess(modcmd,$1) != true) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry, you do not have the correct access for this function.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }

  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  MODCMD Admin
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Invalid command arguments, see HELP MODCMD
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }

  if (!$readcmd($2,command) && ($2 != *)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  MODCMD Admin
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Command:  $2  does not exist, to create it
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color please prepend with * like so...
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color /msg $netconf(sywstem,nickname) MODCMD * $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color This will create a new default function to edit later.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }

  if ($2 == *) {
    if (!$3 || !$4) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  MODCMD Admin
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Invalid command arguments, see HELP MODCMD
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
      } else {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  MODCMD Admin
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Created new function:  $+ $3
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Now see: CMD $2 $+ , MODCMD $2
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      ;create new alias DB entry
      writeini data/aliases.db $3 command $4-
      writeini data/aliases.db $3 access OPER
      writeini data/aliases.db $3 level 123
      writeini data/aliases.db $3 chan 0
      writeini data/aliases.db $3 private 0
      writeini data/aliases.db $3 desc Added By $1
      halt
    }
    } else {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  MODCMD Admin
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry, command under construction.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }

}
alias system.globalnotice {
  if ($hasaccess(globalnotice,$1) != true) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry, you do not have the correct access for this function.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Usage
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Message Required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color try /msg SysOp HELP GLOBALNOTICE
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  ;send global notice
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Sending Global Notice
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sending Global Notice To All Clients
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  if ($netconf(system,loging) == on) { 
    writetolog system Sending globalnotice triggered by $1
  }
  var %x = 1
  while ($ini(data/clients.db,%x)) {
    .sockwrite -tn serv $+(:,$netconf(system,service2)) NOTICE $ini(data/clients.db,%x) [ $+ $1 $+  $+ ] $2-
    inc %x
  }
}
alias system.sconnect {
  if ($hasaccess(sconnect,$1) != true) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry, you do not have the correct access for this function.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Usage
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Server Required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color try /msg SysOp HELP SCONNECT
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  ;send global notice
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Attempting To Connect To Server
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Linking $2
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  if ($netconf(system,loging) == on) { 
    writetolog system SCONNECT by $1 for server $2
  }
  ;do the stuff
  sockwrite -tn serv $+(:,$netconf(server,server)) CONNECT $2
}
alias system.clist {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :4,4. $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY to use this command.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($addy($1),operlevel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You have no IRCop access to $netconf(system,nickname)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You Are Not An IRC Operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) || ($readnick($1,operlevel) < $netconf(opercmds,clist)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Usage
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Host wildcard required, i.e *.com, *.net
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color try /msg SysOp HELP CLIST
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($3) && ($readclient($3,nickname)) {
    var %sento $3
  }
  else {
    var %sento $1
  }
  ;send hlist to client
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE %sento :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE %sento : $+ %color $+  Listing online users that match $2
  var %x 1
  var %found 0
  while ($ini(data/clients.db,%x)) {
    if ($2 iswm $readclient($ini(data/clients.db,%x),host)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE %sento : $+ %color Match: $ini(data/clients.db,%x) - $readclient($ini(data/clients.db,%x),host)
      inc %found   
    }
    inc %x
  }
  if (%found < 1) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE %sento : $+ %color There are no matching records!
  }
  else {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE %sento : $+ %color There are  $+ %found $+ / $+ $ini(data/clients.db,0) $+  records found.
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE %sento :-
  if (%sento != $1) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Sent CLIST
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color I have sent a CLIST to %sento
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  }
}
alias system.hlist {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :4,4. $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY to use this command.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($addy($1),operlevel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You have no IRCop access to $netconf(system,nickname)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You Are Not An IRC Operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) || ($readnick($1,operlevel) < $netconf(opercmds,hlist)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Usage
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Host wildcard required, i.e *.com, *.net
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color try /msg SysOp HELP HLIST
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  ;send hlist to client
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Listing registered users that match $2
  var %x 1
  var %found 0
  while ($ini(data/nicknames.db,%x)) {
    if ($2 iswm $readnick($ini(data/nicknames.db,%x),lasthost)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Match: $ini(data/nicknames.db,%x) - $readnick($ini(data/nicknames.db,%x),lasthost)
      inc %found   
    }
    inc %x
  }
  if (%found < 1) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color There are no matching records!
  }
  else {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color There are  $+ %found $+ / $+ $ini(data/nicknames.db,0) $+  records found.
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
}
alias system.purgeseen {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY to use this command.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You Are Not An IRC Operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($addy($1),operlevel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You have no IRCop access to $netconf(system,nickname)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) && ($readnick($1,operlevel) < $netconf(opercmds,purgeseen)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  ;send global notice
  if ($netconf(system,loging) == on) { 
    writetolog system Cleaning out the SEEN database triggered by $1
  }
  var %ret = $sql_countseen
  if (%ret>0) {
    sql_deleteseen
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  PurgeSeen Complete
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Removed  $+ %ret $+  records from the seen database.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    } else {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  PurgeSeen Complete
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Nothing to be cleared, databases are upto date.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  }

  halt
}
alias system.operabuse {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY to use this command.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You Are Not An IRC Operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($addy($1),operlevel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You have no IRCop access to $netconf(system,nickname)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) && ($readnick($1,operlevel) < $netconf(opercmds,operabuse)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Usage
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Nickname is required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color try /msg SysOp HELP OPERABUSE
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($2 == remove) {
    if (!$3) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Usage
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Nickname is required
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color try /msg SysOp HELP OPERABUSE
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Blacklisting IRC Operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $3 has been removed from blacklist
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    remini data/blacklist.db opers $3
    report OPERABUSE: Blacklisting $3 removed by $1
    if ($netconf(system,loging) == on) { 
      writetolog system $1 removed blacklisted operator $3
    }
    halt
  }
  ;send global notice
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Blacklisting IRC Operator
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 will be blacklisted untill removed.
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  writeini data/blacklist.db opers $2 Added By $1
  report OPERABUSE: Blacklisting $2 requested by $1
  if ($netconf(system,loging) == on) { 
    writetolog system $1 blacklisted IRCoperator $2
  }
}
alias system.jupe {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY to use this command.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You Are Not An IRC Operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($addy($1),operlevel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You have no IRCop access to $netconf(system,nickname)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) && ($readnick($1,operlevel) < $netconf(opercmds,jupe)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Usage
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Server Name Required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color try /msg SysOp HELP JUPE
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  ;send global notice
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Creating Jupiter Server
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color  $lower($2) server being created. simply SQUIT it to remove it
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  if ($netconf(system,loging) == on) { 
    writetolog system $1 created JUPE server $2
  }
  .sockwrite -tn serv SERVER $lower($2) 1 : $+ Jupe By $1
  report JUPE: $1 used jupe to create $lower($2)

}
alias system.badwords {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY to use this command.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You Are Not An IRC Operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($addy($1),operlevel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You have no IRCop access to $netconf(system,nickname)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) && ($readnick($1,operlevel) < $netconf(opercmds,badwords)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($2 == add) {
    if (!$3) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Cannot Complete
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You must specify a bad word
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  /msg $netconf(system,nickname) HELP BADWORDS
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    set %bwords %bwords $+ $lower($3) $+ $chr(44)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Added New Bad Word
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lower($3) $+  has been added to the badword database
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    if ($netconf(system,loging) == on) { 
      writetolog system $1 added $lower($3) as a system badword
    }
    halt
  }
  ;send global notice
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Listing System Filtered Bad Words
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color
  var %x = 1
  while ($gettok(%bwords,%x,44)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $gettok(%bwords,%x,44)
    inc %x
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  End Of List
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
}
alias system.pending {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY to use this command.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You Are Not An IRC Operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($addy($1),operlevel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You have no IRCop access to $netconf(system,nickname)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) && ($readnick($1,operlevel) < $netconf(opercmds,pending)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($ini(data/pending.db,0) < 1) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Not Required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color There are no pending items.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($2 == reject) {
    if (!$3) || (!$4) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Cannot Complete
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You must specify a nickname and item
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  /msg $netconf(system,nickname) HELP PENDING
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if (!$readini(data/pending.db,$3,$4)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Cannot Complete
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color There is no pending item matching that request
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  /msg $netconf(system,nickname) PENDING
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if ($4 == vhost) {
      addnick $3 vhostactive no
    }
    delpending $3 $4
    if ($ini(data/pending.db,$3,0) < 1) { remini data/pending.db $3 }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Rejected Pending Item
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+   $+ $3 $+ 's $lower($4) $+  has been rejected and removed as pending
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }

  if ($2 == accept) {
    if (!$3) || (!$4) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Cannot Complete
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You must specify a nickname and item
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  /msg $netconf(system,nickname) HELP PENDING
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if (!$readini(data/pending.db,$3,$4)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Cannot Complete
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color There is no pending item matching that request
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  /msg $netconf(system,nickname) PENDING
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if ($4 == vhost) {
      addnick $3 vhost $readnick($3,newvhost)
      addnick $3 vhostactive yes
      remini data/nicknames.db $3 newvhost
      if ($readclient($3,nickname)) { sockwrite -tn serv $+(:,$netconf(server,server)) CHGHOST $3 $readnick($3,vhost) }
    }
    if ($4 == tac) {
      writeini data/nicknames.db $3 status active
      remini data/nicknames.db $3 tac
      addnick $3 nickname $3
    }
    if ($4 == qdb) {
      writeini data/nicknames.db $3 status active
      remini data/nicknames.db $3 tac
      addnick $3 nickname $3
    }
    delpending $3 $4
    if ($ini(data/pending.db,$3,0) < 1) { remini data/pending.db $3 }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Approved Pending Item
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+   $+ $3 $+ 's $lower($4) $+  has been accepted and removed as pending
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  ;send global notice
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Listing System Pending Items
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color [nickname] - [item] - [data]
  var %x = 1
  while ($ini(data/pending.db,%x)) {
    var %x2 = 1
    while ($ini(data/pending.db,$ini(data/pending.db,%x),%x2)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $ini(data/pending.db,%x) - 12 $+ $ini(data/pending.db,$ini(data/pending.db,%x),%x2) - $readini(data/pending.db,$ini(data/pending.db,%x),$ini(data/pending.db,$ini(data/pending.db,%x),%x2))
      inc %x2
    }
    inc %x
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color To Edit An Item:
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  /msg $netconf(system,nickname) PENDING [accept/reject] <nickname> <item>
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  End Of Pending List
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
}
alias system.channelnotice {
  if ($hasAccess(channotice,$1) != true) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,access,title)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,access,msg)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,missinginfo)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $replace($lang($1,errors,minfo),[x],Message)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,misc,try) /msg $netconf(system,nickname) HELP CHANNOTICE
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  ;send global notice
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,misc,cmdcomplete)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,ircops,chansendall)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  if ($netconf(system,loging) == on) { 
    writetolog system $1 sent a channel notice to all channels
  }
  var %x = 1
  while ($ini(data/activechans.db,%x)) {
    .sockwrite -tn serv :Global PRIVMSG $ini(data/activechans.db,%x) [ $+ $1 $+  $+ ] $2-
    inc %x
  }
}
alias system.randomnews {
  if ($hasAccess(randomnews,$1) != true) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,access,title)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,access,msg)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($2 == delete) {
    if (!$3) { var %n null }
    else { var %n $3 }
    if (!$ini(data/news.db,random,%n)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,missinginfo)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $replace($lang($1,errors,noitm),[x],%n)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    ;delete randomnews item
    delnews random %n
    report RANDOM NEWS: Random news  $+ %n $+  removed by $1
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,misc,cmdcomplete)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,ircops,opnewsdel)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sysnotice2 $1  $lang($1,ircops,opnewsdisp)
    var %x = 1    
    while ($ini(data/news.db,random,%x)) {
      sysnotice2 $1 * $+ $ini(data/news.db,random,%x) $+ * $readini(data/news.db,random,$ini(data/news.db,random,%x))
      inc %x
    }
    halt
  }
  ;save ranodm news
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,misc,cmdcomplete)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $replace($lang($1,ircops,opnewsadd),[x],$calc($ini(data/news.db,random,0) + 1))
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  if ($netconf(system,loging) == on) { 
    writetolog system $1 added random news
  }
  writeini data/news.db random $calc($ini(data/news.db,random,0) + 1) $2-
}
alias system.opernews {
  if ($hasaccess(opernews,$1) != true) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,access,title)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,access,msg)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($2 == delete) {
    if (!$3) { var %n null }
    else { var %n $3 }
    if (!$ini(data/news.db,oper,%n)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,missinginfo)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $replace($lang($1,errors,noitm),[x],%n)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    ;delete randomnews item
    delnews oper %n
    report OPER NEWS: Oper news  $+ %n $+  removed by $1
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,misc,cmdcomplete)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,ircops,opnewsdel)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sysnotice2 $1  $lang($1,ircops,opnewsdisp)
    var %x = 1    
    while ($ini(data/news.db,oper,%x)) {
      sysnotice2 $1 * $+ $ini(data/news.db,oper,%x) $+ * $readini(data/news.db,oper,$ini(data/news.db,oper,%x))
      inc %x
    }
    halt
  }
  ;save ranodm news
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,misc,cmdcomplete)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $replace($lang($1,ircops,opnewsadd),[x],$calc($ini(data/news.db,oper,0) + 1))
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  if ($netconf(system,loging) == on) { 
    writetolog system $1 added oper news
  }
  writeini data/news.db oper $calc($ini(data/news.db,oper,0) + 1) $2-
}
alias system.logonnews {
  if ($hasAccess(logonnews,$1) != true) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,access,title)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,access,msg)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($2 == delete) {
    if (!$3) { var %n null }
    else { var %n $3 }
    if (!$ini(data/news.db,logon,%n)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,missinginfo)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $replace($lang($1,errors,noitm),[x],%n)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    delnews logon %n
    report LOGON NEWS: Logon news  $+ %n $+  removed by $1
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,misc,cmdcomplete)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,ircops,opnewsdel)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sysnotice2 $1  $lang($1,ircops,opnewsdisp)
    var %x = 1    
    while ($ini(data/news.db,logon,%x)) {
      sysnotice2 $1 * $+ $ini(data/news.db,logon,%x) $+ * $readini(data/news.db,logon,$ini(data/news.db,logon,%x))
      inc %x
    }
    halt
  }
  ;save ranodm news
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,misc,cmdcomplete)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $replace($lang($1,ircops,opnewsadd),[x],$calc($ini(data/news.db,logon,0) + 1))
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  if ($netconf(system,loging) == on) { 
    writetolog system $1 added logon news
  }
  report LOGON NEWS: Added news item  $+ $calc($ini(data/news.db,logon,0) + 1) $+  by $1
  writenews logon $calc($ini(data/news.db,logon,0) + 1) $2-
}
alias system.kill {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY to use this command.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You Are Not An IRC Operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($addy($1),operlevel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You have no IRCop access to $netconf(system,nickname)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) && ($readnick($1,operlevel) < $netconf(opercmds,kill)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Usage
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Nickname Required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color try /msg SysOp HELP KILL
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readnick($1,operlevel) < $readnick($2,operlevel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Cannot kill higher ranking IRC operators
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readclient($2,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  User Not Found
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 12 $+ $2 $+  doesnt seem to be online
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  }
  else {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Killing User From IRC
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Killing user 12 $+ $2  $+ as requested
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    if ($netconf(system,loging) == on) { 
      writetolog system $1 killed $2 from the network
    }
    if (!$3) { .sockwrite -tn serv $+(:,$netconf(server,server)) KILL $2 Requested By $1  }
    else { .sockwrite -tn serv $+(:,$netconf(server,server)) KILL $2 $3- }
  }
}
alias system.chan.bl {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY to use this command.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You Are Not An IRC Operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($addy($1),operlevel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You have no IRCop access to $netconf(system,nickname)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) && ($readnick($1,operlevel) < $netconf(opercmds,channelblacklist)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($2 == list) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Channel BlackList
    var %x 1
    var %found 0
    while ($ini(data/chanbl.db,%x)) {
      if ($chanBL($ini(data/chanbl.db,%x),expiretime) == 0) {
        var %expires Never
      }
      else {
        var %expires $asctime($chanBL($ini(data/chanbl.db,%x),expiretime))
      }
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Entry ID:  $+ %x $+  Added By: $chanBL($ini(data/chanbl.db,%x),by) 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel:  $+ $ini(data/chanbl.db,%x) $+  Expires: %expires
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Reason: $chanBL($ini(data/chanbl.db,%x),reason)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color To Remove: /msg $netconf(system,nickname) CHANNELBLACKLIST REMOVE $ini(data/chanbl.db,%x)
      inc %found
      inc %x
    }
    if (%found < 1) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color No entries found!
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color End of List
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($2 == remove) {
    if (!$3) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Usage
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Missing Channel required to remove CHANNELBLACKLIST
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color try /msg SysOp HELP CHANNELBLACKLIST
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if (!$chanbl($3,by)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Usage
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel  $+ $3 $+ , No such blacklist entry exists.
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color try /msg SysOp HELP CHANNELBLACKLIST
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Removing Blacklisted Channel
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Removed blacklisted channel  $+ $3
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    wipechanBL $3
    report CHANNEL BLACKLIST: $1 removed blacklisted channel $3
    halt
  }
  if (!$2) || (!$3) || (!$4) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Usage
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel time and reason required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color try /msg SysOp HELP CHANNELBLACKLIST
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  var %expire -1
  if (d isin $3) { var %expire $calc($ctime + ($remove($3,d) * 86400)) }
  if (w isin $3) { var %expire $calc($ctime + ($remove($3,w) * 604800)) }
  if (s isin $3) { var %expire $calc($ctime + $remove($3,s)) }
  if (m isin $3) { var %expire $calc($ctime + ($remove($3,m) * 60)) }
  if (h isin $3) { var %expire $calc($ctime + ($remove($3,h,m,s) * 3600)) }
  if ($3 == never) { var %expire 0 | var %never true }
  if (%expire < 1) && (!%never) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Invalid Time option, 0w0d0h0m0s I.E 1w or 7d
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }

  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Blacklisting Channel
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel 12 $+ $2  $+ blacklisted as requested
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  if ($netconf(system,loging) == on) { 
    writetolog system $1 Blacklisted channel $2 from the network
  }
  writetolog $1 Added blacklisted channel $2
  report CHANNEL BLACKLIST: $1 added blacklisted channel $2
  var %banID $2
  addchanBL %banID by $1
  addchanBL %banID time $ctime
  addchanBL %banID expire $3
  addchanBL %banID expiretime %expire
  if ($4) {
    addchanBL %banID reason $4-
  }
  else {
    addchanBL %banID reason Requested
  }

}
alias system.gline {
  if ($hasaccess(gline,$1) != true) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($2 == list) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  GLINE List
    var %x 1
    var %found 0
    while ($ini(data/glines.db,%x)) {
      if ($readnetban($ini(data/glines.db,%x),type) == GLINE) {
        if ($readnetban($ini(data/glines.db,%x),expiretime) != 0) {
          var %expire $asctime($readnetban($ini(data/glines.db,%x),expiretime))
        }
        else {
          var %expire Never
        }
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Entry ID:  $+ %x $+  Added By: $readnetban($ini(data/glines.db,%x),by) 
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Address:  $+ $readnetban($ini(data/glines.db,%x),address) $+  Expires: %expire
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Reason: $readnetban($ini(data/glines.db,%x),reason)
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color To Remove: /msg $netconf(system,nickname) GLINE REMOVE %x
        inc %found
      }
      inc %x
    }
    if (%found < 1) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color No entries found!
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color End of List
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($2 == remove) {
    if (!$3) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Usage
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Missing ID required to remove GLINE
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color try /msg SysOp HELP GLINE
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if (!$readnetban($3,address)) || ($readnetban($3,type) != GLINE) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Usage
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color ID  $+ $3 $+ , No such GLINE exists.
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color try /msg SysOp HELP GLINE
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Removing GLINE
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Removed GLINE  $+ $readnetban($3,address)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv TKL - G * $readnetban($3,address) $readclient($1,host)
    wipenetban $3
    halt
  }
  if (!$2) || (!$3) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Usage
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Nickname and time value required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color try /msg SysOp HELP GLINE
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  var %expire -1
  if (d isin $3) { var %expire $calc($ctime + ($remove($3,d) * 86400)) }
  if (w isin $3) { var %expire $calc($ctime + ($remove($3,w) * 604800)) }
  if (s isin $3) { var %expire $calc($ctime + $remove($3,s)) }
  if (m isin $3) { var %expire $calc($ctime + ($remove($3,m) * 60)) }
  if (h isin $3) { var %expire $calc($ctime + ($remove($3,h,m,s) * 3600)) }
  if ($3 == never) { var %expire 0 | %notime true }
  if (%expire < 1) && (!%notime) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Invalid Time option, 0w0d0h0m0s I.E 1w or 7d
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readadmin($2,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You Cannot GLINE another IRC operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readclient($2,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  User Not Found
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 12 $+ $2 $+  doesnt seem to be online
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  }
  else {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Banning User From IRC
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Banning (gline) user 12 $+ $2  $+ as requested
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    if ($netconf(system,loging) == on) { 
      writetolog system $1 GLINED $2 from the network
    }
    if (!$4) { sockwrite -tn serv TKL + G * $readclient($2,host) $readclient($1,nickname) %expire $ctime :Requested By $1 }
    else { sockwrite -tn serv TKL + G * $readclient($2,host) $readclient($1,nickname) %expire $ctime : $+ $4- }
    writetolog $1 Added GLINE for host $readclient($2,host)
    report GLINE: $1 added gline for host $readclient($2,host) 
    var %banID $calc($ini(data/glines.db,0) + 1)
    addnetban %banID address $readclient($2,host)
    addnetban %banID by $1
    addnetban %banID time $ctime
    addnetban %banID expire $3
    addnetban %banID expiretime %expire
    addnetban %banID type GLINE
    if ($4) {
      addnetban %banID reason $4-
    }
    else {
      addnetban %banID reason Requested
    }
  }
}
alias system.akill {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY to use this command.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You Are Not An IRC Operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($addy($1),operlevel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You have no IRCop access to $netconf(system,nickname)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) && ($readnick($1,operlevel) < $netconf(opercmds,gline)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($2 == list) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Auto KILL List
    var %x 1
    var %found 0
    while ($ini(data/glines.db,%x)) {
      if ($readnetban($ini(data/glines.db,%x),type) == AKILL) {
        if ($readnetban($ini(data/glines.db,%x),expiretime) != 0) {
          var %expire $asctime($readnetban($ini(data/glines.db,%x),expiretime))
        }
        else {
          var %expire Never
        }
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Entry ID:  $+ %x $+  Added By: $readnetban($ini(data/glines.db,%x),by) 
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Address:  $+ $readnetban($ini(data/glines.db,%x),address) $+  Expires: %expire
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Reason: $readnetban($ini(data/glines.db,%x),reason)
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color To Remove: /msg $netconf(system,nickname) AKILL REMOVE %x
        inc %found
      }
      inc %x
    }
    if (%found < 1) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color No entries found!
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color End of List
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($2 == remove) {
    if (!$3) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Usage
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Missing ID required to remove AKILL
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color try /msg SysOp HELP AKILL
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if (!$readnetban($3,address)) || ($readnetban($3,type) != AKILL) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Usage
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color ID  $+ $3 $+ , No such AKILL exists.
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color try /msg SysOp HELP AKILL
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Removing AKILL
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Removed AKILL  $+ $readnetban($3,address)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    wipenetban $3
    halt
  }
  if (!$2) || (!$3) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Usage
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Nickname/Address and time value required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color try /msg SysOp HELP AKILL
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readadmin($2,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You Cannot AKILL another IRC operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readclient($2,nickname)) {
    var %client $readclient($2,host)
  }
  else {
    var %client $2
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Banning User From IRC
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Banning (akill) address 12 $+ %client  $+ as requested
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  if ($netconf(system,loging) == on) { 
    writetolog system $1 AKILL %client network autokill added
  }
  if (!$4) { .sockwrite -tn serv $+(:,$netconf(server,server)) KILL $2 Requested By $1  }
  else { .sockwrite -tn serv $+(:,$netconf(server,server)) KILL $2 $4- }
  var %banID $calc($ini(data/glines.db,0) + 1)
  addnetban %banID address %client
  addnetban %banID by $1
  addnetban %banID time $ctime
  addnetban %banID expire $3
  if (d isin $3) { var %expire $calc($ctime + ($remove($3,d) * 86400)) }
  if (w isin $3) { var %expire $calc($ctime + ($remove($3,w) * 604800)) }
  if (s isin $3) { var %expire $calc($ctime + $remove($3,s)) }
  if (m isin $3) { var %expire $calc($ctime + ($remove($3,m) * 60)) }
  if (h isin $3) { var %expire $calc($ctime + ($remove($3,h,m,s) * 3600)) }
  if ($3 == never) { var %expire 0 }
  addnetban %banID expiretime %expire
  addnetban %banID type AKILL
  if ($4) {
    addnetban %banID reason $4-
  }
  else {
    addnetban %banID reason Requested
  }
}
alias system.agline {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY to use this command.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You Are Not An IRC Operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($addy($1),operlevel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You have no IRCop access to $netconf(system,nickname)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) && ($readnick($1,operlevel) < $netconf(opercmds,gline)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($2 == list) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Auto GLINE List
    var %x 1
    var %found 0
    while ($ini(data/glines.db,%x)) {
      if ($readnetban($ini(data/glines.db,%x),type) == AGLINE) {
        if ($readnetban($ini(data/glines.db,%x),expiretime) != 0) {
          var %expire $asctime($readnetban($ini(data/glines.db,%x),expiretime))
        }
        else {
          var %expire Never
        }
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Entry ID:  $+ %x $+  Added By: $readnetban($ini(data/glines.db,%x),by) 
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Address:  $+ $readnetban($ini(data/glines.db,%x),address) $+  Expires: %expire
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Reason: $readnetban($ini(data/glines.db,%x),reason)
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color To Remove: /msg $netconf(system,nickname) AGLINE REMOVE %x
        inc %found
      }
      inc %x
    }
    if (%found < 1) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color No entries found!
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color End of List
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($2 == remove) {
    if (!$3) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Usage
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Missing ID required to remove AGLINE
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color try /msg SysOp HELP AGLINE
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if (!$readnetban($3,address)) || ($readnetban($3,type) != AGLINE) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Usage
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color ID  $+ $3 $+ , No such AGLINE exists.
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color try /msg SysOp HELP AGLINE
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Removing AGLINE
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Removed AGLINE  $+ $readnetban($3,address)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    wipenetban $3
    halt
  }
  if (!$2) || (!$3) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Usage
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Nickname/Address and time value required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color try /msg SysOp HELP GLINE
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readadmin($2,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You Cannot AGLINE another IRC operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readclient($2,nickname)) {
    var %client $readclient($2,host)
  }
  else {
    var %client $2
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Banning User From IRC
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Banning (agline) user/address 12 $+ %client  $+ as requested
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  if ($netconf(system,loging) == on) { 
    writetolog system $1 AGLINE %client network autogline added
  }
  if (!$4) { .sockwrite -tn serv $+(:,$netconf(server,server)) KILL $2 Requested By $1  }
  else { .sockwrite -tn serv $+(:,$netconf(server,server)) KILL $2 $4- }
  var %banID $calc($ini(data/glines.db,0) + 1)
  addnetban %banID address %client
  addnetban %banID by $1
  addnetban %banID time $ctime
  addnetban %banID expire $3
  if (d isin $3) { var %expire $calc($ctime + ($remove($3,d) * 86400)) }
  if (w isin $3) { var %expire $calc($ctime + ($remove($3,w) * 604800)) }
  if (s isin $3) { var %expire $calc($ctime + $remove($3,s)) }
  if (m isin $3) { var %expire $calc($ctime + ($remove($3,m) * 60)) }
  if (h isin $3) { var %expire $calc($ctime + ($remove($3,h,m,s) * 3600)) }
  if ($3 == never) { var %expire 0 }
  addnetban %banID expiretime %expire
  addnetban %banID type AGLINE
  if ($4) {
    addnetban %banID reason $4-
  }
  else {
    addnetban %banID reason Requested
  }
}
alias system.nickban {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY to use this command.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You Are Not An IRC Operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($addy($1),operlevel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You have no IRCop access to $netconf(system,nickname)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) && ($readnick($1,operlevel) < $netconf(opercmds,gline)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($2 == list) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Auto NickBan List
    var %x 1
    var %found 0
    while ($ini(data/glines.db,%x)) {
      if ($readnetban($ini(data/glines.db,%x),type) == NICKBAN) {
        if ($readnetban($ini(data/glines.db,%x),expiretime) != 0) {
          var %expire $asctime($readnetban($ini(data/glines.db,%x),expiretime))
        }
        else {
          var %expire Never
        }
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Entry ID:  $+ %x $+  Added By: $readnetban($ini(data/glines.db,%x),by) 
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Nickname:  $+ $readnetban($ini(data/glines.db,%x),address) $+  Expires: %expire
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Reason: $readnetban($ini(data/glines.db,%x),reason)
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color To Remove: /msg $netconf(system,nickname) NICKBAN REMOVE %x
        inc %found
      }
      inc %x
    }
    if (%found < 1) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color No entries found!
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color End of List
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($2 == remove) {
    if (!$3) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Usage
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Missing ID required to remove NICKBAN
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color try /msg SysOp HELP NICKBAN
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if (!$readnetban($3,address)) || ($readnetban($3,type) != NICKBAN) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Usage
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color ID  $+ $3 $+ , No such NICKBAN exists.
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color try /msg SysOp HELP NICKBAN
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Removing NICKBAN
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Removed NICKBAN  $+ $readnetban($3,address)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    wipenetban $3
    halt
  }
  if (!$2) || (!$3) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Usage
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Nickname/Address and time value required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color try /msg SysOp HELP NICKBAN
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readadmin($2,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You Cannot NICKBAN another IRC operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readclient($2,nickname)) {
    var %client $readclient($2,host)
  }
  else {
    var %client $2
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Banning User From IRC
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Banning (nickban) address 12 $+ %client  $+ as requested
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  if ($netconf(system,loging) == on) { 
    writetolog system $1 NICKBAN %client network nickban added
  }
  if (!$4) { .sockwrite -tn serv $+(:,$netconf(server,server)) KILL $2 Your nickname was rejected By $1  }
  else { .sockwrite -tn serv $+(:,$netconf(server,server)) KILL $2 $4- }
  var %banID $calc($ini(data/glines.db,0) + 1)
  addnetban %banID address %client
  addnetban %banID by $1
  addnetban %banID time $ctime
  addnetban %banID expire $3
  if (d isin $3) { var %expire $calc($ctime + ($remove($3,d) * 86400)) }
  if (w isin $3) { var %expire $calc($ctime + ($remove($3,w) * 604800)) }
  if (s isin $3) { var %expire $calc($ctime + $remove($3,s)) }
  if (m isin $3) { var %expire $calc($ctime + ($remove($3,m) * 60)) }
  if (h isin $3) { var %expire $calc($ctime + ($remove($3,h,m,s) * 3600)) }
  if ($3 == never) { var %expire 0 }
  addnetban %banID expiretime %expire
  addnetban %banID type NICKBAN
  if ($4) {
    addnetban %banID reason $4-
  }
  else {
    addnetban %banID reason Requested
  }
}
alias system.operaccess {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY to use this command.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You Are Not An IRC Operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($addy($1),operlevel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You have no IRCop access to $netconf(system,nickname)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) && ($readnick($1,operlevel) < $netconf(opercmds,operacces)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) || (!$3) && ($3 != 0) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Usage
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Nickname & Level Required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color try /msg SysOp HELP OPERACCESS
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($2,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  User Not Found
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 12 $+ $2 $+  doesnt seem to be registered
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  }
  else {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Editing OPER access to $netconf(system,nickname))
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 12 $+ $2  $+ now has level 12 $+ $3 $+  access
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    if ($netconf(system,loging) == on) { 
      writetolog system $1 changed $2 operaccess too $3
    }
    if ($3 < 1) {
      addnick $2 nickmodes $removecs($readnick($2,nickmodes),o,O,g,h,a,A,N)
    }
    if ($3 > 1) {
      addnick $2 nickmodes $removecs($readnick($2,nickmodes),o,) $+ o
    }
    addnick $2 operlevel $3
  }
}
alias system.renick {
  if ($hasaccess(renick,$1) != true) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) || (!$3) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Usage
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Nickname and new nickname Required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color try /msg SysOp HELP RENICK
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Forcing Nickname Change
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 will now be renamed to  $+ $3
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  .sockwrite -tn serv :SysOp SVSNICK $2 $3 $ctime
}
alias system.xset {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY to use this command.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You Are Not An IRC Operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($addy($1),operlevel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You have no IRCop access to $netconf(system,nickname)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) || ($readnick($1,operlevel) < $netconf(opercmds,xsetview)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readadmin($addy($1),nickname) == $1)  && (!$2) || (!$3) || (!$4) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $netconf(system,nickname) Service XSET
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Server Configuration:
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Server         : $netconf(server,server)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Domain         : $netconf(server,domain)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color IP             : $netconf(server,ip)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Port           : $netconf(server,port)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Nickname       : $netconf(system,nickname)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  System Configuration:
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Main Channel   : $netconf(system,mainchan)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Log Channel    : $netconf(system,report)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Help Channel   : $netconf(system,helpchan)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Search IRC Det : $netconf(system,searchirc)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Note Quota     : $netconf(system,pmquota)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Log Events     : $netconf(system,loging)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Current Log    : system_ $+ $replace($date,$chr(47),-) $+ .log
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel Expire : $netconf(system,chanexpire)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Nickname Expire: $netconf(system,nickexpire)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Unique Email   : $netconf(system,uniqueemail)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Daily Tasks    : $netconf(system,dailytasks)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Daily Backups  : $netconf(system,dailybackups)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Registration Configuration:
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Nick Registrations       : $netconf(system,nickreg)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel Registrations    : $netconf(system,chanreg)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Max Chans Per Nick       : $netconf(system,maxchans)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  System Statistics:
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Last System Backup       : $duration($calc($ctime - $netconf(system,lastbackup)))
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Last System Backup Date  : $asctime($netconf(system,lastbackup))
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Registered Nicks         : $ini(data/nicknames.db,0)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Registered Chans         : $ini(data/channels.db,0)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Active Channels          : $ini(data/activechans.db,0)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Active Users             : $ini(data/clients.db,0)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Seen Entries             : $ini(data/seen.db,seen,0)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  }
  else {
    if ($readnick($1,operlevel) < $netconf(opercmd,xset)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if ($readadmin($addy($1),nickname) == $1)  && (!$netconf($2,$3)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Error in XSET
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Cannot Find the setting  $+ $2 $+ , $+ $3
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    }
    else {
      writeconf $2 $3 $lower($4)
      report XSET: $upper($2) $upper($3) = $lower($4) By  $+ $1 $+ 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Changing XSET Configuration
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Setting :  $+ $2 $+ , $+ $3
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Now     : $netconf($2,$3) 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      if ($netconf(system,loging) == on) { 
        writetolog system XSET Changed by $1 - $2 / $3 / $lower($4)
      }
    }
  }
}

alias system.reconnect {
  if ($hasaccess(restart,$1) != true) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color have you IDENTIFED yet?
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Services Reconecting
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color The service will now reconnect to the uplink
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  if ($netconf(system,loging) == on) { 
    writetolog system $1 restarted the service
  }
  var %x = 1
  while ($ini(data/activechans.db,%x)) {
    .sockwrite -tn serv :Global PRIVMSG $ini(data/activechans.db,%x) [ $+ Restarting $+  $+ ] The services are restarting, your connections will not be effected.
    inc %x
  }
  timerstart 1 5 /start
  /stop
}
alias system.opercmd {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY to use this command.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You Are Not An IRC Operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($addy($1),operlevel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You have no IRCop access to $netconf(system,nickname)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) || ($readnick($1,operlevel) < $netconf(opercmds,modcmdview)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Listing all available 12 $+ OPERCMD
    var %x = 1
    while ($ini(services.conf,opercmds,%x)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color [12 $+ $netconf(opercmds,$ini(services.conf,opercmds,%x)) $+  $+ ] $ini(services.conf,opercmds,%x)
      inc %x
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  OPERCMD <command> for more information on a command.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($2) && (!$3) {
    ;show command information
    if (!$netconf(opercmds,$2)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Command Not Found
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Cannot find  $+ $2 $+  in the MODCMD database.
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    }
    else {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Displaying Information on 12 $+ $2
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Operator Level Required: 12 $+ $netconf(opercmds,$2)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  See: HELP FLAGS, HELP OPERLEVELS
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    }
  }
  if ($2) && ($3) {
    if ($readnick($1,operlevel) < $netconf(opercmd,modcmd)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    ;check $4 and $3
    if ($3 > $readnick($1,operlevel)) || ($3 < 0) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Data
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please enter a LEVEL between 0 and $readnick($1,operlevel)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  OPERCMD $2 <level>
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if (!$netconf(opercmds,$2)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Command Not Found
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Cannot find  $+ $2 $+  in the OPERCMD database.
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    }
    else {
      writeconf opercmds $2 $3
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Setting Information on 12 $+ $2
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Operator Level Required: 12 $+ $netconf(opercmds,$2)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  See: HELP FLAGS, HELP OPERLEVELS
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      if ($netconf(system,loging) == on) { 
        writetolog system $1 edited opercmd $2 to operator level $3
      }
    }
  }
  ;modcmd features in here
}
alias system.chancmd {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY to use this command.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You Are Not An IRC Operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($addy($1),operlevel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You have no IRCop access to $netconf(system,nickname)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) || ($readnick($1,operlevel) < $netconf(opercmds,modcmdview)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Listing all available 12 $+ CHANCMD
    var %x = 1
    while ($ini(services.conf,chanlevel,%x)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color [12 $+ $netconf(chanlevel,$ini(services.conf,chanlevel,%x)) $+  $+ ] $ini(services.conf,chanlevel,%x)
      inc %x
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  CHANCMD <command> for more information on a command.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($2) && (!$3) {
    ;show command information
    if (!$netconf(chanlevel,$2)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Command Not Found
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Cannot find  $+ $2 $+  in the MODCMD database.
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    }
    else {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Displaying Information on 12 $+ $2
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Level Required: 12 $+ $netconf(chanlevel,$2)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  See: HELP FLAGS, HELP OPERLEVELS
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    }
  }
  if ($2) && ($3) {
    if ($readnick($1,operlevel) < $netconf(opercmd,modcmd)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    ;check $4 and $3
    if ($3 > $readnick($1,operlevel)) || ($3 < 0) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Data
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please enter a LEVEL between 0 and $readnick($1,operlevel)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  CHANCMD $2 <level>
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if (!$netconf(chanlevel,$2)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Command Not Found
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Cannot find  $+ $2 $+  in the CHANCMD database.
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    }
    else {
      writeconf chanlevel $2 $3
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Setting Information on 12 $+ $2
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Level Required: 12 $+ $netconf(chanlevel,$2)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  See: HELP FLAGS, HELP USERLEVELS
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      if ($netconf(system,loging) == on) { 
        writetolog system $1 changed a chancmd $2 to level $3
      }
    }
  }
  ;modcmd features in here
}
alias system.whois {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY to use this command.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You Are Not An IRC Operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($addy($1),operlevel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You have no IRCop access to $netconf(system,nickname)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) && ($readnick($1,operlevel) < $netconf(opercmds,whois)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) || (!$readclient($2,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Usage
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Online User Required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color try /msg SysOp HELP WHOIS
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Whois Information For 12 $+ $2 $+ 
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Ident     : $readclient($2,ident)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Host      : $readclient($2,host)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Server    : $readclient($2,server)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Logged on : $asctime($readclient($2,time))
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Channels $2 is in now:
  var %x = 1
  while ($ini(data/activechans.db,%x)) {
    if ($readison($ini(data/activechans.db,%x),$2)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color  $+ $axs.levels.name($readaccess($2,$ini(data/activechans.db,%x),level)) $+  - 12 $+ $ini(data/activechans.db,%x) $+  - $left($remove($read(data/set_topics.txt, s, $ini(data/activechans.db,%x) $+ :),$ini(data/activechans.db,%x) $+ :),40) $+ ...
    }
    inc %x
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Nickname Information:
  if ($readnick($2,nickname)) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 Is using a registered nickname }
  else { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 Is not registered }
  if ($addy($2)) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 Is Logged in as $2 }
  else { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 Is not logged in yet }
  if ($readadmin($2,nickname)) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 Is a $readadmin($2,rank) }
  if ($readnick($2,operlevel)) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 has oper access 12 $+ $readnick($2,operlevel) }
  if ($readclient($2,awaymsg)) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 is set away - 12 $+ $readclient($2,awaymsg) }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
}
alias system.systemlogs {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY to use this command.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You Are Not An IRC Operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($addy($1),operlevel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You have no IRCop access to $netconf(system,nickname)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) && ($readnick($1,operlevel) < $netconf(opercmds,systemlogs)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  ;display log list
  if ($2 == delete) && ($3) {
    if ($exists(logs\system_ $+ $3 $+ .log))  {
      remove logs\system_ $+ $3 $+ .log
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,cll)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Removed log file logs\system_ $+ $3 $+ .log $+ 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      return
    }
    else {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,cll)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Cannot Find logs\system_ $+ $3 $+ .log $+ 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      return
    }
  }
  if ($2 == deleteall) { 
    var %delete 1
    var %inc 0
    while ($findfile(logs, system_*,%delete)) {
      remove logs\ $+ $remove($findfile(logs, system_*,%delete),$mircdir $+ logs\)
      inc %inc
      inc %delete
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,cll)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Removed all system logs
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    writetolog system *** All logs removed by $1 ***
    report *** All system logs removed by $1 ***
    return
  }
  if ($3) {
    var %x 1
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,sll)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color There are  $+ $findfile(logs,system_ $+ $3 $+ *,0) $+  log files available
    while ($findfile(logs,system_ $+ $3 $+ *,%x)) {
      if ($file(logs\ $+ $remove($findfile(logs,system_ $+ $3 $+ *,%x),$mircdir $+ logs\)).size > 1024) {
        var %fsize $calc($file(logs\ $+ $remove($findfile(logs,system_ $+ $3 $+ *,%x),$mircdir $+ logs\)).size / 1024)
        var %fsizeD KB
      }
      else {
        var %fsize $file(logs\ $+ $remove($findfile(logs,system_ $+ $3 $+ *,%x),$mircdir $+ logs\)).size
        var %fsizeD Bytes
      }
      if (%fsizeD ==  KB) && (%fsize > 1024) {
        var %fsize $calc($file(logs\ $+ $remove($findfile(logs,system_ $+ $3 $+ *,%x),$mircdir $+ logs\)).size / 1024 / 1024)
        var %fsizeD MB
      }
      else {
        var %fsize %fsize
      }
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Filename: $remove($findfile(logs,system_ $+ $3 $+ *,%x),$mircdir $+ logs\) Date: $remove($findfile(logs,system_ $+ $3 $+ *,%x),$mircdir $+ logs\system_,.log) Size: $left($round(%fsize),5) %fsizeD
      var %z $lines($findfile(logs,system*,%x))
      var %p 0
      while ($read(logs\ $+ $remove($findfile(logs,system_ $+ $3 $+ *,%x),$mircdir $+ logs\),%z) && (%p < $2)) {
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $read(logs\ $+ $remove($findfile(logs,system_ $+ $3 $+ *,%x),$mircdir $+ logs\),%z)
        inc %p
        dec %z
      }
      inc %x
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color  $+ $lang($1,oper,sllt)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  }
  else {
    var %x 1
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,sll)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color There are  $+ $findfile(logs,system_*,0) $+  log files available
    while ($findfile(logs,system_*,%x)) {
      if ($file(logs\ $+ $remove($findfile(logs,system_ $+ $3 $+ *,%x),$mircdir $+ logs\)).size > 1024) {
        var %fsize $calc($file(logs\ $+ $remove($findfile(logs,system_ $+ $3 $+ *,%x),$mircdir $+ logs\)).size / 1024)
        var %fsizeD KB
      }
      else {
        var %fsize $file(logs\ $+ $remove($findfile(logs,system_ $+ $3 $+ *,%x),$mircdir $+ logs\)).size
        var %fsizeD Bytes
      }
      if (%fsizeD ==  KB) && (%fsize > 1024) {
        var %fsize $calc($file(logs\ $+ $remove($findfile(logs,system_ $+ $3 $+ *,%x),$mircdir $+ logs\)).size / 1024 / 1024)
        var %fsizeD MB
      }
      else {
        var %fsize %fsize
      }
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Filename: $remove($findfile(logs,system_*,%x),$mircdir $+ logs\) Date: $remove($findfile(logs,system_*,%x),$mircdir $+ logs\system_,.log) Size: $left($round(%fsize),5) %fsizeD
      var %z $lines($findfile(logs,system_*,%x))
      var %p 0
      while ($read(logs\ $+ $remove($findfile(logs,system_*,%x),$mircdir $+ logs\),%z) && (%p < $2)) {
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $read(logs\ $+ $remove($findfile(logs,system_*,%x),$mircdir $+ logs\),%z)
        inc %p
        dec %z
      }
      inc %x
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color  $+ $lang($1,oper,sllt)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  }
}
alias system.database {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY to use this command.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($hasaccess(databases,$1) == false) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  sysnotice $1 -
  sysnotice $1 %color  $+ System Databases
  sysnotice $1 %color Fields: [database] :: [size] :: [Last Accessed]
  if ($2) {
    ;single database
    var %cnter 1
    var %size 0
    while ($findfile(data, $+ $2 $+ *.db,%cnter)) {
      if ($file($remove($findfile(data, $+ $2 $+ *.db,%cnter),$mircdir)).size >= 1024) { var %size $left($calc($file($remove($findfile(data, $+ $2 $+ *.db,%cnter),$mircdir)).size / 1024),4) KB }
      elseif ($calc($file($remove($findfile(data, $+ $2 $+ *.db,%cnter),$mircdir)).size / 1024 / 1024) >= 1024) { var %size $left($calc($file($remove($findfile(data, $+ $2 $+ *.db,%cnter),$mircdir)).size / 1024 / 1024),4) MB }
      else { var %size $file($remove($findfile(data, $+ $2 $+ *.db,%cnter),$mircdir)).size Bytes }
      sysnotice $1 %color  $+ $chr(91) $+  $+ $remove($findfile(data, $+ $2 $+ *.db,%cnter),$mircdirdata\) $+  $+ $chr(93) $+ :: $+ $chr(91) $+  $+ %size $+  $+ $chr(93) $+ :: $+  $+ $chr(91) $+  $+ $duration($calc($ctime - $file($remove($findfile(data, $+ $2 $+ *.db,%cnter),$mircdir)).atime)) $+  $+ $chr(93) $+ 
      inc %cnter
    } 
  }
  else {
    ;full database
    var %cnter 1
    var %size 0
    while ($findfile(data,*.db,%cnter)) {
      if ($file($remove($findfile(data,*.db,%cnter),$mircdir)).size >= 1024) { var %size $left($calc($file($remove($findfile(data,*.db,%cnter),$mircdir)).size / 1024),4) KB }
      elseif ($calc($file($remove($findfile(data,*.db,%cnter),$mircdir)).size / 1024 / 1024) >= 1024) { var %size $left($calc($file($remove($findfile(data,*.db,%cnter),$mircdir)).size / 1024 / 1024),4) MB }
      else { var %size $file($remove($findfile(data,*.db,%cnter),$mircdir)).size Bytes }
      sysnotice $1 %color  $+ $chr(91) $+  $+ $remove($findfile(data,*.db,%cnter),$mircdirdata\) $+  $+ $chr(93) $+ :: $+ $chr(91) $+  $+ %size $+  $+ $chr(93) $+ :: $+  $+ $chr(91) $+  $+ $duration($calc($ctime - $file($remove($findfile(data,*.db,%cnter),$mircdir)).atime)) $+  $+ $chr(93) $+ 
      ;mkdir data\backup
      ;mkdir data\backup\access
      ;copy -o $remove($findfile(data,*.db,%cnter),$mircdir) data\backup\ $+ $remove($findfile(data,*.db,%cnter),$mircdirdata\,.db) $+ _ $+ $replace($time,:,-) $+ .bak
      inc %cnter
    }   
  }
  sysnotice $1 %color  $+ End of Databases
  sysnotice $1 -
}
alias system.database.backups {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY to use this command.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You Are Not An IRC Operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($addy($1),operlevel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You have no IRCop access to $netconf(system,nickname)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) && ($readnick($1,operlevel) < $netconf(opercmds,databases)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  sysnotice $1 -
  sysnotice $1 %color  $+ System Backups
  sysnotice $1 %color Fields: [backup ID] :: [size] :: [files] :: [description] :: [date]
  var %cnter 1
  var %size 0
  while ($ini(data\backup.db,%cnter)) {
    sysnotice $1 %color Backup:  $+ $chr(91) $+  $+ $ini(data\backup.db,%cnter) $+  $+ $chr(93) $+ :: $+ $chr(91) $+  $+ $readbackup($ini(data\backup.db,%cnter),size) $+  $+ $chr(93) $+ :: $+ $chr(91) $+  $+ $readbackup($ini(data\backup.db,%cnter),files) $+  $+ $chr(93) $+ :: $+ $chr(91) $+  $+ $readbackup($ini(data\backup.db,%cnter),Description) $+  $+ $chr(93) $+ :: $+ $chr(91) $+  $+ $date($readbackup($ini(data\backup.db,%cnter),Complete)) $+  $+ $chr(93) $+ 
    ;mkdir data\backup
    ;mkdir data\backup\access
    ;copy -o $remove($findfile(data,*.db,%cnter),$mircdir) data\backup\ $+ $remove($findfile(data,*.db,%cnter),$mircdirdata\,.db) $+ _ $+ $replace($time,:,-) $+ .bak
    inc %cnter
  }   
  sysnotice $1 %color  $+ End of Backups
  sysnotice $1 -
}

alias system.backup.database {
  if (!$addy($1)) && ($1 != $netconf(system,nickname)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY to use this command.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) && ($1 != $netconf(system,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You Are Not An IRC Operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($addy($1),operlevel)) && ($1 != $netconf(system,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You have no IRCop access to $netconf(system,nickname)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) && ($readnick($1,operlevel) < $netconf(opercmds,databases)) && ($1 != $netconf(system,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  sysnotice $1 -
  sysnotice $1 %color  $+ System Database Backup
  sysnotice $1 %color Backing up entire /data directory
  var %backupID $ctime
  sysnotice $1 %color Backup #: %backupID
  writeconf system lastbackup %backupID
  writebackup %backupID Complete $ctime
  writetolog system $1 created a backup restore point # %backupID
  if ($2) {
    writebackup %backupID Description $2-
  }
  else {
    writebackup %backupID Description No Description
  }
  ;full database
  var %cnter 1
  var %size 0
  while ($findfile(data,*.db,%cnter)) {
    mkdir data\backup
    mkdir data\backup\access
    var %size $calc(%size + $file($findfile(data,*.db,%cnter)).size)
    copy -o $remove($findfile(data,*.db,%cnter),$mircdir) data\backup\ $+ $remove($findfile(data,*.db,%cnter),$mircdirdata\,.db) $+ _ $+ %backupID $+ .bak
    inc %cnter
  }
  writebackup %backupID size $round($calc(%size / 1024),2) $+ KB
  writebackup %backupID files %cnter
  copy -o services.conf data\backup\services $+ _ $+ %backupID $+ .bak
  sysnotice $1 %color  $+ Backup Complete  $+ %cnter $+  files copied, $round($calc(%size / 1024),2) $+ KB.
  sysnotice $1 -
}
alias system.database.restore {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY to use this command.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You Are Not An IRC Operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($addy($1),operlevel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,oper,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You have no IRCop access to $netconf(system,nickname)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) && ($readnick($1,operlevel) < $netconf(opercmds,databases)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  sysnotice $1 -
  sysnotice $1 %color  $+ System Restore
  if ($2) {
    ;single restore
    if (!$readbackup($2,Complete)) {
      sysnotice $1 %color Cannot Find Backup  $+ $2 $+  to restore
      sysnotice $1 %color Try /msg $netconf(system,nickname) BACKUPS To view available backups.
      sysnotice $1 -
      halt
    }
    ;delete a restore point
    if ($3 == delete) {
      sysnotice $1 %color Deleting Backup #  $+ $2
      var %files 0
      var %cnter 1
      while ($findfile(data\backup,* $+ $2 $+ *.bak,%cnter)) {
        sysnotice $1 %color  $+ $chr(91) $+  $+ $remove($findfile(data\backup,* $+ $2 $+ *.bak,%cnter),$mircdirdata\backup\) $+  $+ $chr(93) $+  Removed...
        remove $remove($findfile(data\backup,* $+ $2 $+ *.bak,%cnter),$mircdir)
        inc %files
      } 
      inc %cnter
      ;remove data\backup\services_ $+ $2 $+ .bak
      wipebackup $2
      sysnotice $1 %color Backup and  $+ %files $+  files removed.
      sysnotice $1 -
      halt
    }
    sysnotice $1 %color Restoring Backup #  $+ $2
    sysnotice $1 %color This backup was created - $date($readbackup($2,Complete))
    var %cnter 1
    var %size 0
    while ($findfile(data\backup,* $+ $2 $+ *.bak,%cnter)) {
      sysnotice $1 %color  $+ $chr(91) $+  $+ $remove($findfile(data\backup,* $+ $2 $+ *.bak,%cnter),$mircdirdata\backup\) $+  $+ $chr(93) $+  Restored...
      copy -o $remove($findfile(data\backup,* $+ $2 $+ *.bak,%cnter),$mircdir) data\ $+ $remove($findfile(data\backup,* $+ $2 $+ *.bak,%cnter),$mircdirdata\backup\,_,.bak,$netconf(system,lastbackup))) $+ .db
      inc %cnter
    }   
    copy -o data\backup\services_ $+ $2 $+ .bak services.conf
  }
  else {
    ;full restore from last backup
    if (!$readbackup($netconf(system,lastbackup) ,Complete)) {
      sysnotice $1 %color Cannot Find Backup  $+ $netconf(system,lastbackup) $+  to restore
      sysnotice $1 %color Try /msg $netconf(system,nickname) BACKUPS To view available backups.
      sysnotice $1 -
      halt
    }
    sysnotice $1 %color Restoring Last Backup #  $+ $netconf(system,lastbackup) 
    sysnotice $1 %color This backup was created - $date($netconf(system,lastbackup))
    var %cnter 1
    var %size 0
    while ($findfile(data\backup,* $+ $netconf(system,lastbackup) $+ *.bak,%cnter)) {
      if ($file($remove($findfile(data\backup,* $+ $netconf(system,lastbackup) $+ *.bak,%cnter),$mircdir)).size >= 1024) { var %size $left($calc($file($remove($findfile(data\backup,* $+ $netconf(system,lastbackup) $+ *.bak,%cnter),$mircdir)).size / 1024),4) KB }
      elseif ($calc($file($remove($findfile(data\backup,*.bak,%cnter),$mircdir)).size / 1024 / 1024) >= 1024) { var %size $left($calc($file($remove($findfile(data\backup,* $+ $netconf(system,lastbackup) $+ *.bak,%cnter),$mircdir)).size / 1024 / 1024),4) MB }
      else { var %size $file($remove($findfile(data\backup,* $+ $netconf(system,lastbackup) $+ *.bak,%cnter),$mircdir)).size Bytes }
      sysnotice $1 %color  $+ $chr(91) $+  $+ $remove($findfile(data\backup,* $+ $netconf(system,lastbackup) $+ *.bak,%cnter),$mircdirdata\backup\) $+  $+ $chr(93) $+  Restored...
      copy -o $remove($findfile(data\backup,* $+ $netconf(system,lastbackup) $+ *.bak,%cnter),$mircdir) data\ $+ $remove($findfile(data\backup,* $+ $netconf(system,lastbackup) $+ *.bak,%cnter),$mircdirdata\backup\,_,.bak,$netconf(system,lastbackup))) $+ .db
      inc %cnter
    } 
    copy -o data\backup\services_ $+ $netconf(system,lastbackup) $+ .bak services.conf
  }
  remove data\services.db
  sysnotice $1 %color  $+ Restore Complete
  writetolog system *** System Database Restore By $1 ***
  report *** System Database Restore By $1 ***
  sysnotice $1 -
}
