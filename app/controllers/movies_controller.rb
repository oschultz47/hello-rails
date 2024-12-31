class MoviesController < ApplicationController
  before_action :set_movie, only: %i[show edit update destroy]  # This should work as intended
  
  ALLOWED_COLUMNS = %w[title release_date rating]
  ALLOWED_DIRECTIONS = %w[asc desc]

  def index
    # Retrieve or set default sorting parameters
    sort_by = validate_column(params[:column]) || session[:sort_by] || 'title'
    
    # Handle sorting direction
    if params[:column].present?
      # Toggle direction when clicking on the same column
      if session[:sort_by] == params[:column]
        direction = session[:direction] == 'asc' ? 'desc' : 'asc'
      else
        direction = 'asc' # Default to 'asc' when switching to a new column
      end
      
      # Update session values with the new column and direction
      session[:sort_by] = params[:column]
      session[:direction] = direction
    else
      # If no column parameter is provided, use the session values
      direction = session[:direction] || 'asc'
    end

    # Fetch movies sorted according to validated values
    @movies = Movie.order(sort_by => direction)

    # Pass the current sort and direction to the view
    @sort_by = sort_by
    @direction = direction
  end

  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: "Movie was successfully updated." }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy!

    respond_to do |format|
      format.html { redirect_to movies_path, status: :see_other, notice: "Movie was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_movie
    @movie = Movie.find(params.require(:id))  # Ensure we are finding the movie by ID
  end

  def movie_params
    date_params = params[:movie].permit(:release_day, :release_month, :release_year)
    release_date = Date.new(date_params[:release_year].to_i, date_params[:release_month].to_i, date_params[:release_day].to_i) rescue nil
  
    params[:movie][:release_date] = release_date
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def validate_column(column)
    ALLOWED_COLUMNS.include?(column) ? column : nil
  end
  
  def validate_direction(direction)
    ALLOWED_DIRECTIONS.include?(direction) ? direction : nil
  end
end
