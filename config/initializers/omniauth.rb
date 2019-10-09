#When a user wants to sign in using google, this is the method that ensures that the user is taken to the correct OAuth Consent Screen
#that has information like the developer's email, the app's privacy policy etc.
#This is possible because the GOOGLE_CLIENT_ID and the GOOGLE_CLIENT_SECRET are unique to our app.
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV['GOOGLE_CLIENT_SECRET']
end
