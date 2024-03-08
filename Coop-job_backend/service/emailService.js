const nodemailer = require('nodemailer');

// สร้าง transporter โดยใช้ข้อมูลจาก Ethereal
const transporter = nodemailer.createTransport({
    host: 'smtp.ethereal.email',
    port: 587,
    auth: {
        user: 'alva.nader65@ethereal.email',
        pass: 'T1mqvyskk9dtQcDVmZ'
    }
});

// ส่งอีเมล
transporter.sendMail({
  from: '"Your Name" <your-email@example.com>',
  to: 'ploythanat1@gmail.com',
  subject: 'Hello ✔',
  text: 'Hello world?',
  html: '<b>Hello world?</b>'
}, (error, info) => {
  if (error) {
      return console.log(error);
  }
  console.log('Message sent: %s', info.messageId);

  // ดูข้อความทดสอบและ URL ของ Ethereal
  console.log('Preview URL: %s', nodemailer.getTestMessageUrl(info));
});
