import Stripe from 'https://esm.sh/stripe@14.13.0?target=deno';
import {corsHeaders} from '../_shared/cors.ts';
import {SupabaseClient} from 'https://cdn.skypack.dev/@supabase/supabase-js';
import {createClient} from 'https://esm.sh/@supabase/supabase-js@2.39.3'

const stripe = new Stripe(Deno.env.get('STRIPE_API_KEY'), {
  apiVersion: '2023-08-16',
  httpClient: Stripe.createFetchHttpClient(),
});

// Create a Supabase client with the Auth context of the logged in user.
const supabase = createClient(
  // Supabase API URL - env var exported by default.
  Deno.env.get('SUPABASE_URL') ?? '',
  // Supabase API ANON KEY - env var exported by default.
  Deno.env.get('SUPABASE_ANON_KEY') ?? '',
);

const findCheckoutSession = async (sessionId) => {
  try {
    const session = await stripe.checkout.sessions.retrieve(sessionId, {
      expand: ["line_items"],
    });
    return session;
  } catch (e) {
    console.error(e);
    return null;
  }
};

async function handleStripeEvent(request) {
  const signature = request.headers.get('Stripe-Signature');
  const body = await request.text();
  let event;

  try {
    event = await stripe.webhooks.constructEventAsync(
      body,
      signature,
      Deno.env.get('STRIPE_WEBHOOK_SIGNING_SECRET')
    );

  } catch (err) {
    console.error('Webhook Error:', err.message);
    return new Response(err.message, {status: 400, headers: corsHeaders});
  }
  console.log(`EVENT-ID: ${event.id}`);
  console.log(`EVENT-TYPE: ${event.type}`);

  switch (event.type) {
    case "invoice.paid":
    case "checkout.session.completed": {
      const stripeObject: Stripe.Checkout.Session = event.data
        .object as Stripe.Checkout.Session;

      const session = await findCheckoutSession(stripeObject.id);
      console.log(`Session: ${session}`);
      const customerId = session?.customer;
      console.log(`customerId: ${customerId}`);
      const priceId = session?.line_items?.data[0]?.price.id;
      console.log(`priceId: ${priceId}`);
      const userId = stripeObject.client_reference_id;
      console.log(`userId: ${userId}`);
      const plan = session?.line_items?.data[0]?.description;
      console.log(`plan: ${plan}`);

      if (!plan) break;
      // Step 1: Retrieve the subscription_id
      const subscriptionQuery = await supabase
        .from('subscription')
        .select('id')
        .eq('stripe_price_id', priceId)
        .single();

        if(subscriptionQuery.data === null){
            console.log(`No pricingId for subscription. Please check DB!`);
        }

        const subscriptionId = subscriptionQuery.data.id;
        console.log(`subscriptionId: ${subscriptionId}`);

      // Step 2: Update the users_extended table
      const {data, error} = await supabase
        .from('users_extended')
        .update({subscription_id: subscriptionId, stripe_customer_id: customerId})
        .eq('user_id', userId);

      if (error) {
        console.error('Database update error:', error.message);
      } else {
        console.log('Subscription updated for user:', userId);
      }
      // Step 3: Insert a subscription_transaction
      const {transaction, transactionError} = await supabase
        .from('subscription_transactions')
        .insert([
          {
            user_id: userId,
            subscription_id: subscriptionId,
            amount: session?.line_items?.data[0]?.amount_total,
            stripe_customer_id: customerId,
            stripe_checkout_session_id: session.id
          }
        ]);

      if (transactionError) {
        console.error('Error when inserting subscription_transaction:', transactionError.message);
      } else {
        console.log('Subscription transaction added for user:', userId);
      }
      break;
    }

    case "checkout.session.expired": {
      // User didn't complete the transaction
      // You don't need to do anything here, by you can send an email to the user to remind him to complete the transaction, for instance
      break;
    }

    case "customer.subscription.updated": {
      // The customer might have changed the plan (higher or lower plan, cancel soon etc...)
      // You don't need to do anything here, because Stripe will let us know when the subscription is canceled for good (at the end of the billing cycle) in the "customer.subscription.deleted" event
      // You can update the user data to show a "Cancel soon" badge for instance
      break;
    }

    case 'customer.subscription.deleted': {
      // The customer subscription stopped ❌ Revoke access to the product
      const stripeObject: Stripe.Checkout.Session = event.data.object as Stripe.Checkout.Session;
      const subscription = await stripe.subscriptions.retrieve(stripeObject.id);

      // Step 1: Retrieve the subscription_id
      const subscriptionQuery = await supabase
        .from('subscription')
        .select('id')
        .eq('stripe_price_id', 'price_dev_free_individual')
        .single();

      const subscriptionId = subscriptionQuery.data.id;
      console.log('Free subscription_id: ', subscriptionId);
      console.log('subscription.customer: ', subscription.customer);

      // Step 2: Update the users_extended table
      const {data, error} = await supabase
        .from('users_extended')
        .update({subscription_id: subscriptionId})
        .eq("stripe_customer_id", subscription.customer);

      if (error) {
        console.error('Database update error:', error.message);
      } else {
        console.log('Subscription updated for customer:', subscription.customer);
      }

      // Step 3: Insert a subscription_transaction
      const {transaction, transactionError} = await supabase
        .from('subscription_transactions')
        .insert([
          {
            user_id: null,
            subscription_id: subscriptionId,
            amount: null,
            stripe_customer_id: subscription.customer,
            stripe_checkout_session_id: null
          }
        ]);

      if (transactionError) {
        console.error('Error when inserting subscription_transaction:', transactionError.message);
      } else {
        console.log('Subscription transaction added for customer:', subscription.customer);
      }

      break;
    }

    case "invoice.payment_failed":
      // A payment failed (for instance the customer does not have a valid payment method)
      // ❌ Revoke access to the product
      // ⏳ OR wait for the customer to pay (more friendly):
      //      - Stripe will automatically email the customer (Smart Retries)
      //      - We will receive a "customer.subscription.deleted" when all retries were made and the subscription has expired
      break;

    default:
      console.log(`Unhandled event type: ${event}`);
  }

  return new Response(JSON.stringify({received: true}), {status: 200, headers: corsHeaders});
}

Deno.serve(async (request) => {
  if (request.method === 'OPTIONS') {
    return new Response(null, {headers: corsHeaders});
  } else if (request.method === 'POST') {
    return handleStripeEvent(request);
  } else {
    return new Response('Method Not Allowed', {status: 405, headers: corsHeaders});
  }
});
