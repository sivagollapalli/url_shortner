class Visit < ApplicationRecord
  belongs_to :short_url

  after_commit do |visit|
    url = visit.short_url
    url.update_attributes(visits_count: url.visits_count.to_i + 1)
  end
end
