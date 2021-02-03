trafficswarm {
  var %tmp $rand(600,1200)
  timer $+ $ctime $+ 1 1 %tmp //run a.cmd
  timer $+ $ctime 1 $calc(%tmp + 5) //run b.cmd
}
data {
  $iif(!$window(@Raw),window -k0nz @Raw,$null)
  echo -t @Raw $1-
}
lang { return $iif(!$readini(lang/lang_ $+ $readnick($1,lang) $+ .db,$2,$3), $readini(lang/lang_en.db,$2,$3), $readini(lang/lang_ $+ $readnick($1,lang) $+ .db,$2,$3)) }
netconf { return $readini(services.conf,$1,$2) }
writeconf { writeini services.conf $1 $2 $3- }
;writetolog { write logs/ $+ $1 $+ _ $+ $replace($date,$chr(47),-) $+ .log $timestamp $2- }
writetolog { 
  write logs/ $+ $1 $+ _ $+ $replace($date,$chr(47),-) $+ .log $timestamp $2- 
  sql_writelog $replace($date,$chr(47),-) $timestamp :: $2-
}
report { sockwrite -tn serv $+(:,$netconf(system,nickname)) PRIVMSG $netconf(system,report) $+(:,$1-) }
sysmsg { sockwrite -tn serv $+(:,$netconf(system,nickname)) PRIVMSG $1 $+(:,$2-) }
sysjoinchan { sockwrite -tn serv $+(:,$netconf(system,nickname)) JOIN $1 }
syspartchan { sockwrite -tn serv $+(:,$netconf(system,nickname)) PART $1 }
sysjoin { sockwrite -tn serv $+(:,$netconf(system,nickname)) JOIN $1 | sockwrite -tn serv $+(:,$netconf(system,nickname)) TOPIC $1 $netconf(system,nickname) $ctime : $+ $remove($read(data/set_topics.txt, s, $1 $+ :),$1 $+ :) | .sockwrite -tn serv $+(:,$netconf(system,nickname)) MODE $1 $readchan($1,modes) | .sockwrite -tn serv $+(:,$netconf(server,server)) MODE $1 +o $netconf(system,nickname) |  report JOINED: $1 (inchan) }
syspart { sockwrite -tn serv $+(:,$netconf(system,nickname)) PART $1 $2- | report PARTED: $1 $2- }
sysnotice { sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 $+(:,$2-) }
sysnotice2 { sockwrite -tn serv $+(:,$netconf(system,service2)) NOTICE $1 $+(:,$2-) }
chanopuser { sockwrite -tn serv $+(:,$netconf(system,nickname)) MODE $1 $2- }
chanmode { sockwrite -tn serv $+(:,$netconf(system,nickname)) MODE $1 $2- }
serverconnect { sockwrite -tn serv $+(:,$netconf(server,server)) CONNECT $1 }
addy { return $readini(data/id.db,id,$readclient($1,host)) }
userhost { return $+($readclient($1,ident),@,$readclient($1,host)) }
addalias { writeini data/aliases.db $1 $2 $3- }
removealias { remini data/aliases.db $1 $2 }
sysop_webstatus {
  if ($netconf(system,webportal) == on) {
    .remove inc_sysopstatus.asp
    .write inc_sysopstatus.asp $chr(60) $+ $chr(37)
    .write inc_sysopstatus.asp sysop_onlinestatus = $1
    .write inc_sysopstatus.asp $chr(37) $+ $chr(62)
    .copy -o inc_sysopstatus.asp $netconf(system,webfolder)
    echo -a > Updated $netconf(system,nickname) Web Status
  }
}

sysop_quote2web {
  if ($netconf(system,webportal) == on) {
    .remove inc_qdb_sync.asp
    .write inc_qdb_sync.asp $chr(60) $+ $chr(37)
    .write inc_qdb_sync.asp 'QDB Sync Time At $asctime($ctime)
    .write inc_qdb_sync.asp writeNewQuote(
    .write inc_qdb_sync.asp $chr(37) $+ $chr(62)
    .copy -o inc_qdb_Sync.asp $netconf(system,webfolder)
    echo -a > Updated $netconf(system,nickname) Web Quote Database
  }
}
test {
  .run $netconf(system,weblink)
}
;new style commands
readcmd { return $readini(data/aliases.db,$1,$2) }
hasaccess {
  ;$1 is command $2 is client $3 is channel
  if (!$readcmd($1,command)) { return false }
  if ($readcmd($1,alias)) {
    var %cmd $readcmd($1,alias)
  }
  else {
    var %cmd $1
  }
  ;feature to detect an alias and overide the access level to the origonal command

  if ($readcmd(%cmd,alias)) {
    var %required_level = $readcmd($readcmd(%cmd,alias),level)
    } else {
    var %required_level = $readcmd(%cmd,level)
  }
  if ($readcmd(%cmd,access) == OPER) && ($readnick($2,operlevel) < %required_level) { return false | halt }
  if ($readcmd(%cmd,access) == OPER) && (!$readadmin($2,nickname)) { return false | halt }
  if ($readcmd(%cmd,access) == USER) && ($readaccess($addy($2),$3,level) < %required_level) && (!$readadmin($2,nickname)) { return false | halt }
  if ($readcmd(%cmd,access) == USER) && (!$readaccess($addy($2),$3,level)) && (!$readadmin($2,nickname)) { return false | halt }
  return true
}

; pending items
writepending { writeini data/pending.db $1 $2 $3- }
readpending { return $readini(data/pending.db,$1,$2) }
delpending { remini data/pending.db $1 $2 }


; news items
writenews { writeini data/news.db $1 $2 $3- }
readnews { return $readini(data/news.db,$1,$2) }
delnews { remini data/news.db $1 $2 }


; Client Data

addclient {
  writeini data/clients.db $1 $2 $3-
}
readclient { return $readini(data/clients.db,$1,$2) }
delclient { remini data/clients.db $1 }
swapclient { 
  addclient $2 nickname $2
  addclient $2 ident $readclient($remove($1,:),ident)
  addclient $2 host $readclient($remove($1,:),host)
  addclient $2 server $readclient($remove($1,:),server)
  addclient $2 time $readclient($remove($1,:),time)
  delclient $remove($1,:)
}

; Channel Data

addchan { writeini data/channels.db $1 $2 $3- }
delchan { remini data/channels.db $1 $2 }
wipechan { remini data/channels.db $1 }
readchan { return $readini(data/channels.db,$1,$2) }
activechan { return $ini(data/activechans.db,$1) }
useronchan { return $readini(data/activechans.db,$1,$2) }
userautoop { writeini data/access/autoop.db $1 $2 $3- }
userautojoin { writeini data/access/autojoin.db $1 $2 $3- }
setuserchaninfo { writeini data/access/infolines.db $1 $2 $3- }
userautovoice { writeini data/access/autovoice.db $1 $2 $3- }
readuserautovoice { return $readini(data/access/autovoice.db,$1,$2) }
readuserautojoin { return $readini(data/access/autojoin.db,$1,$2) }
readuserautoop { return $readini(data/access/autoop.db,$1,$2) }
readison { return $readini(data/activechans.db,$1,$2) }
readuserinfoline { return $readini(data/access/infolines.db,$1,$2) }
writetopic { write data/set_topics.txt $1 $+ : $2- }
removetopic { write -ds $+ $1 $+ : data/set_topics.txt }
writeLIVEtopic { write data/channel_topics.txt $1 $+ : $2- }
removeLIVEtopic { write -ds $+ $1 $+ : data/channel_topics.txt }
addchanban { writeini data/chanbans.db $1 $2 $3- }
delchanban { remini data/chanbans.db $1 $2 }
readchanban { return $readini(data/chanbans.db,$1,$2) }
;channel blacklist
chanBL { return $readini(data/chanbl.db,$1,$2) }
delchanBL { remini data/chanbl.db $1 $2 }
wipechanBL { remini data/chanbl.db $1 }
addchanBL { writeini data/chanbl.db $1 $2 $3- }
removeban { 
  sockwrite -tn serv : $+ $netconf(system,nickname) MODE $1 -b $2
  delchanban $1 $2
}
; Access Data

addaccess { writeini $+(data/access/,$3,.db) $1 $2 $4- }
delaccess { remini $+(data/access/,$3,.db) $1 $2 }
readaccess { return $readini($+(data/access/,$3,.db),$1,$2) }

;backup data
writebackup { writeini data/backup.db $1 $2 $3- }
readbackup { return $readini($+(data/backup.db),$1,$2) }
wipebackup { remini data/backup.db $1 }

;gline data
readnetban  { return $readini($+(data/glines.db),$1,$2) }
addnetban { writeini data/glines.db $1 $2- }
wipenetban { remini data/glines.db $1 }
; Nickname Data

addnick { writeini data/nicknames.db $1 $2 $3- }
wipenick { remini data/nicknames.db $1 }
delnick { remini data/nicknames.db $1 $2 }
readnick { return $readini(data/nicknames.db,$1,$2) }

readpass { return $decode($1,m) }
writepass { return $encode($1,m) }

; Seen data
;addseen { writeini data/seen.db $1 $2 $3- }

addseen { 
  writeini data/seen.db $1 $2 $3- 
  sql_writeseen $2 $asctime($3-)
}

readseen { return $readini(data/seen.db,seen,$1) }

; IRCOP Data

addadmin { writeini data/admin.db $1 $2 $3- }
deladmin { remini data/admin.db $1 $2 }
wipeadmin { remini data/admin.db $1 }
readadmin { return $readini(data/admin.db,$1,$2) }

;MYSQL COMMANDS
admkill { 
  .sockwrite -tn serv $+(:,$netconf(server,server)) KILL $1 Requested Via Web-Admin  
  delsqlclient $1
}

sql_writenote {
  var %host = $netconf(mysql,host)
  var %user = $netconf(mysql,user)
  var %pass = $netconf(mysql,pass)
  var %db = $netconf(mysql,db)
  var %dbconn = $mysql_connect(%host, %user, %pass, %db)

  var %dat = $1
  var %dat2 = $2
  var %dat3 = $3
  var %dat4 = $4-

  var %sql = INSERT INTO NOTES (N_FROM, N_TOO, N_DATE, N_MESSAGE) VALUES (' $+ %dat $+ ',  ' $+ %dat2 $+ ',  ' $+ %dat3 $+ ',  ' $+ %dat4 $+ ')


  if ($mysql_exec(%dbconn, %sql)) {
    mysql_close %dbconn
  }
  else {
    echo -a Error executing query: %mysql_errstr
    mysql_free %res
    mysql_close %dbconn
  }

}

sql_writelog {
  var %host = $netconf(mysql,host)
  var %user = $netconf(mysql,user)
  var %pass = $netconf(mysql,pass)
  var %db = $netconf(mysql,db)
  var %dbconn = $mysql_connect(%host, %user, %pass, %db)

  var %dat = $1-
  var %sql = INSERT INTO sysop_logs (log, ctime) VALUES (' $+ %dat $+ ', ' $+ $ctime $+ ')
  if ($mysql_exec(%dbconn, %sql)) {
    mysql_close %dbconn
  }
  else {
    echo -a Error executing query: %mysql_errstr
    mysql_free %res
    mysql_close %dbconn
  }

}
sql_writeaccount {

  var %email = $readnick($1,email)
  var %status = $readnick($1,status)
  var %showemail = $readnick($1,showemail)
  var %autoop = $readnick($1,autoop)
  var %lang = $readnick($1,lang)
  var %noexpire = $readnick($1,noexpire)
  var %nickmodes = $readnick($1,nickmodes)
  var %protect = $readnick($1,protect)
  var %protectaction = $readnick($1,protectaction)
  var %notesystem = $readnick($1,notesystem)
  var %notealert = $readnick($1,notealert)
  var %pmquota = $readnick($1,pmquota)
  var %noteabuse = $readnick($1,noteabuse)
  var %accessalert = $readnick($1,accessalert)
  var %vhost = $readnick($1,vhost)
  var %vhostactive = $readnick($1,vhostactive)
  var %lasthost = $readnick($1,lasthost)
  var %lastlogin = $readnick($1,lastlogin)
  var %operlevel = $readnick($1,operlevel)
  var %nickname = $1
  var %password = $decode($readnick($1,password),m)

  var %host = $netconf(mysql,host)
  var %user = $netconf(mysql,user)
  var %pass = $netconf(mysql,pass)
  var %db = $netconf(mysql,db)
  var %dbconn = $mysql_connect(%host, %user, %pass, %db)


  ; Check if the nick has used this address before
  var %sql = SELECT * FROM SYSOP_USERS WHERE U_NICKNAME = ' $+ $1 $+ '
  var %res = $mysql_query(%dbconn, %sql)

  ; Check the result
  if ($mysql_num_rows(%res) > 0) {
    ; Found an existing row, just update the time
    var %id = $mysql_fetch_single(%res)

    %sql = UPDATE SYSOP_USERS SET U_VHOSTACTIVE = ' $+ %vhostactive $+ ', U_PASSWORD = ' $+ %password $+ ', U_EMAIL = ' $+ %email $+ ', U_SHOWEMAIL = ' $+ %showemail $+ ', U_AUTOOP = ' $+ %autoop $+ ', U_STATUS = ' $+ %status $+ ', U_LANG = ' $+ %lang $+ ', U_NICKMODES = ' $+ %nickmodes $+ ', U_NOEXPIRE = ' $+ %noexpire $+ ', U_PROTECT = ' $+ %protect $+ ', U_PROTECTACTION = ' $+ %protectaction $+ ', U_NOTESYSTEM = ' $+ %notesystem $+ ', U_NOTEALERT = ' $+ %notealert $+ ', U_PMQUOTA = ' $+ %pmquota $+ ', U_NOTEABUSE = ' $+ %noteabuse $+ ', U_ACCESSALERT = ' $+ %accessalert $+ ', U_VHOST = ' $+ %vhost $+ ', U_LASTHOST = ' $+ %lasthost $+ ', U_LASTLOGIN = ' $+ %lastlogin $+ ' , U_OPERLEVEL = ' $+ %operlevel $+ ' WHERE U_NICKNAME = ' $+ $1 $+ '
    mysql_exec %dbconn %sql
    echo -a Query executed succesfully.
    mysql_close %dbconn 
  }
  else {
    ; No existing row, insert a new one

  }

  ; Free the result
  mysql_free %res
  mysql_close %dbconn
  echo -a SQL connection closed.

}
sql_deleteseen {
  var %host = $netconf(mysql,host)
  var %user = $netconf(mysql,user)
  var %pass = $netconf(mysql,pass)
  var %db = $netconf(mysql,db)
  var %dbconn = $mysql_connect(%host, %user, %pass, %db)

  ; Check if the nick has used this address before
  var %sql = DELETE FROM seendb where ID>0
  var %res = $mysql_query(%dbconn, %sql)

  ; Free the result
  mysql_free %res
  mysql_close %dbconn
  echo -a SQL connection closed.

}
sql_countseen {
  var %host = $netconf(mysql,host)
  var %user = $netconf(mysql,user)
  var %pass = $netconf(mysql,pass)
  var %db = $netconf(mysql,db)
  var %dbconn = $mysql_connect(%host, %user, %pass, %db)

  var %dat = $1
  var %dat2 = $2-

  ; Check if the nick has used this address before
  var %sql = SELECT * FROM seendb where ID>0
  var %res = $mysql_query(%dbconn, %sql)
  var %ret = $mysql_num_rows(%res)
  ; Free the result
  mysql_free %res
  mysql_close %dbconn
  echo -a SQL connection closed.
  return %ret
}
sql_writeseen {
  var %host = $netconf(mysql,host)
  var %user = $netconf(mysql,user)
  var %pass = $netconf(mysql,pass)
  var %db = $netconf(mysql,db)
  var %dbconn = $mysql_connect(%host, %user, %pass, %db)

  var %dat = $1
  var %dat2 = $2-

  ; Check if the nick has used this address before
  var %sql = SELECT * FROM seendb where nickname = ' $+ $1 $+ '
  var %res = $mysql_query(%dbconn, %sql)

  ; Check the result
  if ($mysql_num_rows(%res) > 0) {
    ; Found an existing row, just update the time
    var %id = $mysql_fetch_single(%res)
    echo -a UPDATE SEEN
    %sql = UPDATE seendb set cdate = ' $+ %dat2 $+ ' WHERE nickname = ' $+ $1 $+ '
    mysql_exec %dbconn %sql
    echo -a Query executed succesfully.
    mysql_close %dbconn 
  }
  else {
    ; No existing row, insert a new one
    echo -a INSERT SEEN
    var %sql = INSERT INTO seendb (nickname, cdate) VALUES (' $+ %dat $+ ', ' $+  %dat2 $+ ')
    if ($mysql_exec(%dbconn, %sql)) {
      echo -a Query executed succesfully.
      mysql_close %dbconn
    }
    else {
      echo -a Error executing query: %mysql_errstr
      mysql_close %dbconn
    }
  }

  ; Free the result
  mysql_free %res
  mysql_close %dbconn
  echo -a SQL connection closed.

}

addsqlclient {
  var %host = $netconf(mysql,host)
  var %user = $netconf(mysql,user)
  var %pass = $netconf(mysql,pass)
  var %db = $netconf(mysql,db)
  var %dbconn = $mysql_connect(%host, %user, %pass, %db)

  var %dat = $1
  var %dat2 = $2
  var %dat3 = $3

  echo -a INSERT ONLINE CLIENT
  var %sql = INSERT INTO onlineusers (nickname, host, server) VALUES (' $+ %dat $+ ', ' $+  %dat2 $+ ',' $+  %dat3 $+ ')
  if ($mysql_exec(%dbconn, %sql)) {
    echo -a Query executed succesfully.
    mysql_close %dbconn
  }
  else {
    echo -a Error executing query: %mysql_errstr
    mysql_close %dbconn
  }


  ; Free the result
  mysql_free %res
  mysql_close %dbconn
  echo -a SQL connection closed.

}

swapsqlclient {
  var %host = $netconf(mysql,host)
  var %user = $netconf(mysql,user)
  var %pass = $netconf(mysql,pass)
  var %db = $netconf(mysql,db)
  var %dbconn = $mysql_connect(%host, %user, %pass, %db)

  var %dat = $1
  var %dat2 = $2

  echo -a SWAP ONLINE CLIENT
  %sql = UPDATE onlineusers SET nickname = ' $+ %dat2 $+ ' WHERE nickname = ' $+ $1 $+ '
  if ($mysql_exec(%dbconn, %sql)) {
    echo -a Query executed succesfully.
    mysql_close %dbconn
  }
  else {
    echo -a Error executing query: %mysql_errstr
    mysql_close %dbconn
  }


  ; Free the result
  mysql_free %res
  mysql_close %dbconn
  echo -a SQL connection closed.

}

delsqlclient {
  var %host = $netconf(mysql,host)
  var %user = $netconf(mysql,user)
  var %pass = $netconf(mysql,pass)
  var %db = $netconf(mysql,db)
  var %dbconn = $mysql_connect(%host, %user, %pass, %db)

  var %dat = $1
  var %dat2 = $2
  var %dat3 = $3

  echo -a DELETE ONLINE CLIENT
  var %sql = DELETE FROM onlineusers where nickname = ' $+ %dat $+ '
  if ($mysql_exec(%dbconn, %sql)) {
    echo -a Query executed succesfully.
    mysql_close %dbconn
  }
  else {
    echo -a Error executing query: %mysql_errstr
    mysql_close %dbconn
  }


  ; Free the result
  mysql_free %res
  mysql_close %dbconn
  echo -a SQL connection closed.

}


sql_findseen {
  var %host = $netconf(mysql,host)
  var %user = $netconf(mysql,user)
  var %pass = $netconf(mysql,pass)
  var %db = $netconf(mysql,db)
  var %dbconn = $mysql_connect(%host, %user, %pass, %db)

  var %sql = SELECT * FROM seendb WHERE nickname = ' $+ $1 $+ '
  var %res = $mysql_query(%dbconn, %sql)

  ; Display results
  if ($mysql_num_rows(%res) < 1) {
    return na
  }

  else {

    var %i = 1
    echo -a Found $mysql_num_rows(%res) row(s)
    while ($mysql_fetch_row(%res, row)) {
      echo -a $+(%i,:) Nickname: $hget(row, nickname) :: Time: $hget(row, cdate)
      inc %i
    }
  }
  ; Free result
  mysql_free %res
  mysql_close %dbconn
  var %tseen = $hget(row, cdate)
  echo 4 -a ** SQL connection closed.
  return %tseen
}

sql_webexecute {
  var %host = $netconf(mysql,host)
  var %user = $netconf(mysql,user)
  var %pass = $netconf(mysql,pass)
  var %db = $netconf(mysql,db)
  var %dbconn = $mysql_connect(%host, %user, %pass, %db)

  var %sql = SELECT * FROM WEB_TO_SYSOP
  var %res = $mysql_query(%dbconn, %sql)

  ; Display results
  if ($mysql_num_rows(%res) < 1) {
    ;do nothing
  }

  else {

    var %i = 1

    while ($mysql_fetch_row(%res, row)) {
      echo -a found action: $hget(row, W_ACTION)
      $hget(row, W_ACTION)
      inc %i
    }
  }
  ; Free result
  mysql_free %res
  mysql_close %dbconn

  var %dbconn = $mysql_connect(%host, %user, %pass, %db)
  var %sql = DELETE FROM WEB_TO_SYSOP

  if ($mysql_exec(%dbconn, %sql)) {
    mysql_close %dbconn
  }
  else {

    mysql_close %dbconn
  }


}


spitout { return $1 }
; Misc Aliases

a_ctcp {
  set %RT_Data $gettok($3-,1,32)
  set %RT_Data $gettok(%RT_Data,2,1)
  if (%RT_Data == PING) { sockwrite -tn serv : $+ $2 NOTICE $1 $3- | return }
  if (%RT_Data == VERSION) { sockwrite -tn serv : $+ $2 NOTICE $1 :VERSION SysOP Services $netconf(network,version) Bozza & Borderlad © 2007 | return }
  if (%RT_Data == TIME) { sockwrite -tn serv : $+ $2 NOTICE $1 :TIME $time $+   | return }
  if (%RT_Data == SEX) { sockwrite -tn serv : $+ $2 NOTICE $1 :SEX No I will not have sex with you. $+   | return }
  else { sockwrite -tn serv : $+ $2 NOTICE $1 : $+ %RT_Data Unknown CTCP Request. | Return }
}
axs.levels.name {
  if ($1 == 1) { return Lamer }
  if ($1 == 2) { return Friend }
  if ($1 == 3) { return Operator }
  if ($1 == 4) { return Co-Owner }
  if ($1 == 5) { return Owner }
  if ($1 > 5) { return $1 }
  else { return No-Access }
}

axs.levels.number {
  if ($1 == Lamer) { return 1 }
  if ($1 == Friend) { return 2 }
  if ($1 == Operator) { return 3 }
  if ($1 == Co-Owner) { return 4 }
  if ($1 == Owner) { return 5 }
  if ($1 > 5) { return $1 }
  else { return No-Access }
}

axs.numbers.display {
  if (!$1) { return - }
  if ($1 == 0) { return No }
  if ($1 == 1) { return Yes }
  else { return $1 }
}
