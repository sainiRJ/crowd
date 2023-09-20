class UserMailer < ApplicationMailer
    def send_otp(email, otp)
        puts "this is method from mailer"
        email = email
        @otp = otp
        mail(to: email, subject: 'Your OTP Code')
      end
  end
 