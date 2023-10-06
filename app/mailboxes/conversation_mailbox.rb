class ConversationMailbox < ApplicationMailbox
  def process
    conversation = Conversation.create(subject: mail.subject, contact: contact)
    new_post = conversation.posts.create!(
      author: contact,
      body: body,
      email_message_id: mail.message_id,
    )
    job_web_id = new_post.get_job_id_from_email
    Rails.logger.debug "job_web_id: #{job_web_id}"
    job = Job.find_by(job_web_id: job_web_id)
    Rails.logger.debug "job: #{job}"
    if job
      Rails.logger.debug "job found"
    else
      Rails.logger.debug "job not found"
      job = Job.create(job_web_id: job_web_id, title: mail.subject) if job_web_id
      new_application = job.applications.create!(user: user) if job
    end
    Rails.logger.debug "returning job: #{job}"
  end
end
