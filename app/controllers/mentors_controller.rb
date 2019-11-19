class MentorsController < ApplicationController

  before_action :set_mentor, only: [:show, :edit, :update, :destroy]

  # GET /mentor/checkin
  def checkin
  end

  # GET /mentor/checkout
  def checkout
  end

  # GET /mentors
  # GET /mentors.json
  def index
    @mentors = Mentor.all
    Rails.logger.debug params.keys
  end

  # GET /mentors/1
  # GET /mentors/1.json
  def show

    @present_week = Time.current.beginning_of_week.utc
    @week_of = Time.zone.parse("0:0am Oct 21st, 2019").utc

    totalhours = @mentor.totalhours(@week_of)
    @num_hours = totalhours[:num_hours]
    @forgot_checkout = totalhours[:forgot_checkout]

    @attendences_list = @mentor.attendences(@week_of)

    @complete_attendences_list = []
    @mentor.checkins.each do |checkin|
        checkout = checkin.correspond_checkout
        @complete_attendences_list.push({checkin:checkin, checkout:checkout})
    end

  end

  # GET /mentors/new
  def new
    @mentor = Mentor.new
  end

  # GET /mentors/1/edit
  def edit
  end

  # POST /mentors
  # POST /mentors.json
  def create
    @mentor = Mentor.new(mentor_params)
    @current_user = Super.find(session[:user_id])
    respond_to do |format|
      if @mentor.save
        format.html { redirect_to @current_user, notice: "Mentor #{@mentor.name} was successfully created." }
        format.json { render :show, status: :created, location: @mentor }
      else
        format.html { render :new }
        format.json { render json: @mentor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mentors/1
  # PATCH/PUT /mentors/1.json
  def update
    @current_user = Super.find(session[:user_id])
    respond_to do |format|
      if @mentor.update(mentor_params)
        format.html { redirect_to @current_user, notice: "Mentor #{@mentor.name} was successfully updated." }
        format.json { render :show, status: :ok, location: @mentor }
      else
        format.html { render :edit }
        format.json { render json: @mentor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mentors/1
  # DELETE /mentors/1.json
  def destroy
    @mentor.destroy
    @current_user = Super.find(session[:user_id])
    respond_to do |format|
      format.html { redirect_to @current_user, notice: "Mentor #{@mentor.name} was successfully deleted." }
      format.json { head :no_content }
    end
  end

  def checkin

   #@mentor = Mentor.find(params[:id])
   @time = Time.now
   puts "----hellocheckin-----"
    puts params
    @mentor = Mentor.find(params[:id])
    puts @mentor.name
    @lat = params[:la]
    @lon = params[:lo]
    @chk_in = Checkin.new(:mentor_id => @mentor.id, :school_id =>@mentor.school_id, :checkin_time=> Time.now, :lat => @lat, :lon => @lon)
    if @chk_in.save
        flash[:notice] = 'Checkin succesful' 
    else
      redirect_to mentor_path
      flash[:notice] = 'something wrong, please try again' 
    end
  end
  

  def checkout
    puts "----hello-----"
    puts params
    @mentor = Mentor.find(params[:id])
    @time = Time.now
    @lat = params[:la]
    @lon = params[:lo]
    @chk_out = Checkout.new(:mentor_id => @mentor.id, :school_id =>@mentor.school_id, :checkout_time=> Time.now, :lat => @lat, :lon => @lon, :ischeckout => true)
    if @chk_out.save
        flash[:notice] = 'Checkout succesful' 
    else
      redirect_to mentor_path
      flash[:notice] = 'something wrong, please try again' 
    end
  end

  def appointment
    @mentor = Mentor.find(params[:id])
    #session[:user_id] = @mentor.id
  end

 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mentor
      @mentor = Mentor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mentor_params
      params.require(:mentor).permit(:name, :email, :school_id)
    end

    
end
