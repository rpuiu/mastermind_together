import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { corsHeaders } from '../_shared/cors.ts'

const MAILGUN_API_KEY = Deno.env.get("MAILGUN_API_KEY");
const MAILGUN_DOMAIN = Deno.env.get("MAILGUN_DOMAIN");

const handler = async (request: Request): Promise<Response> => {
  const base64ApiKey = btoa(`api:${MAILGUN_API_KEY}`);

  if (request.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  const requestData = await request.json();
  const { to, from, subject, body } = requestData;

  const res = await fetch(`https://api.mailgun.net/v3/${MAILGUN_DOMAIN}/messages`, {
    method: "POST",
    headers: {
      "Authorization": `Basic ${base64ApiKey}`,
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: new URLSearchParams({
      from: from,
      to: to,
      subject: subject,
      text: body,
    }),
  });

  const data = await res.json();

  return new Response(JSON.stringify(data), {
    status: 200,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  });
};

serve(handler);


/*
curl -L -X POST 'https://qcycfezcqfdivbjzqjzg.supabase.co/functions/v1/mailgun' -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFjeWNmZXpjcWZkaXZianpxanpnIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODcyODA5ODIsImV4cCI6MjAwMjg1Njk4Mn0.zczM2v7LQ1RrseTDmiWm26O-vtjRysinJkJIK2GtrGQ' --data '{
"to": "mastermindtogether@gmail.com",
"from": "raz.puiu@gmail.com",
"subject": "Test mail",
"body": "It works!"
}'
*/