module MessagesHelper
  def display_message_for(chat, subjects = [], class_name = "col-md-6 scrolling-details")
    if subjects.empty?
      subjects = chat.message_types
    end
    message_list = []
    subjects.each do |subject|
      id_name = subject.downcase.split.join("_")
      message_list << "<div id='#{id_name}' class='#{class_name}'>
          <h3>
            #{subject}
          </h3>
          #{chat.message_for(subject)}
        </div>"
    end
    message_list.join("").html_safe
  end

  def print_grid(messages, columns = 4, show_edit_btn = false)
    str = ""
    messages.each_slice(columns) do |batch|
      str += "<div class='row'>"
      batch.each do |message|
        next unless message.id
        str += display_message_for(message.chat)
      end
      str += "</div>"
    end
    str.html_safe
  end
end
