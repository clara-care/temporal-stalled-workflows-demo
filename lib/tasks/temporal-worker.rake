require "temporalio/client"
require "temporalio/worker"
require_relative "../activities/say_hello_activity"
require_relative "../workflows/say_hello_workflow"
require_relative "../workflows/demo_state_machine_workflow"
require_relative "../workflows/demo_timers_workflow"

namespace "temporal" do
  desc "Run the Temporal worker"
  task :run_worker, [:address, :namespace] do |t, args|
    puts "Starting worker: address=#{args.address}, namespace=#{args.namespace}"

    STDOUT.sync = true
    logger = Logger.new(STDOUT)
    logger.level = Logger::DEBUG

    # Create a client
    client = Temporalio::Client.connect(args.address, args.namespace)

    # Create a worker with the client, activities, and workflows
    worker = Temporalio::Worker.new(
      client:,
      task_queue: "default",
      workflows: [SayHelloWorkflow, DemoStateMachineWorkflow, DemoTimersWorkflow],
      activities: [SayHelloActivity],
      logger:
    )

    # Run the worker until SIGINT. This can be done in many ways, see "Workers" section for details.
    worker.run(shutdown_signals: ["SIGINT"])
  end
end
