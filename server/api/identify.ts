import type { VercelRequest, VercelResponse } from "@vercel/node";
import Anthropic from "@anthropic-ai/sdk";

// Keep this schema's field names in lockstep with the Dart
// `IdentificationResult` model in lib/models/identification_result.dart.
const RESPONSE_SCHEMA = {
  type: "object",
  properties: {
    identified: {
      type: "boolean",
      description: "True if a specific species could be identified with reasonable confidence.",
    },
    commonName: { type: "string" },
    scientificName: { type: "string", description: "Binomial Latin name." },
    confidence: { type: "number", description: "0 to 1 confidence in this identification." },
    kingdom: { type: "string" },
    phylum: { type: "string" },
    taxClass: { type: "string", description: "Taxonomic class." },
    order: { type: "string" },
    family: { type: "string" },
    genus: { type: "string" },
    nativeRange: { type: "string", description: "Where this species originates from." },
    habitat: { type: "string" },
    isInvasive: { type: "boolean" },
    invasiveRegions: { type: "array", items: { type: "string" } },
    invasiveStatusNotes: { type: "string" },
    ecologicalImpact: { type: "string" },
    economicImpact: { type: "string" },
    controlMethods: { type: "string" },
    threatLevel: { type: "string", enum: ["low", "moderate", "high", "severe", "unknown"] },
    alternateCandidates: {
      type: "array",
      items: {
        type: "object",
        properties: {
          commonName: { type: "string" },
          scientificName: { type: "string" },
          confidence: { type: "number" },
        },
        required: ["commonName", "scientificName", "confidence"],
        additionalProperties: false,
      },
    },
    identificationNotes: { type: "string" },
  },
  required: [
    "identified", "commonName", "scientificName", "confidence",
    "kingdom", "phylum", "taxClass", "order", "family", "genus",
    "nativeRange", "habitat", "isInvasive", "invasiveRegions",
    "invasiveStatusNotes", "ecologicalImpact", "economicImpact",
    "controlMethods", "threatLevel", "alternateCandidates",
    "identificationNotes",
  ],
  additionalProperties: false,
} as const;

const SYSTEM_PROMPT = `You are a meticulous field biologist and invasive-species specialist for \
InvasiveX, an app that identifies organisms from photos and reports their \
invasive status. Given one photo, identify the species as precisely as \
you can from visual evidence alone.

Use the web_search tool when it would improve accuracy — to confirm a \
tentative identification against a look-alike, or to verify or refresh \
specific facts about native range, where it is considered invasive, and \
its ecological or economic impact. Prefer authoritative sources (e.g. \
government invasive-species databases, university extension services, \
IUCN) over casual ones.

Be honest about uncertainty: if you cannot identify the organism with \
reasonable confidence, set identified to false, still provide your best \
guess for every field, explain the ambiguity in identificationNotes, and \
list plausible alternatives in alternateCandidates. Never invent a \
precise statistic you are not sure of — describe impacts qualitatively \
instead. Respond only through the structured fields; do not add \
commentary outside them.`;

const USER_PROMPT = `Identify the organism in this photo and fill in every field: its common \
and scientific name; where it is native to; whether it is invasive \
anywhere and in which regions; the ecological and economic harm it \
causes where invasive; its full taxonomic classification; a threat \
level; and a brief note on the visual features you used and any \
uncertainty.`;

function setCors(res: VercelResponse) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type");
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  setCors(res);

  if (req.method === "OPTIONS") {
    res.status(204).end();
    return;
  }
  if (req.method !== "POST") {
    res.status(405).json({ error: "Use POST." });
    return;
  }

  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) {
    res.status(500).json({ error: "Server is missing ANTHROPIC_API_KEY." });
    return;
  }

  const { imageBase64, mediaType } = req.body ?? {};
  if (typeof imageBase64 !== "string" || imageBase64.length === 0) {
    res.status(400).json({ error: "Request body must include imageBase64 (base64-encoded image, no data: prefix)." });
    return;
  }

  const client = new Anthropic({ apiKey });

  try {
    const response = await client.messages.create({
      model: "claude-opus-4-8",
      max_tokens: 8192,
      thinking: { type: "adaptive" },
      output_config: {
        effort: "high",
        format: { type: "json_schema", schema: RESPONSE_SCHEMA },
      },
      tools: [{ type: "web_search_20260209", name: "web_search", max_uses: 3 }],
      system: SYSTEM_PROMPT,
      messages: [
        {
          role: "user",
          content: [
            {
              type: "image",
              source: {
                type: "base64",
                media_type: (mediaType as "image/jpeg" | "image/png" | "image/gif" | "image/webp") ?? "image/jpeg",
                data: imageBase64,
              },
            },
            { type: "text", text: USER_PROMPT },
          ],
        },
      ],
    });

    if (response.stop_reason === "refusal") {
      res.status(422).json({
        error: "refusal",
        message: "Claude declined to analyze this photo.",
        details: response.stop_details ?? null,
      });
      return;
    }

    const textBlock = response.content.find((block) => block.type === "text");
    if (!textBlock || textBlock.type !== "text") {
      res.status(502).json({ error: "No text block in Claude's response." });
      return;
    }

    let parsed: unknown;
    try {
      parsed = JSON.parse(textBlock.text);
    } catch (e) {
      res.status(502).json({ error: "Claude's response was not valid JSON.", raw: textBlock.text });
      return;
    }

    res.status(200).json(parsed);
  } catch (error: any) {
    const status = typeof error?.status === "number" ? error.status : 500;
    res.status(status).json({ error: error?.message ?? "Unknown error calling Claude." });
  }
}
