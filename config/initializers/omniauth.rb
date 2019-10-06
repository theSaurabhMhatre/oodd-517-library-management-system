Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['505074681900-s0g5lp6doj2a9l5jpvnei5jg1vn1anj9.apps.googleusercontent.com'], ENV['Hbgvra6v8etxZo8ltpJY3ljy']
end
