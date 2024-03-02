json.extract! import, :id, :log_file, :status, :created_at, :updated_at
json.url import_url(import, format: :json)
json.log_file url_for(import.log_file)
