require "temporalio/workflow"

class DemoTimersWorkflow < Temporalio::Workflow::Definition
  workflow_query_attr_reader :done

  def execute(params)
    Temporalio::Workflow.logger.info "Started demo timers workflow"

    5.times.each do |i|
      timer_fut(seconds: 1).wait
    end

    Temporalio::Workflow.logger.info "Finished demo timers workflow"
  end

  def timer_fut(seconds:)
    Temporalio::Workflow::Future.new do
      Temporalio::Workflow.logger.info "Timer starting"
      sleep(seconds)
      Temporalio::Workflow.logger.info "Timer finished"
      seconds
    end.tap do
      Temporalio::Workflow.logger.info "Timer created"
    end
  end
end
