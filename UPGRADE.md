### March 29, 2023

We renamed the `outline` CSS class to `btn-outline` to prevent conflicts with TailwindCSS's `outline` class. You will need to update any references of `outline` to `btn-outline` in your views.
We've also added a `Response` class that wraps API client responses to provide access to the original response object for status code and headers. This comes in handy when APIs use headers for pagination, rate limiting, etc.

### February 6, 2023 - System admins

For additional security, we've made the `admin` attribute on the User model readonly.
The `admin` attribute denotes a user as a system-wide admin. The system admins have access to `/admin` and can view the entire database. This is helpful for customer support and other things.

To add or remove a system admin, you can now run the following commands:

```ruby
# Add system admin
Jumpstart.grant_system_admin! User.find_by_email("admin@example.org")

# Remove system admin
Jumpstart.revoke_system_admin! User.find_by_email("admin@example.org")
```

### February 1, 2023 - Administrate updates

We've updated Administrate to the latest version. GitHub accidentally blew away a few commits we added, so you'll want to bundle update administrate so you're on the latest sha.
Administrate has changed views to use new helper methods, so you'll also want to check out the recent commits to adjust the views we have overridden.

### September 14, 2021 - CSS & JS Bundling

Rails 7 introduces `cssbundling-rails` and `jsbundling-rails` packages. We now use the Tailwind CLI and esbuild for Javascript. It's much, much faster and configurable.
We've removed Webpacker, but you can use webpack with jsbundling-rails if you would like.

Use `bin/dev` to run the Rails server along with the CSS & JS watchers in development.

* TailwindCSS has been moved to `app/assets/application.tailwind.css`
* `tailwind.config.js` has been moved to the root
* Sass has been removed and CSS is now processed through postcss only (using the Tailwind CLI)
* Javascript packs are defined in `esbuild.config.js`
* Assets are compiled and output to the `app/assets/builds` directory and served by the asset pipeline.
* Webpacker pack tags have been replaced with asset pipeline tags

### September 4, 2021 - Pay 3 upgrade

The Pay 3.0 upgrade migrates data from the Account model to the new Pay::Customer model and reassociates charges and subscriptions. It also switches generic trials to use the new `fake_processor` in Pay.

You can skip this if you aren't using payments in your app yet.

To upgrade, you'll want to do a few things:
1. Review `20210805001857_upgrade_to_pay_v3.rb`. This migration handles all the data migration to the new tables.
2. Test the migration against your local database. Sync your production database locally to test against it.
3. Test `rails pay:payment_methods:sync_default` in development to make sure it successfully syncs the default payment method for each customer.
4. Run the migration in production
5. Run `rails pay:payment_methods:sync_default` in production to sync default payment methods.
