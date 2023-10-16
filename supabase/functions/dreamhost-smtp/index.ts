import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { corsHeaders } from '../_shared/cors.ts'
import { SMTPClient } from "https://deno.land/x/denomailer/mod.ts";

const SMTP_USERNAME = Deno.env.get("SMTP_USERNAME");
const SMTP_PASSWORD = Deno.env.get("SMTP_PASSWORD");

const handler = async (request: Request): Promise<Response> => {
  if (request.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  const requestData = await request.json();
  const { to, from, subject, body } = requestData;

    const client = new SMTPClient({
      connection: {
        hostname: "smtp.dreamhost.com",
        port: 465,
        tls: true,
        auth: {
            username: SMTP_USERNAME,
            password: SMTP_PASSWORD,
        },
      },
    });

  await client.send({
    from: from,
    to: to,
    subject: subject,
    content: body,
  });

  await client.close();

  return new Response(JSON.stringify({ message: 'Email sent successfully' }), {
    status: 200,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  });
};

serve(handler);
