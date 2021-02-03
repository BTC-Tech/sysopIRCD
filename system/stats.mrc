; Copying or editing of any of the scripts included in this module is strictly prohibited, you may distribute the package
; in its entireity un edited in any form. Support can only be given to those who do not edit these files please do not ask
; if you plan to edit them yourself. Credits and links back to us must remain in the script we do not advertise using your
; network unless the .VERSION command is triggered. You must also agree when connecting the service to any IRC net
; that you have the correct permission to connect the service, you MUST NOT connect the service to Digi-Net and you
; connect the service at your own risk. For support see http://www.digi-net.org

alias system.ircops {
  var %x = 1
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  IRCops $lang($1,ircops,title)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,ircops,line1)  $+ $ini(data/admin.db,0) $+  $lang($1,ircops,line1a)
  while ($ini(data/admin.db,%x)) {
    if ($ini(data/admin.db,%x)) { 
      if ($readclient($ini(data/admin.db,%x),awaymsg)) && ($readison($netconf(system,helpchan),$ini(data/admin.db,%x)) == ison)  { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $ini(data/admin.db,%x) [12 $+ $readnick($addy($ini(data/admin.db,%x)),operlevel) $+  $+ ] [12In $netconf(system,helpchan) $+  $+ ] [12away $+ ] $readclient($ini(data/admin.db,%x),awaymsg) }
      elseif ($readclient($ini(data/admin.db,%x),awaymsg)) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $ini(data/admin.db,%x) [12 $+ $readnick($addy($ini(data/admin.db,%x)),operlevel) $+  $+ ] [12away $+ ] $readclient($ini(data/admin.db,%x),awaymsg) }
      else { 
        if ($readison($netconf(system,helpchan),$ini(data/admin.db,%x)) == ison) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $ini(data/admin.db,%x) [12 $+ $readnick($addy($ini(data/admin.db,%x)),operlevel) $+  $+ ] [12In $netconf(system,helpchan) $+  $+ ] }
        else { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $ini(data/admin.db,%x) [12 $+ $readnick($addy($ini(data/admin.db,%x)),operlevel) $+  $+ ] }
      }
      inc %x
    }
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
}
alias system.selftest {
  var %errors = 0
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Self Diagnosis
  if $isdir($mircdir $+ data) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color The Data Folder exists and is correct
  }
  else {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 4Error: The Data Folder was not Found
    inc %errors
  }
  if (%errors = 0) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color - Checking required data files...
    if (!$exists(data\activechans.db)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 4Error: The data\activechans.db does not exist!!
      inc %errors
    }
    if (!$exists(data\admin.db)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 4Ignoring: The data\admin.db does not exist!!
    }
    if (!$exists(data\blacklist.db)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 4Error: The data\blacklist.db does not exist!!
      inc %errors
    }
    if (!$exists(data\channels.db)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 4Error: The data\channels.db does not exist!!
      inc %errors
    }
    if (!$exists(data\clients.db)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 4Error: The data\clients.db does not exist!!
      inc %errors
    }
    if (!$exists(data\id.db)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 4Error: The data\id.db does not exist!!
      inc %errors
    }
    if (!$exists(data\news.db)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 4Error: The data\news.db does not exist!!
      inc %errors
    }
    if (!$exists(data\nicknames.db)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 4Error: The data\nicknames.db does not exist!!
      inc %errors
    }
    if (!$exists(data\notes.db)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 4Error: The data\notes.db does not exist!!
      inc %errors
    }
    if (!$exists(data\pending.db)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 4Error: The data\pending.db does not exist!!
      inc %errors
    }
    if (!$exists(data\seen.db)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 4Error: The data\seen.db does not exist!!
      inc %errors
    }
    if (!$exists(data\set_topics.txt)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 4Error: The data\set_topics.txt does not exist!!
      inc %errors
    }
  }
  if (%errors = 0) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 3OK: No problems found :)
  }
  if $isdir($mircdir $+ lang) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color The Lang Folder exists and is correct
  }
  else {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 4Error: The Lang Folder was not Found
    inc %errors
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color - Checking for any language files...
  if ($findfile($mircdir $+ \lang,lang_*.db,0) < 1) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 4Error: No language files found!!
    inc %errors
  }
  else {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color There are  $+ $findfile($mircdir $+ \lang,lang_*.db,0) $+  language files available
  }
  if (%errors = 0) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 3OK: No problems found :)
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color - Checking Configuration file...
  if (!$exists(services.conf)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 4Error: Configuration file not found services.conf
    inc %errors
  }
  if (%errors = 0) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 3OK: No problems found :)
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color - Checking Most Recent Backup
  if (!$readbackup($netconf(system,lastbackup) ,Complete)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 4WARNING: Could not find the most recent backup data
    inc %errors
  }
  if (%errors = 0) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 3OK: No problems found :)
  }
  var %x = $ctime
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Test complete at $asctime(%x) and found  $+ %errors $+  problems.
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
}
alias sysop.stats {
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Network Statistics:
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Hello $1 $+ , You are connected to server  $+ $readclient($1,server)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color There are currently  $+ $ini(data/nicknames.db,0) $+  registered users on the network
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color In total users have registered  $+ $ini(data/channels.db,0) $+  channels
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color There are  $+ $ini(data/activechans.db,0) $+  channels with at least 1 user online now
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color There are  $+ $ini(data/clients.db,0) $+  users connected right now and
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color  $+ $ini(data/admin.db,0) $+  of them are IRC operators.
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $netconf(system,nickname) has been online  $+ $duration($calc($ctime - %connect_time))
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  return
}
alias system.cmdinfo {
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Command Error
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please specify a command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  /msg $netconf(system,nickname) CMD <command>
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($hasaccess(cmd,$1) != true) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry, you do not have the correct access for this function.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  var %cmd = $upper($2)
  if (%cmd == listall) {
    var %x 1
    while ($ini(data\aliases.db,%x)) {
      var %cmd = $ini(data\aliases.db,%x)
      if ($readcmd(%cmd,desc)) {
        var %desc = $readcmd(%cmd,desc)
      }
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color [ %x ]  %cmd $+  - %desc
      inc %x
      unset %desc
    }

    halt
  }
  if (!$readcmd(%cmd,command)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Command Error
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color There is no such command alias found  $+ %cmd
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  /msg $netconf(system,nickname) CMD <command>
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readcmd(%cmd,alias)) {
    var %alias %cmd
    var %cmd $readcmd(%cmd,alias)
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Command alias information
  if (%alias) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Command:  $+ %cmd >> %alias
  } 
  else {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Command:  $+ %cmd
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Function:  $+ $readcmd(%cmd,command)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Access:  $+ $readcmd(%cmd,access)
  if ($readcmd(%cmd,chan) == 1 || $readcmd(%cmd,access) == OPER) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Level:  $+ $readcmd(%cmd,level)
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Private Only:  $+ $axs.numbers.display($readcmd(%cmd,private))
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel CMD:  $+ $axs.numbers.display($readcmd(%cmd,chan))
  if ($readcmd(%cmd,arg) && !%alias) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Extra Arguments:  $+ $readcmd(%cmd,arg)
  }
  if ($readcmd(%cmd,desc)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Description:  $+ $readcmd(%cmd,desc)
  }
  if (%alias) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  %alias  $+ is an alias of the  $+ $upper(%cmd) $+  command.
    if ($readcmd(%alias,arg)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Extra Arguments:  $+ $readcmd(%alias,arg)
    }
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  End Of Information
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  return
}
alias sysop.chanlist {
  if ($hasaccess(chanlist,$1) != true) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry, you do not have the correct access for this function.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Active Channel List:
  var %x 1
  while ($ini(data\activechans.db,%x)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $ini(data\activechans.db,%x) - $ini(data\activechans.db,%x,0) users - $left($remove($read(data/set_topics.txt, s, $ini(data\activechans.db,%x)  $+ :),$3 $+ :),35)
    inc %x
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  End Of List
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  return
}


alias system.seen {
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,seen,title)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,seen,error1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  /msg $netconf(system,nickname) HELP SEEN
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($sql_findseen($2) == na) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,seen,title)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 12 $+ $2 $+  $lang($1,seen,notseen)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,seen,title)
  ;sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 12 $+ $2 $+  $lang($1,seen,wasseen) 12 $+ $asctime($readseen($2)) 
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color 12 $+ $2 $+  $lang($1,seen,wasseen) 12 $+ $sql_findseen($2)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  return
}
