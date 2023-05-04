# Inbound Webhooks

Jumpstart Pro includes a generator for handling inbound webhooks. It handles several things:

* Receiving webhooks
* A process for verifying events came from the service
* Saving webhooks to the database for handling high volumes
* Processing webhooks in background jobs

### Usage

Use the generator to create a new inbound webhook processor:

```bash
rails g inbound_webhook Zapier
```

This will generate a couple files:

* `app/controllers/inbound_webhooks/zapier_controller.rb` - handles webhook POST requests, saves and enqueues for processing
* `app/jobs/inbound_webhooks/zapier_job.rb` - Processes the webhooks

Edit the controller to implement verification to make sure the webhook came from the service. Return a `:bad_request` if verification fails.

### Controllers

Inbound webhook controllers really only need to handle verification. Each service is different, so consult their documentation on how to verify webhook events.

If they don't provide verification, use a basic auth username and password in the url for verification.

### Jobs

To process the webhook, edit the job to process the webhook however your application needs.

Once complete, mark the InboundWebhook record as processed to queue it up for deletion.

```ruby
inbound_webhook.processed!
```

If processing fails, you can mark the job as `failed` and enqueue the record for processing again in a few minutes. You can also introduce other statuses to handle more complex situations as needed.

Jobs should also be retried automatically when an exception is thrown if you're using Sidekiq or another background processor that automatically retries failed jobs.

### Other Considerations

Don't forget to handle webhooks properly:

* Safely handle retries
* Idempotent jobs to prevent replay attacks and handle duplicates
