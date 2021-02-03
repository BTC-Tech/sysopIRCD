; Copying or editing of any of the scripts included in this module is strictly prohibited, you may distribute the package
; in its entireity un edited in any form. Support can only be given to those who do not edit these files please do not ask
; if you plan to edit them yourself. Credits and links back to us must remain in the script we do not advertise using your
; network unless the .VERSION command is triggered. You must also agree when connecting the service to any IRC net
; that you have the correct permission to connect the service, you MUST NOT connect the service to Digi-Net and you
; connect the service at your own risk. For support see http://www.digi-net.org

alias system.nickreg {
  if ($netconf(system,nickreg) == off) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,nonickreg)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,nonickreg2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) && (!$3) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,missinginfo)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,emailandpass)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color /msg SysOp NICKREG password email-address
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readnick($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,nickname,1)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color  $+ $1 $+  $lang($1,errors,nickregtaken)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt 
  }
  if ($remove($read(data/nicknames.db, w, * $+ $3 $+ *),email=)) && ($netconf(system,uniqueemail) == on) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+ Email Address In Use
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry the email address  $+ $remove($read(data/nicknames.db, w, * $+ $3 $+ *),email=) $+  is already in use.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($len($1) > 15) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+ Error In Nickname
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry  $+ $1 $+  is too long nicknames must not be more than 15 characters
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color please type /nick NEWNICKNAME to select a new name.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt 
  }
  addnick $1 tac $rand(1,999999999999)
  addnick $1 aic $rand(1,999999999999)
  addnick $1 email $3
  addnick $1 password $encode($2,m)
  addnick $1 showemail off
  addnick $1 autoop on
  addnick $1 status locked
  addnick $1 operlevel 0
  addnick $1 protect off
  addnick $1 accessalert off
  addnick $1 protectaction warn
  addnick $1 lasthost $readclient($1,host)
  addnick $1 vhost $lower($1) $+ .users.digi-net.org
  addnick $1 notesystem on
  addnick $1 lang en
  addnick $1 lastlogin $ctime
  addnick $1 noexpire off
  addnick $1 notealert on
  addnick $1 nickmodes rwx
  if ($netconf(system,pmquota) < 1) { addnick $1 pmquota 15 }
  else { addnick $1 pmquota $netconf(system,pmquota) }
  writepending $1 tac $readnick($1,tac)
  if ($netconf(system,webportal) == on) {
    writeini data/web_pending.db $readnick($1,tac) user $lower($1)
    writeini data/web_pending.db $readnick($1,tac) reply Your SysOp account is now activated with email address $readnick($1,email) 
    writeini data/web_pending.db $readnick($1,tac) action web.TACtivate $readnick($1,tac) $lower($1)
    send_mail $1 newuser_web
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Almost Complete
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please check your inbox at 12 $+ $readnick($1,email)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    report Nickname registration in progress...
    web_pending
  }
  else {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+ NickReg Almost Complete
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color An e-mail has been sent to your inbox with a code to complete
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color this registration and start using your account.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    send_mail $1 newuser
    if ($netconf(system,loging) == on) { 
      writetolog system Sent registration email to $1
    }
  }
  halt
}
alias system.tac {
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+   $lang($1,errors,missinginfo)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,missingtac)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Example: /msg $netconf(system,nickname) TAC 123456
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($1,tac)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Not Required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,alreadyactive)  $+ $1
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($2 != $readnick($1,tac)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,badinfotitle)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,invalidemailcode)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Example: /msg $netconf(system,nickname) TAC 123456
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  delpending $1 tac
  if ($ini(data/pending.db,$1,0) < 1) { remini data/pending.db $1 }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color  $+ $lang($1,nickname,6)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,nickname,accountnowactive)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color For help on this service /msg $netconf(system,nickname) help or visit $netconf(system,helpchan)
  writeini data/nicknames.db $1 status active
  remini data/nicknames.db $1 tac
  writeini data/nicknames.db $1 lastlogin $ctime
  writeini data/id.db id $readclient($1,host) $1
  addnick $1 nickname $1
  report Account Activated TAC: from $+($1,!,$userhost($1)) 
  sockwrite -tn serv : $+ $netconf(nickname,nick) SVS2MODE $1 +r
  if ($netconf(system,loging) == on) { 
    writetolog system $1 activated there account with the correct TAC
  }
  halt
}
alias system.identify {
  if ($netconf(system,safemode) == on) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,safemodenologin)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,safemodenologin2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($addy($1)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+  $+ %color  $+  $lang($addy($1),nickname,3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($addy($1),nickname,4)  $+ $addy($1) $+ 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($addy($1),nickname,5)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($1,nickname)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+  $+ %color  $+  $lang($1,errors,noreglogin)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,noreglogin2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP REGISTER for help.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,missinginfo)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,nopassinc)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP IDENTIFY
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readnick($1,status) != active) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,acclock)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,acclock2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readnick($1,password) !== $encode($2,m)) {
    if (%acc.fail. [ $+ [ $1 ] ] == $null) { set -u10 %acc.fail. [ $+ [ $1 ] ] 1 }
    else { inc %acc.fail. [ $+ [ $1 ] ] }
    if (%acc.fail. [ $+ [ $1 ] ] > 2) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,acclock)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,failedlogin3)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,failedlogin)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      addnick $1 status locked
      report 3 Invalid Logins: from $+($1,!,$userhost($1)) 
      .timerunlock $+ $1 1 900 addnick $1 status Active
      if ($netconf(system,loging) == on) { 
        writetolog system 3 Invalid login attempts from $+($1,!,$userhost($1)) 
      }
      halt
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,wrongpass)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,wrongpass2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,wrongpass3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    if ($netconf(system,loging) == on) { 
      writetolog system Incorrect Login Password from $+($1,!,$userhost($1)) 
    }
    halt
  }
  addnick $1 lastlogin $ctime
  writeini data/id.db id $readclient($1,host) $1
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,nickname,logincomplete)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,nickname,logincomplete2)  $+ $1 $+ 
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Last login was from 12 $+ $readnick($1,lasthost) $+ 
  if ($ini(data/notes.db,$1,0) > 0) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You have  $+ $ini(data/notes.db,$1,0) $+  notes in your inbox. }
  if ($readnick($1,vhost)) && ($readnick($1,vhostactive) == yes) {
    sockwrite -tn serv $+(:,$netconf(server,server)) CHGHOST $1 $readnick($1,vhost)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Your vhost 12 $+ $readnick($1,vhost) $+  is now active.
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv : $+ $netconf(nickname,nick) SVS2MODE $1 $readnick($1,nickmodes)
  if ($readnick($1,operlevel) > 0) {
    ;ircop handling making /oper redundant
    if ($readini(data/blacklist.db,opers,$1)) {
      sockwrite -tn serv : $+ $netconf(nickname,nick) SVS2MODE $1 -oghaAN
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,ircops,bl)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,ircops,blnotice)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      if ($netconf(system,loging) == on) { 
        writetolog system $1 was restricted oper access due to blacklist
      }
    } 
    else {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,ircops,operup)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,ircops,operupnotice) IRC operator
      if ($netconf(system,loging) == on) { 
        writetolog system $1 is now logged in as an IRC operator
      }
      if ($ini(data/pending.db,0) > 0) {
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,ircops,pending)
      }
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv : $+ $netconf(nickname,nick) SVSJOIN $1 $netconf(system,helpchan)
      sockwrite -tn serv : $+ $netconf(nickname,nick) SVSJOIN $1 $netconf(system,report)
      addadmin $1 nickname $1
      addadmin $1 status active
      addadmin $1 when $ctime
      addadmin $1 rank IRC Operator $readnick($1,operlevel)
      if ($readnick($1,vhost)) { sockwrite -tn serv $+(:,$netconf(server,server)) CHGHOST $1 $readnick($1,vhost) }
      else { sockwrite -tn serv $+(:,$netconf(server,server)) CHGHOST $1 $lower($1 $+ .staff.digi-net.org) }
      var %x = 1    
      while ($ini(data/news.db,oper,%x)) {
        sysnotice2 $1 Oper News * $+ $ini(data/news.db,oper,%x) $+ * $readini(data/news.db,oper,$ini(data/news.db,oper,%x))
        inc %x
      }
    }
  }
  sockwrite -tn serv $+(:,$netconf(server,server)) CHGHOST $1 $readnick($1,vhost)
  if ($readnick($1,operlevel) > 0) && (!$readini(data/blacklist.db,opers,$1)) {
    report LOGIN: From $+($1,!,$userhost($1)) successful, Level  $+ $readnick($1,operlevel) $+  operator access granted.

  }
  else {
    report LOGIN: From $+($1,!,$userhost($1)) successful
  }
  if ($readnick($1,nickname)) && ($readnick($1,protect) == on) {
    if ($readnick($1,protectaction) == renick) { 
      timer $+ $1 $+ renick off
    }
  }
  var %x = 1    
  while ($ini(data/news.db,logon,%x)) {
    sysnotice2 $1 Logon News * $+ $ini(data/news.db,logon,%x) $+ * $readini(data/news.db,logon,$ini(data/news.db,logon,%x))
    inc %x
  }
  var %x 1
  while ($ini(data/channels.db,%x)) {
    if ($readuserautojoin($1,$ini(data/channels.db,%x)) == on) { 
      .sockwrite -tn serv $+(:,$netconf(system,nickname)) SVSJOIN $1 $ini(data/channels.db,%x)
    }
    inc %x
  }
  halt
}
alias system.password {
  if ($netconf(system,safemode) == on) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,safemodenologin)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,safemodenologin2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($1,nickname)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,noreglogin)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,noreglogin2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP REGISTER for help.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readnick($1,status) != active) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,acclock)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,acclock2).
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) || (!$3) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+   $lang($1,errors,missinginfo)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,passreq)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP PASSWORD
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$addy($1)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Please Login First
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY as  $+ $1 $+  first.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+ /msg SysOp HELP IDENTIFY
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readnick($1,password) !== $encode($2,m)) {
    if (%acc.fail. [ $+ [ $1 ] ] == $null) { set -u10 %acc.fail. [ $+ [ $1 ] ] 1 }
    else { inc %acc.fail. [ $+ [ $1 ] ] }
    if (%acc.fail. [ $+ [ $1 ] ] > 2) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,acclock)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,failedlogin3)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,failedlogin)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      addnick $1 status locked
      report 3 Invalid Logins: from $+($1,!,$userhost($1)) 
      .timerunlock $+ $1 1 900 addnick $1 status Active
      if ($netconf(system,loging) == on) { 
        writetolog system 3 Invalid login attempts from $+($1,!,$userhost($1)) 
      }
      halt
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,wrongpass)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,wrongpass2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,wrongpass3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  addnick $1 password $encode($3,m)
  addnick $1 lasthost $readclient($1,host)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,nickname,accnewpass)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,nickname,newpassnow) 12 $+ $decode($readnick($1,password),m)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  report PASSWORD: Change from $+($1,!,$userhost($1)) successful
  halt
}
alias system.forgotpass {
  if ($netconf(system,safemode) == on) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,safemodenologin)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,safemodenologin2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) || (!$3) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+   $lang($1,errors,missinginfo)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,missinnande)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP FORGOTPASS
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($2,nickname)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,noreglogin)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,noreglogin21)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP REGISTER for help.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readnick($2,status) != active) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,acclock)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,acclock2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readnick($2,email) != $3) {
    if (%acc.fail. [ $+ [ $2 ] ] == $null) { set -u10 %acc.fail. [ $+ [ $2 ] ] 1 }
    else { inc %acc.fail. [ $+ [ $2 ] ] }
    if (%acc.fail. [ $+ [ $1 ] ] > 2) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,acclock)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,failedlogin3)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,failedlogin)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      addnick $2 status locked
      report 3 Invalid Password Requests: from $+($1,!,$userhost($1)) 
      .timerunlock $+ $2 1 900 addnick $2 status Active
      if ($netconf(system,loging) == on) { 
        writetolog system 3 Invalid login attempts from $+($1,!,$userhost($1)) 
      }
      halt
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,invalidemail)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,invemail)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,passsent)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,passsent2) 12 $+ $readnick($2,email)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  report FORGOTPASS: Request from $+($1,!,$userhost($1)) successful
  send_mail $2 forgotpass
  halt
}
alias system.editemail {
  if ($netconf(system,safemode) == on) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,safemodenologin)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,safemodenologin2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($1,nickname)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,noreglogin)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,noreglogin21)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP REGISTER for help.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readnick($1,status) != active) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,acclock)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,acclock2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) || (!$3) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+   $lang($1,errors,missinginfo)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,pandereq)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP EDITEMAIL
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$addy($1)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Please Login First
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY as  $+ $1 $+  first.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+ /msg SysOp HELP IDENTIFY
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readnick($1,password) !== $encode($2,m)) {
    if (%acc.fail. [ $+ [ $1 ] ] == $null) { set -u10 %acc.fail. [ $+ [ $1 ] ] 1 }
    else { inc %acc.fail. [ $+ [ $1 ] ] }
    if (%acc.fail. [ $+ [ $1 ] ] > 2) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,acclock)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,failedlogin3)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,failedlogin)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      addnick $1 status locked
      report 3 Invalid Logins: from $+($1,!,$userhost($1)) 
      .timerunlock $+ $1 1 900 addnick $1 status Active
      if ($netconf(system,loging) == on) { 
        writetolog system 3 Invalid login attempts from $+($1,!,$userhost($1)) 
      }
      halt
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Password Failure
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry that is not the old password
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Passwords are CaSe SenSiTiVe.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$4) && ($3 != verify) {
    addnick $1 tac $rand(1,999999999999)
    addnick $1 newemail $lower($3)
    addnick $1 lasthost $readclient($1,host)
    if ($netconf(system,webportal) == on) {
      writeini data/web_pending.db $readnick($1,tac) user $lower($1)
      writeini data/web_pending.db $readnick($1,tac) action web.editemail $readnick($1,tac) $lower($1) $lower($3)
      writeini data/web_pending.db $readnick($1,tac) reply Your new email address is now $readnick($1,newemail)
      writeini data/web_pending.db $readnick($1,tac) newmail $readnick($1,newemail)
      send_newmail $1 newemail_web
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Almost Complete
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please check your inbox at 12 $+ $readnick($1,newemail)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      report Email change from $+($1,!,$userhost($1)) in progress
      web_pending
    }
    else {
      send_newmail $1 newemail
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Almost Complete
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please check your inbox at 12 $+ $readnick($1,newemail)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      report Email change from $+($1,!,$userhost($1)) in progress
    }

    if ($netconf(system,loging) == on) { 
      writetolog system Sent email change verification for $1 -  $readnick($1,newemail)
    }
    halt
  }
  if ($3 == verify) && ($4) {
    if ($readnick($1,tac) != $4) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Code Failure
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry that is not the correct email verification code
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    addnick $1 email $readnick($1,newemail)
    remini data/nicknames.db $1 newemail
    remini data/nicknames.db $1 tac
    addnick $1 tac 0
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Email Change Complete
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Your New Email Address Is 12 $+ $readnick($1,email) $+ 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    unset %newmail*
    if ($netconf(system,webportal) == on) {
      .do_web
    }
    halt
  }
}

alias system.myaccount {
  if ($2) && ($readadmin($1,nickname) == $1) { var %nick = $2 }
  else { var %nick = $1 }
  if (!$readnick(%nick,nickname)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Cannot Find Account
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry nickname  $+ %nick $+  is not registered.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP REGISTER for help.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$addy($1)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Please Login First
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please use IDENTIFY to login first
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color See /msg SysOp HELP NICKREG
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($hasaccess(account,$1) != true) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry, you do not have the correct access for this function.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  ;display data etc etc
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Personal Account Inforation
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Nickname      : %nick
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Email Address : $readnick(%nick,email)
  if ($readnick(%nick,status) != active) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Status        : 4 $+ $readnick(%nick,status) }
  else { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Status        : 3 $+ $readnick(%nick,status) }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Show Email    : $readnick(%nick,showemail)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Auto Op       : $readnick(%nick,autoop)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Language      : $lang(%nick,language,name)  $+ $readnick(%nick,lang)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color NoExpire      : $readnick(%nick,noexpire)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color NickModes     : $readnick(%nick,nickmodes)
  if ($readnick(%nick,noexpire) != on) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Account will expire if not logged into within  $+ $netconf(system,nickexpire)
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Protect       : $readnick(%nick,protect)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Protect Action: $readnick(%nick,protectaction)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Note System   : $readnick(%nick,notesystem)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Note Alert    : $readnick(%nick,notealert)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Note Quota    : $readnick(%nick,pmquota) -  $+ $calc(100 - $calc($ini(data/notes.db,%nick,0) * 100 / $readnick(%nick,pmquota))) $+ % $+  free
  if ($readnick(%nick,noteabuse)) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Note Access   : $readnick(%nick,noteabuse) }
  else { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Note Access   : Full Access Granted }
  if ($readnick(%nick,accessalert) == on) { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Access Alert  : Reciving notes when added to a channel }
  else { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Access Alert  : Not recieving notes when added to a channel }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color VHost         : $readnick(%nick,vhost)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Last Connection Information
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Host          : $readnick(%nick,lasthost)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Last Here     : $asctime($readnick(%nick,lastlogin))
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  IRCop access information
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Level                  : $readnick(%nick,operlevel)
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Channels With Access:
  var %x = 1
  while ($ini(data/channels.db,%x)) {
    if ($readaccess(%nick,$ini(data/channels.db,%x),level)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color  $+ [ $+ $axs.levels.name($readaccess(%nick,$ini(data/channels.db,%x),level)) $+ ] 12 $+ $ini(data/channels.db,%x)   
    }
    inc %x   
  }
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  End Of Account Information
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  halt
}
alias system.setaccount {
  if ($netconf(system,safemode) == on) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Cannot Complete
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry services are in safe mode and we cannot
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Continue your password change at this time.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($1,nickname)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Please Register First
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry your nickname  $+ $1 $+  is not registered.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP REGISTER for help.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readnick($1,status) != active) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,acclock)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry for some reason your account is locked. Perhaps you havent activated yet.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please contact an IRCop in #Help.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) || (!$3) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+   $lang($1,errors,missinginfo)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color option and value are both required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP ASET
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$addy($1)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Please Login First
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY as  $+ $1 $+  first.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+ /msg SysOp HELP IDENTIFY
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($2 == lang) {
    if (!$3) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You must spepcify a language extension default would be en
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if (!$exists(lang/lang_ $+ $3 $+ .db)) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You must spepcify a language extension default would be en
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    addnick $1 lang $lower($3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Option Set
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Your Default Language is now $lang($1,language,name)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sql_writeaccount $1
    halt
  }
  if ($2 == autoop) { 
    if ($3 != on) && ($3 != off) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Invalid ASET value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values for AutoOp are on/off
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP ASET
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    addnick $1 autoop $lower($3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Account Setting Changed
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color AutoOp is now  $+ $readnick($1,autoop) $+  for $1
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sql_writeaccount $1 
    return
  }
  if ($2 == notealerts) { 
    if ($3 != on) && ($3 != off) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Invalid ASET value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values for NoteAlerts are on/off
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP ASET
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    addnick $1 notealert $lower($3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Account Setting Changed
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color NoteAlerts is now  $+ $readnick($1,notealert) $+  for $1
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sql_writeaccount $1
    return
  }
  if ($2 == accessalerts) { 
    if ($3 != on) && ($3 != off) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Invalid ASET value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values for AccessAlerts are on/off
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP ASET
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    addnick $1 accessalert $lower($3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Account Setting Changed
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color AccessAlerts are now  $+ $readnick($1,accessalert) $+  for $1
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sql_writeaccount $1
    return
  }
  if ($2 == notes) { 
    if ($3 != on) && ($3 != off) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Invalid ASET value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values for Notes are on/off
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP ASET
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    addnick $1 notesystem $lower($3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Account Setting Changed
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Notes are now  $+ $readnick($1,notesystem) $+  for $1
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sql_writeaccount $1
    return
  }
  if ($2 == showemail) { 
    if ($3 != on) && ($3 != off) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Invalid ASET value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values for ShowEmail are on/off
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP ASET
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    addnick $1 showemail $lower($3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Account Setting Changed
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color ShowEmail is now  $+ $readnick($1,showemail) $+  for $1
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sql_writeaccount $1
    return
  }
  if ($2 == protect) { 
    if ($3 != on) && ($3 != off) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Invalid ASET value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values for Protect are on/off
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP ASET
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    addnick $1 protect $lower($3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Account Setting Changed
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Protect is now  $+ $readnick($1,protect) $+  for $1
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    if ($3 == on) && ($readnick($1,protectaction) == off) { addnick $1 protectaction warn }
    sql_writeaccount $1
    return
  }
  if ($2 == vhost) {
    if (!$3) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Invalid ASET value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please enter a valid vhost
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP ASET
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    %x = 1
    while ($gettok(%bwords,%x,44)) {
      if ($gettok(%bwords,%x,44) isin $3-) {
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Bad Words Filtered
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Your vhost is too rude to display
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
        report Badwords filtered in  $+ $1 $+ 's $2 INFO
        if ($netconf(system,loging) == on) { 
          writetolog system XSET Filtered a bad word vhost for $1
        }
        halt
      }
      inc %x
    }
    addnick $1 newvhost $lower($3)
    addnick $1 vhostactive no
    writepending $1 vhost $readnick($1,newvhost)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Account Setting Changed
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Your new vhost  $+ $readnick($1,newvhost) $+  for $1
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color is now marked pending approval from admin.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sql_writeaccount $1
    halt
  }
  if ($2 == action) {
    if ($3 != off) && ($3 != warn) && ($3 != renick) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Invalid ASET value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values for Action are off/warn/renick
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP ASET
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    addnick $1 protectaction $lower($3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Account Setting Changed
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Protect Action is now  $+ $readnick($1,protectaction) $+  for $1
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sql_writeaccount $1
    if ($3 == off) { addnick $1 protect off }
    if ($3 == warn) && ($readnick($1,protect) == off) { addnick $1 protect on }
    if ($3 == renick) && ($readnick($1,protect) == off) { addnick $1 protect on }
    return
  }
  else {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Invalid ASET option
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please choose a valid option for ASET
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP ASET
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($netconf(system,webportal) == on) {
    .do_web
  }
}

alias system.opersetaccount {
  if ($netconf(system,safemode) == on) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Cannot Complete
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry services are in safe mode and we cannot
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Continue your password change at this time.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$addy($1)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Please Login First
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please IDENTIFY as  $+ $1 $+  first.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+ /msg SysOp HELP IDENTIFY
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readadmin($1,nickname)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,nickname,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You Are Not An IRC Operator
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    if ($netconf(system,loging) == on) { 
      writetolog system $1 attempted to use IRCop command OPERASET and is not an IRCop
    }
    halt
  }
  if ($hasaccess(operaset,$1) != true) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry, you do not have the correct access for this function.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) || (!$3) || (!$4) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+   $lang($1,errors,missinginfo)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color nickname, option and value are sll required
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP OPERASET
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($2,nickname)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Cannot Find Account
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry the nickname  $+ $2 $+  is not registered.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($3 == lang) {
    if (!$4) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You must spepcify a language extension default would be en
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if (!$exists(lang/lang_ $+ $4 $+ .db)) { 
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Incorrect Value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You must spepcify a language extension default would be en
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    addnick $2 lang $lower($4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Account Setting Changed
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Default Language is now $lang($2,language,name) for $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    report OPERASET: Account setting Lang changed for  $+ $2 $+  by  $+ $1 $+ .
    halt
  }
  if ($3 == notealerts) { 
    if ($4 != on) && ($4 != off) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Invalid ASET value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values for NoteAlerts are on/off
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP OPERASET
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    addnick $2 notealert $lower($4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Account Setting Changed
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color NoteAlerts is now  $+ $readnick($2,notealert) $+  for $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    return
  }
  if ($3 == notes) { 
    if ($4 != on) && ($4 != off) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Invalid ASET value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values for Notes are on/off
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP OPERASET
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if ($4 == off) { 
      addnick $2 noteabuse Suspended By $1 
    }
    if ($4 == on) { 
      delnick $2 noteabuse
    }
    addnick $2 notesystem $lower($4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Account Setting Changed
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Notes are now  $+ $readnick($2,notesystem) $+  for $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    report OPERASET: Account setting Notes changed for  $+ $2 $+  by  $+ $1 $+ .
    return
  }
  if ($3 == pmquota) { 
    if (!$4) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Invalid ASET value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You must enter a valid number for pmquota
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP OPERASET
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    addnick $2 pmquota $lower($4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Account Setting Changed
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color PmQuota is now  $+ $readnick($2,pmquota) $+  for $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    report OPERASET: Account setting PmQuota changed for  $+ $2 $+  by  $+ $1 $+ .
    return
  }
  if ($3 == autoop) { 
    if ($4 != on) && ($4 != off) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Invalid ASET value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values for AutoOp are on/off
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP OPERASET
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    addnick $2 autoop $lower($4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Account Setting Changed
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color AutoOp is now  $+ $readnick($2,autoop) $+  for $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    report OPERASET: Account setting AutoOp changed for  $+ $2 $+  by  $+ $1 $+ .
    return
  }
  if ($3 == noexpire) { 
    if ($4 != on) && ($4 != off) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Invalid ASET value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values for NoExpire are on/off
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP OPERASET
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    addnick $2 noexpire $lower($4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Account Setting Changed
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color NoExpire is now  $+ $readnick($2,autoop) $+  for $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    report OPERASET: Account setting NoExpire changed for  $+ $2 $+  by  $+ $1 $+ .
    return
  }
  if ($3 == accessalerts) { 
    if ($4 != on) && ($4 != off) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Invalid ASET value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values for AccessAlerts are on/off
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP OPERASET
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    addnick $2 accessalert $lower($4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Account Setting Changed
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color AccessAlerts are now  $+ $readnick($2,autoop) $+  for $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    report OPERASET: Account setting AccessAlerts changed for  $+ $2 $+  by  $+ $1 $+ .
    return
  }
  if ($3 == showemail) { 
    if ($4 != on) && ($4 != off) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Invalid ASET value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values for ShowEmail are on/off
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP OPERASET
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    addnick $2 showemail $lower($4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Account Setting Changed
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color ShowEmail is now  $+ $readnick($2,showemail) $+  for $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    report OPERASET: Account setting ShowEmail changed for  $+ $2 $+  by  $+ $1 $+ .
    return
  }
  if ($3 == protect) { 
    if ($4 != on) && ($4 != off) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Invalid ASET value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values for Protect are on/off
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP OPERASET
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    addnick $2 protect $lower($4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Account Setting Changed
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Protect is now  $+ $readnick($2,protect) $+  for $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    report OPERASET: Account setting Protect changed for  $+ $2 $+  by  $+ $1 $+ .
    if ($3 == on) && ($readnick($1,protectaction) == off) { addnick $1 protectaction warn }
    return
  }
  if ($3 == action) {
    if ($4 != off) && ($4 != warn) && ($4 != renick) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Invalid ASET value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values for Action are off/warn/renick
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP OPERASET
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    addnick $2 protectaction $lower($4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Account Setting Changed
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Protect Action is now  $+ $readnick($2,protectaction) $+  for $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    report OPERASET: Account setting Protect Action changed for  $+ $2 $+  by  $+ $1 $+ .
    if ($4 == off) { addnick $2 protect off }
    if ($4 == warn) && ($readnick($2,protect) == off) { addnick $2 protect on }
    if ($4 == renick) && ($readnick($2,protect) == off) { addnick $2 protect on }
    return
  }
  if ($3 == status) {
    if ($4 != locked) && ($4 != active) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Invalid ASET value
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Valid values for Action are active/locked
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP OPERASET
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    addnick $2 status $lower($4)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Account Setting Changed
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Status is now  $+ $readnick($2,status) $+  for $2
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    report OPERASET: Account setting Status changed for  $+ $2 $+  by  $+ $1 $+ .
    return
  }
  else {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Invalid OPERASET option
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please choose a valid option for OPERASET
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP OPERASET
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
}
alias system.nickdrop {
  if ($netconf(system,safemode) == on) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Cannot Continue
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry services are in safe mode and we cannot
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Continue any registration commands just now.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$addy($1)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+  $+ %color  $+  $lang($1,nickname,2)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,nickname,3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($hasaccess(nickdrop,$1) != true) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Access Denied
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry, you do not have the correct access for this function.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$readnick($1,nickname)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+  $+ %color  $+  Cannot Complete Login
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry your nickname  $+ $1 $+  is not registered.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Thats Ok, you can register a nickname in a few seconds
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP REGISTER for help.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Cannot Complete This
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please enter a password to continue.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Type /msg SysOp HELP NICKDROP
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readnick($1,status) != active) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,acclock)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry for some reason your account is locked. Perhaps you havent activated yet.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Please contact an IRCop in #Help.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readnick($1,password) !== $encode($2,m)) {
    if (%acc.fail. [ $+ [ $1 ] ] == $null) { set -u10 %acc.fail. [ $+ [ $1 ] ] 1 }
    else { inc %acc.fail. [ $+ [ $1 ] ] }
    if (%acc.fail. [ $+ [ $1 ] ] > 2) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,acclock)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You've failed to enter the correct password 3 times. Your account is now locked
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Try FORGOTPASS after your account is unlocked
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      addnick $1 status locked
      report 3 Invalid Logins: from $+($1,!,$userhost($1)) 
      .timerunlock $+ $1 1 900 addnick $1 status Active
      if ($netconf(system,loging) == on) { 
        writetolog system $1 3 invalid password attempts, account locked
      }
      halt
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Password Failure
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry that is not the correct password
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Passwords are CaSe SenSiTiVe.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  ;remove nickname initiate
  var %chans = 0
  var %x = 1
  while ($ini(data/channels.db,%x)) {
    if ($readaccess($1,$ini(data/channels.db,%x),level)) && ($readchan($ini(data/channels.db,%x),owner) == $1) {
      inc %chans
    }
    inc %x
  }
  if (%chans > 0) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Cannot Continue
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color  $+ %chans $+  of your channels need a new founder
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color See /msg $netconf(system,nickname) HELP SET for more help
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  ;remove nickname
  remini data/access/autoop.db $1
  remini data/access/autojoin.db $1
  remini data/access/autovoice.db $1
  remini data/access/infolines.db $1
  remini data/access/level.db $1
  remini data/notes.db $1
  remini data/pending.db $1
  wipenick $1
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Account Removed
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Your nickname, all its settings and access to any channels have been removed!
  sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  halt
}
