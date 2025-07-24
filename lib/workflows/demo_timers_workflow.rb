require "temporalio/workflow"

class DemoTimersWorkflow < Temporalio::Workflow::Definition
  workflow_query_attr_reader :done

  def execute(params)
    Temporalio::Workflow.logger.info "Started demo timers workflow"

    5.times.each do |i|
      # futures = [timer_fut(label: "1", seconds: 5)]
      # Temporalio::Workflow::Future.any_of(*futures).wait
      timer_fut(label: "1", seconds: 5).wait
    end

    Temporalio::Workflow.logger.info "Finished demo timers workflow"
  end

  def timer_fut(label:, seconds:)
    Temporalio::Workflow::Future.new do
      Temporalio::Workflow.logger.info "Timer #{label} - starting"
      sleep(seconds)
      Temporalio::Workflow.logger.info "Timer #{label} - finished"
      seconds
    end.tap do
      Temporalio::Workflow.logger.info "Timer #{label} - created"
    end
  end
end
