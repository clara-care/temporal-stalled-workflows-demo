require "temporalio/client"
require_relative "../workflows/say_hello_workflow"

namespace "temporal" do
  desc "Run the SayHelloWorkflow"
  task :say_hello, [:temporal_address, :temporal_namespace, :name] do |t, args|
    # Create a client
    client = Temporalio::Client.connect(args.temporal_address, args.temporal_namespace)

    # Run workflow
    result = client.execute_workflow(
      SayHelloWorkflow,
      args.name,
      id: "say-hello-to-#{args.name.downcase.sub(" ", "-")}",
      task_queue: "default"
    )
    puts "Result: #{result}"
  end
end
