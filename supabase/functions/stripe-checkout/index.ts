import Stripe from 'https://esm.sh/stripe@14.13.0?target=deno'
import { corsHeaders } from '../_shared/cors.ts'

const stripe = new Stripe(Deno.env.get('STRIPE_API_KEY') as string, {
  apiVersion: '2023-08-16',
  httpClient: Stripe.createFetchHttpClient(),
});

async function createStripeCheckoutSession(request) {
  // Parse the request body
  const body = await request.json();
  const { priceId, mode, successUrl, cancelUrl, userId, userEmail } = body;

  // Basic validation
  if (!priceId || !successUrl || !cancelUrl || !mode) {
    return new Response(JSON.stringify({ error: 'Missing required parameters' }), { status: 400 });
  }

  // Create Stripe Checkout session
  try {
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      line_items: [
        {
          price: priceId,
          quantity: 1,
        },
      ],
      mode: mode,
      success_url: successUrl,
      cancel_url: cancelUrl,
      client_reference_id: userId,
      customer_email: userEmail, // Optional, for new customers
      // Add more configuration as needed
    });

    return new Response(JSON.stringify({ url: session.url }), {
    status: 200,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' } });
  } catch (error) {
    console.error('Stripe session creation error:', error);
    return new Response(JSON.stringify({ error: error.message }), { status: 500 });
  }
}

// Serve the function
Deno.serve(async (request) => {
  if (request.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  if (request.method === 'POST') {
    return createStripeCheckoutSession(request);
  }
  return new Response('Method Not Allowed', { status: 405 });
});


// To invoke:
// curl -i --location --request POST 'http://localhost:54321/functions/v1/' \
//   --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
//   --header 'Content-Type: application/json' \
//   --data '{"name":"Functions"}'

// curl -i --location --request POST 'http://localhost:54321/functions/v1/stripe-checkout' \
//   --header 'Authorization: Bearer YOUR_SUPABASE_EDGE_FUNCTION_TOKEN' \
//   --header 'Content-Type: application/json' \
//   --data '{
//     "priceId": "price_1OYucUHPkeaXjgQcVbNepMBd",
//     "mode": "subscription",
//     "successUrl": "https://mastermindtogether.com/",
//     "cancelUrl": "https://yourdomain.com/cancel",
//     "userId": "USER_ID_IF_AVAILABLE",
//     "userEmail": "user@example.com"
//   }'

