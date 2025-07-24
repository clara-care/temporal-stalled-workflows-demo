require "temporalio/client"
require_relative "../workflows/demo_timers_workflow"

namespace "temporal" do
  desc "Run the DemoTimersWorkflow"
  task :run_timers_demo, [:temporal_address, :temporal_namespace, :count] do |t, args|
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
      current_time = Time.now.utc
      results = workflow_ids.map do |workflow_id|
        workflow_desc = client.workflow_handle(workflow_id).describe
        {
          workflow_id:,
          elapsed: current_time - start_time,
          is_done: !workflow_desc.close_time.nil?
        }
      end

      results.filter { !_1[:is_done] }.each do |result|
        puts <<~REPORT.tr("\n", " ")
          workflow_id=#{result[:workflow_id]},
          elapsed=#{result[:elapsed].round(2)}s
        REPORT
      end
      finished_workflow_ids = results.filter_map { _1[:workflow_id] if _1[:is_done] }
      puts "Finished: #{finished_workflow_ids.join(",")}" unless finished_workflow_ids.empty?

      break if finished_workflow_ids.count == workflow_ids.count
      sleep(2)
    end

    puts "DONE"

    workflow_ids.each do |id|
      close_time = client.workflow_handle(id).describe.close_time
      duration = close_time - start_time
      puts "Workflow '#{id}' completed at #{close_time} after #{duration}"
    end
  end

  def workflow_id_from_value(value)
    "demo-timers-#{value}"
  end
end
