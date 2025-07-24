require "temporalio/workflow"
require_relative "../activities/say_hello_activity"

class SayHelloWorkflow < Temporalio::Workflow::Definition
  def execute(name)
    Temporalio::Workflow.logger.info "Starting hello workflow"
    Temporalio::Workflow.execute_activity(
      SayHelloActivity,
      name,
      schedule_to_close_timeout: 300
    )
    Temporalio::Workflow.logger.info "Finished hello workflow"
  end
end
