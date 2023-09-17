class JobSearchJob < ApplicationJob
  queue_as :default

  def perform(search_term)
    Indeed.new(search_term).search
  end
end
