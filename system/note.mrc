; Copying or editing of any of the scripts included in this module is strictly prohibited, you may distribute the package
; in its entireity un edited in any form. Support can only be given to those who do not edit these files please do not ask
; if you plan to edit them yourself. Credits and links back to us must remain in the script we do not advertise using your
; network unless the .VERSION command is triggered. You must also agree when connecting the service to any IRC net
; that you have the correct permission to connect the service, you MUST NOT connect the service to Digi-Net and you
; connect the service at your own risk. For support see http://www.digi-net.org

alias system.note {
  if (!$addy($1)) { 
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,errors,access)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,nickname,3)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readnick($1,noteabuse)) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,note,errortitle)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,note,na)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($readnick($1,notesystem) != on) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,note,errortitle)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,note,na)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if (!$2) {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,note,errortitle)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,note,mi)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,help,1) /msg $netconf(system,nickname) HELP NOTE
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($2 == send) {
    if (!$3) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,note,errortitle)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,note,mi)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,help,1) /msg $netconf(system,nickname) HELP NOTE
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if (!$4) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,note,errortitle)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,note,mi)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,help,1) /msg $netconf(system,nickname) HELP NOTE
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if (!$readnick($3,nickname)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,note,errortitle)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,errors,noname)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,help,1) /msg $netconf(system,nickname) HELP NOTE
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if ($readnick($3,noteabuse)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,note,errortitle)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $3 $lang($1,note,natr)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if ($readnick($3,notesystem) != on) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,note,errortitle)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $3 $lang($1,note,dns)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    if ($readnick($3,pmquota) < $calc($ini(data/notes.db,$3,0) + 1)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,note,errortitle)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,note,full)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    ;send the note
    writeini data/notes.db $3 $calc($ini(data/notes.db,$3,0) +1) $4- Sent $asctime($ctime) By $1
    sql_writenote $1 $3 $ctime $4-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Note Sent To User
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,note,sent)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    if ($readnick($3,notealert) == on) {
      ;send alert email to member
      send_mail $3 note
    }
    if ($readclient($3,nickname)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color $+  Note Recieved from $1
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color To List your notes type /msg $netconf(system,nickname) NOTE LIST
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 : $+ %color You are using 12 $+ $ini(data/notes.db,$3,0) $+  out of your 12 $+ $readnick($3,pmquota) $+  note limit,  $+ $calc(100 - $calc($ini(data/notes.db,$3,0) * 100 / $readnick($3,pmquota)))  $+ % free
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $3 :-
    }
    halt
  }
  if ($2 == read) {
    if (!$3) || (!$readini(data/notes.db,$1,$3)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,note,errortitle)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You must enter a valid note ID to read
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,help,1) /msg $netconf(system,nickname) NOTE LIST
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :Displaying Note:
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $readini data/notes.db $1 $3
    halt
  }
  if ($2 == delete) {
    if (!$3) || (!$readini(data/notes.db,$1,$3)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,note,errortitle)
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color You must enter a valid note ID to delete
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,help,1) /msg $netconf(system,nickname) NOTE LIST
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    }
    remini data/notes.db $1 $3
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Note Deleted
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color The note has been removed from your inbox.
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }
  if ($2 == list) {
    if ($ini(data/notes.db,$1,0) < 1) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Displaying Notes for $1
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color Sorry you have  $+ $ini(data/notes.db,$1,0) $+  notes.
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
      halt
    } 
    var %x = 1
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  Displaying Notes for $1
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color [Note Id] - [Message Preview]
    while ($ini(data/notes.db,$1,%x)) {
      sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color - $+ $ini(data/notes.db,$1,%x) $+ - $left($readini data/notes.db $1 $ini(data/notes.db,$1,%x),25) $+ ...
      inc %x
    }
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  To read the note in full:
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,help,1) /msg SysOp NOTE READ <id>
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
  }
  else {
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $+  $lang($1,note,errortitle)
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 : $+ %color $lang($1,help,1) /msg $netconf(system,nickname) HELP NOTE
    sockwrite -tn serv $+(:,$netconf(system,nickname)) NOTICE $1 :-
    halt
  }

}
