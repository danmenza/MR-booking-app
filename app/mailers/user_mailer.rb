require 'aws-sdk-ses'

class UserMailer < ApplicationMailer
    
    def reservation_confirmation_email(reservation, subject, sender, recipient)
        html_body = render_to_string(:partial =>   'user_mailer/reservation_confirmation.html.erb', :layout => false, :locals => {:reservation => reservation})
    
        send_email(subject, html_body, sender, recipient)
    end

    def send_email (subject, html_body, sender, recipient)
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
                    recipient,
                    ],
                    },
                message: {
                    body: {
                    html: {
                    charset: encoding,
                    data: html_body,
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
