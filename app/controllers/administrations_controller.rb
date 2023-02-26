class AdministrationsController < ApplicationController

  def zeroing_material_balances
    Material.find_each do |material|
      pp "id: #{material.id}, qty: #{material.qty}"
      material.qty = 0.0
      material.save!
    end

    redirect_to root_path
  end

  def increase_decrease_jobs_price
    Job.find_each do |job|
      pp "id: #{job.id}, price: #{job.price}"

      percent =  1 + (params[:percents].to_f / 100)

      job.price = (job.price * percent).round(2)

      job.save!
    end

    redirect_to root_path
  end


end
