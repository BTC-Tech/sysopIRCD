; Copying or editing of any of the scripts included in this module is strictly prohibited, you may distribute the package
; in its entireity un edited in any form. Support can only be given to those who do not edit these files please do not ask
; if you plan to edit them yourself. Credits and links back to us must remain in the script we do not advertise using your
; network unless the .VERSION command is triggered. You must also agree when connecting the service to any IRC net
; that you have the correct permission to connect the service, you MUST NOT connect the service to Digi-Net and you
; connect the service at your own risk. For support see http://www.digi-net.org

alias system.chandrop {
  if ($netconf(system,chanreg) == off) && (!$readadmin($addy($1),nickname) == $1) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,chanreg1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,chanreg2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($left($2,1) != $chr(35)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel name required, names MUST start with
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color the character  $+ $chr(35) $+  e.g #My-Channel
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt    
  }
  if (!$readchan($2,channel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,notreg)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($hasaccess(drop,$1,$2) != true) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 

  if ($readnick($1,operlevel) < $netconf(chanlevel,admindrop)) && ($readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4).
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  ;remove any infolines
  var %x = 1
  while ($ini(data/access/infolines.db,%x)) {
    if ($readuserinfoline($ini(data/access/infolines.db,%x),$2)) {
      remini data/access/infolines.db $ini(data/access/infolines.db,%x) $2
    }
    inc %x
  }
  ;remove any autovoice
  var %x = 1
  while ($ini(data/access/autovoice.db,%x)) {
    if ($readini(data/access/autovoice.db,$ini(data/access/autovoice.db,%x),$2)) {
      remini data/access/autovoice.db $ini(data/access/autovoice.db,%x) $2
    }
    inc %x
  }
  ;remove any autoop
  var %x = 1
  while ($ini(data/access/autoop.db,%x)) {
    if ($readini(data/access/autoop.db,$ini(data/access/autoop.db,%x),$2)) {
      remini data/access/autoop.db $ini(data/access/autoop.db,%x) $2
    }
    inc %x
  }
  ;remove any autojoins
  var %x = 1
  while ($ini(data/access/autojoin.db,%x)) {
    if ($readini(data/access/autojoin.db,$ini(data/access/autojoin.db,%x),$2)) {
      remini data/access/autojoin.db $ini(data/access/autojoin.db,%x) $2
    }
    inc %x
  }
  ;remove any user levels
  var %x = 1
  while ($ini(data/access/level.db,%x)) {
    if ($readini(data/access/level.db,$ini(data/access/level.db,%x),$2)) {
      remini data/access/level.db $ini(data/access/level.db,%x) $2
    }
    inc %x
  }
  ;remove any channel logs
  var %delete 1
  var %inc 0
  while ($findfile(logs, $+ $2 $+ *,%delete)) {
    remove logs\ $+ $remove($findfile(logs, $+ $2 $+ _*,%delete),$mircdir $+ logs\)
    inc %inc
    inc %delete
  }
  ;remove the topic if any
  removetopic $2
  ;delete the channel
  wipechan $2
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,drop)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 $lang($1,channel,drop2)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  .sockwrite -tn serv $+(:,$netconf(server,server)) MODE $2 -r
  .sockwrite -tn serv $+(:,$netconf(system,nickname)) PART $2
  report DROP: $2 Deleted by $+($1,!,$userhost($1)) 
  writetolog system $2 Deleted by $1
  halt
}

alias system.chanreg {
  if ($netconf(system,chanreg) == off) && (!$readadmin($addy($1),nickname) == $1) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,chanreg1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,chanreg2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$addy($1)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  var %x = 1
  set %channels 0
  while ($ini(data/channels.db,%x)) {
    if ($readchan($ini(data/channels.db,%x),owner) == $1) {
      set %channels $calc(%channels + 1)
    }
    inc %x
  }
  if (%channels > $netconf(system,maxchans)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Too Many Channels
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,noreg2) - %channels
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($left($2,1) != $chr(35)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel name required, names MUST start with
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color the character  $+ $chr(35) $+  e.g #My-Channel
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt    
  }
  if ($readchan($2,channel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Channel Taken
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry that channel is already registered.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  addchan $2 channel $2
  addchan $2 owner $addy($1)
  addchan $2 datereg $ctime
  addchan $2 autoop off
  addchan $2 badlang off
  addchan $2 inchan on
  addchan $2 modes +nrt
  addchan $2 voice off
  addchan $2 clones off
  addchan $2 strictop off
  addchan $2 setaccess 4
  addchan $2 bantimeout 0
  addchan $2 topicfreq off
  addchan $2 spamfilter off
  addchan $2 sayaccess 3
  addchan $2 quoteaccess 2
  addchan $2 capkick 0
  addchan $2 lastvisit $ctime
  addchan $2 loging off
  addchan $2 noexpire off

  addaccess $1 $2 level 5
  if ($readnick($1,autoop) == on) {
    addaccess $1 $2 autoop on
  }
  else
  {
    addaccess $1 $2 autoop off
  }
  addaccess $1 $2 autovoice off
  writetopic $2 Welcome to $2
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Channel Registration Complete
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 is now registered to you $1 $+ .
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please note channels unvisited for  $+ $netconf(system,chanexpire) $+ 
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color will be removed by $netconf(system,nickname) automatically
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  .sockwrite -tn serv $+(:,$netconf(system,nickname)) JOIN $2
  if ($netconf(system,qmode) == on) {
    .sockwrite -tn serv $+(:,$netconf(server,server)) MODE $2 +qo $netconf(system,nickname)
    } else {
    .sockwrite -tn serv $+(:,$netconf(server,server)) MODE $2 +o $netconf(system,nickname)
  }
  .sockwrite -tn serv $+(:,$netconf(server,server)) MODE $2 $readchan($2,modes)
  report CHANREG: $2 from $+($1,!,$userhost($1)) successful
  if ($netconf(system,loging) == on) { 
    writetolog system $2 Registered by $1
  }
  halt
}

alias system.version {
  if ($readchan($2,channel)) {
    sysmsg $2 SysOp Services Version $netconf(system,version) $+  Bozza & Borderlad https://btctech.co.uk/
  }
  else {
    sysnotice $1 SysOp Services Version $netconf(system,version) $+  Bozza & Borderlad https://btctech.co.uk/
  }
}
alias system.deluser {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel name required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readchan($2,suspended)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 is currently suspended by admin, 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Reason: $readchan($2,suspended)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readchan($2,channel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel $2 is not registered
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color For help regarding registration /msg $netconf(system,nickname) HELP CHANREG
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($hasaccess(deluser,$1,$2) != true) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  if (!$3) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Nickname
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid nickname to deluser required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($3,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Nickname
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Nickname $3 is not registered
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color For help regarding registration /msg $netconf(system,nickname) HELP NICKREG
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readaccess($3,$2,level)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,5)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Nickname $3 does not have access to $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$4) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Level
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid level required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid Options are: Owner, Co-Owner, Operator, Friend, Lamer 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($axs.levels.name($4) == Nothing) && ($axs.levels.number($4) == Nothing) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Level
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid level required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid Options are: Owner, Co-Owner, Operator, Friend, Lamer 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($4 !isnum) { set -u10 %level $axs.levels.number($4) }
  if ($readaccess($addy($1),$2,level) <= %level) && ($readchan($1,owner) != $1) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Cannot remove a user with equal or higher access than your own.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readnick($1,operlevel) < $netconf(chanlevel,admindeluser)) && ($readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4).
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  delaccess $3 $2 level
  delaccess $3 $2 autoop
  delaccess $3 $2 autovoice
  delaccess $3 $2 autojoin
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  User Removed
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $3 has been removed as a $2 $axs.levels.name(%level)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  if ($readchan($2,loging) == on) { 
    writetolog $2 $3 user level removed by $1
  }
  ;send user a note
  if ($readnick($3,notesystem) == on) && (!$readnick($3,noteabuse)) && ($readnick($3,accessalert) == on) {
    writeini data/notes.db $3 $calc($ini(data/notes.db,$3,0) +1) Hello $3 $+ , $1 removed you as a $2 $axs.levels.name(%level)  on $asctime($ctime)
    if ($readclient($3,nickname)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color $+  Note Recieved from $netconf(system,nickname)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color To List your notes type /msg $netconf(system,nickname) NOTE LIST
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color You are using 12 $+ $ini(data/notes.db,$3,0) $+  out of your 12 $+ $readnick($3,pmquota) $+  note limit
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 :-
    }
  }
  if ($addy($3)) && ($axs.levels.name(%level) != Lamer) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color $+  Channel Access Removed
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color $1 removed your access as a $2 $axs.levels.name(%level)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 :-
    halt
  }
  if ($axs.levels.name(%level) == Lamer) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color $+  Ban Removed $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color $1 removed you as a $2 $axs.levels.name(%level)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 :-
    sockwrite -tn serv : $+ $netconf(system,nickname) MODE $2 -b $mask($+($3,!,$userhost($3)),2)
  }
}

alias sysop.randombot {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readaccess($addy($1),$2,level)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  if ($hasaccess(randombot,$1) != true) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Insufficient access to use this command
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color have you IDENTIFED yet?
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }

  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  RANDOMBOT
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color %bots bots running...
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  halt

}

alias sysop.dummy {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Bot name required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Try /msg SysOp ADDBOT <botname> <#channel>
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readaccess($addy($1),$2,level)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  if ($hasaccess(addbot,$1) != true) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry, you do not have the correct access for this function.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$3) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect usage
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Try /msg SysOp ADDBOT <botname> <#channel>
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($4 == -delete) {
    sockwrite -tn serv $+(:,$2) QUIT :Quit:
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Removed Dummy User
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Your dummy user will be kicked the fuck out!
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  }
  else {
    .createDummy $2 $3
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Created Dummy User
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Your dummy user should join the channel now.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }


}
alias sysop.say {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel name required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readchan($2,channel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel $2 is not registered
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color For help regarding registration /msg $netconf(system,nickname) HELP CHANREG
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readchan($2,suspended)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 is currently suspended by admin, 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Reason: $readchan($2,suspended)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readaccess($addy($1),$2,level)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  if ($readaccess($addy($1),$2,level) < $readchan($2,sayaccess)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4).
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readnick($1,operlevel) < $netconf(chanlevel,adminsay)) && ($readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4).
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  if (!$3) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect usage
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Try /msg SysOp SAY <#channel> <message>
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  sockwrite -tn serv $+(:,SysOp) PRIVMSG $2 : $+ $3-

}
alias system.access {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel name required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readchan($2,channel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel $2 is not registered
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color For help regarding registration /msg $netconf(system,nickname) HELP CHANREG
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readchan($2,suspended)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 is currently suspended by admin, 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Reason: $readchan($2,suspended)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readaccess($addy($1),$2,level)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  if ($readaccess($addy($1),$2,level) < $netconf(chanlevel,access)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4).
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readnick($1,operlevel) < $netconf(chanlevel,adminaccess)) && ($readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4).
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  if (!$3) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Nickname
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid nickname for access required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($3,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Nickname
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Nickname $3 is not registered
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color For help regarding registration /msg $netconf(system,nickname) HELP NICKREG
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readaccess($3,$2,level)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  No Access For user
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Nickname $3 does not have access to $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Information
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel     : $2
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Nickname    : $3
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Access Level:   $+ $axs.levels.name($readaccess($3,$2,level))
  if ($readadmin($3,nickname) == $3) && ($readnick($3,operlevel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $3 $+  is an IRCop with 12 $+ $readnick($3,operlevel)  $+ access.
  }
  elseif ($readadmin($3,nickname) == $3) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $3 $+  is an IRCop with 12 $+ No  $+ access.
  } 
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  halt
}
alias system.adduser {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel name required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readchan($2,channel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel $2 is not registered
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color For help regarding registration /msg $netconf(system,nickname) HELP CHANREG
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readchan($2,suspended)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 is currently suspended by admin, 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Reason: $readchan($2,suspended)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($hasaccess(adduser,$1,$2) != true) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  if (!$3) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Nickname
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid nickname to adduser required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$4) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Level
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid level required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid Options are: Owner, Co-Owner, Operator, Friend, Lamer 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($axs.levels.name($4) == No-Access) && ($axs.levels.number($4) == No-Access) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Level
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid level required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid Options are: Owner, Co-Owner, Operator, Friend, Lamer 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($4 !isnum) { set -u10 %level $axs.levels.number($4) }
  if ($readaccess($addy($1),$2,level) <= %level) && ($readchan($2,owner) != $1) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Cannot add a user with higher or equal access than your own.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readnick($1,operlevel) < $netconf(chanlevel,adminadduser)) && ($readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4).
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  if (!$readnick($3,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Nickname
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Nickname $3 is not registered
    if ($readclient($3,nickname)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $3 is online, i will send them a message inviting
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color them to register, then you may attempt to add them.
      ;notice the person
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color $+  You were asked to join a channel access list
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color Hello, $1 tried to add you as a $2 $axs.levels.name(%level)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color but couldn't as your not registered yet, if you would like to
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color register type /msg $netconf(system,nickname) HELP REGISTER
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 :-
      echo -a >> Sent NICKREG request to $3
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readaccess($3,$2,level)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,5)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Nickname $3 already has access to $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  addaccess $3 $2 level %level  
  addaccess $3 $2 autoop $iif(%level > 2,on,off)
  addaccess $3 $2 autovoice $iif(%level < 2,on,off)
  addaccess $3 $2 autojoin off
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  User Added 
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $3 has been added as a $2 $axs.levels.name(%level)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  if ($readchan($2,loging) == on) { 
    writetolog $2 $3 added as a channel $axs.levels.name(%level) by $1
  }
  ;send user a note
  if ($readnick($3,notesystem) == on) && (!$readnick($3,noteabuse)) && ($readnick($3,accessalert) == on) {
    writeini data/notes.db $3 $calc($ini(data/notes.db,$3,0) +1) Hello $3 $+ , $1 added you as a $2 $axs.levels.name(%level)  on $asctime($ctime)
    if ($readclient($3,nickname)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color $+  Note Recieved from $netconf(system,nickname)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color To List your notes type /msg $netconf(system,nickname) NOTE LIST
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color You are using 12 $+ $ini(data/notes.db,$3,0) $+  out of your 12 $+ $readnick($3,pmquota) $+  note limit
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 :-
    }
  }
  if ($addy($3)) && ($axs.levels.name(%level) != Lamer) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color $+  Channel Access Granted
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color $1 added you as a $2 $axs.levels.name(%level)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 :-
    halt
  }
  if ($axs.levels.name(%level) == Lamer) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color $+  Banned From $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color $1 added you as a $2 $axs.levels.name(%level)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 :-
    sockwrite -tn serv : $+ $netconf(system,nickname) MODE $2 +b $mask($+($3,!,$userhost($3)),2)
    .sockwrite -tn serv $+(:,$netconf(system,nickname)) KICK $2 $3 Lamer
    halt 
  }
}
alias system.chanuset {
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel name required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readchan($2,channel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel $2 is not registered
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color For help regarding registration /msg $netconf(system,nickname) HELP CHANREG
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readchan($2,suspended)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 is currently suspended by admin, 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Reason: $readchan($2,suspended)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($hasAccess(uset,$1,$2) == false) {   
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$3) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Personal Settings For $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Auto-Op   : $readuserautoop($1,$2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Auto-Voice: $readuserautovoice($1,$2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Auto-Join : $readuserautojoin($1,$2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Join Info : $readuserinfoline($1,$2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($3 == aop) {
    if ($4 != on) && ($4 != off) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values are: on/off
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if ($4 == on) { userautoop $1 $2 on }
    if ($4 == off) { userautoop $1 $2 off }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Option Set
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color AOP is now $lower($4) in $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($3 == autojoin) {
    if ($4 != on) && ($4 != off) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values are: on/off
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if ($4 == on) { userautojoin $1 $2 on }
    if ($4 == off) { userautojoin $1 $2 off }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Option Set
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color AutoJoin is now $lower($4) for $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($3 == vop) {
    if ($4 != on) && ($4 != off) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values are: on/off
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if ($4 == on) { userautovoice $1 $2 on }
    if ($4 == off) { userautovoice $1 $2 off }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Option Set
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Auto Voice is now $lower($4) in $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($3 == info) {
    if (!$4)  && ($4 != off) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Missing Informations
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Try .USET INFO [<message>|off]
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if ($4 == off) {
      remini data/access/infolines.db $1 $2
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Info Message
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Your infoline message was removed
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if ($4) && ($4 != *) { 
      %x = 1
      while ($gettok(%bwords,%x,44)) {
        if ($gettok(%bwords,%x,44) isin $4-) {
          sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
          sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Bad Words Filtered
          sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Your infoline message is too rude to display
          sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
          report Badwords filtered in  $+ $1 $+ 's $2 INFO
          halt
        }
        inc %x
      }
    setuserchaninfo $1 $2 $4- }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Infoline saved for $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $4-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  }
}
alias system.opdown {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel name required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readchan($2,channel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel $2 is not registered
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color For help regarding registration /msg $netconf(system,nickname) HELP CHANREG
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readchan($2,suspended)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 is currently suspended by admin, 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Reason: $readchan($2,suspended)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readaccess($addy($1),$2,level)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  if ($readaccess($addy($1),$2,level) < $netconf(chanlevel,down)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4).
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  ;functions go in here
  if ($netconf(system,qmode) == on) {
    chanopuser $2 -qaov $1 | halt
    } else {
    chanopuser $2 -ov $1 $1 | halt
  }

}
alias system.opup {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel name required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readchan($2,channel)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel $2 is not registered
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color For help regarding registration /msg $netconf(system,nickname) HELP CHANREG
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readchan($2,suspended)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 is currently suspended by admin, 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Reason: $readchan($2,suspended)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readaccess($addy($1),$2,level)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  if ($readaccess($addy($1),$2,level) < $netconf(chanlevel,up)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4).
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  ;functions go in here

  if ($netconf(system,qmode) == on) {
    if ($readaccess($addy($1),$2,level) == 5) { chanopuser $2 +qao $1 }
    if ($readaccess($addy($1),$2,level) == 4) { chanopuser $2 +ao $1 }
    } else {
    if ($readaccess($addy($1),$2,level) == 5) { chanopuser $2 +ov $1 $1 }
    if ($readaccess($addy($1),$2,level) == 4) { chanopuser $2 +ov $1 $1 }
  }

  if ($readaccess($addy($1),$2,level) == 3) { chanopuser $2 +ov $1 }
  if ($readaccess($addy($1),$2,level) == 2) { chanopuser $2 +v $1 }
}
alias system.deopuser {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel name required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$3) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect USername
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Username name required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$activechan($2)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 is not currently open or active
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color For help regarding registration /msg $netconf(system,nickname) HELP CHANREG
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$useronchan($2,$3)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry  $+ $3 $+  is not on channel  $+ $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readchan($2,suspended)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 is currently suspended by admin, 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Reason: $readchan($2,suspended)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readaccess($addy($1),$2,level)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  if ($readaccess($addy($1),$2,level) < $netconf(chanlevel,op)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4).
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readnick($1,operlevel) < $netconf(chanlevel,admindeopuser)) && ($readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4).
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  if ($readaccess($addy($1),$2,level) < $readaccess($3,$2,level)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Cannot deop users with a higher access than you.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  ;functions go in here

  if ($netconf(system,qmode) == on) {
    chanopuser $2 -qaov $3 $3 $3 $3
    } else {
    chanopuser $2 -ov $3 $3
  }
}
alias system.opuser {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel name required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$3) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Username
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Username name required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$activechan($2)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 is not currently open or active
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color For help regarding registration /msg $netconf(system,nickname) HELP CHANREG
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$useronchan($2,$3)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry  $+ $3 $+  is not on channel  $+ $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readchan($2,suspended)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 is currently suspended by admin, 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Reason: $readchan($2,suspended)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readaccess($addy($1),$2,level)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  if ($readaccess($addy($1),$2,level) < $netconf(chanlevel,op)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4).
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readnick($1,operlevel) < $netconf(chanlevel,adminopuser)) && ($readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4).
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  ;functions go in here
  if ($netconf(system,qmode) == on) {
    if ($readaccess($addy($3),$2,level) == 5) { chanopuser $2 +q $3  | halt }
    if ($readaccess($addy($3),$2,level) == 4) { chanopuser $2 +a $3 | halt }
    } else {
    if ($readaccess($addy($3),$2,level) == 5) { chanopuser $2 +ov $3 $3 | halt }
    if ($readaccess($addy($3),$2,level) == 4) { chanopuser $2 +ov $3 $3 | halt }
  }
  if ($readaccess($addy($3),$2,level) == 3) { chanopuser $2 +ov $3 $3 | halt }
  if ($readaccess($addy($3),$2,level) == 2) { chanopuser $2 +v $3 | halt }
  chanopuser $2 +ov $3 $3
}
alias system.kickuser {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel name required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  /msg SysOp K #channel bob
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$3) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Username
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Username name required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  /msg SysOp K #channel bob
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$activechan($2)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 is not currently open or active
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color For help regarding registration /msg $netconf(system,nickname) HELP CHANREG
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$useronchan($2,$3)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry  $+ $3 $+  is not on channel  $+ $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readchan($2,suspended)) && (!$readmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 is currently suspended by admin, 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Reason: $readchan($2,suspended)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readaccess($addy($1),$2,level)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  if ($readaccess($addy($1),$2,level) < $netconf(chanlevel,kick)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4).
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readnick($1,operlevel) < $netconf(chanlevel,adminkick)) && ($readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4).
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  if ($readadmin($3,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Cannot kick an IRC operator from the channel.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readaccess($addy($1),$2,level) < $readaccess($3,$2,level)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Cannot Kick Users With Higher Access Than You.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  ;functions go in here
  sockwrite -tn serv $+(:,$netconf(system,nickname)) KICK $2 $3 Requested
  if ($readchan($2,loging) == on) { 
    writetolog $2 $3 was kicked by $1
  }
}
alias system.kickbanuser {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel name required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  /msg SysOp KB #channel bob
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$3) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Username
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Username name required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  /msg SysOp KB #channel bob
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$activechan($2)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 is not currently open or active
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color For help regarding registration /msg $netconf(system,nickname) HELP CHANREG
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$useronchan($2,$3)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry  $+ $3 $+  is not on channel  $+ $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readchan($2,suspended)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 is currently suspended by admin, 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Reason: $readchan($2,suspended)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readaccess($addy($1),$2,level)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  if ($readaccess($addy($1),$2,level) < $netconf(chanlevel,kickban)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4).
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readnick($1,operlevel) < $netconf(chanlevel,adminkick)) && ($readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4).
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  if ($readadmin($3,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Cannot kick an IRC operator from the channel.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readaccess($addy($1),$2,level) < $readaccess($3,$2,level)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Cannot Kick Users With Higher Access Than You.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  ;functions go in here
  sockwrite -tn serv : $+ $netconf(system,nickname) MODE $2 +b $mask($+($3,!,$userhost($3)),2)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) KICK $2 $3 Requested
  if ($readchan($2,bantimeout) == 1) { //timerban $+ $2 $+ $ctime 1 900 /removeban $2 $mask($+($3,!,$userhost($3)),2) }
  if ($readchan($2,bantimeout) == 2) { //timerban $+ $2 $+ $ctime 1 3600 /removeban $2 $mask($+($3,!,$userhost($3)),2) }
  if ($readchan($2,bantimeout) == 3) { //timerban $+ $2 $+ $ctime 1 10800 /removeban $2 $mask($+($3,!,$userhost($3)),2) }
  if ($readchan($2,loging) == on) { 

    writetolog $2 $3 - $mask($+($3,!,$userhost($3)),2) was kickbanned by $1
  }
  addchanban $2 $mask($+($3,!,$userhost($3)),2) $ctime
}
alias system.ban {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel name required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  /msg SysOp BAN #channel bob
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$3) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Username
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Username name required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  /msg SysOp BAN #channel bob
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$activechan($2)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 is not currently open or active
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color For help regarding registration /msg $netconf(system,nickname) HELP CHANREG
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$useronchan($2,$3)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry  $+ $3 $+  is not on channel  $+ $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readchan($2,suspended)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 is currently suspended by admin, 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Reason: $readchan($2,suspended)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readaccess($addy($1),$2,level)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  if ($readaccess($addy($1),$2,level) < $netconf(chanlevel,ban)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4).
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readnick($1,operlevel) < $netconf(chanlevel,adminkick)) && ($readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4).
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  if ($readadmin($3,nickname)) && ($readadmin($3,nickname) != $1) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Cannot ban an IRC operator from the channel.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readaccess($addy($1),$2,level) < $readaccess($3,$2,level)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Cannot ban Users With Higher Access Than You.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  ;functions go in here
  sockwrite -tn serv : $+ $netconf(system,nickname) MODE $2 +b $mask($+($3,!,$userhost($3)),2)
  if ($readchan($2,bantimeout) == 1) { //timerban $+ $2 $+ $ctime 1 900 /removeban $2 $mask($+($3,!,$userhost($3)),2) }
  if ($readchan($2,bantimeout) == 2) { //timerban $+ $2 $+ $ctime 1 3600 /removeban $2 $mask($+($3,!,$userhost($3)),2) }
  if ($readchan($2,bantimeout) == 3) { //timerban $+ $2 $+ $ctime 1 10800 /removeban $2 $mask($+($3,!,$userhost($3)),2) }
  if ($readchan($2,loging) == on) { 
    writetolog $2 $3 - $mask($+($3,!,$userhost($3)),2) was banned by $1
  }
  addchanban $2 $mask($+($3,!,$userhost($3)),2) $ctime
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Channel Ban Added
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color The following ban for $3 has been added to $2
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $mask($+($3,!,$userhost($3)),2)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
}
alias system.unban {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel name required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  /msg SysOp UNBAN #channel <nick/address>
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$3) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Username
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Username/Host name required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  /msg SysOp UNBAN #channel <nick/address>
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$activechan($2)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 is not currently open or active
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color For help regarding registration /msg $netconf(system,nickname) HELP CHANREG
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readchan($2,suspended)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 is currently suspended by admin, 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Reason: $readchan($2,suspended)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readaccess($addy($1),$2,level)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  if ($readaccess($addy($1),$2,level) < $netconf(chanlevel,unban)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4).
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readnick($1,operlevel) < $netconf(chanlevel,adminunban)) && ($readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4).
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  ;functions go in here
  if ($readclient($3,host)) {
    var %ub $mask($+($3,!,$userhost($3)),2)
  }
  else {
    var %ub $3
  }
  sockwrite -tn serv : $+ $netconf(system,nickname) MODE $2 -b %ub
  delchanban $2 %ub
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Channel Ban Removed
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color The following host has been removed from the channel ban list
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color %ub
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
}

alias system.channelbans {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel name required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  /msg SysOp BANS #channel
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  ;if (!$readchan($2,channel)) {
  ; sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  ; sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
  ; sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel $2 is not registered
  ; sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color For help regarding registration /msg $netconf(system,nickname) HELP CHANREG
  ; sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  ; halt
  ;}
  if ($readchan($2,suspended)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 is currently suspended by admin, 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Reason: $readchan($2,suspended)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readaccess($addy($1),$2,level)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  if ($readaccess($addy($1),$2,level) < $netconf(chanlevel,kickban)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4).
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  ;functions go in here
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $2 Active Ban List
  var %x = 1
  var %found 0
  while ($ini(data/chanbans.db,$2,%x)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $ini(data/chanbans.db,$2,%x) Added: $asctime($readchanban($2,$ini(data/chanbans.db,$2,%x)))
    inc %x
    inc %found
  }
  if (%found < 1) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color No bans active for $2
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color End of $2 ban list
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
}
alias system.chanset {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel name required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readchan($2,channel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel $2 is not registered
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color For help regarding registration /msg $netconf(system,nickname) HELP CHANREG
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readchan($2,suspended)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 is currently suspended by admin, 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Reason: $readchan($2,suspended)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readaccess($addy($1),$2,level)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  if ($readaccess($addy($1),$2,level) < $readchan($2,setaccess)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4).
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$3) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Channel Settings For $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Registrar    :  $+ $readchan($2,owner)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Topic        : $left($remove($read(data/set_topics.txt, s, $2 $+ :),$2 $+ :),40) $+ ...
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Modes        : $readchan($2,modes)
    if ($readchan($2,strictop) == on) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color StrictOp     : On  : Only listed users can be opped }
    else { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color StrictOp     : Off : No opping restrictions }
    if ($readchan($2,spamfilter) == on) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Spam Filter  : On  : Spammers will be kicked }
    else { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Spam Filter  : Off : Not protected from spammers }
    if ($readchan($2,inchan) == on) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color InChan       : On  : $netconf(system,nickname)) will join the channel }
    else { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color InChan       : Off : $netconf(system,nickname)) will not join the channel }  
    if ($readchan($2,capkick) = 0) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color CapKick      : Off : CapKick is disabled }
    elseif (!$readchan($2,capkick)) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color CapKick      : Off : CapKick is disabled }
    else { 
      if ($len($readchan($2,capkick)) = 1) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color CapKick      : $readchan($2,capkick)   : % cap letters before kick }
      elseif ($len($readchan($2,capkick)) = 2) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color CapKick      : $readchan($2,capkick)  : % cap letters before kick }
      else { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color CapKick      : $readchan($2,capkick) : % cap letters before kick }
    }
    if ($readchan($2,badlang) == on) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color BadLang      : On  : $netconf(system,nickname)) will kick non users who swear }
    else { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color BadLang      : Off : $netconf(system,nickname)) will allow anyone to swear }  
    if ($readchan($2,autoop) == on) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color AutoOp       : On  : $netconf(system,nickname)) will auto op users on join }
    else { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color AutoOp       : Off : $netconf(system,nickname)) will not auto op anyone }  
    if ($readchan($2,loging) == on) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Loging       : On  : $netconf(system,nickname)) will log channel events }
    else { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Loging       : Off : $netconf(system,nickname)) will not log channel events }  
    if ($readchan($2,voice) == on) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color AutoVoice    : On  : $netconf(system,nickname)) will auto voice users on join }
    else { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color AutoVoice    : Off : $netconf(system,nickname)) will not auto voice anyone }  
    if ($readchan($2,voice) == on) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color CloneStrict  : On  : Clones not allowed in $2 }
    else { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color CloneStrict  : Off : Clones allowed in $2 } 
    if ($readchan($2,joinmsg)) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color JoinMsg      : On  : $left($readchan($2,joinmsg),40) }
    else { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color JoinMsg      : Off : No JoinMsg saved! } 
    if ($readchan($2,char)) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Trigger      : On  : Public command trigger is  $+ $readchan($2,char) }
    else { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Trigger      : Off : Using default command trigger } 
    if ($readchan($2,url)) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel URL  : On  : $readchan($2,url) }
    else { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel URL  : Off : No URL saved for $2 } 
    if ($readchan($2,setaccess) == 5) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color SetAccess    :  5  : Only Onwers can use SET }
    if ($readchan($2,setaccess) == 4) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color SetAccess    :  4  : Co-Owners and above can use SET }
    if ($readchan($2,setaccess) == 3) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color SetAccess    :  3  : Operators and above can use SET }
    if ($readchan($2,sayaccess) == 5) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color SayAccess    :  5  : Only Onwers can use SAY }
    if ($readchan($2,sayaccess) == 4) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color SayAccess    :  4  : Co-Owners and above can use SAY }
    if ($readchan($2,sayaccess) == 3) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color SayAccess    :  3  : Operators and above can use SAY }
    if ($readchan($2,sayaccess) == 2) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color SayAccess    :  2  : Friends and above can use SAY }
    if ($readchan($2,bantimeout) == 1) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color BanTimeOut   :  1  : Bans removed after 15 mins }
    if ($readchan($2,bantimeout) == 2) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color BanTimeOut   :  2  : Bans removed afer 60 mins }
    if ($readchan($2,bantimeout) == 3) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color BanTimeOut   :  3  : Bans Removed after 180 mins }
    if ($readchan($2,bantimeout) == 0) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color BanTimeOut   :  0  : Bans never automatically removed }
    if ($readchan($2,topiclock) == off) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color TopicLock    :  0  : No TopicLock restrictions }
    if ($readchan($2,topiclock) == 2) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color TopicLock    :  2  : Friends and above can change topics }
    if ($readchan($2,topiclock) == 3) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color TopicLock    :  3  : Operators and above can change topics }
    if ($readchan($2,topiclock) == 4) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color TopicLock    :  4  : Co-Owners and above can change topics }
    if ($readchan($2,topiclock) == 5) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color TopicLock    :  5  : Only Owners can change topics }
    if ($readchan($2,topicfreq) == on) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color TopicFreq    : On  : Topic refreshed every 4 hours }
    else { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color TopicFreq    : Off : Topic is never refreshed } 
    if ($readchan($2,noexpire) == on) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color NoExpire     : On  : Channel will never expire } 
    else { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color NoExpire     : Off : Channel will expire when unvisited for  $+ $netconf(system,chanexpire) } 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel was last visited by a listed user:
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $asctime($readchan($2,lastvisit))  $+ $duration($calc($ctime - $readchan($2,lastvisit)))
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($3 == topiclock) {
    if (!$4) && ($4 != off) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values are: off 2 3 4 5
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    addchan $2 topiclock $4
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Option Set
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color TopicLock is now $lower($4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    if ($readchan($2,loging) == on) { 
      writetolog $2 $1 changed SET option TopicLock - $4
    }
    halt
  }
  if ($3 == topicfreq) {
    if ($4 != on) && ($4 != off) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values are: on/off
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if ($4 == on) { 
      addchan $2 topicfreq on
      timer $+ $2 $+ topic 0 14400 sockwrite -tn serv $+(:,$netconf(system,nickname)) TOPIC $2 $netconf(system,nickname) $ctime : $+ $remove($read(data/set_topics.txt, s, $2 $+ :),$2 $+ :)
      if ($readchan($2,loging) == on) { 
        writetolog $2 $1 changed SET option TopicFreq - $4
      }
    }
    if ($4 == off) { 
      addchan $2 topicfreq off 
      timer $+ $2 $+ topic off
      if ($readchan($2,loging) == on) { 
        writetolog $2 $1 changed SET option TopicFreq - $4
      }
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Option Set
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color TopicFreq is now $lower($4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($3 == spamfilter) {
    if ($4 != on) && ($4 != off) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values are: on/off
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if ($4 == on) { addchan $2 spamfilter on }
    if ($4 == off) { addchan $2 spamfilter off }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Option Set
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color SpamFilter is now $lower($4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    if ($readchan($2,loging) == on) { 
      writetolog $2 $1 changed SET option SpamFilter - $4
    }
    halt
  }
  if ($3 == autoop) {
    if ($4 != on) && ($4 != off) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values are: on/off
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if ($4 == on) { addchan $2 autoop on }
    if ($4 == off) { addchan $2 autoop off }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Option Set
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color AutoOP is now $lower($4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    if ($readchan($2,loging) == on) { 
      writetolog $2 $1 changed SET option AutoOp - $4
    }
    halt
  }
  if ($3 == loging) {
    if ($4 != on) && ($4 != off) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values are: on/off
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if ($4 == on) { addchan $2 loging on | writetolog $2 $1 enabled loging using SET }
    if ($4 == off) { addchan $2 loging off | writetolog $2 $1 disabled loging using SET }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Option Set
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Event Loging is now $lower($4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($3 == setaccess) {
    if ($4 != 3) && ($4 != 4) && ($4 != 5) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values are: 3-5
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    addchan $2 setaccess $4
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Option Set
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color SetAccess is now $lower($4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    if ($readchan($2,loging) == on) { 
      writetolog $2 $1 changed SET option SetAccess - $4
    }
    halt
  }
  if ($3 == capkick) {
    if ($4 !< 100) || ($4 !> -1) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values are: 1 - 100
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    addchan $2 capkick $4
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Option Set
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color CapKick is now $lower($4) $+ %
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    if ($readchan($2,loging) == on) { 
      writetolog $2 $1 changed SET option CapKick - $4
    }
    halt
  }
  if ($3 == sayaccess) {
    if ($4 != 2) && ($4 != 3) && ($4 != 4) && ($4 != 5) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values are: 2-5
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    addchan $2 sayaccess $4
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Option Set
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color SayAccess is now $lower($4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    if ($readchan($2,loging) == on) { 
      writetolog $2 $1 changed SET option SayAccess - $4
    }
    halt
  }
  if ($3 == autovoice) {
    if ($4 != on) && ($4 != off) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values are: on/off
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if ($4 == on) { addchan $2 voice on }
    if ($4 == off) { addchan $2 voice off }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Option Set
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color AutoVoice is now $lower($4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    if ($readchan($2,loging) == on) { 
      writetolog $2 $1 changed SET option AutoVoice - $4
    }
    halt
  }
  if ($3 == strictop) {
    if ($4 != on) && ($4 != off) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values are: on/off
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if ($4 == on) { addchan $2 strictop on }
    if ($4 == off) { addchan $2 strictop off }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Option Set
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color StrictOP is now $lower($4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    if ($readchan($2,loging) == on) { 
      writetolog $2 $1 changed SET option StrictOp - $4
    }
    halt
  }
  if ($3 == bantimeout) {
    if ($4 != 1) && ($4 != 2) && ($4 != 3) && ($4 != 0) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values are: 0-3
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    addchan $2 bantimeout $4
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Option Set
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color BanTimeOut is now $lower($4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    if ($readchan($2,loging) == on) { 
      writetolog $2 $1 changed SET option BanTimeOut - $4
    }
    halt
  }
  if ($3 == badlang) {
    if ($4 != on) && ($4 != off) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values are: on/off
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if ($4 == on) { addchan $2 badlang on }
    if ($4 == off) { addchan $2 badlang off }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Option Set
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color BadLang is now $lower($4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    if ($readchan($2,loging) == on) { 
      writetolog $2 $1 changed SET option BadLang - $4
    }
    halt
  }
  if ($3 == joinmsg) {
    if (!$4) && ($4 != off) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values are: off/message
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if ($4 != off ) { addchan $2 joinmsg $4- }
    if ($4 == off) { remini data/channels.db $2 joinmsg }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Option Set
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color JoinMsg is now $4-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    if ($readchan($2,loging) == on) { 
      writetolog $2 $1 changed SET option JoinMsg - $4-
    }
    halt
  }
  if ($3 == topic) {
    if (!$4) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color SET TOPIC <topic msg>
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }    
    removetopic $2
    writetopic $2 $4-
    removeLIVEtopic $2
    writeLIVEtopic $2 $4-

    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Option Set
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Topic is now $4-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) TOPIC $2 $netconf(system,nickname) $ctime : $+ $remove($read(data/set_topics.txt, s, $2 $+ :),$2 $+ :)
    if ($readchan($2,loging) == on) { 
      writetolog $2 $1 changed SET option Topic - $4-
    }
    halt  
  }
  if ($3 == founder) {
    if (!$4) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color SET FOUNDER <nickname>
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if (!$readnick($4,nickname)) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  New Founder Isnt Registered
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry $4 isnt registered, please choose another founder
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if ($readchan($2,owner) != $1) && (!$readadmin($1,nickname)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Only the channel registrar can change the founder.
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    ;change channel founder
    addaccess $4 $2 level 5
    addchan $2 owner $4
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  New Founder Complete
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color  $+ $readchan($2,owner) $+  is the new channel registrar
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    if ($readchan($2,loging) == on) { 
      writetolog $2 $1 changed SET option Founder, New channel owner is - $readchan($2,owner)
    }
    halt
  }
  if ($3 == url) {
    if (!$4) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color SET URL <http://url.com>
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    addchan $2 url $4-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Option Set
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel URL is now $4
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    if ($readchan($2,loging) == on) { 
      writetolog $2 $1 changed SET option URL - $4
    }
    halt
  }
  if ($3 == trigger) {
    if (!$4) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color SET TRIGGER <character>
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    addchan $2 char $4
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Option Set
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Public command trigger is now $4
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    if ($readchan($2,loging) == on) { 
      writetolog $2 $1 changed SET option Trgger - $4
    }
    halt
  }
  if ($3 == modes) {
    if (!$4) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color SET MODES <+-a-z>
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if ($4 != clear) { 
      if (+ isin $4) {
        addchan $2 modes $+(+r,$remove($4,+,-))
        sockwrite -tn serv $+(:,$netconf(system,nickname)) MODE $2 $readchan($2,modes) 
      }
      else {
        addchan $2 modes $+(+r-,$remove($4,+,-))
        sockwrite -tn serv $+(:,$netconf(system,nickname)) MODE $2 $readchan($2,modes) 
      }
      ;addchan $2 modes +r $+ $4 
      ;.sockwrite -tn serv $+(:,$netconf(system,nickname)) MODE $2 $readchan($2,modes)
    }
    if ($4 == clear) { addchan $2 modes +r | .sockwrite -tn serv $+(:,$netconf(system,nickname)) MODE $2 -ijklmpszAMOR }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Option Set
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel Modes Are Now  $readchan($2,modes)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    if ($readchan($2,loging) == on) { 
      writetolog $2 $1 changed SET option Modes - $readchan($2,modes)
    }
    halt
  }
  if ($3 == inchan) {
    if (!$readadmin($1,nickname)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  IRCop Only Function
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You do not have access to use SET INCHAN
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please ask an IRC operator /msg SysOp IRCOPS
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if ($4 != on) && ($4 != off) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values are: on/off
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if ($4 == on) { 
      if ($readchan($2,inchan) == on) {
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Cannot Complete
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color I am already in the channel and inchan is set ON
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
        halt
      }
      addchan $2 inchan on 
      sysjoin $2
      halt
    }
    if ($4 == off) { 
      if ($readchan($2,inchan) == off) {
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Cannot Complete
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color I am not in the channel and inchan is set OFF
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
        halt
      }
      addchan $2 inchan off
      syspart $2
      halt
    }
  }
  if ($3 == noexpire) {
    if (!$readadmin($1,nickname)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  IRCop Only Function
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You do not have access to use SET NOEXPIRE
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please ask an IRC operator /msg SysOp IRCOPS
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }

    if ($4 != on) && ($4 != off) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values are: on/off
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if ($4 == on) { 
      if ($readchan($2,noexpire) == on) {
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Cannot Complete
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color NoExpire value is already on
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
        halt
      }
      addchan $2 noexpire on 
    }
    if ($4 == off) {
      if ($readchan($2,noexpire) == off) {
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Cannot Complete
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color NoExpire value is already off
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
        halt
      }
      addchan $2 noexpire off 
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Option Set
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color NoExpire is now $lower($4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    if ($readchan($2,loging) == on) { 
      writetolog $2 $1 changed SET option NoExpire - $4
    }
    halt
  }
  if ($3 == suspend) {
    if (!$readadmin($1,nickname)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  IRCop Only Function
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You do not have access to use SET SUSPEND
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please ask an IRC operator /msg SysOp IRCOPS
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }

    if ($4 != off) && (!$4) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values are: off/message to users
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if ($4 == off) { 
      addchan $2 inchan on 
      remini data/channels.db $2 suspended
      sysjoin $2
      halt
    }
    if ($4 != off) {
      addchan $2 inchan off 
      addchan $2 suspended $4-
      syspart $2 Suspended By $1
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Option Set
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Suspend is now $lower($4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    if ($readchan($2,loging) == on) { 
      writetolog $2 $1 changed SET option Suspended - $4
    }
    halt
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect SET option
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color See  $+ /msg $netconf(system,nickname) HELP SET
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  halt
}
alias system.userlist {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel name required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readchan($2,channel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel $2 is not registered
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color For help regarding registration /msg $netconf(system,nickname) HELP CHANREG
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readchan($2,suspended)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 is currently suspended by admin, 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Reason: $readchan($2,suspended)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  ;if (!$readaccess($addy($1),$2,level)) && (!$readadmin($1,nickname)) {
  ;  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  ;  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
  ;  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4)
  ;  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  ;  halt
  ;} 
  ;if ($readaccess($addy($1),$2,level) < $netconf(chanlevel,ulist)) && (!$readadmin($1,nickname)) {
  ;  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  ;  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
  ;  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4).
  ;  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  ;  halt
  ;} 
  if ($hasaccess(users,$1,$2) == false) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4).
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  ;displaying user lists
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $2 $lang($1,channel,userlist)
  var %x = 1
  while ($ini(data/access/level.db,%x)) {
    if ($readison($2,$ini(data/access/level.db,%x)) == ison) {
      if ($axs.levels.name($readaccess($ini(data/access/level.db,%x),$2,level)) == Owner) {  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,levels,Owner)     : $+ $readaccess($ini(data/access/level.db,%x),$2,level) $+ : [12here $+ ] $ini(data/access/level.db,%x) }
      inc %x
    }
    else {
      if ($axs.levels.name($readaccess($ini(data/access/level.db,%x),$2,level)) == Owner) {  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,levels,Owner)     : $+ $readaccess($ini(data/access/level.db,%x),$2,level) $+ : $ini(data/access/level.db,%x) }
      inc %x
    }

  }
  var %x = 1
  while ($ini(data/access/level.db,%x)) {
    if ($readison($2,$ini(data/access/level.db,%x)) == ison) {
      if ($axs.levels.name($readaccess($ini(data/access/level.db,%x),$2,level)) == Co-Owner) {  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,levels,Co-Owner)  : $+ $readaccess($ini(data/access/level.db,%x),$2,level) $+ : [12here $+ ] $ini(data/access/level.db,%x) }    
      inc %x
    }
    else {
      if ($axs.levels.name($readaccess($ini(data/access/level.db,%x),$2,level)) == Co-Owner) {  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,levels,Co-Owner)  : $+ $readaccess($ini(data/access/level.db,%x),$2,level) $+ : $ini(data/access/level.db,%x) }    
      inc %x
    }
  }
  var %x = 1
  while ($ini(data/access/level.db,%x)) {
    if ($readison($2,$ini(data/access/level.db,%x)) == ison) {
      if ($axs.levels.name($readaccess($ini(data/access/level.db,%x),$2,level)) == Operator) {  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,levels,Operator)  : $+ $readaccess($ini(data/access/level.db,%x),$2,level) $+ : [12here $+ ] $ini(data/access/level.db,%x) }
      inc %x
    }
    else {
      if ($axs.levels.name($readaccess($ini(data/access/level.db,%x),$2,level)) == Operator) {  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,levels,Operator)  : $+ $readaccess($ini(data/access/level.db,%x),$2,level) $+ : $ini(data/access/level.db,%x) }
      inc %x
    }
  }
  var %x = 1
  while ($ini(data/access/level.db,%x)) {
    if ($readison($2,$ini(data/access/level.db,%x)) == ison) {
      if ($axs.levels.name($readaccess($ini(data/access/level.db,%x),$2,level)) == Friend) {  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,levels,Friend)    : $+ $readaccess($ini(data/access/level.db,%x),$2,level) $+ : [12here $+ ] $ini(data/access/level.db,%x) }
      inc %x
    }
    else {
      if ($axs.levels.name($readaccess($ini(data/access/level.db,%x),$2,level)) == Friend) {  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,levels,Friend)    : $+ $readaccess($ini(data/access/level.db,%x),$2,level) $+ : $ini(data/access/level.db,%x) }
      inc %x
    }
  }
  var %x = 1
  while ($ini(data/access/level.db,%x)) {
    if ($axs.levels.name($readaccess($ini(data/access/level.db,%x),$2,level)) == Lamer) {  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,levels,Lamer)     : $+ $readaccess($ini(data/access/level.db,%x),$2,level) $+ : $ini(data/access/level.db,%x) }   
    inc %x
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,enduserlist)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
}

alias system.chaninfo {
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel name required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readchan($2,channel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel $2 is not registered
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color For help regarding registration /msg $netconf(system,nickname) HELP CHANREG
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readchan($2,suspended)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 is currently suspended by admin, 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Reason: $readchan($2,suspended)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  ;display channel info
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Viewing 12 $+ $2 $+  information
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Registrar    : $readchan($2,owner)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Last Visited : $asctime($readchan($2,lastvisit))  $+ $duration($calc($ctime - $readchan($2,lastvisit)))
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Date Created : $asctime($readchan($2,datereg))
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel URL  : $readchan($2,url)
  var %x = 1
  var %owners = 0
  while ($ini(data/access/level.db,%x)) {
    if ($axs.levels.name($readaccess($ini(data/access/level.db,%x),$2,level)) == Owner) { inc %owners }
    inc %x
  }
  var %x = 1
  var %coowners = 0
  while ($ini(data/access/level.db,%x)) {
    if ($axs.levels.name($readaccess($ini(data/access/level.db,%x),$2,level)) == Co-Owner) { inc %coowners }
    inc %x
  }
  var %x = 1
  var %ops = 0
  while ($ini(data/access/level.db,%x)) {
    if ($axs.levels.name($readaccess($ini(data/access/level.db,%x),$2,level)) == Operator) { inc %ops }
    inc %x
  }
  var %x = 1
  var %friends = 0
  while ($ini(data/access/level.db,%x)) {
    if ($axs.levels.name($readaccess($ini(data/access/level.db,%x),$2,level)) == Friend) { inc %friends }
    inc %x
  }
  var %x = 1
  var %lamers = 0
  while ($ini(data/access/level.db,%x)) {
    if ($axs.levels.name($readaccess($ini(data/access/level.db,%x),$2,level)) == Lamer) { inc %lamers }
    inc %x
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Owners       : %owners
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Co-Owners    : %coowners
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Operators    : %ops
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Friends      : %friends
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Lamers       : %lamers
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  halt
}
alias system.chanlogs {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel name required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readchan($2,channel)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Channel $2 is not registered
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color For help regarding registration /msg $netconf(system,nickname) HELP CHANREG
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readchan($2,suspended)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $2 is currently suspended by admin, 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Reason: $readchan($2,suspended)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readaccess($addy($1),$2,level)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  if ($readaccess($addy($1),$2,level) < $netconf(chanlevel,chanlogs)) && (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,4).
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  } 
  ;display log list
  if ($3 == delete) && ($4) {
    if ($exists(logs\ $+ $2 $+ _ $+ $4 $+ .log))  {
      remove logs\ $+ $2 $+ _ $+ $4 $+ .log
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,cll)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Removed log file logs\ $+ $2 $+ $4 $+ .log $+ 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      return
    }
    else {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,cll)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Cannot Find logs\ $+ $2 $+ $4 $+ .log $+ 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      return
    }
  }
  if ($3 == deleteall) { 
    var %delete 1
    var %inc 0
    while ($findfile(logs, $+ $2 $+ *,%delete)) {
      remove logs\ $+ $remove($findfile(logs, $+ $2 $+ _ $+ $4 $+ *,%delete),$mircdir $+ logs\)
      inc %inc
      inc %delete
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,cll)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Removed all logs for channel  $+ $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    return
  }
  if ($4) {
    var %x 1
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,cll)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,cllt)  $+ $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color There are  $+ $findfile(logs, $+ $2 $+ _ $+ $4 $+ *,0) $+  log files available
    while ($findfile(logs, $+ $2 $+ _ $+ $4 $+ *,%x)) {
      if ($file(logs\ $+ $remove($findfile(logs, $+ $2 $+ *,%x),$mircdir $+ logs\)).size > 1024) {
        var %fsize $calc($file(logs\ $+ $remove($findfile(logs, $+ $2 $+ *,%x),$mircdir $+ logs\)).size / 1024)
        var %fsizeD KB
      }
      else {
        var %fsize $file(logs\ $+ $remove($findfile(logs, $+ $2 $+ *,%x),$mircdir $+ logs\)).size
        var %fsizeD Bytes
      }
      if (%fsizeD ==  KB) && (%fsize > 1024) {
        var %fsize $calc($file(logs\ $+ $remove($findfile(logs, $+ $2 $+ *,%x),$mircdir $+ logs\)).size / 1024 / 1024)
        var %fsizeD MB
      }
      else {
        var %fsize %fsize
      }
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Filename: $remove($findfile(logs, $+ $2 $+ _ $+ $4 $+ *,%x),$mircdir $+ logs\) Date: $remove($findfile(logs, $+ $2 $+ _ $+ $4 $+ *,%x),$mircdir $+ logs\ $+ $2 $+ _,.log) Size: $left($round(%fsize),5) %fsizeD
      var %z $lines($findfile(logs, $+ $2 $+ _ $+ $4 $+ *,%x))
      var %p 0
      while ($read(logs\ $+ $remove($findfile(logs, $+ $2 $+ *,%x),$mircdir $+ logs\),%z) && (%p < $3)) {
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $read(logs\ $+ $remove($findfile(logs, $+ $2 $+ _ $+ $4 $+ *,%x),$mircdir $+ logs\),%z)
        inc %p
        dec %z
      }
      inc %x
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  }
  else {
    var %x 1
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,channel,cll)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,channel,cllt)  $+ $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color There are  $+ $findfile(logs, $+ $2 $+ *,0) $+  log files available
    while ($findfile(logs, $+ $2 $+ *,%x)) {
      if ($file(logs\ $+ $remove($findfile(logs, $+ $2 $+ *,%x),$mircdir $+ logs\)).size > 1024) {
        var %fsize $calc($file(logs\ $+ $remove($findfile(logs, $+ $2 $+ *,%x),$mircdir $+ logs\)).size / 1024)
        var %fsizeD KB
      }
      else {
        echo -a LOG: logs\ $+ $remove($findfile(logs, $+ $2 $+ *,%x),$mircdir $+ logs\)
        var %fsize = $file($findfile(logs, $+ $2 $+ *,%x)).size
        var %fsizeD = Bytes
      }
      if (%fsizeD ==  KB) && (%fsize > 1024) {
        var %fsize $calc($file(logs\ $+ $remove($findfile(logs, $+ $2 $+ *,%x),$mircdir $+ logs\)).size / 1024 / 1024)
        var %fsizeD MB
      }
      else {
        var %fsize = %fsize
      }
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Filename: $remove($findfile(logs, $+ $2 $+ *,%x),$mircdir $+ logs\) Date: $remove($findfile(logs, $+ $2 $+ *,%x),$mircdir $+ logs\ $+ $2 $+ _,.log) Size: $left($round(%fsize),5) %fsizeD
      var %z = $lines($findfile(logs, $+ $2 $+ *,%x))
      var %p = 0
      while ($read(logs\ $+ $remove($findfile(logs, $+ $2 $+ *,%x),$mircdir $+ logs\),%z) && (%p < $3)) {
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $read(logs\ $+ $remove($findfile(logs, $+ $2 $+ *,%x),$mircdir $+ logs\),%z)
        inc %p
        dec %z
      }
      inc %x
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  }
}
