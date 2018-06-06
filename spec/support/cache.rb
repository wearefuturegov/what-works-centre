RSpec.configure do |config|
  config.after(:each, cache: true) do
    Rails.cache.clear
  end
  
  config.after(:each, preview: true) do
    ContentfulModel.use_preview_api = false
  end
end
