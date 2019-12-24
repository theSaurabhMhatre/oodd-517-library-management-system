class LibraryMailer < ApplicationMailer
  default from: 'simplelibrary.manager@gmail.com'

  def success_mail
    @student = params[:student]
    mail(to: @student.email, subject: 'Book checked out')
  end
end
