class ReportsController < ApplicationController

  def index

  end

  def workers_report
    if permit_workers_report[:worker_id] == 'all'
      @workers_report = Worker.all.map do |worker|
        worker_report_json(worker, permit_workers_report[:start_date], permit_workers_report[:end_date])
      end
    else
      @workers_report = [worker_report_json(Worker.find(permit_workers_report[:worker_id]), permit_workers_report[:start_date], permit_workers_report[:end_date])]
    end
  end

  private

  def permit_workers_report
    params.require(:workers_report).permit(:start_date, :end_date, :worker_id)
  end

  def worker_report_json(worker, start_date, end_date)
    payrolls = worker.payrolls.where("date IN (?)", start_date.to_date..end_date.to_date)
    {
      worker: worker,
      total_sum: payrolls.sum(&:sum)
    }
  end

end
