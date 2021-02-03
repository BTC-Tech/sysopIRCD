; Copying or editing of any of the scripts included in this module is strictly prohibited, you may distribute the package
; in its entireity un edited in any form. Support can only be given to those who do not edit these files please do not ask
; if you plan to edit them yourself. Credits and links back to us must remain in the script we do not advertise using your
; network unless the .VERSION command is triggered. You must also agree when connecting the service to any IRC net
; that you have the correct permission to connect the service, you MUST NOT connect the service to Digi-Net and you
; connect the service at your own risk. For support see http://www.digi-net.org
on *:exit:{
  .stop
  .sysop_webstatus 0
}
on *:start:{
  .start
}
alias start {
  if ($sock(Serv)) {
    echo > Closing current service link
    sockclose Serv
  }
  echo > SysOP Services Loading
  echo > Loading current services configuration
  echo >> Connecting Services to $netconf(server,ip) using Port $netconf(server,port)
  var %errors = 0
  echo -a :-
  echo -a : $+ %color $+  Self Diagnosis
  if $isdir($mircdir $+ data) {
    echo -a : $+ %color The Data Folder exists and is correct
  }
  else {
    echo -a : $+ %color 4Error: The Data Folder was not Found
    inc %errors
  }
  if (%errors = 0) {
    echo -a : $+ %color - Checking required data files...
    if (!$exists(data\blacklist.db)) {
      echo -a : $+ %color 4Error: The data\blacklist.db does not exist!!
      inc %errors
    }
    if (!$exists(data\channels.db)) {
      echo -a : $+ %color 4Error: The data\channels.db does not exist!!
      inc %errors
    }
    if (!$exists(data\news.db)) {
      echo -a : $+ %color 4Error: The data\news.db does not exist!!
      inc %errors
    }
    if (!$exists(data\nicknames.db)) {
      echo -a : $+ %color 4Error: The data\nicknames.db does not exist!!
      inc %errors
    }
    if (!$exists(data\notes.db)) {
      echo -a : $+ %color 4Error: The data\notes.db does not exist!!
      inc %errors
    }
    if (!$exists(data\pending.db)) {
      echo -a : $+ %color 4Error: The data\pending.db does not exist!!
      inc %errors
    }
    if (!$exists(data\seen.db)) {
      echo -a : $+ %color 4Error: The data\seen.db does not exist!!
      inc %errors
    }
    if (!$exists(data\set_topics.txt)) {
      echo -a : $+ %color 4Error: The data\set_topics.txt does not exist!!
      inc %errors
    }
    if (!$exists(data\aliases.db)) {
      echo -a : $+ %color 4Error: The data\aliases.db does not exist!!
      inc %errors
    }
  }
  if (%errors = 0) {
    echo -a : $+ %color 3OK: No problems found :)
  }
  if $isdir($mircdir $+ lang) {
    echo -a : $+ %color The Lang Folder exists and is correct
  }
  else {
    echo -a : $+ %color 4Error: The Lang Folder was not Found
    inc %errors
  }
  echo -a : $+ %color - Checking for any language files...
  if ($findfile($mircdir $+ \lang,lang_*.db,0) < 1) {
    echo -a : $+ %color 4Error: No language files found!!
    inc %errors
  }
  else {
    echo -a : $+ %color There are  $+ $findfile($mircdir $+ \lang,lang_*.db,0) $+  language files available
  }
  if (%errors = 0) {
    echo -a : $+ %color 3OK: No problems found :)
  }
  echo -a : $+ %color - Checking Configuration file...
  if (!$exists(services.conf)) {
    echo -a : $+ %color 4Error: Configuration file not found services.conf
    inc %errors
  }
  if (%errors = 0) {
    echo -a : $+ %color 3OK: No problems found :)
  }
  var %x = $ctime
  echo -a : $+ %color Test complete at $asctime(%x) and found  $+ %errors $+  problems.
  echo -a :-
  if (%errors < 1) {
    sockopen serv $netconf(server,ip) $netconf(server,port)
    set %connect_time $ctime
    timerclearall 0 900 /clearall
    timerdaily 0 1 do_daily
    timerwebex 0 60 sql_webexecute
  }
}
alias stop {
  var %x = 1
  while ($ini(data/clients.db,%x)) {
    .sockwrite -tn serv $+(:,$netconf(system,service2)) NOTICE $ini(data/clients.db,%x) [ $+ SysOp $+  $+ ] SysOp services is now quiting the network, your connection will not be effected.
    inc %x
  }
  var %x = 1
  while ($ini(data/clients.db,%x)) {
    delsqlclient $ini(data/clients.db,%x)
    inc %x
  }

  echo > Killing service link
  echo > Clearing Temporary Records
  .remove data/activechans.db
  .remove data/clients.db
  .remove data/channel_topics.txt
  .remove data/admin.db
  .remove data/id.db
  set %whosonline 0
  sockclose serv
  .sysop_webstatus 0
}

on 1:sockopen:serv: {
  if ($sockerr > 0) { echo -s >>> There was an error creating service link (Error Code: $sockerr $+ ) | .sysop_webstatus 0 | Return }
  unset %RT*
  echo >>> Sending password to server
  sockwrite -tn serv PASS $+(:,$netconf(server,pass))
  echo >>> Creating Server
  sockwrite -tn serv SERVER $netconf(server,server) 1 $+(:,$netconf(server,info))
  set %used no
  echo >>> Service Link Established, Preparing to load Services
  .sysop_webstatus 1
}
on 1:sockread:serv: {
  if ($sockerr > 0) { echo >>> There was an error connecting services (Error Code: $sockerr $+ ) | .sysop_webstatus 0 | return }
  if (%used == NO) {
    echo >>>> Beginning Service Connection
    services_connect
    unset %used 
  }
  :read_more
  sockread %data
  if ($sockbr == 0) { unset %data | return }
  if (%data == $null) { set %data - }
  data_in %data
  goto read_more
}
on 1:sockclose:serv: {
  echo Lost connection with $+($sock($sockname).ip,:,$sock($sockname).port)
  .sysop_webstatus 0
}
alias services_connect {
  if ($2 == -s) { echo >>>>> Stopping System Service | .sockwrite -tn serv : $+ SYSOP QUIT :Recieved Termination signal from Console }
  elseif ($2 == -r) { echo >>>>> Reloading System Service | .sockwrite -tn serv : $+ SYSOP QUIT :Recieved Restart signal from Console }
  .sockwrite -tn serv NICK $netconf(system,nickname) 1 $ctime services $netconf(server,domain) $netconf(server,server) * $+(,:,$netconf(system,name))
  .sockwrite -tn serv NICK $netconf(system,service2) 1 $ctime services $netconf(server,domain) $netconf(server,server) * $+(,:,$netconf(system,name))
  .sockwrite -tn serv $+(:,$netconf(system,nickname)) MODE $netconf(system,nickname) +iHpSqz
  .sockwrite -tn serv $+(:,$netconf(system,nickname)) SWHOIS $netconf(system,nickname) :For help with $netconf(system,nickname) Service type /msg $netconf(system,nickname) HELP
  .sockwrite -tn serv $+(:,$netconf(system,service2)) MODE $netconf(system,service2) +iSqz
  join_chans
}

alias leaveBot {


  ;randomize the leave or QUIY
  var %rbot = $rand(1, 2)
  if (%rbot<2) {
    .sockwrite -tn serv $+(:,$1) QUIT :Quit:
    } else {
    .sockwrite -tn serv $+(:,$1) PART $2
    var %atime = $rand(30, 90)
    .timerautobotq $+ $1 1 %atime .sockwrite -tn serv $+(:,$1) QUIT :Quit:
  }
}
alias createDummy {
  .sockwrite -tn serv NICK $1 1 $ctime services $netconf(server,domain) $netconf(server,server) * $+(,:,$1)
  .sockwrite -tn serv $+(:,$1) MODE $1 +iSqz
  .sockwrite -tn serv $+(:,$1) JOIN $2

  echo ---- Joined Dummy
  var %atime = $rand(100, 300)
  .timerautobot $+ $1 1 %atime .leaveBot $1 $2
}
alias join_chans {
  echo >>>>> Joining Registered Channels
  var %x = 1
  while ($ini(data/channels.db,%x)) {
    if ($readchan($ini(data/channels.db,%x),inchan) == on) && (!$readchan($ini(data/channels.db,%x),suspended)) { 
      .sockwrite -tn serv $+(:,$netconf(system,nickname)) JOIN $ini(data/channels.db,%x)
      if ($netconf(system,qmode) == on) {
        .sockwrite -tn serv $+(:,$netconf(server,server)) MODE $ini(data/channels.db,%x) +qo $netconf(system,nickname)
        } else {
        .sockwrite -tn serv $+(:,$netconf(server,server)) MODE $ini(data/channels.db,%x) +o $netconf(system,nickname)
      }
      .sockwrite -tn serv $+(:,$netconf(system,nickname)) MODE $ini(data/channels.db,%x) $iif($readchan($ini(data/channels.db,%x),modes),$ifmatch,+nt)
      .sockwrite -tn serv $+(:,$netconf(system,nickname)) TOPIC $ini(data/channels.db,%x) $netconf(system,nickname) $ctime : $+ $remove($read(data/set_topics.txt, s, $ini(data/channels.db,%x) $+ :),$ini(data/channels.db,%x) $+ :)
      .removeLIVEtopic $ini(data/channels.db,%x)
      writeLIVEtopic $ini(data/channels.db,%x) $remove($read(data/set_topics.txt, s, $ini(data/channels.db,%x) $+ :),$ini(data/channels.db,%x) $+ :)
    }
    if ($readchan($ini(data/channels.db,%x),topicfreq) == on) {
      timer $+ $ini(data/channels.db,%x) $+ topic 0 14400 sockwrite -tn serv $+(:,$netconf(system,nickname)) TOPIC $ini(data/channels.db,%x) $netconf(system,nickname) $ctime : $+ $remove($read(data/set_topics.txt, s, $ini(data/channels.db,%x) $+ :),$ini(data/channels.db,%x) $+ :)
    }
    inc %x
  }
}
alias leave_chans {
  echo >>>>> Leaving Registered Channels
  var %x = 1
  while ($ini(data/channels.db,%x)) {
    if ($readchan($ini(data/channels.db,%x),inchan) == on) { 
      .sockwrite -tn serv $+(:,$netconf(system,nickname)) PART $ini(data/channels.db,%x) PartAll By Console
    }
    inc %x
  }
}
alias expire_chans {
  echo >>>>> Removing Expired Channels
  var %x = 1
  while ($ini(data/channels.db,%x)) {
    if (w isin $left($duration($calc($ctime - $readchan($ini(data/channels.db,%x),lastvisit))),3)) {
      var %ttime $ctime
      var %ttime2 $readchan($ini(data/channels.db,%x),lastvisit) 
      var %calc $calc((%ttime - %ttime2) * 7) 
    }
    if (d isin $netconf(system,chanexpire)) && ($readchan($ini(data/channels.db,%x),noexpire) != on) {
      if (d isin $left($duration($calc($ctime - $readchan($ini(data/channels.db,%x),lastvisit))),3))  && ($remove($left($duration($calc($ctime - $readchan($ini(data/channels.db,%x),lastvisit))),3),d,a,y,s) >= $remove($netconf(system,chanexpire),d)) {
        ;channel has expired function
        var %x 1
        while ($ini(data/access/infolines.db,%x)) {
          if ($readuserinfoline($ini(data/access/infolines.db,%x),$ini(data/channels.db,%x))) {
            remini data/access/infolines.db $ini(data/access/infolines.db,%x) $ini(data/channels.db,%x)
          }
          inc %x
        }
        ;remove any autovoice
        var %x = 1
        while ($ini(data/access/autovoice.db,%x)) {
          if ($readini(data/access/autovoice.db,$ini(data/access/autovoice.db,%x),$ini(data/channels.db,%x))) {
            remini data/access/autovoice.db $ini(data/access/autovoice.db,%x) $ini(data/channels.db,%x)
          }
          inc %x
        }
        ;remove any autoop
        var %x = 1
        while ($ini(data/access/autoop.db,%x)) {
          if ($readini(data/access/autoop.db,$ini(data/access/autoop.db,%x),$ini(data/channels.db,%x))) {
            remini data/access/autoop.db $ini(data/access/autoop.db,%x) $ini(data/channels.db,%x)
          }
          inc %x
        }
        ;remove any autojoins
        var %x = 1
        while ($ini(data/access/autojoin.db,%x)) {
          if ($readini(data/access/autojoin.db,$ini(data/access/autojoin.db,%x),$ini(data/channels.db,%x))) {
            remini data/access/autojoin.db $ini(data/access/autojoin.db,%x) $ini(data/channels.db,%x)
          }
          inc %x
        }
        ;remove any user levels
        var %x = 1
        while ($ini(data/access/level.db,%x)) {
          if ($readini(data/access/level.db,$ini(data/access/level.db,%x),$ini(data/channels.db,%x))) {
            remini data/access/level.db $ini(data/access/level.db,%x) $ini(data/channels.db,%x)
          }
          inc %x
        }
        ;remove any channel logs
        var %delete 1
        var %inc 0
        while ($findfile(logs, $+ $ini(data/channels.db,%x) $+ *,%delete)) {
          remove logs\ $+ $remove($findfile(logs, $+ $2 $+ _*,%delete),$mircdir $+ logs\)
          inc %inc
          inc %delete
        }
        ;remove the topic if any
        removetopic $ini(data/channels.db,%x)
        .sockwrite -tn serv $+(:,$netconf(server,server)) MODE $ini(data/channels.db,%x) -r
        .sockwrite -tn serv $+(:,$netconf(system,nickname)) PART $ini(data/channels.db,%x) Channel Has Expired
        report DROP: $ini(data/channels.db,%x) Channel unvisited and expired
        writetolog system $ini(data/channels.db,%x) unvisted and expired
        ;delete the channel
        wipechan $ini(data/channels.db,%x)
      }
      if (w isin $left($duration($calc($ctime - $readchan($ini(data/channels.db,%x),lastvisit))),3))  && ($remove($left($duration(%calc),3),w,k,s) >= $remove($netconf(system,chanexpire),d)) {
        ;channel has expired function
        var %x 1
        while ($ini(data/access/infolines.db,%x)) {
          if ($readuserinfoline($ini(data/access/infolines.db,%x),$ini(data/channels.db,%x))) {
            remini data/access/infolines.db $ini(data/access/infolines.db,%x) $ini(data/channels.db,%x)
          }
          inc %x
        }
        ;remove any autovoice
        var %x = 1
        while ($ini(data/access/autovoice.db,%x)) {
          if ($readini(data/access/autovoice.db,$ini(data/access/autovoice.db,%x),$ini(data/channels.db,%x))) {
            remini data/access/autovoice.db $ini(data/access/autovoice.db,%x) $ini(data/channels.db,%x)
          }
          inc %x
        }
        ;remove any autoop
        var %x = 1
        while ($ini(data/access/autoop.db,%x)) {
          if ($readini(data/access/autoop.db,$ini(data/access/autoop.db,%x),$ini(data/channels.db,%x))) {
            remini data/access/autoop.db $ini(data/access/autoop.db,%x) $ini(data/channels.db,%x)
          }
          inc %x
        }
        ;remove any autojoins
        var %x = 1
        while ($ini(data/access/autojoin.db,%x)) {
          if ($readini(data/access/autojoin.db,$ini(data/access/autojoin.db,%x),$ini(data/channels.db,%x))) {
            remini data/access/autojoin.db $ini(data/access/autojoin.db,%x) $ini(data/channels.db,%x)
          }
          inc %x
        }
        ;remove any user levels
        var %x = 1
        while ($ini(data/access/level.db,%x)) {
          if ($readini(data/access/level.db,$ini(data/access/level.db,%x),$ini(data/channels.db,%x))) {
            remini data/access/level.db $ini(data/access/level.db,%x) $ini(data/channels.db,%x)
          }
          inc %x
        }
        ;remove any channel logs
        var %delete 1
        var %inc 0
        while ($findfile(logs, $+ $ini(data/channels.db,%x) $+ *,%delete)) {
          remove logs\ $+ $remove($findfile(logs, $+ $2 $+ _*,%delete),$mircdir $+ logs\)
          inc %inc
          inc %delete
        }
        ;remove the topic if any
        removetopic $ini(data/channels.db,%x)
        .sockwrite -tn serv $+(:,$netconf(server,server)) MODE $ini(data/channels.db,%x) -r
        .sockwrite -tn serv $+(:,$netconf(system,nickname)) PART $ini(data/channels.db,%x) Channel Has Expired
        report DROP: $ini(data/channels.db,%x) Channel unvisited and expired
        writetolog system $ini(data/channels.db,%x) unvisted and expired
        ;delete the channel
        wipechan $ini(data/channels.db,%x)
      }    
    }

    if (w isin $netconf(system,chanexpire)) && ($readchan($ini(data/channels.db,%x),noexpire) != on) {
      if (w isin $left($duration($calc($ctime - $readchan($ini(data/channels.db,%x),lastvisit))),3))  && ($remove($left($duration($calc(%calc / 7)),3),w,k,s) >= $remove($netconf(system,chanexpire),w)) {
        ;channel has expired function      
        var %x 1
        while ($ini(data/access/infolines.db,%x)) {
          if ($readuserinfoline($ini(data/access/infolines.db,%x),$ini(data/channels.db,%x))) {
            remini data/access/infolines.db $ini(data/access/infolines.db,%x) $ini(data/channels.db,%x)
          }
          inc %x
        }
        ;remove any autovoice
        var %x = 1
        while ($ini(data/access/autovoice.db,%x)) {
          if ($readini(data/access/autovoice.db,$ini(data/access/autovoice.db,%x),$ini(data/channels.db,%x))) {
            remini data/access/autovoice.db $ini(data/access/autovoice.db,%x) $ini(data/channels.db,%x)
          }
          inc %x
        }
        ;remove any autoop
        var %x = 1
        while ($ini(data/access/autoop.db,%x)) {
          if ($readini(data/access/autoop.db,$ini(data/access/autoop.db,%x),$ini(data/channels.db,%x))) {
            remini data/access/autoop.db $ini(data/access/autoop.db,%x) $ini(data/channels.db,%x)
          }
          inc %x
        }
        ;remove any autojoins
        var %x = 1
        while ($ini(data/access/autojoin.db,%x)) {
          if ($readini(data/access/autojoin.db,$ini(data/access/autojoin.db,%x),$ini(data/channels.db,%x))) {
            remini data/access/autojoin.db $ini(data/access/autojoin.db,%x) $ini(data/channels.db,%x)
          }
          inc %x
        }
        ;remove any user levels
        var %x = 1
        while ($ini(data/access/level.db,%x)) {
          if ($readini(data/access/level.db,$ini(data/access/level.db,%x),$ini(data/channels.db,%x))) {
            remini data/access/level.db $ini(data/access/level.db,%x) $ini(data/channels.db,%x)
          }
          inc %x
        }
        ;remove any channel logs
        var %delete 1
        var %inc 0
        while ($findfile(logs, $+ $ini(data/channels.db,%x) $+ *,%delete)) {
          remove logs\ $+ $remove($findfile(logs, $+ $ini(data/channels.db,%x) $+ _*,%delete),$mircdir $+ logs\)
          inc %inc
          inc %delete
        }
        ;remove the topic if any
        removetopic $ini(data/channels.db,%x)
        ;delete the channel
        .sockwrite -tn serv $+(:,$netconf(server,server)) MODE $ini(data/channels.db,%x) -r
        .sockwrite -tn serv $+(:,$netconf(system,nickname)) PART $ini(data/channels.db,%x)
        report DROP: $ini(data/channels.db,%x) Channel unvisited and expired
        writetolog system $ini(data/channels.db,%x) unvisted and expired
        wipechan $ini(data/channels.db,%x)
      }
    }
    inc %x
  }
}
alias expire_nicks {
  echo >>>>> Removing Expired nicknames
  var %x = 1
  while ($ini(data/nicknames.db,%x)) {
    if (w isin $left($duration($calc($ctime - $readnick($ini(data/nicknames.db,%x),lastlogin))),3)) {
      var %ttime $ctime
      var %ttime2 $readnick($ini(data/nicknames.db,%x),lastlogin) 
      var %calc $calc((%ttime - %ttime2)) 
    }
    if (d isin $netconf(system,nickexpire)) && ($readnick($ini(data/nicknames.db,%x),noexpire) != on) {
      if (d isin $left($duration($calc($ctime - $readnick($ini(data/nicknames.db,%x),lastlogin))),3))  && ($remove($left($duration($calc($ctime - $readnick($ini(data/nicknames.db,%x),lastlogin))),3),d,a,y,s) >= $remove($netconf(system,nickexpire),d)) {
        ;nickname has expired function
        echo -a trigger 1 expire $ini(data/nicknames.db,%x)
        var %chans = 0
        var %x2 = 1
        while ($ini(data/channels.db,%x2)) {
          if ($readaccess($ini(data/nicknames.db,%x2),$ini(data/channels.db,%x2),level)) && ($readchan($ini(data/channels.db,%x2),owner) == $ini(data/nicknames.db,%x)) {
            var %x3 1
            while ($ini(data/access/infolines.db,%x3)) {
              if ($readuserinfoline($ini(data/access/infolines.db,%x3),$ini(data/channels.db,%x2))) {
                remini data/access/infolines.db $ini(data/access/infolines.db,%x2) $ini(data/channels.db,%x2)
              }
              inc %x3
            }
            ;remove any autovoice
            var %x3 = 1
            while ($ini(data/access/autovoice.db,%x3)) {
              if ($readini(data/access/autovoice.db,$ini(data/access/autovoice.db,%x3),$ini(data/channels.db,%x2))) {
                remini data/access/autovoice.db $ini(data/access/autovoice.db,%x3) $ini(data/channels.db,%x2)
              }
              inc %x3
            }
            ;remove any autoop
            var %x3 = 1
            while ($ini(data/access/autoop.db,%x3)) {
              if ($readini(data/access/autoop.db,$ini(data/access/autoop.db,%x3),$ini(data/channels.db,%x2))) {
                remini data/access/autoop.db $ini(data/access/autoop.db,%x3) $ini(data/channels.db,%x2)
              }
              inc %x3
            }
            ;remove any autojoins
            var %x3 = 1
            while ($ini(data/access/autojoin.db,%x3)) {
              if ($readini(data/access/autojoin.db,$ini(data/access/autojoin.db,%x3),$ini(data/channels.db,%x2))) {
                remini data/access/autojoin.db $ini(data/access/autojoin.db,%x3) $ini(data/channels.db,%x2)
              }
              inc %x3
            }
            ;remove any user levels
            var %x3 = 1
            while ($ini(data/access/level.db,%x3)) {
              if ($readini(data/access/level.db,$ini(data/access/level.db,%x3),$ini(data/channels.db,%x2))) {
                remini data/access/level.db $ini(data/access/level.db,%x3) $ini(data/channels.db,%x2)
              }
              inc %x3
            }
            ;remove any channel logs
            var %delete 1
            var %inc 0
            while ($findfile(logs, $+ $ini(data/channels.db,%x) $+ *,%delete)) {
              remove logs\ $+ $remove($findfile(logs, $+ $ini(data/channels.db,%x) $+ _*,%delete),$mircdir $+ logs\)
              inc %inc
              inc %delete
            }
            ;remove the topic if any
            removetopic $ini(data/channels.db,%x)
            ;delete the channel
            .sockwrite -tn serv $+(:,$netconf(server,server)) MODE $ini(data/channels.db,%x) -r
            .sockwrite -tn serv $+(:,$netconf(system,nickname)) PART $ini(data/channels.db,%x)
            report DROP: $ini(data/channels.db,%x) Channel owner account expired
            writetolog system $ini(data/channels.db,%x) channel owner account expired
            wipechan $ini(data/channels.db,%x)
          }
          inc %x2
        }
        ;remove nickname
        remini data/access/autoop.db $ini(data/nicknames.db,%x)
        remini data/access/autojoin.db $ini(data/nicknames.db,%x)
        remini data/access/autovoice.db $ini(data/nicknames.db,%x)
        remini data/access/infolines.db $ini(data/nicknames.db,%x)
        remini data/access/level.db $ini(data/nicknames.db,%x)
        remini data/notes.db $ini(data/nicknames.db,%x)
        remini data/pending.db $ini(data/nicknames.db,%x)
        writetolog system Removed expired nickname $ini(data/nicknames.db,%x)
        report NICKDROP: Removing expired nickname $ini(data/nicknames.db,%x)
        wipenick $ini(data/nicknames.db,%x)
      }
      if (w isin $left($duration(%calc),3))  && ($calc(($remove($left($duration($calc($ctime - $readnick($ini(data/nicknames.db,%x),lastlogin))),3),w,k,s)) * 7) >= $remove($netconf(system,nickexpire),d)) {
        ;nickname has expired function
        echo -a trigger 2 expire $ini(data/nicknames.db,%x)
        var %chans = 0
        var %x2 = 1
        while ($ini(data/channels.db,%x2)) {
          if ($readaccess($ini(data/nicknames.db,%x2),$ini(data/channels.db,%x2),level)) && ($readchan($ini(data/channels.db,%x2),owner) == $ini(data/nicknames.db,%x)) {
            var %x3 1
            while ($ini(data/access/infolines.db,%x3)) {
              if ($readuserinfoline($ini(data/access/infolines.db,%x3),$ini(data/channels.db,%x2))) {
                remini data/access/infolines.db $ini(data/access/infolines.db,%x2) $ini(data/channels.db,%x2)
              }
              inc %x3
            }
            ;remove any autovoice
            var %x3 = 1
            while ($ini(data/access/autovoice.db,%x3)) {
              if ($readini(data/access/autovoice.db,$ini(data/access/autovoice.db,%x3),$ini(data/channels.db,%x2))) {
                remini data/access/autovoice.db $ini(data/access/autovoice.db,%x3) $ini(data/channels.db,%x2)
              }
              inc %x3
            }
            ;remove any autoop
            var %x3 = 1
            while ($ini(data/access/autoop.db,%x3)) {
              if ($readini(data/access/autoop.db,$ini(data/access/autoop.db,%x3),$ini(data/channels.db,%x2))) {
                remini data/access/autoop.db $ini(data/access/autoop.db,%x3) $ini(data/channels.db,%x2)
              }
              inc %x3
            }
            ;remove any autojoins
            var %x3 = 1
            while ($ini(data/access/autojoin.db,%x3)) {
              if ($readini(data/access/autojoin.db,$ini(data/access/autojoin.db,%x3),$ini(data/channels.db,%x2))) {
                remini data/access/autojoin.db $ini(data/access/autojoin.db,%x3) $ini(data/channels.db,%x2)
              }
              inc %x3
            }
            ;remove any user levels
            var %x3 = 1
            while ($ini(data/access/level.db,%x3)) {
              if ($readini(data/access/level.db,$ini(data/access/level.db,%x3),$ini(data/channels.db,%x2))) {
                remini data/access/level.db $ini(data/access/level.db,%x3) $ini(data/channels.db,%x2)
              }
              inc %x3
            }
            ;remove any channel logs
            var %delete 1
            var %inc 0
            while ($findfile(logs, $+ $ini(data/channels.db,%x) $+ *,%delete)) {
              remove logs\ $+ $remove($findfile(logs, $+ $ini(data/channels.db,%x) $+ _*,%delete),$mircdir $+ logs\)
              inc %inc
              inc %delete
            }
            ;remove the topic if any
            removetopic $ini(data/channels.db,%x)
            ;delete the channel
            .sockwrite -tn serv $+(:,$netconf(server,server)) MODE $ini(data/channels.db,%x) -r
            .sockwrite -tn serv $+(:,$netconf(system,nickname)) PART $ini(data/channels.db,%x)
            report DROP: $ini(data/channels.db,%x) Channel owner account expired
            writetolog system $ini(data/channels.db,%x) channel owner account expired
            wipechan $ini(data/channels.db,%x)
          }
          inc %x2
        }
        ;remove nickname
        remini data/access/autoop.db $ini(data/nicknames.db,%x)
        remini data/access/autojoin.db $ini(data/nicknames.db,%x)
        remini data/access/autovoice.db $ini(data/nicknames.db,%x)
        remini data/access/infolines.db $ini(data/nicknames.db,%x)
        remini data/access/level.db $ini(data/nicknames.db,%x)
        remini data/notes.db $ini(data/nicknames.db,%x)
        remini data/pending.db $ini(data/nicknames.db,%x)
        writetolog system Removed expired nickname $ini(data/nicknames.db,%x)
        report NICKDROP: Removing expired nickname $ini(data/nicknames.db,%x)
        wipenick $ini(data/nicknames.db,%x)
      } 
    }
    if (w isin $netconf(system,nickexpire)) && ($readnick($ini(data/nicknames.db,%x),noexpire) != on) {
      if (w isin $left($duration($calc($ctime - $readnick($ini(data/nicknames.db,%x),lastlogin))),3))  && ($calc(($remove($left($duration($calc($ctime - $readnick($ini(data/nicknames.db,%x),lastlogin))),3),w,k,s))) >= $remove($netconf(system,nickexpire),w)) {
        ;nickname has expired function 
        echo -a trigger 3 expire $ini(data/nicknames.db,%x)  
        var %chans = 0
        var %x2 = 1
        while ($ini(data/channels.db,%x2)) {
          if ($readaccess($ini(data/nicknames.db,%x2),$ini(data/channels.db,%x2),level)) && ($readchan($ini(data/channels.db,%x2),owner) == $ini(data/nicknames.db,%x)) {
            var %x3 1
            while ($ini(data/access/infolines.db,%x3)) {
              if ($readuserinfoline($ini(data/access/infolines.db,%x3),$ini(data/channels.db,%x2))) {
                remini data/access/infolines.db $ini(data/access/infolines.db,%x2) $ini(data/channels.db,%x2)
              }
              inc %x3
            }
            ;remove any autovoice
            var %x3 = 1
            while ($ini(data/access/autovoice.db,%x3)) {
              if ($readini(data/access/autovoice.db,$ini(data/access/autovoice.db,%x3),$ini(data/channels.db,%x2))) {
                remini data/access/autovoice.db $ini(data/access/autovoice.db,%x3) $ini(data/channels.db,%x2)
              }
              inc %x3
            }
            ;remove any autoop
            var %x3 = 1
            while ($ini(data/access/autoop.db,%x3)) {
              if ($readini(data/access/autoop.db,$ini(data/access/autoop.db,%x3),$ini(data/channels.db,%x2))) {
                remini data/access/autoop.db $ini(data/access/autoop.db,%x3) $ini(data/channels.db,%x2)
              }
              inc %x3
            }
            ;remove any autojoins
            var %x3 = 1
            while ($ini(data/access/autojoin.db,%x3)) {
              if ($readini(data/access/autojoin.db,$ini(data/access/autojoin.db,%x3),$ini(data/channels.db,%x2))) {
                remini data/access/autojoin.db $ini(data/access/autojoin.db,%x3) $ini(data/channels.db,%x2)
              }
              inc %x3
            }
            ;remove any user levels
            var %x3 = 1
            while ($ini(data/access/level.db,%x3)) {
              if ($readini(data/access/level.db,$ini(data/access/level.db,%x3),$ini(data/channels.db,%x2))) {
                remini data/access/level.db $ini(data/access/level.db,%x3) $ini(data/channels.db,%x2)
              }
              inc %x3
            }
            ;remove any channel logs
            var %delete 1
            var %inc 0
            while ($findfile(logs, $+ $ini(data/channels.db,%x) $+ *,%delete)) {
              remove logs\ $+ $remove($findfile(logs, $+ $ini(data/channels.db,%x) $+ _*,%delete),$mircdir $+ logs\)
              inc %inc
              inc %delete
            }
            ;remove the topic if any
            removetopic $ini(data/channels.db,%x)
            ;delete the channel
            .sockwrite -tn serv $+(:,$netconf(server,server)) MODE $ini(data/channels.db,%x) -r
            .sockwrite -tn serv $+(:,$netconf(system,nickname)) PART $ini(data/channels.db,%x)
            report DROP: $ini(data/channels.db,%x) Channel owner account expired
            writetolog system $ini(data/channels.db,%x) channel owner account expired
            wipechan $ini(data/channels.db,%x)
          }
          inc %x2
        }
        ;remove nickname
        remini data/access/autoop.db $ini(data/nicknames.db,%x)
        remini data/access/autojoin.db $ini(data/nicknames.db,%x)
        remini data/access/autovoice.db $ini(data/nicknames.db,%x)
        remini data/access/infolines.db $ini(data/nicknames.db,%x)
        remini data/access/level.db $ini(data/nicknames.db,%x)
        remini data/notes.db $ini(data/nicknames.db,%x)
        remini data/pending.db $ini(data/nicknames.db,%x)
        writetolog system Removed expired nickname $ini(data/nicknames.db,%x)
        report NICKDROP: Removing expired nickname $ini(data/nicknames.db,%x)
        wipenick $ini(data/nicknames.db,%x)    
      }
    }
    inc %x
  }
}
alias expire_akills_OLD {
  echo >>>>> Removing Expired gline/akills
  var %x = 1
  while ($ini(data/glines.db,%x)) {
    if (w isin $left($duration($calc($ctime - $readnetban($ini(data/glines.db,%x),time))),3)) {
      var %ttime $ctime
      var %ttime2 $readnetban($ini(data/glines.db,%x),time) 
      var %calc $calc((%ttime - %ttime2) * 7) 
    }
    if (d isin $readnetban($ini(data/glines.db,%x),expire)) {
      if (d isin $left($duration($calc($ctime - $readnetban($ini(data/glines.db,%x),time))),3))  && ($remove($left($duration($calc($ctime - $readnetban($ini(data/glines.db,%x),time))),3),d,a,y,s) >= $remove($readnetban($ini(data/glines.db,%x),expire),d)) {
        ;expired function      
        wipenetban $ini(data/glines.db,%x)
        report AKILL Removing Expired AKILL #  $+ $ini(data/glines.db,%x)
        writetolog system Removing Expired AKILL #  $+ $ini(data/glines.db,%x)

      }
      if (w isin $left($duration($calc($ctime - $readnetban($ini(data/glines.db,%x),time))),3))  && ($remove($left($duration(%calc),3),w,k,s) >= $remove($readnetban($ini(data/glines.db,%x),expire),d)) {
        ;expired function      
        wipenetban $ini(data/glines.db,%x)
        report AKILL Removing Expired AKILL #  $+ $ini(data/glines.db,%x)
        writetolog system Removing Expired AKILL #  $+ $ini(data/glines.db,%x)
      }    
    }

    if (w isin $readnetban($ini(data/glines.db,%x),expire)) {
      if (w isin $left($duration($calc($ctime - $readnetban($ini(data/glines.db,%x),time))),3))  && ($remove($left($duration($calc(%calc / 7)),3),w,k,s) >= $remove($readnetban($ini(data/glines.db,%x),expire),w)) {
        ;expired function      
        wipenetban $ini(data/glines.db,%x)
        report AKILL Removing Expired AKILL #  $+ $ini(data/glines.db,%x)
        writetolog system Removing Expired AKILL #  $+ $ini(data/glines.db,%x)
      }
    }
    inc %x
  }
}
alias expire_allbans {
  var %x = 1
  while ($ini(data/glines.db,%x)) {
    if ($ctime >= $readnetban($ini(data/glines.db,%x),expiretime)) && ($readnetban($ini(data/glines.db,%x),expiretime) != 0) {
      report BAN EXPIRE Removing Expired $readnetban($ini(data/glines.db,%x),type) #  $+ $ini(data/glines.db,%x)  $+ $readnetban($ini(data/glines.db,%x),address)
      writetolog system Removing Expired $readnetban($ini(data/glines.db,%x),type) #  $+ $ini(data/glines.db,%x)  $+ $readnetban($ini(data/glines.db,%x),address)
      if ($readnetban($ini(data/glines.db,%x),type) == GLINE) || ($readnetban($ini(data/glines.db,%x),type) == AGLINE) {
        sockwrite -tn serv TKL - G * $readnetban($ini(data/glines.db,%x),address) $netconf(server,server)
      }
      wipenetban $ini(data/glines.db,%x)
    }
    inc %x
  }
  var %x = 1
  while ($ini(data/chanBL.db,%x)) {
    if ($ctime >= $chanBL($ini(data/chanBL.db,%x),expiretime)) && ($chanBL($ini(data/chanBL.db,%x),expiretime) != 0) {
      report CHANEL BLACKLIST Removing Expired channel blacklist #  $+ $ini(data/chanBL.db,%x)
      writetolog system Removing Expired channel blacklist #  $+ $ini(data/chanBL.db,%x) 
      wipechanBL $ini(data/chanBL.db,%x)
    }
    inc %x
  }

}
alias do_daily {
  ;mysql web perform
  ;remove any expired akills / glines / aglines
  expire_allbans
  ;web_actions
  if ($time == $netconf(system,dailytasks)) {
    ;daily stuff

    report *** Performing Daily Tasks $time ***
    send_mail $netconf(system,administrator) systemlogs
    report > Sending logs to system administrator: $readnick($netconf(system,administrator),email)
    writeconf system currentdate $replace($date,$chr(47),-) 
    report > Setting Date  $+ $replace($date,$chr(47),-) 
    ;create new system log
    report > Creating Daily Log
    writetolog system *** Starting Daily Tasks $time ***
    ;remove any expired channels
    report > Removing Any Expired Channels
    expire_chans
    ;remove any expired nicknames
    report > Removing Any Expired Accounts And Any Channels They Have
    expire_nicks
    ;do we do daily backups
    if ($netconf(system,dailybackups) == on) {
      report > Creating System Restore Point (backup)
      system.backup.database $netconf(system,nickname) Automated Backup
    }
    ;enter your own daily task funtions or commands here



    ;do not edit below this line
    report *** Daily Tasks Complete $time ***
    writetolog system *** Daily Tasks Complete ***
  }
}

alias check_akills {
  var %x 1
  while ($ini(data/glines.db,%x)) {
    if (* $+ $readnetban($ini(data/glines.db,%x),address) $+ * iswm $+(*@,$1)) && ($readnetban($ini(data/glines.db,%x),type) == AKILL) {
      ;echo -a $ini(data/glines.db,%x) - $readnetban($ini(data/glines.db,%x),address)
      sockwrite -tn serv $+(:,$netconf(server,server)) KILL $2 $readnetban($ini(data/glines.db,%x),reason)
      report AKILL: $1 triggered an auto kill - $readnetban($ini(data/glines.db,%x),reason)
      halt
    }
    inc %x 
  }
}
alias check_aglines {
  var %x 1
  while ($ini(data/glines.db,%x)) {
    if (* $+ $readnetban($ini(data/glines.db,%x),address) $+ * iswm $+(*@,$1)) && ($readnetban($ini(data/glines.db,%x),type) == GLINE) {
      ;echo -a $ini(data/glines.db,%x) - $readnetban($ini(data/glines.db,%x),address)
      sockwrite -tn serv TKL + G * $1 $netconf(system,nickname) $calc($ctime + 3600) $ctime :AGLINE - $readnetban($ini(data/glines.db,%x),reason)
      report AGLINE: $1 triggered an auto GLINE - $readnetban($ini(data/glines.db,%x),reason)
      halt
    }
    inc %x 
  }
}
