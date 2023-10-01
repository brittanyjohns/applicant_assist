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

  def display_message_accordion_for(chat, subjects = [])
    if subjects.empty?
      subjects = chat.message_types
    end
    message_list = []
    message_list << "<div class='accordion' id='accordionExample'>"
    subjects.each do |subject|
      id_name = subject.downcase.split.join("_")
      message_list << "<div id='#{id_name}' class='accordion-item'>"
      message_list << "<h2 class='accordion-header'>"
      message_list << "<button class='accordion-button' type='button' data-bs-toggle='collapse' data-bs-target='#collapse#{id_name}' aria-expanded='true' aria-controls='collapse#{id_name}'>"
      message_list << "#{subject}"
      message_list << "</button>"
      message_list << "</h2>"
      message_list << "<div id='collapse#{id_name}' class='accordion-collapse collapse' aria-labelledby='heading#{id_name}' data-bs-parent='#accordionExample'>"
      message_list << "<div id='accordion_body_#{id_name}' class='accordion-body'>"
      message_list << "#{chat.message_for(subject)}"
      message_list << "</div>"
      message_list << "</div>"
      message_list << "</div>"
    end
    message_list << "</div>"
    message_list.join("").html_safe
  end

  def print_grid(messages, columns = 3, show_edit_btn = false)
    str = ""

    messages.each_slice(columns) do |batch|
      str += "<div class='row'>"
      batch.each do |message|
        id_name = message.subject.downcase.split.join("_")
        next unless message.id
        str += "<div id='#{id_name}' class='scrolling-details col-md-#{12 / columns}'>"
        str += "<h3>#{message.subject}</h3>"
        if message.displayed_content && message.displayed_content.body
          puts "MESSAGE: #{message.displayed_content.body}"
          str += "<p class='lead'>MSG ID: #{message.id}</p>"
          str += message.displayed_content.body.to_trix_html
        else
          str += "<p>No #{message.subject} yet</p>"
        end
        str += "</div>"
      end
      str += "</div>"
    end
    str.html_safe
  end
end
