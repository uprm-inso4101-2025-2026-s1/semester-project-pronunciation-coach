/**
 * xAPI Ingest Function
 *
 * This Supabase Edge Function serves as the bridge between the apps front-end xAPI event tracking
 * and the backend data store. It securely receives xAPI statements (actor, verb, object, etc, will change once variables are better defined),
 * validates their structure, and stores them in the `xapi_statements` table within Supabase. (must create table in supabase)
 *
 * Importance:
 * - Enables consistent recording of user learning interactions (e.g., completions, attempts, feedback)
 * - Supports future analytics dashboards and progress tracking
 * - Uses Supabase’s service role for secure insertion and validation
 * - Provides a centralized endpoint that can evolve into a full Learning Record Store (LRS)
 */
import { createClient } from "https://deno.land/x/supabase_deno/mod.ts";// <--- must verify, research shows to use this


type XApiStatement = { //can be modified with necessary variables, will connect to front end so will change based of that
  actor: Record<string, unknown>;
  verb:  Record<string, unknown>;
  object: Record<string, unknown>;
  result?: Record<string, unknown>;
  context?: Record<string, unknown>;
  timestamp?: string;
  [k: string]: unknown;
};

// --- CORS helpers ---
const corsHeaders: Record<string, string> = {
  "Access-Control-Allow-Origin": "*", // tighten for prod
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

Deno.serve(async (req: Request): Promise<Response> => {
  // Preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return new Response(
      JSON.stringify({ error: "Only POST is allowed" }),
      { status: 405, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  // Parse
  let body: XApiStatement | XApiStatement[];
  try {
    body = await req.json();
  } catch {
    return new Response(
      JSON.stringify({ error: "Invalid JSON" }),
      { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  // Normalize to array to support single or batch
  const statements = Array.isArray(body) ? body : [body];

  // Minimal xAPI validation: require actor/verb/object
  for (const [i, s] of statements.entries()) {
    if (!s || typeof s !== "object") {
      return new Response(
        JSON.stringify({ error: `Statement[${i}] is not an object` }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }
    if (!s.actor || !s.verb || !s.object) {
      return new Response(
        JSON.stringify({ error: `Statement[${i}] missing actor/verb/object` }),
        { status: 422, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }
  }

  // Supabase client (service role inside Edge)
  const SUPABASE_URL = Deno.env.get("SUPABASE_URL");
  const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

  if (!SUPABASE_URL || !SERVICE_ROLE_KEY) {
    return new Response(
      JSON.stringify({ error: "Server not configured: missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY, {
    auth: { persistSession: false },
  });

  // Map to insert rows
  const rows = statements.map((s) => ({
    actor:   s.actor,
    verb:    s.verb,
    object:  s.object,
    result:  s.result ?? null,
    context: s.context ?? null,
    raw:     s as Record<string, unknown>, // keep full payload
    // created_at defaults to now() via DB
  }));

  const { error } = await supabase.from("xapi_statements").insert(rows);

  if (error) {
    return new Response(
      JSON.stringify({ error: "DB insert failed", details: error.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  return new Response(
    JSON.stringify({ ok: true, inserted: rows.length }),
    { status: 201, headers: { ...corsHeaders, "Content-Type": "application/json" } },
  );
});
