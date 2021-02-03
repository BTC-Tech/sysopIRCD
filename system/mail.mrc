; Copying or editing of any of the scripts included in this module is strictly prohibited, you may distribute the package
; in its entireity un edited in any form. Support can only be given to those who do not edit these files please do not ask
; if you plan to edit them yourself. Credits and links back to us must remain in the script we do not advertise using your
; network unless the .VERSION command is triggered. You must also agree when connecting the service to any IRC net
; that you have the correct permission to connect the service, you MUST NOT connect the service to Digi-Net and you
; connect the service at your own risk. For support see http://www.digi-net.org

on *:SOCKCLOSE:sendmail:{
  if ($var(sendmailc*,0) > 0) { unset %sendmail* } 
}
alias send_mail {
  writeini -n mail.ini sendmail address $readnick($1,email)
  writeini -n mail.ini sendmail nick $1
  writeini -n mail.ini sendmail type $2
  sockopen sendmail $netconf(system,smtp) 25
  set %sendmailc 1
}
alias send_newmail {
  writeini -n mail.ini sendmail address $readnick($1,newemail)
  writeini -n mail.ini sendmail nick $1
  writeini -n mail.ini sendmail type $2
  sockopen sendnewmail $netconf(system,smtp) 25
  set %sendmailc 1
}
on *:SOCKREAD:sendmail:{
  sockread %sendmail
  tokenize 32 %sendmail
  echo - $1-
  if ($1 == 551) {  unset %sendmail* | sockclose sendmail }
  elseif ($1 == 501) { unset %sendmail* | sockclose sendmail }
  elseif (($1 == 220) && (%sendmailc == 1)) { report Mail Socket Open (Sending $readini(mail.ini,sendmail,type) message to $readini(mail.ini,sendmail,address) $+ ) | sockwrite -n sendmail HELO irc.btctech.co.uk | inc %sendmailc }
  elseif (($1 == 250) && (%sendmailc == 2)) { sockwrite -n sendmail MAIL FROM: < $+ $netconf(emails,services) $+ > | inc %sendmailc }
  elseif (($1 == 250) && (%sendmailc == 3)) { sockwrite -n sendmail RCPT TO: < $+ $readini(mail.ini,sendmail,address) $+ > | inc %sendmailc }
  elseif (($1 == 250) && (%sendmailc == 4)) { sockwrite -n sendmail DATA | inc %sendmailc }
  elseif (($1 == 250) && (%sendmailc == 5)) { sockwrite -n sendmail QUIT }
  elseif ($1 == 354) {
    if ($readini(mail.ini,sendmail,type) == newuser) {
      sockwrite -n sendmail From: "SysOp Services" < $+ $netconf(emails,services) $+ >
      sockwrite -n sendmail To: $readini(mail.ini,sendmail,address)
      sockwrite -n sendmail Subject: SysOp Services Nickname Registration
      sockwrite -n sendmail Date: $asctime
      sockwrite -n sendmail
      sockwrite -n sendmail Congratulations, You have successfully registered to SysOP
      sockwrite -n sendmail Services with the following information:
      sockwrite -n sendmail 
      sockwrite -n sendmail Nickname: $readini(mail.ini,sendmail,nick)
      sockwrite -n sendmail Pass: $decode($readnick($readini(mail.ini,sendmail,nick),password),m)
      sockwrite -n sendmail E-Mail: $readnick($readini(mail.ini,sendmail,nick),email))
      sockwrite -n sendmail Host: $readnick($readini(mail.ini,sendmail,nick),lasthost))
      sockwrite -n sendmail 
      sockwrite -n sendmail 
      sockwrite -n sendmail To activate this account and make full use of its features
      sockwrite -n sendmail please type /msg $netconf(system,nickname) TAC $readnick($readini(mail.ini,sendmail,nick),tac))
      sockwrite -n sendmail 
      sockwrite -n sendmail If you have any questions on SysOp Services please
      sockwrite -n sendmail see a helper in $netconf(system,helpchan)
      sockwrite -n sendmail 
      sockwrite -n sendmail If you have recieved this email in error, please disregard it
      sockwrite -n sendmail 
      sockwrite -n sendmail Thank you for using SysOp Services
      sockwrite -n sendmail .
    }
    if ($readini(mail.ini,sendmail,type) == newuser_web) {
      sockwrite -n sendmail From: "SysOp Services" < $+ $netconf(emails,services) $+ >
      sockwrite -n sendmail To: $readini(mail.ini,sendmail,address)
      sockwrite -n sendmail Subject: SysOp Services Nickname Registration
      sockwrite -n sendmail Date: $asctime
      sockwrite -n sendmail
      sockwrite -n sendmail Congratulations, You have successfully registered to SysOp
      sockwrite -n sendmail Services with the following information:
      sockwrite -n sendmail 
      sockwrite -n sendmail Nickname: $readini(mail.ini,sendmail,nick)
      sockwrite -n sendmail Pass: $decode($readnick($readini(mail.ini,sendmail,nick),password),m)
      sockwrite -n sendmail E-Mail: $readnick($readini(mail.ini,sendmail,nick),email))
      sockwrite -n sendmail 
      sockwrite -n sendmail 
      sockwrite -n sendmail To activate this account and make full use of its features
      sockwrite -n sendmail please vist $netconf(system,weblink) $+ ircx.asp?func=verify&key= $+ $readnick($readini(mail.ini,sendmail,nick),tac))
      sockwrite -n sendmail 
      sockwrite -n sendmail If requested please enter the activation code $readnick($readini(mail.ini,sendmail,nick),tac))
      sockwrite -n sendmail
      sockwrite -n sendmail If you have any questions on SysOp Services please
      sockwrite -n sendmail see a helper in $netconf(system,helpchan)
      sockwrite -n sendmail 
      sockwrite -n sendmail If you have recieved this email in error, please disregard it
      sockwrite -n sendmail 
      sockwrite -n sendmail Thank you for using SysOp Services
      sockwrite -n sendmail .
    }
    if ($readini(mail.ini,sendmail,type) == forgotpass) {
      sockwrite -n sendmail From: "SysOp Services" < $+ $netconf(emails,services) $+ >
      sockwrite -n sendmail To: $readini(mail.ini,sendmail,address)
      sockwrite -n sendmail Subject: SysOp Password Request
      sockwrite -n sendmail Date: $asctime
      sockwrite -n sendmail
      sockwrite -n sendmail Your Password was requested on IRC
      sockwrite -n sendmail IDENTIFY with the following information:
      sockwrite -n sendmail 
      sockwrite -n sendmail Nickname: $readini(mail.ini,sendmail,nick)
      sockwrite -n sendmail Pass: $decode($readnick($readini(mail.ini,sendmail,nick),password),m)
      sockwrite -n sendmail E-Mail: $readnick($readini(mail.ini,sendmail,nick),email))
      sockwrite -n sendmail Host: $readnick($readini(mail.ini,sendmail,nick),lasthost))
      sockwrite -n sendmail 
      sockwrite -n sendmail 
      sockwrite -n sendmail To login to your account >
      sockwrite -n sendmail please type /msg $netconf(system,nickname) IDENTIFY $decode($readnick($readini(mail.ini,sendmail,nick),password),m)
      sockwrite -n sendmail 
      sockwrite -n sendmail If you have any questions on SysOp Services please
      sockwrite -n sendmail see a helper in $netconf(system,helpchan)
      sockwrite -n sendmail 
      sockwrite -n sendmail If you have recieved this email in error, please disregard it
      sockwrite -n sendmail 
      sockwrite -n sendmail Thank you for using SysOp Services
      sockwrite -n sendmail .
    }
    if ($readini(mail.ini,sendmail,type) == note) {
      sockwrite -n sendmail From: "SysOp Services" < $+ $netconf(emails,services) $+ >
      sockwrite -n sendmail To: $readini(mail.ini,sendmail,address)
      sockwrite -n sendmail Subject: Note Received on IRC
      sockwrite -n sendmail Date: $asctime
      sockwrite -n sendmail
      sockwrite -n sendmail You have recived a new note on IRC sent to you by another user
      sockwrite -n sendmail To read your notes please login to IRC at irc:// $+ $netconf(system,irclink)
      sockwrite -n sendmail
      sockwrite -n sendmail To login to your account >
      sockwrite -n sendmail please type /msg $netconf(system,nickname) IDENTIFY <your password>
      sockwrite -n sendmail 
      sockwrite -n sendmail If you have any questions on SysOp Services please
      sockwrite -n sendmail see a helper in $netconf(system,helpchan) or type /msg $netconf(system,nickname) HELP
      sockwrite -n sendmail 
      sockwrite -n sendmail If you have recieved this email in error, please disregard it
      sockwrite -n sendmail 
      sockwrite -n sendmail Thank you for using SysOp Services
      sockwrite -n sendmail .
    }
    if ($readini(mail.ini,sendmail,type) == systemlogs) {
      sockwrite -n sendmail From: "SysOp Services" < $+ $netconf(emails,services) $+ >
      sockwrite -n sendmail To: $readini(mail.ini,sendmail,address)
      sockwrite -n sendmail Subject: IRC System Logs
      sockwrite -n sendmail Date: $asctime
      sockwrite -n sendmail
      sockwrite -n sendmail $netconf(system,nickname) was requested to send you the system logs for IRC.
      sockwrite -n sendmail These logs have been included, please see below.
      var %p 1
      var %x 1
      while ($findfile(logs,system_ $+ $netconf(system,currentdate) $+ *,%x)) {
        sockwrite -n sendmail
        sockwrite -n sendmail Log Filename: $remove($findfile(logs,system_ $+ $netconf(system,currentdate) $+ *,%x),$mircdirlogs\)
        while ($read(logs\ $+ $remove($findfile(logs,system_ $+ $netconf(system,currentdate) $+ *,%x),$mircdirlogs\),%p)) {
          sockwrite -n sendmail $read(logs\ $+ $remove($findfile(logs,system_ $+ $netconf(system,currentdate) $+ *,%x),$mircdirlogs\),%p)
          inc %p
        }
        inc %x
      }
      sockwrite -n sendmail 
      sockwrite -n sendmail If you have recieved this email in error, please disregard it
      sockwrite -n sendmail 
      sockwrite -n sendmail Thank you for using SysOp Services
      sockwrite -n sendmail .
    }

  }
  elseif ($1 == 221) { report Mail Socket Closed |  unset %sendmail* }
}
on *:SOCKREAD:sendnewmail:{
  sockread %sendmail
  tokenize 32 %sendmail
  echo - $1-
  if ($1 == 551 || $1 == 503 || $1 == 451) {  unset %sendmail* | sockclose sendnewmail }
  elseif ($1 == 501) { unset %sendmail* | sockclose sendnewmail }
  elseif (($1 == 220) && (%sendmailc == 1)) { report Mail Socket Open (Sending $readini(mail.ini,sendmail,type) message to $readini(mail.ini,sendmail,address) $+ ) | sockwrite -n sendnewmail HELO irc.btctech.co.uk | inc %sendmailc }
  elseif ((%sendmailc == 2) && ($1 == 250)) { 
    sockwrite -n sendnewmail AUTH LOGIN
    inc %sendmailc
  }
  elseif ((%sendmailc == 3) && ($1 == 334)) { 
    sockwrite -n sendnewmail $encode(service@btctech.co.uk, m)
    inc %sendmailc
  }
  elseif ((%sendmailc == 4) && ($1 == 334)) { 
    sockwrite -n sendnewmail $encode(M1llyjt859597B, m)
    inc %sendmailc
  }
  elseif (($1 == 250) && (%sendmailc == 5)) { sockwrite -n sendnewmail MAIL FROM: < $+ $netconf(emails,services) $+ > | inc %sendmailc }
  elseif (($1 == 250) && (%sendmailc == 6)) { sockwrite -n sendnewmail RCPT TO: < $+ $readini(mail.ini,sendmail,address) $+ > | inc %sendmailc }
  elseif (($1 == 250) && (%sendmailc == 7)) { sockwrite -n sendnewmail DATA | inc %sendmailc }
  elseif (($1 == 250) && (%sendmailc == 8)) { sockwrite -n sendnewmail QUIT }
  elseif ($1 == 354) {
    if ($readini(mail.ini,sendmail,type) == newemail) {
      sockwrite -n sendnewmail From: "SysOp Services" < $+ $netconf(emails,services) $+ >
      sockwrite -n sendnewmail To: $readini(mail.ini,sendmail,address)
      sockwrite -n sendnewmail Subject: SysOp Services Edit Email Verification
      sockwrite -n sendnewmail Date: $asctime
      sockwrite -n sendnewmail
      sockwrite -n sendnewmail Almost Done, To change your email address please login to IRC and IDENTIFY
      sockwrite -n sendnewmail Take Note of the following information:
      sockwrite -n sendnewmail 
      sockwrite -n sendnewmail Nickname: $readini(mail.ini,sendmail,nick)
      sockwrite -n sendnewmail NEW E-Mail: $readnick($readini(mail.ini,sendmail,nick),newemail))
      sockwrite -n sendnewmail Host: $readnick($readini(mail.ini,sendmail,nick),lasthost))
      sockwrite -n sendnewmail 
      sockwrite -n sendnewmail 
      sockwrite -n sendnewmail To activate this new email >
      sockwrite -n sendnewmail please type /msg $netconf(system,nickname) EDITEMAIL <password> VERIFY $readnick($readini(mail.ini,sendmail,nick),tac))
      sockwrite -n sendnewmail 
      sockwrite -n sendnewmail If you have any questions on SysOP Services please
      sockwrite -n sendnewmail see a helper in $netconf(system,helpchan)
      sockwrite -n sendnewmail 
      sockwrite -n sendnewmail If you have recieved this email in error, please disregard it
      sockwrite -n sendnewmail 
      sockwrite -n sendnewmail Thank you for using SysOp Services
      sockwrite -n sendnewmail .
    }
    if ($readini(mail.ini,sendmail,type) == newemail_web) {
      sockwrite -n sendnewmail From: "SysOp Services" < $+ $netconf(emails,services) $+ >
      sockwrite -n sendnewmail To: $readini(mail.ini,sendmail,address)
      sockwrite -n sendnewmail Subject: SysOp Services Edit Email Verification
      sockwrite -n sendnewmail Date: $asctime
      sockwrite -n sendnewmail
      sockwrite -n sendnewmail Almost Done, To change your email address please visit the web link below.
      sockwrite -n sendnewmail Take Note of the following information:
      sockwrite -n sendnewmail 
      sockwrite -n sendnewmail Nickname: $readini(mail.ini,sendmail,nick)
      sockwrite -n sendnewmail NEW E-Mail: $readnick($readini(mail.ini,sendmail,nick),newemail))
      sockwrite -n sendnewmail Host: $readnick($readini(mail.ini,sendmail,nick),lasthost))
      sockwrite -n sendnewmail 
      sockwrite -n sendnewmail 
      sockwrite -n sendnewmail To activate this new email >
      sockwrite -n sendnewmail please visit www.digi-net.org/irc_set.asp?func=verify&key= $+ $readnick($readini(mail.ini,sendmail,nick),tac))
      sockwrite -n sendnewmail 
      sockwrite -n sendnewmail If you have any questions on SysOP Services please
      sockwrite -n sendnewmail see a helper in $netconf(system,helpchan)
      sockwrite -n sendnewmail 
      sockwrite -n sendnewmail If you have recieved this email in error, please disregard it
      sockwrite -n sendnewmail 
      sockwrite -n sendnewmail Thank you for using SysOp Services
      sockwrite -n sendnewmail .
    }
  }
  elseif ($1 == 221) { report Mail Socket Closed |  unset %sendmail* }
}
