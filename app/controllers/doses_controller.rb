class DosesController < ApplicationController
  def create
    @cocktail = Cocktail.find(params[:cocktail_id])
    @dose = Dose.new(dose_params)
    @dose.cocktail = @cocktail
    if @dose.save
      redirect_to cocktail_path(@dose.cocktail)
    else
      render "cocktails/show", status: :unprocessable_entity
    end
  end

  def destroy
    @dose = Dose.find(params[:id])
    @dose.destroy
    redirect_to cocktail_path(@dose.cocktail), notice: 'Dose is deleted.'
  end

  private

  def dose_params
    params.require(:dose).permit(:description, :ingredient_id)
  end
end
