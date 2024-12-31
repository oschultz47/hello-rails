class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]

  # GET /movies or /movies.json
  def index
    # Retrieve sort parameters from session or set defaults if not present
    sort_by = session[:sort_by] || 'title'
    direction = session[:direction] || 'asc'

    # If sorting parameters are passed (by clicking on a column), update the session
    if params[:column].present?
      # Toggle direction between 'asc' and 'desc' each time the same column is clicked
      if session[:sort_by] == params[:column]
        direction = (session[:direction] == 'asc' ? 'desc' : 'asc')
      else
        direction = 'asc'  # Default direction is 'asc' when a new column is sorted
      end

      # Update session values with new sorting parameters
      session[:sort_by] = params[:column]
      session[:direction] = direction
    end

    # Fetch movies sorted according to session values
    @movies = Movie.order(session[:sort_by] => session[:direction])

    # Pass the current sort and direction to the view to highlight active column
    @sort_by = session[:sort_by]
    @direction = session[:direction]
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
      @movie = Movie.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.expect(movie: [ :title, :rating, :description, :release_date ])
    end
end
