import chardet
import datetime
from email.message import EmailMessage
import imaplib
import re
import smtplib
import time

from tools.misc import eprint

def get_smtp_conn(smtp_server, user=None, password=None):
    for retry in range(5):
        try:
            smtp = smtplib.SMTP(smtp_server)
        except smtplib.SMTPConnectError as e:
            if retry == 4 or e.smtp_code != 421:
                raise
            time.sleep(20)
    if user is not None:
        smtp.starttls()
        smtp.login(user, password)
    return smtp

def send_mail(smtp_server, from_, to_, subject, body):
    msg = EmailMessage()
    body += f"\n{datetime.datetime.now()}\n"
    msg.set_content(body)
    msg['Subject'] = subject
    msg['From'] = from_
    msg['To'] = to_
    smtp = get_smtp_conn(smtp_server)
    smtp.send_message(msg)
    smtp.quit()

def search_inbox(host, user, password, since_date, subject_searchstring,
                 handler_fn, delete_handled_messages):
    '''
    since_date: Search only today (good for tests): datetime.date.today()
    '''
    if since_date is None:
        since_date = datetime.date(1980, 1, 1)
    since_date_str = since_date.strftime("%d-%b-%Y")
    imap = imaplib.IMAP4_SSL(host)
    imap.login(user, password)
    imap.select("INBOX")

    eprint('Since date', since_date)
    _, data = imap.search(None, f"NOT BEFORE {since_date_str}")
    for num in data[0].split():
        resp, data = imap.fetch(num, '(RFC822)')
        try:
            msg = data[0][1]
            msg = msg.decode(chardet.detect(msg)['encoding']).rstrip()
            mo = re.search('^Subject: (.*)', msg, re.MULTILINE)
            if mo is not None:
                subject = mo.group(1)
                if subject_searchstring not in subject:
                    continue
            if handler_fn(msg) and delete_handled_messages:
                imap.store(num, '+FLAGS', '\\Deleted')
        except TypeError:
            eprint('error: resp:', resp, 'data', data)
            raise

    if delete_handled_messages:
        imap.expunge()
    imap.logout()
