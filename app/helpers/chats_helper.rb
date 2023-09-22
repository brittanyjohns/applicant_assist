module ChatsHelper
  def form_links(form, link_names, input_id = nil)
    link_list = []
    link_names.each do |link_name|
      input_id = link_name.downcase.split.join("_")
      link_list << form.submit(link_name, id: input_id, class: "btn btn-sm btn-dark")
    end
    link_list.join("").html_safe
  end
end
