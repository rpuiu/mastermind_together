# Mastermind Together

## Supabase:

### Database:

The SQL commands used to create the public schema can be found under `lib/sql`. These need to be manually executed in a new supabase instance to create all the tables. Please make sure that the realtime is enabled on the necessary tables.

### Edge functions:

#### Install:

https://supabase.com/docs/guides/functions/quickstart

#### Init:

`supabase functions new hello-world`

#### Deploy:

`supabase functions deploy FUNCTION_NAME --project-ref <PROJECT_REF=the first part of the supabase url>`
The functions are stored under: `supabase/functions/` in the root of the project.

Please make sure that the production project is linked using `supabase link --project-ref <PROJECT_REF>`. 
Please make sure that the necessary secrets are set for that specific with `supabase secrets list`. 
For example, the mailgun function needs MAILGUN_API_KEY and MAILGUN_DOMAIN.

To set the secrets from an .env file you can use:
`supabase secrets set --env-file ./supabase/functions/stripe-checkout/.env --project-ref <PROJECT_REF>`
Please make sure to update with the prod values, create the stripe endpoint and update the secrets as necessary

## Stripe Payments:
- Create an endpoint for the webhooks and pass the supabase function url
- Reveal the signing secret and add it as `STRIPE_WEBHOOK_SIGNING_SECRET` in `supabase/functions/stripe-webhook/.env-prod`
- Update the secrets using `supabase secrets set --env-file ./supabase/functions/stripe-webhook/.env-prod --project-ref <PROJECT_REF>`
- **Do not forget to update the priceID in the DB `subscription` table**.

## Deployment:
- `lib/_conf/nginx/etc/nginx/sitesavailable/mmt/mmt.conf` contains the nginx.conf
The `deploy.sh` script is used for deployment on web. `.env.dev` and `.env.prod` are used to store environment variables for production and development, and 2 instances of Supabase are created accordingly. 

## Other:

#### Password Reset:
To be able to successfully reset the password for the users of a tenant, you need to add the tenant's Redirect URL in Supabase -> Authentication -> URL Configuration -> Redirect URLs