; Copying or editing of any of the scripts included in this module is strictly prohibited, you may distribute the package
; in its entireity un edited in any form. Support can only be given to those who do not edit these files please do not ask
; if you plan to edit them yourself. Credits and links back to us must remain in the script we do not advertise using your
; network unless the .VERSION command is triggered. You must also agree when connecting the service to any IRC net
; that you have the correct permission to connect the service, you MUST NOT connect the service to Digi-Net and you
; connect the service at your own risk. For support see http://www.digi-net.org
alias system.help {
  if $2 { goto chktopic | halt }
  else { goto helplist | halt }
  :chktopic
  if $exists(Help\ $+ $2 $+ .TXT) { play -c $1 Help\ $+ $2 $+ .TXT 0 | halt }
  else {
    sockwrite -tn serv :SysOp NOTICE $1 :-
    sockwrite -tn serv :SysOp NOTICE $1 :4,4. $lang($1,help,2)
    sockwrite -tn serv :SysOp NOTICE $1 :4,4. $lang($1,help,3)
    sockwrite -tn serv :SysOp NOTICE $1 :4,4. $lang($1,help,4)
    sockwrite -tn serv :SysOp NOTICE $1 :-
    halt
  }
  :helplist
  { play -c $1 Help\help_list.TXT 0 | halt }
}
