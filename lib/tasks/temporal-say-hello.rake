require "temporalio/client"
require_relative "../workflows/say_hello_workflow"

namespace "temporal" do
  desc "Run the SayHelloWorkflow"
  task :say_hello, [:temporal_address, :temporal_namespace, :name] do |t, args|
    # Create a client
    client = Temporalio::Client.connect(args.temporal_address, args.temporal_namespace)

    # Run workflow
    workflow_id = "say-hello-to-#{args.name.downcase.sub(" ", "-")}"
    start_time = Time.now.utc
    client.start_workflow(
      SayHelloWorkflow,
      args.name,
      id: workflow_id,
      task_queue: "default"
    )

    while client.workflow_handle(workflow_id).describe.close_time.nil?
      sleep 1
    end
    end_time = client.workflow_handle(workflow_id).describe.close_time
    puts "Workflow #{workflow_id} closed (duration #{end_time - start_time}s)"
  end
end
