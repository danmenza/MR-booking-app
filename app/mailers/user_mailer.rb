require 'aws-sdk-ses'

class UserMailer < ApplicationMailer
    
    def reservation_confirmation_email(reservation, subject, sender)
        # The HTML body of the email
        receiver = reservation.user.email
        htmlbody = render_to_string(:partial =>   'user_mailer/email_template.html.erb', :layout => false, :locals => {:reservation => reservation})
    
        # send email
        send_email(receiver, sender, subject, htmlbody)
    end
    def send_email (receiver, sender, subject, htmlbody)
    region = "us-east-1"

    # Specify the text encoding scheme.
    encoding = "UTF-8" 
    # configure SES session
    ses = Aws::SES::Client.new(
        region: region,
        access_key_id: "AKIAS2BQNZKETQ2DFZ7C", 
        secret_access_key: "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"
    )

        begin
            ses.send_email({
                destination: {
                    to_addresses: [
                    receiver,
                    ],
                    },
                message: {
                    body: {
                    html: {
                    charset: encoding,
                    data: htmlbody,
                    }
                    },
                subject: {
                    charset: encoding,
                    data: subject,
                },
                },
                source: sender,
                })
            puts "Email sent!"
        rescue Aws::SES::Errors::ServiceError => error
            puts "Email not sent. Error message: #{error}"
        end
    end
end
