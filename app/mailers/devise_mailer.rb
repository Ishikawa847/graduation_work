class DeviseMailer < Devise::Mailer
  def reset_password_instructions(record, token, opts = {})
    reset_url = edit_user_password_url(reset_password_token: token)

    Resend::Emails.send({
      from: "no-reply@my-muscle-meal.com",
      to: record.email,
      subject: "パスワードリセット",
      html: "<p>こちらからリセットしてください</p><a href='#{reset_url}'>リセット</a>"
    })
  end
end