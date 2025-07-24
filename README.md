- Copied `docker-compose.yml` from [`temporalio/docker-compose/docker-compose-postgres.yml`](https://github.com/temporalio/docker-compose/blob/main/docker-compose-postgres.yml)
- Added a worker service and worker `Dockerfile`
- Copied `SayHelloWorkflow` and `SayHelloActivity`
- Copied `worker.rb` into `lib/tasks/temporal-worker.rake`

# Demo SDK Ruby - Stalled Workflows

This repository demonstrates a case where Temporal workflows built on the [Ruby SDK](https://github.com/temporalio/sdk-ruby) become "stuck" waiting on a future. In the demo, a `Temporalio::Workflow::Future` instance wraps a simple call to `sleep` (other methods like `wait_condition` may or may not be affected).

## Setup

- Ruby >= 3.3
- Docker (or Podman)
- docker-compose (or podman-compose)

[`Devbox`](https://www.jetify.com/docs/devbox/) configuration is provided to allow the demo development environment to be recreated more precisely. Alternatively, any Ruby environment manager (rbenv, mise) should suffice.

## Instructions

- `bundle install --without=development,test` - install the ruby dependencies
- `docker-compose up -d` - launch the temporal infrastructure and worker(s)
- `rake temporal:run_timers_demo[localhost:7233,default,10]` - start 10 copies of the `DemoTimersWorkflow`, then poll waiting for all 10 workflows to close

## Demo example



### Normal workflow

![Screenshot 2025-07-24 at 4 06 52 PM](https://github.com/user-attachments/assets/8b0b4629-7556-4608-a2bb-9a27e531c24d)

### Stalled workflow

![Screenshot 2025-07-24 at 4 07 05 PM](https://github.com/user-attachments/assets/3db0f27c-d53c-4907-aa0a-5d7986faa50f)

## Demo logs

<details>

<summary>Demo run - workflow poller</summary>

```
Started demo-timers-250
Started demo-timers-847
Started demo-timers-420
Started demo-timers-163
Started demo-timers-567
workflow_id=demo-timers-250, elapsed=0.04s
workflow_id=demo-timers-847, elapsed=0.04s
workflow_id=demo-timers-420, elapsed=0.04s
workflow_id=demo-timers-163, elapsed=0.04s
workflow_id=demo-timers-567, elapsed=0.04s
workflow_id=demo-timers-250, elapsed=2.05s
workflow_id=demo-timers-847, elapsed=2.05s
workflow_id=demo-timers-420, elapsed=2.05s
workflow_id=demo-timers-163, elapsed=2.05s
workflow_id=demo-timers-567, elapsed=2.05s
workflow_id=demo-timers-250, elapsed=4.08s
workflow_id=demo-timers-847, elapsed=4.08s
workflow_id=demo-timers-420, elapsed=4.08s
workflow_id=demo-timers-163, elapsed=4.08s
workflow_id=demo-timers-567, elapsed=4.08s
workflow_id=demo-timers-163, elapsed=6.11s
workflow_id=demo-timers-567, elapsed=6.11s
Finished: demo-timers-250,demo-timers-847,demo-timers-420
workflow_id=demo-timers-163, elapsed=8.13s
workflow_id=demo-timers-567, elapsed=8.13s
Finished: demo-timers-250,demo-timers-847,demo-timers-420
workflow_id=demo-timers-163, elapsed=10.16s
workflow_id=demo-timers-567, elapsed=10.16s
Finished: demo-timers-250,demo-timers-847,demo-timers-420
workflow_id=demo-timers-163, elapsed=12.17s
workflow_id=demo-timers-567, elapsed=12.17s
Finished: demo-timers-250,demo-timers-847,demo-timers-420
workflow_id=demo-timers-163, elapsed=14.2s
workflow_id=demo-timers-567, elapsed=14.2s
Finished: demo-timers-250,demo-timers-847,demo-timers-420
workflow_id=demo-timers-163, elapsed=16.22s
workflow_id=demo-timers-567, elapsed=16.22s
Finished: demo-timers-250,demo-timers-847,demo-timers-420

```

</details>

<details>

<summary>Demo run - worker logs</summary>

```
I, [2025-07-24T16:51:52.753364 #1]  INFO -- : Timer created {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f28-7dbd-a0f0-b12994094255", :task_queue=>"default", :workflow_id=>"demo-timers-847", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:52.754111 #1]  INFO -- : Timer starting {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f28-7dbd-a0f0-b12994094255", :task_queue=>"default", :workflow_id=>"demo-timers-847", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:52.759569 #1]  INFO -- : Timer finished {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f1e-7267-8020-aa1c3ae815f2", :task_queue=>"default", :workflow_id=>"demo-timers-250", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:52.759915 #1]  INFO -- : Timer created {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f1e-7267-8020-aa1c3ae815f2", :task_queue=>"default", :workflow_id=>"demo-timers-250", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:52.760102 #1]  INFO -- : Timer starting {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f1e-7267-8020-aa1c3ae815f2", :task_queue=>"default", :workflow_id=>"demo-timers-250", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:52.762474 #1]  INFO -- : Timer finished {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f30-7351-ba1f-863727eb7e22", :task_queue=>"default", :workflow_id=>"demo-timers-420", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:52.762822 #1]  INFO -- : Timer created {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f30-7351-ba1f-863727eb7e22", :task_queue=>"default", :workflow_id=>"demo-timers-420", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:52.762997 #1]  INFO -- : Timer starting {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f30-7351-ba1f-863727eb7e22", :task_queue=>"default", :workflow_id=>"demo-timers-420", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:52.765295 #1]  INFO -- : Timer finished {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f35-71bb-ab4f-4d24269f7987", :task_queue=>"default", :workflow_id=>"demo-timers-163", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:52.765672 #1]  INFO -- : Timer created {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f35-71bb-ab4f-4d24269f7987", :task_queue=>"default", :workflow_id=>"demo-timers-163", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:52.765976 #1]  INFO -- : Timer starting {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f35-71bb-ab4f-4d24269f7987", :task_queue=>"default", :workflow_id=>"demo-timers-163", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:53.772499 #1]  INFO -- : Timer finished {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f28-7dbd-a0f0-b12994094255", :task_queue=>"default", :workflow_id=>"demo-timers-847", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:53.774011 #1]  INFO -- : Timer created {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f28-7dbd-a0f0-b12994094255", :task_queue=>"default", :workflow_id=>"demo-timers-847", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:53.774502 #1]  INFO -- : Timer starting {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f28-7dbd-a0f0-b12994094255", :task_queue=>"default", :workflow_id=>"demo-timers-847", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:53.780006 #1]  INFO -- : Timer finished {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f1e-7267-8020-aa1c3ae815f2", :task_queue=>"default", :workflow_id=>"demo-timers-250", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:53.780567 #1]  INFO -- : Timer created {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f1e-7267-8020-aa1c3ae815f2", :task_queue=>"default", :workflow_id=>"demo-timers-250", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:53.780912 #1]  INFO -- : Timer starting {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f1e-7267-8020-aa1c3ae815f2", :task_queue=>"default", :workflow_id=>"demo-timers-250", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:53.782812 #1]  INFO -- : Timer finished {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f30-7351-ba1f-863727eb7e22", :task_queue=>"default", :workflow_id=>"demo-timers-420", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:53.783113 #1]  INFO -- : Timer created {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f30-7351-ba1f-863727eb7e22", :task_queue=>"default", :workflow_id=>"demo-timers-420", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:53.783350 #1]  INFO -- : Timer starting {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f30-7351-ba1f-863727eb7e22", :task_queue=>"default", :workflow_id=>"demo-timers-420", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:53.785650 #1]  INFO -- : Timer finished {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f35-71bb-ab4f-4d24269f7987", :task_queue=>"default", :workflow_id=>"demo-timers-163", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:53.786033 #1]  INFO -- : Timer created {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f35-71bb-ab4f-4d24269f7987", :task_queue=>"default", :workflow_id=>"demo-timers-163", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:53.786277 #1]  INFO -- : Timer starting {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f35-71bb-ab4f-4d24269f7987", :task_queue=>"default", :workflow_id=>"demo-timers-163", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:54.793947 #1]  INFO -- : Timer finished {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f28-7dbd-a0f0-b12994094255", :task_queue=>"default", :workflow_id=>"demo-timers-847", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:54.795218 #1]  INFO -- : Timer created {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f28-7dbd-a0f0-b12994094255", :task_queue=>"default", :workflow_id=>"demo-timers-847", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:54.795862 #1]  INFO -- : Timer starting {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f28-7dbd-a0f0-b12994094255", :task_queue=>"default", :workflow_id=>"demo-timers-847", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:54.798373 #1]  INFO -- : Timer finished {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f1e-7267-8020-aa1c3ae815f2", :task_queue=>"default", :workflow_id=>"demo-timers-250", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:54.798920 #1]  INFO -- : Timer created {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f1e-7267-8020-aa1c3ae815f2", :task_queue=>"default", :workflow_id=>"demo-timers-250", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:54.799127 #1]  INFO -- : Timer starting {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f1e-7267-8020-aa1c3ae815f2", :task_queue=>"default", :workflow_id=>"demo-timers-250", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:54.802536 #1]  INFO -- : Timer finished {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f35-71bb-ab4f-4d24269f7987", :task_queue=>"default", :workflow_id=>"demo-timers-163", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:54.803009 #1]  INFO -- : Timer created {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f35-71bb-ab4f-4d24269f7987", :task_queue=>"default", :workflow_id=>"demo-timers-163", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:54.803182 #1]  INFO -- : Timer starting {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f35-71bb-ab4f-4d24269f7987", :task_queue=>"default", :workflow_id=>"demo-timers-163", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:54.804897 #1]  INFO -- : Timer finished {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f30-7351-ba1f-863727eb7e22", :task_queue=>"default", :workflow_id=>"demo-timers-420", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:54.805208 #1]  INFO -- : Timer created {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f30-7351-ba1f-863727eb7e22", :task_queue=>"default", :workflow_id=>"demo-timers-420", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:54.805402 #1]  INFO -- : Timer starting {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f30-7351-ba1f-863727eb7e22", :task_queue=>"default", :workflow_id=>"demo-timers-420", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:55.820033 #1]  INFO -- : Timer finished {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f28-7dbd-a0f0-b12994094255", :task_queue=>"default", :workflow_id=>"demo-timers-847", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:55.820414 #1]  INFO -- : Timer created {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f28-7dbd-a0f0-b12994094255", :task_queue=>"default", :workflow_id=>"demo-timers-847", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:55.820635 #1]  INFO -- : Timer starting {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f28-7dbd-a0f0-b12994094255", :task_queue=>"default", :workflow_id=>"demo-timers-847", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:55.821788 #1]  INFO -- : Timer finished {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f1e-7267-8020-aa1c3ae815f2", :task_queue=>"default", :workflow_id=>"demo-timers-250", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:55.822100 #1]  INFO -- : Timer created {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f1e-7267-8020-aa1c3ae815f2", :task_queue=>"default", :workflow_id=>"demo-timers-250", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:55.822258 #1]  INFO -- : Timer starting {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f1e-7267-8020-aa1c3ae815f2", :task_queue=>"default", :workflow_id=>"demo-timers-250", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:55.824935 #1]  INFO -- : Timer finished {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f30-7351-ba1f-863727eb7e22", :task_queue=>"default", :workflow_id=>"demo-timers-420", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:55.825201 #1]  INFO -- : Timer created {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f30-7351-ba1f-863727eb7e22", :task_queue=>"default", :workflow_id=>"demo-timers-420", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:55.825554 #1]  INFO -- : Timer starting {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f30-7351-ba1f-863727eb7e22", :task_queue=>"default", :workflow_id=>"demo-timers-420", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:56.852177 #1]  INFO -- : Timer finished {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f28-7dbd-a0f0-b12994094255", :task_queue=>"default", :workflow_id=>"demo-timers-847", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:56.852645 #1]  INFO -- : Finished demo timers workflow {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f28-7dbd-a0f0-b12994094255", :task_queue=>"default", :workflow_id=>"demo-timers-847", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:56.854494 #1]  INFO -- : Timer finished {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f1e-7267-8020-aa1c3ae815f2", :task_queue=>"default", :workflow_id=>"demo-timers-250", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:56.854766 #1]  INFO -- : Finished demo timers workflow {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f1e-7267-8020-aa1c3ae815f2", :task_queue=>"default", :workflow_id=>"demo-timers-250", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:56.856887 #1]  INFO -- : Timer finished {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f30-7351-ba1f-863727eb7e22", :task_queue=>"default", :workflow_id=>"demo-timers-420", :workflow_type=>"DemoTimersWorkflow"}
I, [2025-07-24T16:51:56.857233 #1]  INFO -- : Finished demo timers workflow {:attempt=>1, :namespace=>"default", :run_id=>"01983d59-2f30-7351-ba1f-863727eb7e22", :task_queue=>"default", :workflow_id=>"demo-timers-420", :workflow_type=>"DemoTimersWorkflow"}
```

</details>
