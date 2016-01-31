namespace :es do

  task reload: :environment do
    Page.__elasticsearch__.create_index! force: true
    Page.__elasticsearch__.refresh_index!
    Page.import
  end

end
