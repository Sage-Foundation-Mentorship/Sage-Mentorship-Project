class SupersController < ApplicationController
  before_action :require_login
  before_action :authorize_super
  def index
  end

  def new
  end

  def show
    @schools = School.all
    @mentors = Mentor.all
    @admins = Admin.all
    @supers = Super.all
  end

  def delete
  end
end
