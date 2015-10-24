#!/usr/bin/env python
# -*- coding:utf-8 -*-
 
#-----------------------------------------------------------
# Usage: 
# $Id: mail.py  me@annhe.net  2015-10-09 12:52:53 $
#-----------------------------------------------------------
 
#导入smtplib and MIMEText
import smtplib
from email.mime.text import MIMEText
from email.mime.image import MIMEImage
from email.MIMEMultipart import MIMEMultipart
import ConfigParser

#解析配置文件
config = ConfigParser.ConfigParser()
config.read("conf.ini")

mail_host=config.get("mailserver", "server")
mail_user=config.get("mailserver", "user")
mail_pass=config.get("mailserver", "passwd")
mail_postfix=config.get("mailserver", "postfix")
mailto_list=config.get("send", "mailto_list").split(",")
mailcc_list=config.get("send", "mailcc_list").split(",")


#####################

def HtmlContent(info,url='',url_msg='',url_img=''):

	content='''
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf8" />
<title>Demo: CSS3 Buttons</title>
<style type="text/css">

.download {
	display: inline-block;
	margin-top: 20px;
	padding: 15px;
	font-size: 26px;
	font-weight: bold;
	color: #fff;
	text-shadow: none;
	border-radius: 4px;
	-webkit-animation-name: fadeIn;
	-moz-animation-name: fadeIn;
	-ms-animation-name: fadeIn;
	-o-animation-name: fadeIn;
	animation-name: fadeIn;
	-webkit-animation-delay: .9s;
	-webkit-animation-fill-mode: both;
	-webkit-animation-duration: 1.2s;
	-webkit-animation-iteration-count: 1;
	-webkit-animation-timing-function: ease;
	-webkit-transition: all 0.3s ease;
	-moz-transition: all 0.3s ease;
	-o-transition: all 0.3s ease;
	transition: all 0.3s ease;
}

.download:hover {
	-webkit-transform: scale(1.1);
	-moz-transform: scale(1.1);
	-o-transform: scale(1.1);
	transform: scale(1.1);
}

a {
text-decoration: none;
}


div.twitter {
	font-size: 20px;
	padding: 5px;
	color: #fff;
	background: #2da1ec;
	border-radius: 3px;
}

div.twitter:hover {
	color: #fff;
	background: #2eacff;
}

div.twitter:active {
	top: 1px;
}

  padding: 0px 20.48px;
}



</style>	<body>

<div>
</div>
<!--	 <div class="twitter" data-tip="twitter"> -->
 <table width="750" border="1" cellpadding="0" cellspacing="0" style="border:0px solid #ff0000">
			%s
		</table>
<!--	 </div> -->

<br>
<br>
<a href="%s">%s</a>
<br>
<br>
<br>
<img src="%s" />
<br>
</body>
</html>

'''%(info,url,url_msg,url_img)
	return content

def send_mail(to_list,sub,content,cc=mailcc_list,att_file = '',img = ''):

	'''
	to_list:
	sub:
	content:
	att_file:
	send_mail("rfyiamcool@163.com","sub","content","/var/www/html/report/KVM.xls")
	'''
	me = mail_user + "<"+mail_user+"@"+mail_postfix+">"
	msg = MIMEMultipart()
	msg['Subject'] = sub

	if(att_file != ''):
			att = MIMEText(open(att_file,'rb').read(),'base64','gb2312')
			att["Content-Type"] = 'application/octet-stream'
			att_file = ''.join(att_file.split('/')[-1:])
			att["Content-Disposition"] = "attachment;filename=%s" %att_file
			msg.attach(att)
	if(img != ''):
			msg_image = MIMEImage(open(img,'rb').read())
			msg_image.add_header('Content-ID',"<%s>" %img);
			msg.attach(msg_image)
			content += "<td><img src='cid:%s'></td>" %img

	body = MIMEText(content,_subtype='html',_charset='utf8')
	msg.attach(body)

	msg['From'] = mail_user + "<" + mail_user + "@" + mail_postfix + ">"
	msg['To'] = ";".join(to_list)
	msg['Cc'] = ";".join(cc)

	print(msg['To'])
	try:
		s = smtplib.SMTP()
		s.connect(mail_host)
		s.login(mail_user,mail_pass)
		s.sendmail(me, to_list, msg.as_string())
		s.close()
		return True
	except Exception, e:
		print str(e)
		return False


if __name__ == '__main__':

	content = HtmlContent('测试');
	if send_mail(mailto_list,'测试',content,mailcc_list,'',''):
		print "success"
	else:
		print "fail"
