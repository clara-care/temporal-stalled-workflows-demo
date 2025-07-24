require "temporalio/client"
require_relative "../workflows/demo_timers_workflow"

namespace "temporal" do
  desc "Run the DemoTimersWorkflow"
  task :run_timers_demo, [:temporal_address, :temporal_namespace, :count] do |t, args|
    # Create a client
    client = Temporalio::Client.connect(args.temporal_address, args.temporal_namespace)

    values = args[:count].to_i.times.map { Random.random_number(1..1_000) }

    start_time = Time.now.utc
    values.each do |value|
      workflow_id = workflow_id_from_value value
      client.start_workflow(
        DemoTimersWorkflow,
        {id: value},
        id: workflow_id,
        task_queue: "default"
      )
      puts "Started #{workflow_id}"
    end
    workflow_ids = values.map { workflow_id_from_value _1 }

    loop do
      results = all_workflows_done?(client, workflow_ids)
      puts results
      break if results.map { _1[:result] }.all?
      sleep(5)
    end

    workflow_ids.each do |id|
      close_time = client.workflow_handle(id).describe.close_time
      duration = close_time - start_time
      puts "Workflow '#{id}' completed at #{close_time} after #{duration}"
    end
  end

  def workflow_id_from_value(value)
    "demo-#{value}"
  end

  def all_workflows_done?(client, workflow_ids)
    workflow_ids.map { {workflow_id: _1, result: workflow_done?(client, _1)} }
  end

  def workflow_done?(client, workflow_id)
    client.workflow_handle(workflow_id).describe.close_time != nil
  end
end
