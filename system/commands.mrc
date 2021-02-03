; Copying or editing of any of the scripts included in this module is strictly prohibited, you may distribute the package
; in its entireity un edited in any form. Support can only be given to those who do not edit these files please do not ask
; if you plan to edit them yourself. Credits and links back to us must remain in the script we do not advertise using your
; network unless the .VERSION command is triggered. You must also agree when connecting the service to any IRC net
; that you have the correct permission to connect the service, you MUST NOT connect the service to Digi-Net and you
; connect the service at your own risk. For support see http://www.digi-net.org

alias data_in {
  data $1-
  if ($mid($4,2,1) == $chr(1)) && ($2 != notice) && ($4 != :ACTION) { A_CTCP $mid($1,2,$len($1))  $3 $4- | Return }
  if ($1 == PING) { .sockwrite -tn serv : $+ $sserver PONG $2 }

  ;commands from DB
  if ($2 == privmsg) && ($3 == $netconf(system,nickname) || $3 == $netconf(system,nickname) $+ @ $+ $netconf(system,servicehost) ) {
    var %a 1
    while ($ini(data\aliases.db,%a)) {
      if ($remove($4,:) == $ini(data\aliases.db,%a)) {
        if ($readini(data\aliases.db, $+ $ini(data\aliases.db,%a),chan) == 1) && ($readchan($3,channel)) {
          $readini(data\aliases.db, $+ $ini(data\aliases.db,%a),command) $remove($1,:) $3 $5- $readini(data\aliases.db, $+ $ini(data\aliases.db,%a),arg)
        }
        else {
          $readini(data\aliases.db, $+ $ini(data\aliases.db,%a),command) $remove($1,:) $5- $readini(data\aliases.db, $+ $ini(data\aliases.db,%a),arg) 
        }
        return
      }
      inc %a
    }
  }

  if ($2 == privmsg) && ($4 == :help) && ($3 == $netconf(system,nickname)) { system.help $remove($1,:) $5- | return }
  elseif ($2 == privmsg) && ($3 == $netconf(system,nickname)) { 
    sysnotice $remove($1,:) -
    sysnotice $remove($1,:)  %color $+  $lang($remove($1,:),errors,nocommandTitle)
    sysnotice $remove($1,:) %color $lang($remove($1,:),errors,nocommand)
    sysnotice $remove($1,:)  %color $+  $lang($remove($1,:),errors,nocommandFooter)
    sysnotice $remove($1,:) -
    return
  }

  ; Public Commands
  set -u10 %cmd $right($4,-1)
  ;commands from DB
  if ($2 == privmsg) {
    var %a 1
    while ($ini(data\aliases.db,%a)) {
      if (%cmd == $iif($readchan($3,char),$ifmatch,.) $+ $ini(data\aliases.db,%a)) {
        if ($readini(data\aliases.db, $+ $ini(data\aliases.db,%a),chan) == 1) && ($readchan($3,channel)) && ($readini(data\aliases.db, $+ $ini(data\aliases.db,%a),private) != 1) {
          $readini(data\aliases.db, $+ $ini(data\aliases.db,%a),command) $remove($1,:) $3 $5- $readini(data\aliases.db, $+ $ini(data\aliases.db,%a),arg)
        }
        else {
          if ($readini(data\aliases.db, $+ $ini(data\aliases.db,%a),private) != 1) {
            $readini(data\aliases.db, $+ $ini(data\aliases.db,%a),command) $remove($1,:) $5- $readini(data\aliases.db, $+ $ini(data\aliases.db,%a),arg) 
          }
          else {
            sysnotice $remove($1,:) -
            sysnotice $remove($1,:)  %color $+  Command Not Correct
            sysnotice $remove($1,:) %color This command is a private command and requires the /msg Prefix
            sysnotice $remove($1,:)  %color $+  /msg $netconf(system,nickname) $ini(data\aliases.db,%a)
            sysnotice $remove($1,:) -
          }
        }
        return
      }
      inc %a
    }
  }
  ; General Procedures
  ;spam filter
  if ($2 == PRIVMSG) {
    if (http isin $remove($4-,:)) && ($readchan($3,spamfilter) == on) {
      if ($readaccess($remove($1,:),$3,level) < $netconf(chanlevel,spamlevel)) || (!$readaccess($remove($1,:),$3,level)) && (!$readadmin($remove($1,:),nickname)) {
        sockwrite -tn serv $+(:,$netconf(system,nickname)) KICK $3 $remove($1,:) $lang($3,channel,nospamkick)
        if ($readchan($3,loging) == on) { 
          writetolog $3 $remove($1,:) $lang($3,channel,nospamlog)
        }
      }
    }
  }
  ;CAPS filter
  if ($2 == PRIVMSG) && ($readchan($3,capkick) > 0) && (%startup == $null) {
    if ($readaccess($addy($remove($1,:)),$3,level) >= $netconf(chanlevel,spamlevel)) || ($readadmin($remove($1,:),nickname)) { return }
    var %caps = $len($strip($remove($4-,:)))
    %caps = %caps - $len($removecs($strip($remove($4-,:)),Q,W,E,R,T,Y,U,I,O,P,A,S,D,F,G,H,J,K,L,Z,X,C,V,B,N,M,$chr(32)))
    if ($round($calc((%caps / $len($remove($4-,:))) * 100),2) >= $readchan($3,capkick)) && (%caps > 5) {
      sockwrite -tn serv : $+ $netconf(system,nickname) KICK $3 $remove($1,:) :Excessive Caps - %caps $+ / $+ $len($remove($4-,:)) ( $+ $round($calc((%caps / $len($remove($4-,:))) * 100),2)) $+ % $+ )
      if ($readchan($3,loging) == on) { 
        writetolog $3 $remove($1,:) $lang($2,channel,capkicklog)
      }
    }
  }

  ;bantimeout
  if ($2 == MODE) && ($4 == +b)  && (%startup == $null) {
    addchanban $3 $5 $ctime
    if ($readchan($3,bantimeout) == 1) { //timerban $+ $3 $+ $ctime 1 900 /removeban $3 $5 }
    if ($readchan($3,bantimeout) == 2) { //timerban $+ $3 $+ $ctime 1 3600 /removeban $3 $5 }
    if ($readchan($3,bantimeout) == 3) { //timerban $+ $3 $+ $ctime 1 10800 /removeban $3 $5 }
  }
  ;chanban database
  if ($2 == MODE) && ($4 == -b)  && (%startup == $null) {
    delchanban $3 $5
  }
  ;swearkick
  if ($2 == PRIVMSG) && ($readchan($3,badlang) == on) && (%startup == $null) {
    var %x = 1
    while $gettok(%bwords,%x,44) {
      if ($gettok(%bwords,%x,44) isin $remove($4-,:)) && ($readaccess($addy($remove($1,:)),$2,level) < $netconf(chanlevel,swearkicker)) {
        .sockwrite -tn serv $+(:,$netconf(system,nickname)) KICK $3 $remove($1,:) No Swearing In $3 please.
        if ($readchan($3,loging) == on) { 
          writetolog $3 $remove($1,:) $lang($3,channel,swearkicklog) $+ , $gettok(%bwords,%x,44)
        }
      }
      inc %x
    }
  }
  if ($2 == NICK) {
    var %x 1
    while ($ini(data/glines.db,%x)) {
      if (* $+ $readnetban($ini(data/glines.db,%x),address) $+ * iswm $3) && ($readnetban($ini(data/glines.db,%x),type) == NICKBAN) {
        ;echo -a $ini(data/glines.db,%x) - $readnetban($ini(data/glines.db,%x),address)
        sockwrite -tn serv $+(:,$netconf(system,nickname)) KILL $3 $readnetban($ini(data/glines.db,%x),reason)
        report NICKBAN: $3 triggered an auto kill NickBan - $readnetban($ini(data/glines.db,%x),reason)
        writetolog system $3 triggered a nickban autokill - $readnetban($ini(data/glines.db,%x),reason)
        halt
      }
      inc %x 
    }
    addseen seen $3 $ctime
    addseen seen $remove($1,:) $ctime
    swapclient $remove($1,:) $3
    swapsqlclient $remove($1,:) $3
    var %x = 1
    while ($ini(data/activechans.db,%x)) {
      if ($readini(data/activechans.db,$ini(data/activechans.db,%x),$remove($1,:))) { remini data/activechans.db $ini(data/activechans.db,%x) $remove($1,:) | writeini data/activechans.db $ini(data/activechans.db,%x) $3 ison }
      inc %x
    }
    if ($readadmin($remove($1,:),nickname)) {
      addadmin $3 nickname $3
      addadmin $3 status active
      addadmin $3 when $ctime
      addadmin $3 rank $readadmin($remove($1,:),rank)
      wipeadmin $remove($1,:)
    }
    if ($readnick($3,nickname)) && ($readnick($3,protect) == on) && (!$addy($3)) {
      if ($readnick($3,protectaction) == warn) { 
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 :-
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color $+  $lang($3,nickname,6)
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color $lang($3,nickname,7)  $+ $3 $+  $lang($3,nickname,8)
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color $lang($3,nickname,9)
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color $+  $lang($3,nickname,10)
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 :-
      }
      if ($readnick($3,protectaction) == renick) { 
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 :-
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color $+  $lang($3,nickname,6)
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color $lang($3,nickname,7)  $+ $3 $+  $lang($3,nickname,8)
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color $lang($3,nickname,9)
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color $+  $lang($3,nickname,10)
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 :-
        timer $+ $3 $+ renick 1 60 /sockwrite -tn serv :SysOp SVSNICK $3 Guest $+ $rand(1,99)  $ctime
      }
    }

  }
  if ($1 == NICK) {
    var %x 1
    while ($ini(data/glines.db,%x)) {
      if (* $+ $readnetban($ini(data/glines.db,%x),address) $+ * iswm $+(*@,$6)) && ($readnetban($ini(data/glines.db,%x),type) == AKILL) {
        ;echo -a $ini(data/glines.db,%x) - $readnetban($ini(data/glines.db,%x),address)
        sockwrite -tn serv $+(:,$netconf(server,server)) KILL $2 $readnetban($ini(data/glines.db,%x),reason)
        report AKILL: $2 triggered an auto kill - $readnetban($ini(data/glines.db,%x),reason)
        halt
      }
      inc %x 
    }
    var %x 1
    while ($ini(data/glines.db,%x)) {
      if (* $+ $readnetban($ini(data/glines.db,%x),address) $+ * iswm $+(*@,$6)) && ($readnetban($ini(data/glines.db,%x),type) == AGLINE) {
        ;echo -a $ini(data/glines.db,%x) - $readnetban($ini(data/glines.db,%x),address)
        sockwrite -tn serv TKL + G * $6 $netconf(system,nickname) $calc($ctime + 3600) $ctime :AGLINE - $readnetban($ini(data/glines.db,%x),reason)
        report AGLINE: $2 triggered an auto GLINE - $readnetban($ini(data/glines.db,%x),reason)
        halt
      }
      inc %x 
    }
    var %x 1
    while ($ini(data/glines.db,%x)) {
      if (* $+ $readnetban($ini(data/glines.db,%x),address) $+ * iswm $2) && ($readnetban($ini(data/glines.db,%x),type) == NICKBAN) {
        ;echo -a $ini(data/glines.db,%x) - $readnetban($ini(data/glines.db,%x),address)
        sockwrite -tn serv $+(:,$netconf(system,nickname)) KILL $2 $readnetban($ini(data/glines.db,%x),reason)
        report NICKBAN: $2 triggered an auto kill NickBan - $readnetban($ini(data/glines.db,%x),reason)
        writetolog system $2 triggered a nickban autokill - $readnetban($ini(data/glines.db,%x),reason)
        halt
      }
      inc %x 
    }
    if ($netconf(system,searchirc) == on) {
      if (scrawl isin $2) { return | halt }
    }
    sockwrite -tn serv : $+ $netconf(nickname,nick) SVS2MODE $2 -o
    addseen seen $2 $ctime
    if ($netconf(system,connectnotices) == on) {
      report CONNECTING: $+($2,!,$5,@,$6) - $7
    }
    addsqlclient $2 $6 $7
    addclient $2 nickname $2
    addclient $2 ident $5
    addclient $2 host $6
    addclient $2 server $7
    addclient $2 time $4
    if ($netconf(server,welcome)) { sysnotice2 $2 $netconf(server,welcome) }
    var %x = 1    
    while ($ini(data/news.db,random,%x)) {
      sysnotice2 $2 Random News * $+ $ini(data/news.db,random,%x) $+ * $readini(data/news.db,random,$ini(data/news.db,random,%x))
      inc %x
    }
    if ($readnick($2,nickname)) && ($readnick($2,protect) == on) {
      if ($readnick($2,protectaction) == warn) { 
        sysnotice2 $2 :-
        sysnotice2 $2 : $+ %color $+  $lang($2,nickname,6)
        sysnotice2 $2 : $+ %color $lang($2,nickname,7)  $+ $2 $+  $lang($2,nickname,8)
        sysnotice2 $2 : $+ %color $lang($2,nickname,9)
        sysnotice2 $2 : $+ %color $+  $lang($2,nickname,10)
        sysnotice2 $2 :-
      }
      if ($readnick($2,protectaction) == renick) { 
        sysnotice2 $2 :-
        sysnotice2 $2 : $+ %color $+  $lang($2,nickname,6)
        sysnotice2 $2 : $+ %color $lang($2,nickname,7)  $+ $2 $+  $lang($2,nickname,8)
        sysnotice2 $2 : $+ %color $lang($2,nickname,9)
        sysnotice2 $2 : $+ %color $+  $lang($2,nickname,10)
        sysnotice2 $2 :-
        timer $+ $2 $+ renick 1 60 //sockwrite -tn serv : $+ $netconf(system,nickname) SVSNICK $2 Guest $+ $ini(data/clients.db,0) $ctime
      }
    }
    return
  }
  if ($2 == MODE) && (+ isin $4) && ($netconf(server,nickname) != $remove($1,:)) && (%startup == $null) {
    if (o isin $4) {
      var %cmod = $remove($4,+)
      if ($readchan($3,strictop) == on) && (!$readaccess($5,$3,level)) { chanmode $3 -o $5 }
      if ($readchan($3,strictop) == on) && ($readaccess($5,$3,level) < $netconf(chanlevel,op)) { chanmode $3 -o $5 }
    }
  }
  if ($2 == MODE) && (- isin $4) && ($netconf(system,nickname) isin $5) && (%startup == $null) {
    if ($netconf(system,qmode) == on) {
      sockwrite -tn serv : $+ $netconf(server,nickname) MODE $3 +q $netconf(system,nickname)
      } else {
      sockwrite -tn serv : $+ $netconf(server,nickname) MODE $3 +o $netconf(system,nickname)
    }
    if ($netconf(system,loging) == on) {
      writetolog system $remove($1,:) attempted to DEOP service $netconf(system,nickname) in channel $3
      report $remove($1,:) attempted to DEOP service $netconf(system,nickname) in channel $3
    }
  }
  if ($2 == QUIT) {
    if ($netconf(system,webportal) == on) {
      .do_web
    }
    if ($netconf(system,searchirc) == on) {
      if (scrawl isin $remove($1,:)) { return | halt }
    }
    addseen seen $remove($1,:) $ctime
    if ($netconf(system,connectnotices) == on) {
      report QUIT: $+($remove($1,:),!,$readclient($remove($1,:),ident),@,$readclient($remove($1,:),host)) - $readclient($remove($1,:),server)
    }
    var %x = 1
    while ($ini(data/activechans.db,%x)) {
      if ($readini(data/activechans.db,$ini(data/activechans.db,%x),$remove($1,:))) { remini data/activechans.db $ini(data/activechans.db,%x) $remove($1,:) }
      if ($ini(data/activechans.db,$ini(data/activechans.db,%x),0) < 1) { remini data/activechans.db $ini(data/activechans.db,%x) }
      inc %x
    }
    if ($readadmin($remove($1,:),nickname)) {
      wipeadmin $remove($1,:)
    }
    remini data/id.db id $readclient($remove($1,:),host)
    delclient $remove($1,:)
    delsqlclient $remove($1,:)
    return
  }
  if ($1 == SQUIT) {
    report NETSPLIT:  $+ $2 $+  has disconnected from the network with reason: $remove($3,:)
    report NETSPLIT: Attempting to reconnect to  $+ $2 $+ 
    var %x = 1
    while ($ini(data/clients.db,%x)) {
      .sockwrite -tn serv $+(:,$netconf(system,service2)) NOTICE $ini(data/clients.db,%x) [ $+ NETSPLIT $+  $+ ] The network servers have split, please be patient as i try to resolve this problem...
      inc %x
    }
    serverconnect $2
  }

  if ($2 == EOS) {
    report NETSPLIT: We have reconnected to server  $+ $remove($1,:) $+ 
    while ($ini(data/clients.db,%x)) {
      .sockwrite -tn serv $+(:,$netconf(system,service2)) NOTICE $ini(data/clients.db,%x) [ $+ NETSPLIT $+  $+ ] All services are now linked, thank you for your patience.
      inc %x
    }
  }
  if ($2 == JOIN) {
    ;channel blacklist here close channels that aint allowed by admin

    ;if ($chanBL($3,expiretime) > $ctime) && (!$readadmin($remove($1,:),nickname)) && (%startup == $null) {
    ; sockwrite -tn serv : $+ $netconf(system,nickname) MODE $3 +b $mask($+($remove($1,:),!,$userhost($remove($1,:))),2)
    ; sockwrite -tn serv $+(:,$netconf(system,nickname)) KICK $3 $remove($1,:) $chanBL($3,reason)
    ; addchanban $3 $mask($+($remove($1,:),!,$userhost($remove($1,:))),2) $ctime
    ; report CHANNEL BLACKLIST: $remove($1,:) tried to join blacklisted channel  $+ $3 $+ 
    ; halt
    ;}
    var %x 1
    while ($ini(data/chanBL.db,%x)) {
      if (* $+ $ini(data/chanBL.db,%x) $+ * iswm $remove($3,$chr(35))) || ($ini(data/chanBL.db,%x) == $3) {
        if ($readadmin($remove($1,:),nickname)) && (%startup == $null) {
          report CHANNEL BLACKLIST: $remove($1,:) joined blacklisted channel  $+ $3 
        }
        else {
          sysjoinchan $3
          sockwrite -tn serv : $+ $netconf(system,nickname) MODE $3 +i
          timer $+ $3 $+ $ctime 1 3200 syspartchan $3
          sockwrite -tn serv : $+ $netconf(system,nickname) MODE $3 +b $mask($+($remove($1,:),!,$userhost($remove($1,:))),2)
          sockwrite -tn serv $+(:,$netconf(system,nickname)) KICK $3 $remove($1,:) $chanBL($3,reason)
          addchanban $3 $mask($+($remove($1,:),!,$userhost($remove($1,:))),2) $ctime
          report CHANNEL BLACKLIST: $remove($1,:) tried to join  $+ $3 $+  but was kicked as it matched blacklist entry  $+ $ini(data/chanBL.db,%x)
          halt
        }
      }
      inc %x
    }
    ;if channel isnt registered set the system default modes for the channel
    if (!$readchan($3,owner)) && (%startup == $null) { sockwrite -tn serv : $+ $netconf(server,server) MODE $3 +nt | sockwrite -tn serv : $+ $netconf(server,server) MODE $3 -o $remove($1,:) }
    if ($readaccess($remove($1,:),$3,level) == 1) {
      sockwrite -tn serv : $+ $netconf(system,nickname) MODE $3 +b $mask($+($remove($1,:),!,$userhost($remove($1,:))),2)
      .sockwrite -tn serv $+(:,$netconf(system,nickname)) KICK $3 $remove($1,:) Lamer
      halt 
    }
    if ($readchan($3,joinmsg)) && (%startup == $null) { sockwrite -tn serv $+(:,$netconf(system,nickname)) notice $remove($1,:)  :< $+ $3 $+ > $readchan($3,joinmsg) }
    if ($readuserinfoline($remove($1,:),$3)) && ($addy($remove($1,:))) && (%startup == $null) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) PRIVMSG $3  :< $+ $remove($1,:) $+ > $readuserinfoline($remove($1,:),$3)
    }
    if ($readaccess($remove($1,:),$3,autovoice) == on) && ($addy($remove($1,:))) && ($readchan($3,voice) == on) && (%startup == $null) { 
      chanopuser $3 +v $remove($1,:) 
    }
    if ($readaccess($addy($remove($1,:)),$3,level)) {
      ;log user vist as last visit to the channel
      addchan $3 lastvisit $ctime
    }
    if ($readaccess($remove($1,:),$3,autoop) == on) && ($addy($remove($1,:))) && ($readchan($3,autoop) == on) && (%startup == $null) { 
      if ($readaccess($addy($remove($1,:)),$3,level) == 5) { chanopuser $3 +o $remove($1,:) }
      if ($readaccess($addy($remove($1,:)),$3,level) == 4) { chanopuser $3 +o $remove($1,:) }
      if ($readaccess($addy($remove($1,:)),$3,level) == 3) { chanopuser $3 +o $remove($1,:) }
    }
    var %x = 1
    while ($gettok($3-,%x,44)) {
      writeini data/activechans.db $gettok($3-,%x,44) $remove($1,:) ison
      inc %x
    }

  }

  if ($2 == TOPIC) {
    removeLIVEtopic $3
    writeLIVEtopic $3 $remove($6-,:)
    .do_web
    if ($readchan($3,owner)) && ($readchan($3,topiclock) != off) {
      if ($readaccess($addy($remove($1,:)),$3,level) < $readchan($3,topiclock)) {
        .sockwrite -tn serv $+(:,$netconf(system,nickname)) TOPIC $3 $netconf(system,nickname) $ctime : $+ $remove($read(data/set_topics.txt, s, $3 $+ :),$3 $+ :) 
      }
    }
  }

  if ($2 == AWAY) && (!$3) {
    echo -a > Removed away message
    remini data/clients.db $remove($1,:) awaymsg
  }
  if ($2 == AWAY) && ($len($3-) > 1) {
    addclient $remove($1,:) awaymsg $remove($3-,:)
  }
  if ($2 == KICK) {
    remini data/activechans.db $3 $4
    if ($ini(data/activechans.db,$3,0) < 1) { remini data/activechans.db $3 }
  }
  if ($2 == PART) {
    remini data/activechans.db $3 $remove($1,:)
    if ($ini(data/activechans.db,$3,0) < 1) { remini data/activechans.db $3 }
  }
  if ($2 == SENDSNO) {
    if (*is now a* iswm $6-) {
      if ($readini(data/blacklist.db,opers,$remove($4,:))) {
        sockwrite -tn serv : $+ $netconf(nickname,nick) SVS2MODE $remove($4,:) -oghaAN
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $remove($4,:) :-
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $remove($4,:) : $+ %color $+  $lang($remove($4,:),ircops,bl)
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $remove($4,:) : $+ %color $lang($remove($4,:),ircops,blnotice)
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $remove($4,:) :-
        if ($netconf(system,loging) == on) { 
          writetolog system $remove($4,:) tried to oper up but is blacklisted
        }
        halt
      } 
      report $remove($4,:) $7-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $remove($4,:) :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $remove($4,:) : $+ %color $+  $lang($remove($4,:),ircops,operup)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $remove($4,:) : $+ %color $lang($remove($4,:),ircops,operupnotice) $10-
      if ($netconf(system,loging) == on) { 
        writetolog system $remove($4,:) is now logged in as a $10-
      }
      if ($ini(data/pending.db,0) > 0) {
        sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $remove($4,:) : $+ %color $lang($remove($4,:),ircops,pending)
      }
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $remove($4,:) :-
      addadmin $remove($4,:) nickname $remove($4,:)
      addadmin $remove($4,:) status active
      addadmin $remove($4,:) when $ctime
      addadmin $remove($4,:) rank $10-
      if ($readnick($remove($4,:),vhost)) { sockwrite -tn serv $+(:,$netconf(server,server)) CHGHOST $remove($4,:) $readnick($remove($4,:),vhost) }
      else { sockwrite -tn serv $+(:,$netconf(server,server)) CHGHOST $remove($4,:) $lower($remove($4,:) $+ .staff.digi-net.org) }
      var %x = 1    
      while ($ini(data/news.db,oper,%x)) {
        sysnotice2 $remove($4,:) Oper News * $+ $ini(data/news.db,oper,%x) $+ * $readini(data/news.db,oper,$ini(data/news.db,oper,%x))
        inc %x
      }
    }
  }
}
