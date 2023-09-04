# Mastermind Together

## Supabase

### Database:

The SQL commands used to create the public schema can be found under `lib/sql`. These need to be manually executed in a new supabase instance to create all the tables. Please make sure that the realtime is enabled on the necessary tables.

### Edge functions

#### Install:

https://supabase.com/docs/guides/functions/quickstart

#### Init:

`supabase functions new hello-world`

#### Deploy:

`supabase functions deploy FUNCTION_NAME --project-ref <PROJECT_REF=the first part of the supabase url>`
The functions are stored under: `supabase/functions/` in the root of the project.

Please make sure that the production project is linked using `supabase link --project-ref <PROJECT_REF>`. Please make sure that the necessary secrets are set for that specific with `supabase secrets list`. For example, the mailgun function needs MAILGUN_API_KEY and MAILGUN_DOMAIN.

## Deployment

The `deploy.sh` script is used for deployment on web. `.env.dev` and `.env.prod` are used to store environment variables for production and development, and 2 instances of Supabase are created accordingly. 
